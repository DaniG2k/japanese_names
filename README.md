# JapaneseNames

JapaneseNames provides an interface to the [ENAMDIC file](http://www.csse.monash.edu.au/~jwb/enamdict_doc.html).

## JapaneseNames::Parser

### Parser#split

Currently the main method is `split` which, given a kanji and kana representation of a name splits
into to family/given names.

```ruby
  parser = JapaneseNames::Parser.new
  parser.split('堺雅美', 'さかいマサミ')  #=> [['堺', '雅美'], ['さかい', 'マサミ']]
```

The logic is as follows:

* Step 1: Split kanji name into possible last name sub-strings

   ```
   上原亜沙子 => 

   上原亜沙子
   上原亜沙
   上原亜
   上原
   上
   ```

* Step 2: Lookup possible kana matches in dictionary (done in a single pass)

   ```
   上原亜沙子 => X
   上原亜沙　 => X
   上原亜　　 => X
   上原　　　 => かみはら　かみばら　うえはら うえばら...
   上　　　　 => かみ　うえ ...
   ```

* Step 3: Compare kana lookups versus kana name and detect first match (starting from longest candidate string)

   ```
   うえはらあさこ contains かみはら ? => X
   うえはらあさこ contains かみばら ? => X
   うえはらあさこ contains うえはら ? => YES! [うえはら]あさこ
   ```

* Step 4: If match found, split names accordingly

   ```
   [上原]亜沙子  => 上原 亜沙子
   [うえはら]あさこ => うえはら あさこ
   ```

* Step 5: If match not found, repeat steps 1-4 in reverse for FIRST name:

   ```
   上原亜沙子 => 

   上原亜沙子 => X
   　原亜沙子 => X
   　　亜沙子 => あさこ
   　　　沙子 => さこ
   　　　　子 => こ

   上原[亜沙子]  => 上原 亜沙子
   うえはら[あさこ] => うえはら あさこ
   ```

* Step 6: If match still not found, return `nil`


## ENAMDICT

This library comes packaged with a compacted version of the [ENAMDIC file](http://www.csse.monash.edu.au/~jwb/enamdict_doc.html)
at `bin/enamdict.min`.

This file can be regenerated by `rake enamdict:refresh`, which downloads, extracts, and compiles the ENAMDICT file.


## TODO

* **Additional Methods:** Add additional methods to access the ENAMDICT file.

* **Performance:** Currently name lookup takes approx 0.5 sec. Benchmarking and/or a native C
implementation of the dictionary would be nice.

* **Gender Lookup:** Use m/f dictionary flag to infer name gender.


## Contributing

Fork -> Commit -> Spec -> Push -> Pull Request


## Authors

* [@johnnyshields](https://github.com/johnnyshields)


## Copyright

Copyright (c) 2014 Johnny Shields.

ENAMDICT is Copyright (c) [The Electronic Dictionary Research and Development Group](http://www.edrdg.org/)

See LICENSE for details
