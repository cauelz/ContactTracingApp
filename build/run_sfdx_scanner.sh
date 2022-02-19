
echo "Install SFDX Scanner"
sfdx plugins:install @salesforce/sfdx-scanner

echo "Running SFDX Scanner"
npx sfdx scanner:run --target "**/default/**" --format "csv" --outfile "sfdxScannerAnalysis.csv" --violations-cause-error