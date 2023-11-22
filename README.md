# comtradeAPI

Interact with the [comtradeAPI](https://comtradeplus.un.org/) to download data directly or via their bulk downloading service.
For a more detailed description of the admissible parameters and functionality beyond the function descriptions, please see [here](https://unstats.un.org/wiki/display/comtrade/New+Comtrade+User+Guide#NewComtradeUserGuide-UNComtradeAPIManagement).
## Functionality 

### 1. Set your API Key
```r
# set key
comtradeAPI::setPrimaryKey("yourComtradeKey")
```

### 2. Download data directly (up to 250k entries max)
```r
# downlaod monthly trade (max 100 rows) between reporter 757 and 288
# reporter code / country association is described in `comtradeAPI::reporters` 
comtradeAPI::getData(
  reporterCode = 757,
  partnerCode = 288,
  maxRecords = 100
  period = 2020,
  freqCode = "M"
)
```
### 3. Download file which shows which files are available for bulk download
```r
preview <- comtradeAPI::previewBulkData(
  reporterCode = 288,
  period = 2020,
  freqCode = "M",
  clCode = "H2"
)
```
### 4. Download the files listed in preview (from 3) to "filePath"
```r
comtradeAPI::getBulkDataFromLink(
  data = preview,
  filePath = "yourFolderPath"
)
```

### 5. or just do step 3 and 4 in one, if you do not need to preview what you download before
```r
comtradeAPI::getBulkData(
  reporterCode = 288,
  period = 2020,
  freqCode = "M",
  clCode = "H2",
  filePath = "yourFolderPath"
)
```

### 6. and ultimately, unzip (decompress) the downloaded files
```r
comtradeAPI::decompressFiles(
  filePath = "yourFolderPath",
  removeOriginal = TRUE
)
```
