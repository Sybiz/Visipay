Import-Module 'C:\Program Files (x86)\Sybiz\Sybiz Visipay\Sybiz.Visipay.Platform.dll'
Add-Type -AssemblyName 'System.Web'

#Uncomment the appropriate connection string
#$companyDB  = "Persist Security Info=False;Integrated Security=SSPI;database=<MYDATABASE>;server=<MYSERVER>;MultipleActiveResultSets=True;"
#$companyDB  = "Persist Security Info=False;User ID=<USERNAME>;Password=<PASSWORD>;database=<MYDATABASE>;server=<MYSERVER>;MultipleActiveResultSets=True;"

if ([Sybiz.Visipay.Platform.Security.Principal]::Login("<USERNAME>","<PASSWORD>", $companyDB) -ne 1)
{
    Write-Host "Unable to login"
}
else 
{
    $Employees = [Sybiz.Visipay.Platform.Business.Payroll.VisipayEmployeeInfoList]::GetEmployeeInfoList(1)
    #$Employees = [Sybiz.Visipay.Platform.Business.Payroll.EmployeeLookupInfoList]::GetList()
    #$Employees | Where-Object -Property Terminated -EQ 0  | Out-GridView -Title "Active Employees" 

    $Users = [Sybiz.Visipay.Platform.Security.VisipayUser_List]::GetList()
    #$Users | Where-Object -Property EmployeeId -EQ 0  | Out-GridView -Title "Users"

    $Employees | ForEach-Object {
        $exists = ($Users | Where-Object -Property EmployeeId -EQ $_.EmployeeId).Count
        $terminated = $_.TerminatedOn

        if($terminated -eq $null -and $exists -eq 0) 
        {
		#This will generate a simple password that is 10 characters long with a single non-alphanumeric character and may not meet your requirements
            $password = [System.Web.Security.Membership]::GeneratePassword(10, 1)

            $User = [Sybiz.Visipay.Platform.Security.VisipayUser]::GetNewUser()
            $User.EmployeeId = $_.EmployeeId
            $User.UserName = $_.FirstName + "." + $_.LastName
            $User.InitialPassword = $password
            $User.ConfirmPassword = $password

		#Assumes that a role with the name ESS exists
            $role = $User.Roles | Where-Object -Property RoleName -eq "ESS"
            $role.Active = $true
            $Users.Add($User)

		#Uncomment the line below to send the email, this will require configuration which is outside the scope of this script
            #Send-MailMessage -To $Employees[0].Email -From '<FROM EMAIL ADDRESS>' -Subject 'ESS Password' -Body 'Your ESS password is ' + $password
        }
    }
    #$users = $users.Save()

    #If this not emailing to employees this is the only output generated
    $users.Save() | Out-GridView -Title "Users"	

    [Sybiz.Visipay.Platform.Security.Principal]::LogOut()
}