#Requires -Modules Pester
<#
.SYNOPSIS
    Tests a script
.EXAMPLE
    Invoke-Pester 
.NOTES
    checks if an Azure Resource Manager tempalte  meets the generic conditions
#>

$ErrorActionPreference = 'stop'
Set-StrictMode -Version latest

$RepoRoot = (Resolve-Path $PSScriptRoot\..).Path
#$JsonFile = Split-Path -Leaf $RepoRoot
$JsonFile = "$RepoRoot\azuredeploy.json"
Describe "Json file: $JsonFile" {
   BeforeAll { 
        $SchemaVersion = '2015-01-01-preview'
        $SchemaUri = '{0}{1}#' -f 'http://schemas.microsoft.org/azure/deploymentTemplate?api-version=', $SchemaVersion
        [System.Reflection.Assembly]::LoadWithPartialName("System.Web.Extensions")     
        $JavaScriptSerializer = [System.Web.Script.Serialization.JavaScriptSerializer]::new()
        $JavaScriptSerializer.MaxJsonLength = $JavaScriptSerializer.MaxJsonLength * 10
        $JavaScriptSerializer.RecursionLimit = 99
        $json = $null
    }
    
    Context 'Valid Json' {
        It 'is valid Json' {
            #$powershellRepresentation = ConvertFrom-Json (Get-Content $JsonFile -Raw)
            #should also work but throws an error for files > 2MB
            #http://stackoverflow.com/questions/17034954/how-to-check-if-file-has-valid-json-syntax-in-powershell
           { $json = $JavaScriptSerializer.DeserializeObject((Get-Content $JsonFile -Raw)) } | should Not Throw       
        }
    } #end context Json file
    
    Context "$JsonFile properties" {   
       BeforeAll {
           $json =  $JavaScriptSerializer.DeserializeObject((Get-Content $JsonFile -Raw))
       }      
       It 'should include a schema' {  
           $json.Keys -ccontains '$schema'| Should Be $true     
       }         
        It "should have a value of $SchemaUri" {
            $json['$schema'] -eq $SchemaUri | Should be $true
        }      
        It 'should include parameters' {
            $json.Keys -ccontains 'parameters' | Should Be $true      
        }      
        It 'should include variables' {
            $json.Keys -ccontains 'variables' | Should Be $true
        }       
        It 'should include resources' {
            $json.Keys -ccontains 'resources' | Should Be $true
        }      
        It 'should include outputs' {
            $json.Keys -ccontains 'outputs' | Should Be $true
        }       
        foreach ($Parameter in $json['parameters'].GetEnumerator()) {
           foreach ($Item in $Parameter) {
               $Item.Key
               It "parameter $($item.Key) contains metadata" {
                   ($item.value).Keys -ccontains 'metadata' | Should Be $true
               }
           } 
        }
        AfterAll {
            $json = $null         
        }
    } #end context properties 
} #end describe Json file