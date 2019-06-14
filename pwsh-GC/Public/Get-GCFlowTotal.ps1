function Get-GCFlowTotal {

	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,ValueFromPipeline=$true)][System.Array]$Flow
	)
	
	begin {
		$Subtotal = 0
	}
	process {
		foreach ($F in $Flow) {
			$SubTotal += $F.Count
		}
	}
	end {
		[Int32]$Subtotal
	}
}

