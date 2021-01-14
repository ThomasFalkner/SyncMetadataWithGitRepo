rem copy Metadata from git repository directory
rem pull, rebase and rebuild cache

@echo off

set ol_shared_path=C:\Sage\Office Line\DevLong\Application\Source\Shared
set solution_path=C:\AppDesignerSolutions

set PartnerIdDotPackageId=%1
echo %PartnerIdDotPackageId%

if not exist %solution_path%\%PartnerIdDotPackageId%\ (
	echo No metadata directory!
	exit
)

echo Pull and Rebase
git pull --rebase

for /f "tokens=1 delims=." %%a in ("%PartnerIdDotPackageId%") do set partnerId=%%a
for /f "tokens=2 delims=." %%a in ("%PartnerIdDotPackageId%") do set packageId=%%a
echo %partnerId%
echo %packageId%

set metadata_path=%ol_shared_path%\Metadata
set repos_path=%solution_path%\%partnerId%.%packageId%

echo copy package file
copy "%repos_path%\Packages\%partnerId%.%packageId%.xml" "%metadata_path%\Packages\%partnerId%.%packageId%.xml" /y

for /D %%G in ("%repos_path%\Data\*") do (
	del "%metadata_path%\Data\%%~nxG\*.%partnerId%.%packageId%.xml" /f /q
	copy "%repos_path%\Data\%%~nxG\*.%partnerId%.%packageId%.xml" "%metadata_path%\Data\%%~nxG\*.xml" /y
)

echo Rebuild cache
@echo on	
"%ol_shared_path%\Sagede.Shared.RealTimeData.Metadata.Exchange.exe" /action=RebuildMetadataCache /partnerid=%partnerId% /packageId=%packageId%

echo ready!

exit