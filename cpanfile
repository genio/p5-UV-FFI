on 'runtime' => sub {
    requires 'strict';
    requires 'warnings';
    requires 'feature';
    requires 'utf8';
    requires 'Alien::libuv';
    requires 'Carp';
    requires 'Cwd';
    requires 'Data::Dumper';
    requires 'Exporter' => '5.57';
    requires 'FFI::Platypus' => '0.96';
    requires 'File::Basename';
    requires 'File::ShareDir';
    requires 'File::Spec';
    requires 'Path::Tiny';
    requires 'Ref::Util';
    requires 'Sub::Util';
};

on 'test' => sub {
    requires 'Test::More' => '0.88';
};
