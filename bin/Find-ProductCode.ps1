<#
.SYNOPSIS
   Finds windows installer product codes for installed products that match the specified name
 
.DESCRIPTION
   Thanks to script found on StackOverflow.
   
.LINK
   http://stackoverflow.com/questions/21491631/how-to-uninstall-with-msiexec-using-product-id-guid-without-msi-file-present

.EXAMPLE
    Find-ProductCode Microsoft
    
.EXAMPLE
    Find-ProductCode "Visual Studio"
   
.PARAMETER ProductName
   The name of the product to search for. Supports regular expressions.
#>
param(
    [string]$ProductName
)

get-wmiobject Win32_Product | where-object {$_.Name -match $ProductName} | Format-Table IdentifyingNumber, Name
