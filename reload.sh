cd pelican
pelican content
cd output
cp -fRa  ./ ../../
python2 -m pelican.server
