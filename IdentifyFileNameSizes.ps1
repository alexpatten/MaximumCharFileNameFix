<#

Have hundreds of thousands of files to check paths for? This script will loop through directories of a main directory.
Being able to filter through sub-folders is much faster for filtering through files as Get-ChildItem will only contain a fraction of the main directory.

Note: If you have all files in one directory, then un-comment line 8 and comment out line 9.

#>

#Changeable variables
$path = "" #Main path for files/subdirectories. Note: Do NOT add a \ at the end.

#Start script
Get-ChildItem -Path $path | Select-Object -Property FullName | ForEach-Object { #Loop folders in main directory.
    #pathToScan = $path #The path to scan and the the lengths for (sub-directories will be scanned as well).
    $pathToScan = $path+"\"+($_.FullName | Split-Path -Leaf) #The path to scan and the the lengths for (sub-directories will be scanned as well).
    
    #Loop through files in each subdirectory (or main directory).
    Get-ChildItem -Path $pathToScan -Recurse -Force | Select-Object -Property FullName, @{Name="FullNameLength";Expression={($_.FullName.Length)}} | Sort-Object -Property FullNameLength -Descending | ForEach-Object {
        if($_.FullNameLength -ge 256) { #If the length of name exceeds 256
            Write-Host $_.FullName #Write file path to host
        }
    }
}