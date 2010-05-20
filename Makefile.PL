use ExtUtils::MakeMaker;

use YAML::Any qw(LoadFile);
my $file = "plugins/FacebookCommenters/config.yaml";
my $version = LoadFile($file)->{version} ||
    die "No version found in $file";

WriteMakefile(
    NAME            => 'Facebook Commenters',
    VERSION         => $version,
    DISTNAME        => 'FacebookCommenters',
);
