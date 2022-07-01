<#

Have hundreds of thousands of files where some may have illegal character limits (256+)? 
This script will loop through directories of a main directory and rename those files by: 
	1. Renaming their parent directory
	2. Removing spaces in the file name
	3. Reverting the parent directory name.
	
Being able to filter through sub-folders is much faster for filtering through files as Get-ChildItem will only contain a fraction of the main directory.

However, if you have all files in one directory, then un-comment line 20 and comment out line 21.

#>

# Changeable variables
$path = "" # Main path for files/subdirectories.
$charLimit = 256 # Character limit (Microsoft OS is 256 by default).

# Start script
Get-ChildItem -Path $path | Select-Object -Property FullName | ForEach-Object { # Loop folders in main directory.
    #pathToScan = $path # The path to scan and the the lengths for (sub-directories will be scanned as well).
    $subDir = ($_.FullName | Split-Path -Leaf)
    $pathToScan = $path+"\"+$subDir # The path to scan and the the lengths for (sub-directories will be scanned as well).
    
    # Loop through files in each subdirectory (or main directory).
    Get-ChildItem -Path $pathToScan -Recurse -Force | Select-Object -Property FullName, @{Name="FullNameLength";Expression={($_.FullName.Length)}} | Sort-Object -Property FullNameLength -Descending | ForEach-Object {
        if($_.FullNameLength -ge $charLimit) { # If the length of name exceeds charLimit.
        Write-Host "The file path exceeds $charLimit : $_.FullName" # Write file path to host.
        $fileName = ($_.FullName | Split-Path -Leaf) # String for original file name.
        $newFileName = ($_.FullName | Split-Path -Leaf) -replace ' ', '' # String for new file name without spaces.
        Rename-Item $pathToScan "0" # Rename directory of file with path exceeding 256 characters.
        Rename-Item $path\"0"\$fileName $newFileName  # Rename file by removing all spaces.
        Rename-Item $path\"0" $pathToScan # Revert directory name back.
        }
    }
}