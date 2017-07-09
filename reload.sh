cd pelican
pelican content
cd output
cp -fRa  ./ ../../
python -m pelican.server