function Set-GCPassword {
	[cmdletbinding()]

	param(
		# User object as returned from GuardiCore, but with updated values.
		# Accepts the PS object, not JSON data.
		# This allows you to grab a user, change it via powershell methods,
		# and pass it into this function to update it.
		[Parameter(ValueFromPipeline)]
		[PSTypeName("GCUser")]$User,

		# There's no way to not use a regular string here.
		# Besides, it's meant to be a temporary password anyway.
		[Parameter(Mandatory)]
		[String]$Password,

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
			$RequestUser | Add-Member -MemberType NoteProperty -Name "password" -Value $Password
			$RequestUser | Add-Member -MemberType NoteProperty -Name "password_confirm" -Value $Password
			$RequestBody = $RequestUser | Select-Object -Property action,can_access_passwords,description,email,id,permission_scheme_ids,two_factor_auth_enabled,username,password,password_confirm

			pwsh-GC-post-request -Raw -Uri $Uri -Body $RequestBody -Method Post -ApiKey $Key
		}
	}
}