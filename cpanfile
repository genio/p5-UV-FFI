on 'runtime' => sub {
    requires 'strict';
    requires 'warnings';
    requires 'feature';
    requires 'utf8';
    requires 'Alien::Base::Wrapper';
    requires 'Alien::libuv' => '1.013';
    requires 'Carp';
    requires 'Cwd';
    requires 'Data::Dumper';
    requires 'Exporter' => '5.57';
    requires 'FFI::Platypus' => '1.00';
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
