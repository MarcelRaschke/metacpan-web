use strict;
use warnings;
use lib 't/lib';

use Digest::SHA ();
use Test::More;

# This test validates that all of the static files in the images, icons, and
# fonts directories have the expected content. These files are served with an
# infinite cache time, their content should never change in any meaningful
# way. If the content of one of these files needs to change, it should
# normally use a new file name. If it's a minor change where it is acceptable
# for users to use the old files, then updating the hash can be done instead.

## regenerate with: perl t/static-files.t --regen

for my $arg (@ARGV) {
    if ( $arg eq '--regen' ) {
        my @roots = qw(
            root/static/icons
            root/static/images
        );

        my @files;

        require File::Find;
        File::Find::find(
            {
                no_chdir => 1,
                wanted   => sub {
                    return
                        if -d;
                    return
                        if m{\/\.} || m{~$};

                    push @files, $_;
                },
            },
            @roots,
        );

        my %sha = map {
            $_ => Digest::SHA->new('sha1')->addfile( $_, 'b' )->hexdigest
        } @files;

        my $script = $0;
        $script = "./$script"
            unless $script =~ m{^/};

        open my $fh, '+<', $script
            or die;

        while ( my $line = <$fh> ) {
            chomp $line;
            if ( $line eq '__DATA__' ) {
                truncate $fh, tell $fh;
                for my $file ( sort keys %sha ) {
                    print $fh "$sha{$file}  $file\n";
                }
                close $fh;

                @ARGV = ();
                do $script or die;
                exit;
            }
        }

        die "Can't find __DATA__ marker in $0!\n";
    }
    else {
        die "Unsupported option $arg!\n";
    }
}

my %files = reverse map /(\S+)/g, <DATA>;

for my $file ( sort keys %files ) {
    my $want_sha = $files{$file};
    my $got_sha
        = eval { Digest::SHA->new('sha1')->addfile( $file, 'b' )->hexdigest }
        or diag $@;
    is $got_sha, $want_sha, "static file content is correct: $file";
}

done_testing;

