rem copy metadata to git repository directory
rem commit and push

@echo off

set ol_shared_path=C:\Sage\Office Line\DevLong\Application\Source\Shared
set solution_path=C:\AppDesignerSolutions

set PartnerIdDotPackageId=%1
echo %PartnerIdDotPackageId%

if not exist %solution_path%\%partnerId%.%packageId%\ (
	echo No metadata directory!
	exit
)

for /f "tokens=1 delims=." %%a in ("%PartnerIdDotPackageId%") do (
	set partnerId=%%a
	echo %partnerId%
)
for /f "tokens=2 delims=." %%a in ("%PartnerIdDotPackageId%") do (
	set packageId=%%a
	echo %packageId%
)

set metadata_path=%ol_shared_path%\Metadata
set repos_path=%solution_path%\%partnerId%.%packageId%

xcopy "%metadata_path%\Packages" "%repos_path%\Packages" /T /E /I /y
copy "%metadata_path%\Packages\%partnerId%.%packageId%.xml" "%repos_path%\Packages\%partnerId%.%packageId%.xml" /y
xcopy "%metadata_path%\Data" "%repos_path%\Data" /T /E /I /y

for /D %%G in ("%metadata_path%\Data\*") do (
	del "%repos_path%\Data\%%~nxG\*.*" /f /q
	copy "%metadata_path%\Data\%%~nxG\*.%partnerId%.%packageId%.xml" "%repos_path%\Data\%%~nxG\*.xml" /y
)

echo Commit and Push
git add -A && git commit -a -m "%2"
git push

echo ready!

exit