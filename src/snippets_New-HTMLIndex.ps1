## some snippets for making a directory index static file for some path -- eventually useful for making index pages for static site on GH Pages?

# Get-ChildItem ddayinc-com\tmp\siteContents | Select-Object @{n="Name"; e={"<a href='{0}'>{0}{1}</a>" -f $_.Name, $(if ($_ -is [System.IO.DirectoryInfo]) {"/"})}}, LastWriteTime, @{n="LengthKB"; e={if ($_ -is [System.IO.FileInfo]) {"{0:n2}" -f $_.Length / 1KB}}} | ConvertTo-Html | ForEach-Object{[System.Web.HttpUtility]::HtmlDecode($_)} | Out-File -Encoding ascii blah.htm

$hshParamForConvertToHtml = @{
    Title = "This index"
    CssUri = "ddayinc-com\tmp\src\style.css"
    PreContent = "pre"
}

# .bz2 .gz .gzip .tgz .uz .zip; https://fontawesome.com/icons/file-zipper?f=classic&s=regular
# .clixml .htm .ipynb .js .json .php .ps1 .py .sh .sql .yaml .yml; https://fontawesome.com/icons/file-code?f=classic&s=regular
# .ini .txt .csv .doc; https://fontawesome.com/icons/file-lines?f=classic&s=solid
# .jpg .png; https://fontawesome.com/icons/file-image?f=classic&s=regular
# .mp3 .m4a; https://fontawesome.com/icons/file-audio?f=classic&s=regular
# .mov .mp4; https://fontawesome.com/icons/file-video?f=classic&s=regular
# .exe .msi .msixbundle .u .zone plain ol file; https://fontawesome.com/icons/file?f=classic&s=regular


Get-ChildItem ddayinc-com\tmp\siteContents | Foreach-Object {
    New-Object -TypeName psobject -Property ([ordered]@{
        Name = "<span class='{0}' /><a href='{1}'>{1}{2}</a>" -f $(if ($_.PSIsContainer) {"folderItem"} else {"fileItem"}), $_.Name, $(if ($_.PSIsContainer) {"/"})
        LastWriteTime = $_.LastWriteTime.ToString("s")
        # LengthKB = if (-not $_.PSIsContainer) {[Math]::Round(($_.Length / 1KB), 2)}
        SizeKB = if (-not $_.PSIsContainer) {"{0:n2}" -f ($_.Length / 1KB)}
    })
} | ConvertTo-Html @hshParamForConvertToHtml | ForEach-Object{[System.Web.HttpUtility]::HtmlDecode($_)} | Out-File -Encoding ascii blah.htm
