function Set-GCUser {
	[cmdletbinding()]

	param(
		# User object as returned from GuardiCore, but with updated values.
		# Accepts the PS object, not JSON data.
		# This allows you to grab a user, change it via powershell methods,
		# and pass it into this function to update it.
		[Parameter(ValueFromPipeline)]
		[PSTypeName("GCUser")]$User,

		[PSTypeName("GCApiKey")]$ApiKey
	)
	
	begin {
		if ( GCApiKey-present $ApiKey ) {
			if ( $ApiKey ) {
				$Key = $ApiKey
			} else {
				$Key = $global:GCApiKey
			} 
			$Uri = "/system/user"
		}
	}

	process {
		foreach ( $ThisUser in $User ) {
			# Serialize/deserialize
			$RequestUser = $ThisUser | ConvertTo-Json -Depth 2 | ConvertFrom-Json

			$RequestUser | Add-Member -MemberType NoteProperty -Name "action" -Value "update"
			$RequestBody = $RequestUser | Select-Object -Property action,can_access_passwords,description,email,id,permission_scheme_ids,two_factor_auth_enabled,username

			pwsh-GC-post-request -Raw -Uri $Uri -Body $RequestBody -Method Post -ApiKey $Key
		}
	}
}
