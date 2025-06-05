package MetaCPAN::Web;
use Moose;
use namespace::autoclean;

use Catalyst::Runtime 5.90042;

use Catalyst qw/
    ConfigLoader
    Authentication
    /, '-Log=warn,error,fatal';
use Log::Log4perl::Catalyst ();

with 'MetaCPAN::Role::Fastly';
with 'MetaCPAN::Role::Fastly::Catalyst';

__PACKAGE__->request_class_traits( [ qw(
    MetaCPAN::Web::Role::Request
    Catalyst::TraitFor::Request::REST
) ] );

__PACKAGE__->response_class_traits( [ qw(
    MetaCPAN::Web::Role::Response
) ] );

__PACKAGE__->config(
    name                                        => 'MetaCPAN::Web',
    default_view                                => 'Xslate',
    disable_component_resolution_regex_fallback => 1,
    encoding                                    => 'UTF-8',
    'Plugin::Authentication'                    => {
        use_session => 0,
        default     => {
            class      => '+MetaCPAN::Web::Authentication::Realm',
            credential => {
                class => 'NoPassword',
            },
            store => {
                class => '+MetaCPAN::Web::Authentication::Store',
            },
        },
    }
);

__PACKAGE__->log( Log::Log4perl::Catalyst->new( undef, autoflush => 1 ) );

$ENV{COLUMNS} ||= 80;

after prepare_action => sub {
    my ($self) = @_;
    $self->req->final_args( $self->req->args );
};

__PACKAGE__->setup;
__PACKAGE__->meta->make_immutable;

1;
