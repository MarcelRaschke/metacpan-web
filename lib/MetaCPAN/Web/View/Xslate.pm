package MetaCPAN::Web::View::Xslate;
use Moose;
extends qw(Catalyst::View::Xslate);
use File::Temp           ();
use MetaCPAN::Web::Types qw( AbsPath );

has '+syntax'      => ( default => 'Metakolon' );
has '+encode_body' => ( default => 0 );
has '+preload'     => ( default => 0 );
has '+cache'       => ( default => 0 );
has '+cache_dir' => (
    isa     => AbsPath,
    coerce  => 1,
    default => sub {
        File::Temp::tempdir(
            TEMPLATE => 'metacpan-web-templates-XXXXXX',
            CLEANUP  => 1,
            TMPDIR   => 1,
        );
    },
);
has '+module' => (
    default =>
        sub { [ 'Text::Xslate::Bridge::Star',
        'MetaCPAN::Web::View::Xslate::Bridge', ] }
);

has api_public => (
    is       => 'ro',
    required => 1,
);
has source_host => (
    is       => 'ro',
    required => 1,
);

sub COMPONENT {
    my ( $class, $app, $args ) = @_;

    $args = $class->merge_config_hashes(
        {
            api_public  => $app->config->{api_public} || $app->config->{api},
            source_host => $app->config->{source_host},
        },
        $args,
    );
    return $class->SUPER::COMPONENT( $app, $args );
}

has '+expose_methods' => (
    default =>
        sub
    { [ qw(
        abs_url
        page_url
    ) ] },
);

sub page_url {
    my ( $self, $c, @args ) = @_;
    my $req = $c->request;
    my $uri = @args ? $req->uri_with(@args) : $req->uri;
    $uri->as_string;
}

sub abs_url {
    my ( $self, $c, $url, $base ) = @_;
    $base ||= $c->request->uri;
    my $uri = URI->new_abs( $url, $base );
    $uri->as_string;
}

around render => sub {
    my ( $orig, $self, $c, $template, $args ) = @_;

    my $vars = { $args ? %$args : %{ $c->stash } };

    my $req = $c->req;

    $vars->{api_public}  = $self->api_public;
    $vars->{source_host} = $self->source_host;
    $vars->{assets}      = $req->env->{'metacpan.assets'} || [];
    $vars->{current}     = {
        $c->action->reverse    => 1,
        $c->request->uri->path => 1,
    };

    return $self->$orig( $c, $template, $vars );
};

__PACKAGE__->meta->make_immutable;

1;
