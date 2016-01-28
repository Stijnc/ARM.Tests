# ARM.Tests
Azure Resource Manager specific Tests

## Purpose
The main purpose of these tests is validating basic elements
The main reasons behind splitting tests over multiple repositories are portability and reusability.

## Test included
* It is valid JSON
* It includes a schema
* The schema value is'http://schemas.microsoft.org/azure/deploymentTemplate?api-version=2015-01-01-preview#'
* It includes a 'parameters' section
* It includes a 'variables' section
* It includes a 'resources' section
* It includes a 'outputs' section
* Each defined parameter contains metadata

## Other Testing repositories
* PowerShell.Tests
* PowerShell.Module.Tests
* PowerShell.Script.Tests
