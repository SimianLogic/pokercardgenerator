First working release. Works best while run from Flash Builder, but including an AIR binary as well. 

DOWNLOAD BINARY: https://github.com/SimianLogic/pokercardgenerator/releases/download/0.1/PokerCardGenerator.air
TODO: walkthrough

Support for:
* choosing a card layout
* adjusting output size
* choosing a font
* loading images for each suit
* loading images for each face card (with a variety of options)
* saving/loading project file
* exporting 52 PNGs

Not supported:
* loading new layout files (SWCs or SWFs? a text file? would like to make it Flash-independent)
* arbitrarily sized cards
* untested on Windows, will be surprised if the file I/O works without some patches

Known Bugs:
* font choice saves, but on project load the font is not reflected in the cards
