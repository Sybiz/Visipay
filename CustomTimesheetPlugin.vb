
'Basic timesheet plugin
'Build this as a dll, place dll (no need to include references) into Visipay install folder \Plugin
'Assuming correct, plugin will be visible as option under "Configure Timesheets" wizard

'References required:
'Sybiz.Visipay.IO
'Sybiz.Visipay.Platform
'Csla (from root Visipay folder)

Imports Sybiz.Visipay.IO.Import.Timesheets

Public Class CustomTimeSheetPlugin
    Inherits TimesheetImport
    Implements IDisposable

    'Where the main 'chunk' of code goes. Generally speaking this will always end up being a "Proccess".
    'What is put into the timesheet import is then govenered by "GetTimeSheetEntries".
    Public Sub Plug()
        Dim timeEntryList As New TimesheetEntryList
        Dim tlEntryList As New TimeLogEntryList
        Proccess(timeEntryList, tlEntryList)
    End Sub

#Region "Necessary Stuff"

    Public Sub New()
        'Do nothing...but necessary to include for purposes of the plugin generally!
    End Sub

    Public Overrides Function GetTimeSheetEntries() As TimesheetEntryList
        'Fill up a TimesheetEntryList here; this could be via CSV import, sucking in from a database...whatever the case may be. Comprised of many "TimesheetEntry"s
        'Below example is painfully simple to demonstrate general function of the plugin

        Dim tList As New TimesheetEntryList From {
            TimesheetEntry.NewObject(1, 1, 1, Nothing)
        }

        'NOTE: A TimesheetEntry is comprised of the following in this order:
        'EmployeeNumber
        'Quantity
        'Timesheet Identifier (as set up against lookup)
        'Department number

        Return tList
    End Function

    Public Overrides Function GetTimeLogEntries() As TimeLogEntryList
        Dim tlList As New TimeLogEntryList
        Return tlList
    End Function

    Public Overrides ReadOnly Property PluginSetup() As Object
    'Change Plugin name here; this is how it shows up in the "Configure Timesheet" list.
    Public Overrides ReadOnly Property PluginName() As String = "Custom TimeSheet Plugin"
    Public Overrides ReadOnly Property IsValid() As Boolean = True
    Public Overrides ReadOnly Property UseTimesheetIdentifier() As Boolean = True
    Public Overrides ReadOnly Property UseStaffLink() As Boolean = False
    Public Overrides Sub Dispose() Implements IDisposable.Dispose

    End Sub

#End Region

End Class
