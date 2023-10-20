class X::Record::NoMethod {
    method message {"Methods are not allowed on records" }
}

my class MetamodelX::RecordHOW is Metamodel::ClassHOW {
    sub fmt-record(\record) {
        my @values = record.^attributes.map: { .type.raku,
                                               (.has_accessor ?? (S/'!'/./ with .name) !! .name ),
                                               .get_value(record).raku }
        my ($type-len, $name-len) = [Zmax] @values».chars;
        do for @values { "%-$($type-len)s %-$($name-len)s = %s;".sprintf(|$_)}
    }
    method compose(Mu \type) {
        if self.methods(type, :local) { die X::Record::NoMethod.new }
        self.add_method: type, 'COERCE',  anon method (%map) { self.bless: |%map }
        self.add_method: type, 'CALL-ME', anon method (|v)   { self.COERCE: %(v) }
        self.add_method: type, 'raku',    anon method        { when not self.defined { callsame }
                                                               "record $(self.^name) \{\n"
                                                               ~self.&fmt-record
                                                                    .join("\n")
                                                                    .indent(4) ~"\n}" }
        callsame;
    }
}

my package EXPORTHOW {
    package DECLARE {
        constant record = MetamodelX::RecordHOW
    }
}