__DATA__
679be699079a90f586aa90dbc79aac14731a226c  root/static/icons/apple-touch-icon.png
9352147a2cb97acb161f21202e9bfec29b6faa30  root/static/icons/favicon-16.ico
2ef4ad41df53e9361604fc7e110d28949e972b8f  root/static/icons/favicon.ico
3f8243315f8ad8a4101e1585695eb0ec169f5ade  root/static/icons/folder.png
697355984fb0724f2cd358c2c3139fdb7ec9e56b  root/static/icons/grid.svg
aa842d887b715e457517c3a6d5006189275e12fd  root/static/icons/page_white.png
9d0aaf1b7b03783229d08e972fd5ca7e5113e2de  root/static/icons/page_white_c.png
5cd510d1d1ae6126d23ecdba62fac129520a3af4  root/static/icons/page_white_code.png
206b6499e0042c778be417a65eb74d3682cb8fdb  root/static/images/dots.png
c6eb68299d78fecc8b74b05ee11942c034992da5  root/static/images/dots.svg
b0cdcd8a2baf229cea555bb5a72e94a234057641  root/static/images/flag/ad.png
9be5373eb09ae6dda325cf774dca5917c0141b4f  root/static/images/flag/ae.png
9301bee0e54de0a85e6407a36c377bb178527ecf  root/static/images/flag/af.png
88aa1b3dad76e6db3cf0022c9f0eb307bfb93363  root/static/images/flag/ag.png
74bd5efd4fd024c8b66cb5664faf64430b674f1b  root/static/images/flag/ai.png
46660f781e66632a383e83a56dc4fa1ad128d26f  root/static/images/flag/al.png
b8f6f60729242aabf0713f9202f508859e88ba38  root/static/images/flag/am.png
7a5893399cf9620a40796dda067ed38bf417a991  root/static/images/flag/an.png
abb8b82f9c327a4974deb2338b000d8c1e307896  root/static/images/flag/ao.png
23000bca35847ecfbd0b1cc0528d23a0a360f9fb  root/static/images/flag/ar.png
e35b729883fb0f2a20ecd7ab06b0fd6829e367f5  root/static/images/flag/as.png
3ad44815d577ca5a5eb6537630d5ebbfa45d2cdb  root/static/images/flag/at.png
b1e3a3b54aa747331b6a468883f0f470aded8d32  root/static/images/flag/au.png
72b80e6c39c68925eb514a4e2a0f72d4755acd17  root/static/images/flag/aw.png
734624eac0deb3f5026b2eaf031baba8740174e7  root/static/images/flag/ax.png
5ddf14ae26789de8744a3a7e7bd8863fc52ba3c8  root/static/images/flag/az.png
b72dff7cbe8dab567624451efa880d3f7ddbc603  root/static/images/flag/ba.png
dc03bd1ac890f80eedfc11419bac728517c58ea1  root/static/images/flag/bb.png
1d85eba3fe4dbd8664fac1c2d1462573615b9b51  root/static/images/flag/bd.png
87b1230ecf291723b2d62579cad7f508fce75574  root/static/images/flag/be.png
df58bd656641c86f3a1d1ea4717f5118ec2fe805  root/static/images/flag/bf.png
e59e50416f1ceaa32b3c4a1522c34ea4d763180e  root/static/images/flag/bg.png
dc93040f172e2e94fc153bd1e87bfefc88d58d36  root/static/images/flag/bh.png
7b65c16a3f62523003163415ebdc83a63e02d2e1  root/static/images/flag/bi.png
a8635d513f045df5fb891dedfc09a1bb39f073bb  root/static/images/flag/bj.png
e0cc80dae5afe31f4c25d90b47fadc7cfeabb142  root/static/images/flag/bm.png
770fa4a50452a5260c8c48ac0997b22ad9d40d63  root/static/images/flag/bn.png
1a3e81e40fd68d08a742ee4968824248e0632708  root/static/images/flag/bo.png
6d55dd3b6a89bd0a8c26d0acea96351c62c2c7f6  root/static/images/flag/br.png
f2505db9caa6fa2e5dd60203c12689efdd011124  root/static/images/flag/bs.png
53fd260bb6a9a2b2159009c9f5ebf6d00e2821b1  root/static/images/flag/bt.png
993f09a3f83b06dd0c60a1a1c1ab626616a80691  root/static/images/flag/bv.png
d2a29fb9126a15792da586b0708414a73c3c1a5e  root/static/images/flag/bw.png
3792e79af0b3ab9c5566fc56c5a4f2b4a956b208  root/static/images/flag/by.png
3ba8ebbf222cdc49cfd98280a34cf53c9d63d8c3  root/static/images/flag/bz.png
1426208899d9eba516726060932545d7585a31bb  root/static/images/flag/ca.png
3380dddff08aad0be35dd33aaba0ca250d6a9a18  root/static/images/flag/catalonia.png
6f5f6d75a6efc67d3a0a2d38ecfd37b4ebbfe2d2  root/static/images/flag/cc.png
4bcc1e97f7c5b539b2369d19f5f15a64dfad3ad8  root/static/images/flag/cd.png
2bec006ff5fb8b676b0d82b20300c35291301ea4  root/static/images/flag/cf.png
f64b6c7ca573e9bafed888616148bb6c67105154  root/static/images/flag/cg.png
a6d7f1ae89c02e4d63262d4905704a2002c6c0d7  root/static/images/flag/ch.png
a704f6746f41f0f47fea20a176a335ac61622730  root/static/images/flag/ci.png
fac8d638d7ea1c130f36354d5c3ad41ccc31c9cf  root/static/images/flag/ck.png
19ea9982340c0315fed3e7b0c538a7d6beebc083  root/static/images/flag/cl.png
cf1d530409d89b32ca558bd09ef464a445f3713d  root/static/images/flag/cm.png
f5aef8de7c11eb0768698133b1688aa9bb77f88b  root/static/images/flag/cn.png
d03b9541a206d1eca276ef6fb683dd8b3e61d311  root/static/images/flag/co.png
d698f2e308304f5ac8e379f8ecada011cc9f257d  root/static/images/flag/cr.png
070d2ba2174abd2b9eb29c12c96b443be4a6d3be  root/static/images/flag/cs.png
3380dddff08aad0be35dd33aaba0ca250d6a9a18  root/static/images/flag/ct.png
ae902012678979069c68cd5853c36d449d064d79  root/static/images/flag/cu.png
e1eff2f478f8be92893fcb356313ba9bc8811edd  root/static/images/flag/cv.png
5be99dbcbdeb4fe75352bfc990c333103432644d  root/static/images/flag/cx.png
269865a9cafba4b45f548b313de25056bbf9561d  root/static/images/flag/cy.png
96635c50c150934a920a82348ffc990e67b34dc4  root/static/images/flag/cz.png
227f9f143acacd3fc4752c0e8e7a38bafd68771d  root/static/images/flag/de.png
d0679a902c1ac8a07e480d82c8f5ea57be8143d6  root/static/images/flag/dj.png
492be7aadaf42f433bbadfa3d1ef501fe15910c4  root/static/images/flag/dk.png
010c7744286ff86c74d39b52d7d9664563f9d0af  root/static/images/flag/dm.png
65b145cc2824786ec181f57d3c932b97ea61676a  root/static/images/flag/do.png
5693dab8f6447aa35d8d3996c88f016ccf2308b6  root/static/images/flag/dz.png
4d5d982c5afc4987d1bb4d6ea1e8bcaa02dd4117  root/static/images/flag/ec.png
fc7192549dd41d7bceb120dc861c3d556fbf2b7a  root/static/images/flag/ee.png
67c038bdf4878a010c5e02f1b0882379488fa2c8  root/static/images/flag/eg.png
5b6e218cd18fd70cce7bcfc0b9f3382cadafb842  root/static/images/flag/eh.png
9ca83612c71a0a125d785a0d0dd854339aa59be0  root/static/images/flag/england.png
ce7ca10a35a6648781202693f521eb5d3a940d29  root/static/images/flag/er.png
38591de6f587dbb2caa2ccfada3e243eb5a3cf15  root/static/images/flag/es.png
569222c2f0902bc44fa2bd012564ae85d12e3ea6  root/static/images/flag/et.png
bb0857be0eba184b7faafa6c2cd075743ee8af68  root/static/images/flag/europeanunion.png
6addba050674961e2279cd997056a7418f2d798a  root/static/images/flag/fam.png
257a4d8cb3e704cc691dae6216d1df0de332d84d  root/static/images/flag/fi.png
757b23b361a4fafedc8b273373cdedfed57b03a9  root/static/images/flag/fj.png
97f85fd5338a194b16cda40240be1d950761b8a6  root/static/images/flag/fk.png
7c83f55c157600785105388ade44231d17da3cc6  root/static/images/flag/fm.png
93f768e5e67afc4c6c4d21e4c4ec5e084c13fc5b  root/static/images/flag/fo.png
ac676c76c3cefa4d24df13a1f0ae7b012f301cf0  root/static/images/flag/fr.png
ff4bd0cb9802f2745722ec439cacb2d69c42e319  root/static/images/flag/ga.png
2d2252727ee7df2697657f1f7d122494ee90a38f  root/static/images/flag/gb.png
a7e1e82e5ed8f8d1a42dd0ac77729a5593d73da4  root/static/images/flag/gd.png
2ea28f9d3fc9ea0bef18b97fbe01b60ce98bcde2  root/static/images/flag/ge.png
ac676c76c3cefa4d24df13a1f0ae7b012f301cf0  root/static/images/flag/gf.png
f6cb942939dfd4e4cd320256718a8ff1d64d2ecc  root/static/images/flag/gh.png
37160eda114d33f15da5ce9ccad0c80d3229824b  root/static/images/flag/gi.png
cfe2389d19c0b8b06140b8ec40bc1d3dfaef2a96  root/static/images/flag/gl.png
e91a42ce8bf537814ad94fa747db4bbc06ba10ef  root/static/images/flag/gm.png
c73440ac377ccc0cf4499c83bdf27f38ebe19f6f  root/static/images/flag/gn.png
1ee748bbbd969ec3f881073d21b1ac4263237d76  root/static/images/flag/gp.png
8cf71670916cc33e88f1dd9d714a7f4d8b748c25  root/static/images/flag/gq.png
c01213416b3ed9cf25f6bab9cfd75ddb34343441  root/static/images/flag/gr.png
2e6af3a823404c03a29b4b875f0a284c67d010e4  root/static/images/flag/gs.png
723082c03f7f7428819f244fba317351fde9fe3a  root/static/images/flag/gt.png
f22620c2b07727bb29345dcf14dfdff857498eb9  root/static/images/flag/gu.png
eee25434a40e2020091d979a830492bb26d014d0  root/static/images/flag/gw.png
400abfad1fa7b64f7b78b2bc0769de771cbf0621  root/static/images/flag/gy.png
d448a174dd4b5b3eebb4c5ec9ff344b2857cafde  root/static/images/flag/hk.png
b1e3a3b54aa747331b6a468883f0f470aded8d32  root/static/images/flag/hm.png
0902195090b0bc4b01c85c466e4446b883d0199d  root/static/images/flag/hn.png
bde348d7938a8a71c3f89416e7e00f997b39fea5  root/static/images/flag/hr.png
8381b5ba9c0e061f90fa612ba06ee3c51c0cf62e  root/static/images/flag/ht.png
7f32e88f7012c28c6f3309ee0be65181c98435df  root/static/images/flag/hu.png
a93e453dd3d2ba59eb29c108447437be4e005f20  root/static/images/flag/id.png
6c782302d871f065a70cc297262ab4977c06e947  root/static/images/flag/ie.png
3f8f663abe29074cb3f7262f65ac853c4d318177  root/static/images/flag/il.png
29378fc45ad0b4f37e2a31d8d3bb6fd2733cd750  root/static/images/flag/in.png
18574bfa6e9ceeaef41b20a2aac7e4dd1163e07f  root/static/images/flag/io.png
2f88bd1f61d8cf7da6d437128a517135dd6f23cf  root/static/images/flag/iq.png
b22d713769c90c36204493ce3c5247c637acee68  root/static/images/flag/ir.png
78aef4d57c9fd988642bf6ccf5e51e38c7d14476  root/static/images/flag/is.png
e6968e1a37dc2059cad6766deaeacf7d61927826  root/static/images/flag/it.png
14a77030943a095bd33bdeff4ffc92e3bf96a3cd  root/static/images/flag/jm.png
077dcae8ee48930e83609e12bf533e235fb8c037  root/static/images/flag/jo.png
b48dd756851dde20d12c407002bd9c4f58ed4bee  root/static/images/flag/jp.png
cc6c12136699fec1844d369e3742ff366860b0e7  root/static/images/flag/ke.png
54c60dbc073a195aae60d7ddd05885d2b684bbd5  root/static/images/flag/kg.png
026198ed425398c001ddd3e681c08d50888612f1  root/static/images/flag/kh.png
15c274882e733b55fdc264e4ba2480a6f471ba1a  root/static/images/flag/ki.png
edb27a978fd1d66e8d0187a0e47fb50e754b1e55  root/static/images/flag/km.png
c637a13fdc62d8e8974fba8d2abc9a2932a1ffc2  root/static/images/flag/kn.png
882ba84d82ef766eb21b35e19d82af8b86ebbbc9  root/static/images/flag/kp.png
f4338b9edce1df94d1a8caced13d9e7de33f5629  root/static/images/flag/kr.png
7c9ba741b6ad0fb3f0e7842d675564e4b9f18db9  root/static/images/flag/kw.png
536fec8f9dd626903eb20e733b93c88619e5048c  root/static/images/flag/ky.png
9e859cae5d15f8cf3202fdaba8b156f37697e7f4  root/static/images/flag/kz.png
3a6e1bb74bcc096bf0f9575224847fcb005e95ad  root/static/images/flag/la.png
a3c603bf4795612cdcfdbd524457348f82f7b3e9  root/static/images/flag/lb.png
61ed337c2b3c7aebff752f55ad4ad219fa1a78b4  root/static/images/flag/lc.png
d4c34a6a2f431ce11dbbd0dec438fe8b1d2e71f8  root/static/images/flag/li.png
c6b73abba26b602859599ba6d9ca7464dbcde5e8  root/static/images/flag/lk.png
358cd0cc2dae5be69d55f41bf3581e4d8f9bcb2a  root/static/images/flag/lr.png
135fd39cfaf0e8c3e3e116bb861a5a3398a71e9c  root/static/images/flag/ls.png
3a5ef6b5bb3d5b0ab910700cd45f81bc537a2377  root/static/images/flag/lt.png
b3c3664dbbdcd96331f4e463629bc66653e7995f  root/static/images/flag/lu.png
c07f77c05f5ff79cc656a3419ce313938007d08d  root/static/images/flag/lv.png
81401759c25db8931b5f53b8dbbf5e0806eda1dd  root/static/images/flag/ly.png
138a8f6fa8b0779b410ac465af099c14849976db  root/static/images/flag/ma.png
581fde2017f60bd6ae078888395cf4788307eff7  root/static/images/flag/mc.png
7afb89a3ef3f75cf8c4f89b7521c13316b7d21f9  root/static/images/flag/md.png
470743bac20f4282b8483450f17b875ae4ca227d  root/static/images/flag/me.png
9d2a496b987b025da6f1e77cf82e5db24717d085  root/static/images/flag/mg.png
0e3060d94e13993732f796ca6790c352cc5986bb  root/static/images/flag/mh.png
a16c86993248c4f79fd3ce9aea53c01581b00cae  root/static/images/flag/mk.png
758913c7093b77d4d7aad6c3b84ec2ab90a61131  root/static/images/flag/ml.png
fd888c92b299018eedb20c41366e868dd9561f66  root/static/images/flag/mm.png
a3a51ce109e5510cce1f71b60bc27dc12c670df4  root/static/images/flag/mn.png
1fe878fe2d2b5852aa0db7185b8400aa80b61dcc  root/static/images/flag/mo.png
4a74701182bbfcd8767f7377e940a22f572c109f  root/static/images/flag/mp.png
7737641349533b595bcc807edb6877432d6cda3a  root/static/images/flag/mq.png
fe648fb5ed419e74803f24c27728c1f034ba457a  root/static/images/flag/mr.png
42bcde1064e218ee4417bf1d984b0b915b8ad794  root/static/images/flag/ms.png
8dd994e8594466552b5928f2aef40cca81668292  root/static/images/flag/mt.png
36ff160d256eff6487118fc6e9e34104b741df33  root/static/images/flag/mu.png
4ab64ed6e406e7e22d75f2a1da8c2c23c4eced39  root/static/images/flag/mv.png
328e68f89613ae681f89b2adf448a17a61893b46  root/static/images/flag/mw.png
dafaf4482b573010f75c79b55c06219fbe44e501  root/static/images/flag/mx.png
1dbfc17f31c5d73083e9686086eb72c402c10970  root/static/images/flag/my.png
b277dfe0081ef9bf2a855a43f2a6a1c1060c71dc  root/static/images/flag/mz.png
55ba43801ea8994332d07bb518331eefc40c7da5  root/static/images/flag/na.png
88838d9df558c47575acf1ec3e03286119100228  root/static/images/flag/nc.png
b1010219c9a606c73dd91135ef06c4102ef2c958  root/static/images/flag/ne.png
430cfaee743e9d8d5d3c8336aa0369e0f44802d3  root/static/images/flag/nf.png
cb02c41decc8e7e8d077c5b3ef878e50baf0c6ca  root/static/images/flag/ng.png
0b68dd65207a2142d96be8fb856264d18aeb3d84  root/static/images/flag/ni.png
eb0cf9b99ad87219d4067ff8fd68845cf663d62b  root/static/images/flag/nl.png
993f09a3f83b06dd0c60a1a1c1ab626616a80691  root/static/images/flag/no.png
1688dcfdfe149a937b6445b733055fe3b5a9e7c2  root/static/images/flag/np.png
5f0f408d9126d6c4016a3193b2a0d6776b2ce0ee  root/static/images/flag/nr.png
2145604d3a97ca96166985dabe3c26ef791eee30  root/static/images/flag/nu.png
1c91c8a73b713f1a2334e745b3770c9addfa17c5  root/static/images/flag/nz.png
b7569257098271b97dba23bc8be0b6da7f0d58d8  root/static/images/flag/om.png
71544a40bd5a809275fbe93be55b1fa50bbe082c  root/static/images/flag/pa.png
7408c6378663030f4e5fc12497a1720ad1184427  root/static/images/flag/pe.png
d5caec866ed57385a592a88dd205b00be8fdcaa4  root/static/images/flag/pf.png
64fd70e3bdc64907d4959fa7ca26f0bb6d0e8950  root/static/images/flag/pg.png
e7b5bd5aee43e0bb8ccde469e8a546878fdc5bc6  root/static/images/flag/ph.png
4455011813df28e7b3253851a48e5f12de5b454d  root/static/images/flag/pk.png
2ea4d6d34e7a7a22fadb5d24fc45dd336d6edbb8  root/static/images/flag/pl.png
5c00e726e5b6722054ea9e72c5e90af082506bc4  root/static/images/flag/pm.png
00671b24ecf082184bdd37c6fa34fdca9dcb6e2a  root/static/images/flag/pn.png
c78c58c4abdef5a72f76236e11fa84e1ee276578  root/static/images/flag/pr.png
aeb64033b647b0645e7c0a2c29b87625e23bed8c  root/static/images/flag/ps.png
4f42728dee7c4e4c25e144dc3037a509b5ea9b0b  root/static/images/flag/pt.png
524a40d7e4a9da9363a232627560a598a19c264d  root/static/images/flag/pw.png
74c5bc2fc5d2ca1b1c5abdc74ce88b9d9781f865  root/static/images/flag/py.png
a234e6b821929016ebe2582f24852544c0ebadc3  root/static/images/flag/qa.png
ac676c76c3cefa4d24df13a1f0ae7b012f301cf0  root/static/images/flag/re.png
736a9f0e74f44916c0731576d99fa06244a76b17  root/static/images/flag/ro.png
23a9e15642bd7a5a7860d281e0e68c6a0a6a81d8  root/static/images/flag/rs.png
5dee6bec53ee330a32bc13aeb5ad66b2d95ae56d  root/static/images/flag/ru.png
53c55248eddee3a19393ee21d873b67af7a754d7  root/static/images/flag/rw.png
83c3f966b229ed2acf9c9feada2ac42649f4fe1b  root/static/images/flag/sa.png
43b918fadfa3c5db0bb72d84bd3fc8e30f0df0ff  root/static/images/flag/sb.png
92fe4e82fc8708a7fe67480b8915fc3f380fe5d0  root/static/images/flag/sc.png
240d805dc5389252bca7a6474a75f9bf14920555  root/static/images/flag/scotland.png
14fead6fb243455cfb8c20fe2f8a44d2d7ccb070  root/static/images/flag/sd.png
ee2e7d3d4a7b85992ec91ac7e397d04d3a674bc3  root/static/images/flag/se.png
cc689f2e0ca366cb3da863f62fe061af814e9405  root/static/images/flag/sg.png
66d55e63f310329f8177e212876292db1d8f36da  root/static/images/flag/sh.png
a5bdcaa3691134368e8a0789f06208c0d086e552  root/static/images/flag/si.png
993f09a3f83b06dd0c60a1a1c1ab626616a80691  root/static/images/flag/sj.png
d2a98eaf1eeb2891bf8ee4a57b5b82488960f254  root/static/images/flag/sk.png
34ef0bc46f18707786ed802140522b0a08f94d41  root/static/images/flag/sl.png
b49eb091ecefece8dd9763239c50f0b3ac30a48e  root/static/images/flag/sm.png
e43feb8efd9cf9d0145a883745cbef4c5ee4f672  root/static/images/flag/sn.png
9635b3ef055f746b8fe68e0ac96c09f09b40e652  root/static/images/flag/so.png
bf49269e1802610baae3f67102fee7c76df9fd20  root/static/images/flag/sr.png
5f27fa1d0ef54f8ebad9903e0067e39de4b3d7e7  root/static/images/flag/st.png
d7722f5605a0058aab18a429e4b3fe76f7fbecbe  root/static/images/flag/sv.png
cc7cf710eabf5723cb20d745185675f0546be594  root/static/images/flag/sy.png
058592b5319e99e08b74df07623e2ac1efa91781  root/static/images/flag/sz.png
8dd6fbed684107d54650cc066bf98a2dee777437  root/static/images/flag/tc.png
e5ab5117cdcab6800e58e568ad2eaaeaa40aaadc  root/static/images/flag/td.png
cc62061d1995b5f86ed8a16bf8734283ff508d4d  root/static/images/flag/tf.png
11df441838d5f76773975cd8e5dfe7751f95f12b  root/static/images/flag/tg.png
971bcf3bdb1ab0d22d5046035e4a6fe5ed8bb9c5  root/static/images/flag/th.png
2c674b8a3ec336343bcbbef54edaf8775deb6816  root/static/images/flag/tj.png
feaca8e3d4fc7d878e7ae1f5a9dca0957880d43d  root/static/images/flag/tk.png
2d76cf0b54ae8d3c8515fae4ec47f2f852a6a3ca  root/static/images/flag/tl.png
0877316905724f24b6aead16d3db71e97ae4003b  root/static/images/flag/tm.png
046e210cef7cfcae885edd3566adb4453506753c  root/static/images/flag/tn.png
cf3f7acfce003c55b27e2eddc5c64bb8846ca09b  root/static/images/flag/to.png
0f8270dbfaf1fee0c890a37329f1fc934578ab74  root/static/images/flag/tr.png
fbe9b484923116ad8a2bcf82cec699b91c30a663  root/static/images/flag/tt.png
d003e55b5f1039fb5cd6245937d66930f60e9f93  root/static/images/flag/tv.png
b7f6a3b5beecc817cf1910c6ba56aad020ae85ff  root/static/images/flag/tw.png
4c10a01f694c09815a428afd841137827783ec28  root/static/images/flag/tz.png
c25db33eec90ce647ef60a221f0edf9688d71860  root/static/images/flag/ua.png
52ef3a14b469b96bd6a8b8c0dec9b7a0802bab4b  root/static/images/flag/ug.png
4f2b922f60d83b31eeab38c767e9ff5d46a57b3b  root/static/images/flag/uk.png
c71d7d21e036c957591291e36cbc41429c084065  root/static/images/flag/um.png
1479802403c35c4fa52f8587d17012aa78798ac6  root/static/images/flag/us.png
a780991f52d454a92264c548230b2e15c230ac10  root/static/images/flag/uy.png
ae49f285bb64ae74fab6252b5e4bf82316a64cd9  root/static/images/flag/uz.png
60287158752bbd32d66dd8fab19f5909bdb1d307  root/static/images/flag/va.png
418473b225c06b52d6e8cb7f0f325098326f15be  root/static/images/flag/vc.png
6a4d244485bb1cafc0aef43d554b75871c4e87f3  root/static/images/flag/ve.png
76d5f8c7fd51dbc06b4ed53288b3dc15252c4ff4  root/static/images/flag/vg.png
daab9de79fb184bc3849063dcf54071957a622ae  root/static/images/flag/vi.png
4a31798471c992200ddf7f5c68461c00fa08978c  root/static/images/flag/vn.png
2595aa1ffc0300639e9432aac85f7ad621ecb2b6  root/static/images/flag/vu.png
e93a5be7d95233a9df3f96b642d4b153a0f69b4f  root/static/images/flag/wales.png
98faebd2bfc945c7c118e932f6382aad8c110a20  root/static/images/flag/wf.png
449ad612b4981ba130dd727edc0a8f98aa16df32  root/static/images/flag/ws.png
48b9a9a905479f9d4dae8e8c2f61d118b501102e  root/static/images/flag/ye.png
afe19553a9e2031f1fbe0dd3d6e2fc2423bb255a  root/static/images/flag/yt.png
feea3187e982145186f283f92b499c09e7687dc2  root/static/images/flag/za.png
a3c6a57541a2ffddd6b91ebbdb96befd4ad92652  root/static/images/flag/zm.png
2976e751f3c7ba4ba941c5517802b32428e90e78  root/static/images/flag/zw.png
8c2ccfffd4eed6908e37032d7a73492451bb9b05  root/static/images/gray.png
b7bf154dd5c44f62e8762327d34c56d1541e4039  root/static/images/metacpan-logo.svg
0cc5770d720c1f8604c92c97d1137a3eb4a6596c  root/static/images/profile/bitbucket.png
a3186aa4864390fbc418806dc0785cc208557ede  root/static/images/profile/blinklist.png
bb03c436933efae1464fa103d2aa0146f0e71cb2  root/static/images/profile/brightkite.png
a5d3e94fbb974e2ef0154228a5dcb36b8a3e75f8  root/static/images/profile/coderwall.png
69344764309bcf9c9f5e873c3eda5741ec81cbfb  root/static/images/profile/couchsurfing.png
3dcfb1ba28b55eb470f8ebfe66e63580558f44df  root/static/images/profile/design_float.png
2dbed99d2f09ba268954a03b9a3425b4a14e3ef8  root/static/images/profile/dopplr.png
3f65db48f1971b2fc837c3168dea20e96b16946d  root/static/images/profile/dotshare.png
87d0c86253e979c396ab7e3acecc89581efd16e6  root/static/images/profile/email.png
65065c1a2a504cbeb4a6462ac2d3f26a0b4825da  root/static/images/profile/facebook.png
4a9cf5fb039e7118d829c9adb7c7600531d8a5aa  root/static/images/profile/feed.png
1d0dbc7cd409b41c1687ff503d223225fcae390d  root/static/images/profile/flickr.png
992d52f26d3d159cf2495f5a7241f67a224ea9aa  root/static/images/profile/friendfeed.png
0d8cf45c93988001f7465ff87be26d0b82f1bef8  root/static/images/profile/furl.png
968957a97c6066602d4d359e6a0a4ae340156f15  root/static/images/profile/gamespot.png
c9aad238ad66887c8498279293f4c779cc142887  root/static/images/profile/geeklist.png
7768618ea6b52b35ce13ba8866228fda77e86c5b  root/static/images/profile/github.png
976db088e71f755f7e51b29496df6bd8de53c13b  root/static/images/profile/gitlab.png
21dff75b978510ddfa6c33203ca8b266494ab2d0  root/static/images/profile/gitorious.png
f6b88ec72f3611127356d6c59c17901cd09df584  root/static/images/profile/gittip.png
6d1e4fa7af002dbe2185419863daa92ea4141d27  root/static/images/profile/hackernews.png
9b86fef7a4fcf2e854152c183285fec2bb073bee  root/static/images/profile/hackerrank.png
94671f8a3e0af14982bc9d35c776f8cbe57c3518  root/static/images/profile/hackthissite.png
d91b6bb320532f8519d15199d13fd23433124b75  root/static/images/profile/identica.png
12422a9c1b690e0820fcf5c35195b1087408a305  root/static/images/profile/instagram.png
250c08fb7790c4771050f18eacdc5f3180be3e87  root/static/images/profile/lastfm.png
d2305c39515daaf8c89d9bf3055690bfd41ddcbb  root/static/images/profile/linkedin.png
9cb35d11f03337e0ba9661c2229267f9a23ef188  root/static/images/profile/magnolia.png
7a56a8890ac6d6a2073383f98181a490de156cfa  root/static/images/profile/meetup.png
796fb059f0bc0e282f86f49fa5da575525b3cc14  root/static/images/profile/metacpan.png
a22660e444f3059bbd0db0a5c41ce4a8cdedb1ec  root/static/images/profile/mixx.png
474cfd2775d0a86706d072649281fd4210eba917  root/static/images/profile/myspace.png
b54de94e16f78f40c1b1dc5bd6469e3093fea15a  root/static/images/profile/nerdability.png
0b8172a74b5ad4afa40f6246b9087de057232110  root/static/images/profile/newsblur.png
cf600d1ce2ba84d54bc210ed4859b90a07d22f6a  root/static/images/profile/newsvine.png
7b734b00f54ea1f64fcb9c62c6093b2f45f0e755  root/static/images/profile/ohloh.png
3c3922920e78403c4e6c969cb9b7f7f185f552c0  root/static/images/profile/orcid.png
4183a8a028543531a4a04a40917ac4cc1eb1d39e  root/static/images/profile/perlmonks.png
a8caffce132bcfdaa0d87d6311ca7ba40be30e9d  root/static/images/profile/pinboard.png
bbc03be0b7e878b0ac5b552ca1c2c4a568dcd744  root/static/images/profile/playperl.png
723b1d505ba65d0d11c3e7e5f33158ae1349cc5b  root/static/images/profile/posterous.png
f53a57193f209a34f70bb791750cb60df3a4cb30  root/static/images/profile/reddit.png
9375111d1ec664e1c38203b419e4518f770076d6  root/static/images/profile/slideshare.png
3911607f7c8558628bf3da1dac17c629f073a490  root/static/images/profile/sourceforge.png
8776aea26dfdf439fe49708e2443af5fe80a413b  root/static/images/profile/speakerdeck.png
47b929c1a69439c75a45996f679d25e641b46bb6  root/static/images/profile/sphere.png
8124d18e33e0f8d4c34fda699049327994b6aa28  root/static/images/profile/sphinn.png
0aa89b247473f38ca58b3f4f7671d8e5197164b1  root/static/images/profile/stackexchange.png
b47eacd70f55c9affa2cddefd9ab670cc1ba9e9d  root/static/images/profile/stackoverflow.png
09e6119a810d344a3a1999f178f19ccddbc9a803  root/static/images/profile/stackoverflowcareers.png
714f1bdbec3add94bb526d21b4ca6e175d6f7464  root/static/images/profile/steam.png
6b6151d6104f169ee7b534a19bc548c25ec1a2b8  root/static/images/profile/stumbleupon.png
deb71618182162153d8452275db7d4ed87ab1550  root/static/images/profile/substack.png
1b59c8976d02cbfb8c86955b6541572187fafcb6  root/static/images/profile/technorati.png
f99eaa4bd2db23997d6a3ff722edd4ffc65571c9  root/static/images/profile/tripadvisor.png
326411b5ed27cbed86fd4a0eac83f49579553420  root/static/images/profile/tumblr.png
52ab835d12cf808924dbe5ac15f28115e23c405c  root/static/images/profile/twitter.png
7022b109b09a2167e7d2acdf7d4544886fa1c83c  root/static/images/profile/vimeo.png
f9f0e31b575d54daff57a3ff7a5df362cfc37f92  root/static/images/profile/youtube.png
161cb712a2298eeb3940afc710caf7f9f9194bef  root/static/images/sponsors/activestate.png
16b8e4557ee882a3dd157170e08d1ededa18812a  root/static/images/sponsors/advance-systems.jpg
ee9ccebabfe78643470da003d83e6b61608979f6  root/static/images/sponsors/booking.png
8a01c9ce500f517cceded7e5b929b718af2f10e9  root/static/images/sponsors/bytemark_logo.svg
12036785cf973c7340818e0837db942830dbf01e  root/static/images/sponsors/control-my-id.png
8d0a1c548cae06f8d384c7619ee55baabcc27386  root/static/images/sponsors/cpanel.png
0f8418f040c5504fa69386bafcf7046f11c37503  root/static/images/sponsors/dealspotr.png
6f5474eb784a5e9c7498c7a5d773b6ae7b9b5c2d  root/static/images/sponsors/deriv.svg
8c9059f6ef31a420bfb9f6efb4ce01278e5a5740  root/static/images/sponsors/dyn.png
a588394fcb496ee492d289d4db0e1d3624a34528  root/static/images/sponsors/easyname.png
ad5fc6a8acfc28c3f2836e5265ed6607d2105f6a  root/static/images/sponsors/elastic.svg
5d76d29f7e9ce2d323cef2c451cd26300e10c770  root/static/images/sponsors/epo.png
affc39387e003c45463936607df8f48ff4727c2c  root/static/images/sponsors/fastly_logo.svg
bf821b7f7ef4d00c61046141e8e28b9366eb3dbb  root/static/images/sponsors/fastmail.svg
4b8d0d2d653d76dc59b446bd706b034a007f581a  root/static/images/sponsors/geocodelogo.svg
ff77edb3ea13567310837717da9d2cdea155682c  root/static/images/sponsors/github_logo.png
ddc82658ac274d981a7e3159fc4ed452166f73a4  root/static/images/sponsors/idonethis.png
887d712f253b63e53319ad37cfcf3fdbd36e8a36  root/static/images/sponsors/kritika.svg
45ae7ac5577e16b082966d44053844948ae627bc  root/static/images/sponsors/liquidweb_logo.png
ddaa87b7948c4d46a51f763c80570c1767f1c0b4  root/static/images/sponsors/open-cage.svg
7f77555505dfcb1a2c3b47bec95062fe2dd7a5da  root/static/images/sponsors/panopta.png
fb43b99a721b83aeebf528977f3df7083a69289e  root/static/images/sponsors/perl-careers.png
e7a33768fa5460562e48a3676fe048d3e261f8dd  root/static/images/sponsors/perl-services.svg
5cdd9d7bda9936c0ab678063a93df341fd37acb1  root/static/images/sponsors/perl_logo.png
e691cd3eb125c4b9e157a083a1c0a5f14e5a692a  root/static/images/sponsors/qah-2014.png
bb659e08ba1966a9e6d90f9969ce89dd8c6a61b7  root/static/images/sponsors/servercentral.png
b22714f31bf7817c297cf6670fa27c0fe53e9897  root/static/images/sponsors/sonic.png
f251ab8c5c58c9c87bbd2e6042d9b2574cd0bc8b  root/static/images/sponsors/speedchilli.png
28b210ec069326d1914b54186854e278b874e08e  root/static/images/sponsors/travis-ci.png
d1756602e3883c084a901338b96d8a03b8b540b9  root/static/images/sponsors/vienna.pm.jpeg
6df4cc414faac9f34dcac688d4edc19757bc61f3  root/static/images/sponsors/yellowbot-small.png
7d258eae0a03c68f57f87b385e5df233aa62fb57  root/static/images/sponsors/yellowbot.png
f00590419c1aa7a25f90da433e939e89468da3a7  root/static/images/sponsors/yellowbot_2.png
