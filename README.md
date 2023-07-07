# A basic record type

Usage:

```raku
use Record;

record User {
   has Str $.name;
   has Int $.age;
}

User(:name<Author>:age<42>);
```

`Record` offers no validation beyond Raku's normal type-checking; fields are not required unless marked with `is required`.

Compare with [Data::Record](https://github.com/raku-community-modules/Data-Record), which offers a less-minimalist alternative with more advanced validation.
