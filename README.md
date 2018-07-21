# qc-ipa - Experimental conversion of French IPA to Québécois (Joual)

This repository contains code that attempts to convert [French IPA](https://github.com/open-dict-data/ipa-dict) (`fr_FR`) into an approximation of basilectal Québécois, with the end goal of providing a usable IPA dictionary of Québécois French for the [ipa-dict](https://github.com/open-dict-data/ipa-dict) project.

## Demo

The resulting output (labelled with the code `fr_QC`) can be viewed in the ipa-dict repository, where it has been included on an experimental basis.

The demo has been created by applying the code contained here to the standard French IPA dictionary (labelled `fr_FR`) in the same ipa-dict repository.

## Usage

To use most of the options you will need a copy of the French IPA dictionary file (`fr_FR.txt`) which can be obtained from the ipa-dict project [here](https://github.com/open-dict-data/ipa-dict). Several of the options (such as `-c`, `-l`, and `-p`) require specifying the location of this dictionary using the `-d` option. So, if you have downloaded the dictionary to your home folder, you could specify it with:

    -d ~/fr_FR.txt

The options should be fairly self-explanatory, and are listed below. To lookup the (converted) pronunciation of a single word for example, you can use the following command:

    ./qc_ipa.rb -d ~/fr_FR.txt -l [WORD]

If you already have the IPA for a Standard French word and would like to convert it using this script, you can do so using the `-i` option without need to specify a dictionary file:

    ./qc_ipa.rb -i [IPA]

### Options

* `-c`, `--check WORD`: _Check if word exists in standard French database (dictionary file must be specified with -d)_
* `-d`, `--dictionary FILE`: _Specify Standard French IPA dictionary file_
* `-h`, `--help`: _Display help message_
* `-i`, `--ipa-convert IPA`: _Convert IPA for a single word from Standard French to Québécois_
* `-l`, `--lookup WORD`: _Lookup / convert a single word (dictionary file must be specified with -d)_
* `-p`, `--process DICTIONARY`: _Convert the entire IPA dictionary file_

## Notes

It should be stated at the outset that a perfect, accurate, automated conversion may very well be an impossible task. It may not even be desirable to have a dictionary that is the result of such a fully automated conversion.

Therefore, the plan is to address those linguistic phenomena that are straightforward enough to lend themselves to automated conversion, and then manually correct the remaining entries. This is, in other words, an attempt to bootstrap the creation of a freely-licensed resource for Québécois since no other such resource exists (to my knowledge).

Note that there will be a significant number of errors in the database, possibly indefinitely. Many of these will be the result of overzealous application of certain sound change rules. This should be considered experimental, alpha / conceptual-stage software, and should not be used in production or anywhere that accuracy is important.

Nevertheless, observation of the sound changes in the database may be helpful for learners and others interested in acquiring Québécois French, and may assist with listening comprehension practice.

_Please note that the use of the term "Joual" here should be understand in its broadest sense, rather than specifically the dialect of urban Montréal._

## Sound changes

Within the code, there is a distinction between fully-automated conversions (rules), and those which are applied "semi-automatically" from a static list of words (this list can be found in `conversions.txt`).

Examples of fully automated conversions:

* Affricated /t/ and /d/
  * /ti/ => /t͡si/
  * /ty/ => /t͡sy/
  * /di/ => /d͡zi/
  * /dy/ => /d͡zy/
  * etc.
* Reduction of final consonant clusters:
  * /bl$/ => /b/
  * /dʁ$/ => /d/
  * /fl$/ => /f/
  * /gʁ$/ => /g/
  * etc.
* Diphthongization of long vowels:
  * /ɛ̃/ => /ẽĩ̯/
  * /ɔ̃/ => /õũ̯/
  * /ɔ/ => /ɑɔ̯/
  * etc.
* Variant pronunciation of /œ̃/:
  * /œ̃/ => /œ̃˞/
* Change in final /a/:
  * /a/ => /ɔ/

## Vocabulary

While the main focus of this project was originally only to encode the sound changes required to pronounce words from the standard French vocabulary in Québécois, it would also be good to collect any Québec-specific words which are not already included in the [standard French IPA dictionary](https://github.com/open-dict-data/ipa-dict) that we are using. This vocabulary is stored in the `mots.txt` file, which contains a growing list of words that would otherwise not be handled by the converter. Additions to this list are welcome!

Like the `conversions.txt` file, entries in `mots.txt` should consist of two tab-separated columns, with the headword in the first column, and the pronunciation between strokes/forward slashes, e.g.:

    chercheure	/ʃɛʁʃœʁ/
    prélart	/pʁelaʁ/

If there is more than one possible pronunciation, separate each one with a comma and single space, e.g.:

    chus	/ʃy/, /ʃys/

Note that words which are already included in the IPA dictionary for `fr_FR` but simply have a different pronunciation should go in the `conversions.txt` file if they are not already covered by an automatic rule.

## Issues

* Identifying medial open and closed syllables
* Identifying long vowels
  * For example: _fête_ and _tête_ should be converted from /fɛːt/ and /tɛːt/ => /faɪ̯t/ and /taɪ̯t/ respectively, however the presence of /ɛː/ in standard French is not well documented and does not exist in the source database
* In general "r" is represented as /ʁ/ despite a range of pronunciations depending on the region and speaker
  * Specifically, the /r/~/ɹ/ in loanwords from English has not yet been addressed

## Contributing

Corrections and suggestions to improve the output of the code are very welcome. The easiest way to do this is likely to [open an issue](https://github.com/dohliam/qc-ipa/issues) if you see a problem, but if you'd like to create a [pull request](https://github.com/dohliam/qc-ipa/pulls) to solve the issue yourself that would of course be even better.

Note that in many circumstances there is a continuum of possible sound changes ranging from acrolect to basilect, and in each case the most basilectal change has been selected here. For example, final /a/ could be represented as [ɑ] or [ɔ] depending on the situation and background of the speaker, but this has been consistently represented as /ɔ/ here.

The IPA provided should be reasonably _phonemic_ (we are not looking for a precise _phonetic_ transcription), and "astral Unicode" in particular should be avoided if possible. Pronunciations that might be perceived as excessively regional within Québec should also be avoided in favour of those that could be expected to be more generally understood. (A possible area of future development might be to add options at conversion time for specifying region and degree of distance from the basilect -- PRs and/or data to help with this would be very welcome.)

## License

MIT.
