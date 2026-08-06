function New-JSoftMainWindow {
    Add-Type -AssemblyName PresentationFramework
    Add-Type -AssemblyName PresentationCore
    Add-Type -AssemblyName WindowsBase

    [xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="J-Soft Software Center" Height="820" Width="1280" MinHeight="600" MinWidth="900"
        ResizeMode="CanResize" WindowStyle="SingleBorderWindow" FontFamily="Segoe UI"
        WindowStartupLocation="CenterScreen" Background="#0B1F33">
  <Window.Resources>
    <Style TargetType="Button">
      <Setter Property="MinHeight" Value="34"/>
      <Setter Property="Padding" Value="12,6"/>
      <Setter Property="Margin" Value="0,0,8,0"/>
      <Setter Property="Background" Value="#8B3DFF"/>
      <Setter Property="Foreground" Value="#FFFFFF"/>
      <Setter Property="BorderBrush" Value="#8B3DFF"/>
      <Setter Property="BorderThickness" Value="1"/>
      <Setter Property="FontWeight" Value="SemiBold"/>
    </Style>
    <Style TargetType="TextBox">
      <Setter Property="Background" Value="#0F253B"/>
      <Setter Property="Foreground" Value="#FFFFFF"/>
      <Setter Property="BorderBrush" Value="#31506B"/>
      <Setter Property="BorderThickness" Value="1"/>
      <Setter Property="Padding" Value="10,6"/>
    </Style>
    <Style TargetType="ComboBox">
      <Setter Property="Background" Value="#0F253B"/>
      <Setter Property="Foreground" Value="#111827"/>
      <Setter Property="BorderBrush" Value="#31506B"/>
      <Setter Property="Padding" Value="8,5"/>
    </Style>
    <Style TargetType="CheckBox">
      <Setter Property="Foreground" Value="#FFFFFF"/>
    </Style>
    <Style TargetType="ListView">
      <Setter Property="Background" Value="#102A43"/>
      <Setter Property="Foreground" Value="#FFFFFF"/>
      <Setter Property="BorderBrush" Value="#31506B"/>
    </Style>
    <Style TargetType="ListBox">
      <Setter Property="Background" Value="#0F253B"/>
      <Setter Property="Foreground" Value="#FFFFFF"/>
      <Setter Property="BorderBrush" Value="#31506B"/>
      <Setter Property="BorderThickness" Value="1"/>
      <Setter Property="Padding" Value="4"/>
    </Style>
    <Style TargetType="ListBoxItem">
      <Setter Property="Foreground" Value="#FFFFFF"/>
      <Setter Property="Padding" Value="10,8"/>
      <Setter Property="Margin" Value="0,2"/>
      <Setter Property="HorizontalContentAlignment" Value="Stretch"/>
      <Style.Triggers>
        <Trigger Property="IsSelected" Value="True">
          <Setter Property="Background" Value="#8B3DFF"/>
          <Setter Property="Foreground" Value="#FFFFFF"/>
        </Trigger>
        <Trigger Property="IsMouseOver" Value="True">
          <Setter Property="Background" Value="#31506B"/>
        </Trigger>
      </Style.Triggers>
    </Style>
  </Window.Resources>

  <Grid>
    <Grid.RowDefinitions>
      <RowDefinition Height="92"/>
      <RowDefinition Height="*"/>
      <RowDefinition Height="56"/>
    </Grid.RowDefinitions>

    <Border Grid.Row="0" Background="#081A2B" Padding="22,16">
      <Grid>
        <Grid.ColumnDefinitions>
          <ColumnDefinition Width="*"/>
          <ColumnDefinition Width="Auto"/>
        </Grid.ColumnDefinitions>
        <StackPanel Orientation="Horizontal">
          <Border Width="46" Height="46" CornerRadius="10" Background="#16324A" BorderBrush="#8B3DFF" BorderThickness="1" Margin="0,0,14,0">
            <TextBlock Text="JS" Foreground="#FFFFFF" FontSize="18" FontWeight="Bold" HorizontalAlignment="Center" VerticalAlignment="Center"/>
          </Border>
          <StackPanel>
            <TextBlock x:Name="HeaderTitle" Text="J-Soft Software Center" Foreground="#FFFFFF" FontSize="25" FontWeight="Bold"/>
            <TextBlock x:Name="HeaderSubtitle" Text="Lokale Softwareauswahl für Windows" Foreground="#B8C4D0" FontSize="13"/>
          </StackPanel>
        </StackPanel>
        <StackPanel Grid.Column="1" HorizontalAlignment="Right">
          <TextBlock x:Name="VersionText" Foreground="#B8C4D0" HorizontalAlignment="Right"/>
          <TextBlock x:Name="WingetStatusText" Foreground="#B8C4D0" HorizontalAlignment="Right" Margin="0,4,0,0"/>
          <TextBlock x:Name="AdminStatusText" Foreground="#B8C4D0" HorizontalAlignment="Right" Margin="0,4,0,0"/>
        </StackPanel>
      </Grid>
    </Border>

    <Grid Grid.Row="1">
      <Grid.ColumnDefinitions>
        <ColumnDefinition Width="220"/>
        <ColumnDefinition Width="*"/>
      </Grid.ColumnDefinitions>

      <Border Grid.Column="0" Background="#102A43" Padding="14">
        <StackPanel>
          <Button x:Name="NavSoftwareButton" Content="Software" Margin="0,0,0,8"/>
          <Button x:Name="NavPresetsButton" Content="Presets" Margin="0,0,0,8" Background="#16324A" BorderBrush="#31506B"/>
          <Button x:Name="NavHistoryButton" Content="Installationsverlauf" Margin="0,0,0,8" Background="#16324A" BorderBrush="#31506B"/>
          <Button x:Name="NavSettingsButton" Content="Einstellungen" Margin="0,0,0,8" Background="#16324A" BorderBrush="#31506B"/>
          <Button x:Name="NavAboutButton" Content="Über J-Soft" Margin="0,0,0,8" Background="#16324A" BorderBrush="#31506B"/>
          <Border Background="#0B1F33" CornerRadius="8" Padding="10" Margin="0,18,0,0">
            <StackPanel>
              <TextBlock Text="Hinweis" Foreground="#FFFFFF" FontWeight="SemiBold"/>
              <TextBlock Text="Editor, Self-Hosting und Systemmodule sind vorbereitet, aber noch nicht Bestandteil dieser Version." Foreground="#B8C4D0" TextWrapping="Wrap" Margin="0,6,0,0"/>
              <Button x:Name="ExpandCategoriesButton" Content="Kategorien aufklappen" Margin="0,14,0,0" Background="#16324A" BorderBrush="#31506B"/>
              <Button x:Name="CollapseCategoriesButton" Content="Kategorien zuklappen" Margin="0,8,0,0" Background="#16324A" BorderBrush="#31506B"/>
              <Button x:Name="SelectVisibleButton" Content="Sichtbare auswählen" Margin="0,8,0,0" Background="#8B3DFF" BorderBrush="#8B3DFF"/>
            </StackPanel>
          </Border>
        </StackPanel>
      </Border>

      <Grid Grid.Column="1" Margin="18">
        <Grid x:Name="SoftwareView">
          <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
          </Grid.RowDefinitions>

          <Border Grid.Row="0" Background="#16324A" CornerRadius="8" Padding="14" Margin="0,0,0,14">
            <Grid>
              <Grid.RowDefinitions>
                <RowDefinition Height="Auto"/>
                <RowDefinition Height="Auto"/>
              </Grid.RowDefinitions>
              <Grid.ColumnDefinitions>
                <ColumnDefinition Width="2*"/>
                <ColumnDefinition Width="190"/>
                <ColumnDefinition Width="210"/>
                <ColumnDefinition Width="Auto"/>
              </Grid.ColumnDefinitions>
              <TextBox x:Name="SearchBox" Grid.Column="0" Height="36" Margin="0,0,12,0"/>
              <ComboBox x:Name="PresetBox" Grid.Column="1" Height="36" Margin="0,0,12,0" DisplayMemberPath="name" SelectedValuePath="id"/>
              <Button x:Name="ApplyPresetButton" Grid.Column="2" Content="Profil laden"/>
              <TextBlock Grid.Row="1" Grid.Column="0" Text="Kategorien" Foreground="#B8C4D0" VerticalAlignment="Center" Margin="0,14,10,0"/>
              <WrapPanel x:Name="CategoryButtonPanel" Grid.Row="1" Grid.Column="1" Grid.ColumnSpan="3" Margin="0,10,0,0"/>
            </Grid>
          </Border>

          <ScrollViewer Grid.Row="1" VerticalScrollBarVisibility="Auto">
            <StackPanel>
              <StackPanel x:Name="ApplicationPanel"/>
            </StackPanel>
          </ScrollViewer>
        </Grid>

        <Grid x:Name="PresetEditorView" Visibility="Collapsed">
          <Grid.ColumnDefinitions>
            <ColumnDefinition Width="250"/>
            <ColumnDefinition Width="*"/>
          </Grid.ColumnDefinitions>

          <Border Grid.Column="0" Background="#16324A" CornerRadius="8" Padding="14" Margin="0,0,14,0">
            <Grid>
              <Grid.RowDefinitions>
                <RowDefinition Height="Auto"/>
                <RowDefinition Height="*"/>
                <RowDefinition Height="Auto"/>
              </Grid.RowDefinitions>
              <TextBlock Text="Meine Presets" Foreground="#FFFFFF" FontSize="20" FontWeight="Bold" Margin="0,0,0,12"/>
              <ListBox x:Name="PresetListBox" Grid.Row="1" DisplayMemberPath="name"/>
              <StackPanel Grid.Row="2" Margin="0,12,0,0">
                <Button x:Name="NewPresetButton" Content="Neues Preset"/>
                <Button x:Name="DeletePresetButton" Content="Preset löschen" Background="#5B2430" BorderBrush="#E85D68" Margin="0,8,0,0"/>
              </StackPanel>
            </Grid>
          </Border>

          <Border Grid.Column="1" Background="#16324A" CornerRadius="8" Padding="20">
            <Grid>
              <Grid.RowDefinitions>
                <RowDefinition Height="Auto"/>
                <RowDefinition Height="Auto"/>
                <RowDefinition Height="Auto"/>
                <RowDefinition Height="Auto"/>
                <RowDefinition Height="*"/>
                <RowDefinition Height="Auto"/>
              </Grid.RowDefinitions>
              <TextBlock x:Name="PresetEditorTitle" Text="Preset auswählen" Foreground="#FFFFFF" FontSize="24" FontWeight="Bold" Margin="0,0,0,16"/>
              <TextBlock Grid.Row="1" Text="Name" Foreground="#B8C4D0" Margin="0,0,0,4"/>
              <TextBox x:Name="PresetNameBox" Grid.Row="2" Height="36"/>
              <StackPanel Grid.Row="3" Margin="0,12,0,12">
                <TextBlock Text="Beschreibung" Foreground="#B8C4D0" Margin="0,0,0,4"/>
                <TextBox x:Name="PresetDescriptionBox" Height="62" TextWrapping="Wrap" AcceptsReturn="True"/>
                <TextBlock Text="Programme im Preset" Foreground="#FFFFFF" FontSize="17" FontWeight="SemiBold" Margin="0,16,0,8"/>
                <TextBox x:Name="PresetAppSearchBox" Height="34"/>
                <TextBlock Text="Kategorien" Foreground="#B8C4D0" Margin="0,12,0,4"/>
                <WrapPanel x:Name="PresetCategoryButtonPanel"/>
              </StackPanel>
              <ScrollViewer Grid.Row="4" VerticalScrollBarVisibility="Auto">
                <StackPanel x:Name="PresetApplicationList">
                  <TextBlock x:Name="PresetIncludedTitle" Foreground="#FFFFFF" FontSize="16" FontWeight="SemiBold" Margin="0,0,0,8"/>
                  <StackPanel x:Name="PresetIncludedPanel"/>
                  <TextBlock x:Name="PresetAvailableTitle" Foreground="#FFFFFF" FontSize="16" FontWeight="SemiBold" Margin="0,18,0,8"/>
                  <StackPanel x:Name="PresetAvailablePanel"/>
                </StackPanel>
              </ScrollViewer>
              <StackPanel Grid.Row="5" Orientation="Horizontal" HorizontalAlignment="Right" Margin="0,14,0,0">
                <TextBlock x:Name="PresetEditorStatusText" Foreground="#B8C4D0" VerticalAlignment="Center" Margin="0,0,16,0"/>
                <Button x:Name="EditPresetButton" Content="Preset bearbeiten" Background="#16324A" BorderBrush="#31506B"/>
                <Button x:Name="CancelPresetEditButton" Content="Bearbeitung schließen" Background="#16324A" BorderBrush="#31506B" Visibility="Collapsed"/>
                <Button x:Name="SavePresetButton" Content="Preset speichern"/>
              </StackPanel>
            </Grid>
          </Border>
        </Grid>

        <Grid x:Name="PreparedView" Visibility="Collapsed">
          <Border Background="#16324A" CornerRadius="8" Padding="28">
            <StackPanel>
              <TextBlock x:Name="PreparedTitle" Foreground="#FFFFFF" FontSize="24" FontWeight="Bold"/>
              <TextBlock x:Name="PreparedMessage" Foreground="#B8C4D0" FontSize="15" TextWrapping="Wrap" Margin="0,12,0,0"/>
            </StackPanel>
          </Border>
        </Grid>

        <Grid x:Name="HistoryView" Visibility="Collapsed">
          <Border Background="#16324A" CornerRadius="8" Padding="16">
            <Grid>
              <Grid.RowDefinitions>
                <RowDefinition Height="Auto"/>
                <RowDefinition Height="*"/>
              </Grid.RowDefinitions>
              <TextBlock Text="Installationsverlauf der aktuellen Sitzung" Foreground="#FFFFFF" FontSize="22" FontWeight="Bold" Margin="0,0,0,12"/>
              <ListView x:Name="HistoryList" Grid.Row="1">
                <ListView.View>
                  <GridView>
                    <GridViewColumn Header="Programm" DisplayMemberBinding="{Binding Name}" Width="160"/>
                    <GridViewColumn Header="Startzeit" DisplayMemberBinding="{Binding StartTime}" Width="130"/>
                    <GridViewColumn Header="Endzeit" DisplayMemberBinding="{Binding EndTime}" Width="130"/>
                    <GridViewColumn Header="Status" DisplayMemberBinding="{Binding Status}" Width="130"/>
                    <GridViewColumn Header="Exitcode" DisplayMemberBinding="{Binding ExitCode}" Width="80"/>
                    <GridViewColumn Header="Fehler" DisplayMemberBinding="{Binding ErrorMessage}" Width="360"/>
                  </GridView>
                </ListView.View>
              </ListView>
            </Grid>
          </Border>
        </Grid>
      </Grid>
    </Grid>

    <Border Grid.Row="2" Background="#081A2B" Padding="18,10">
      <Grid>
        <Grid.ColumnDefinitions>
          <ColumnDefinition Width="*"/>
          <ColumnDefinition Width="Auto"/>
        </Grid.ColumnDefinitions>
        <StackPanel Orientation="Horizontal" VerticalAlignment="Center">
          <TextBlock x:Name="SelectedCountText" Text="0 ausgewählt" Foreground="#FFFFFF" Margin="0,0,18,0"/>
          <TextBlock x:Name="CurrentStatusText" Text="Bereit." Foreground="#B8C4D0"/>
        </StackPanel>
        <StackPanel Grid.Column="1" Orientation="Horizontal">
          <RadioButton x:Name="WingetRadio" Content="WinGet" IsChecked="True" Foreground="#FFFFFF" VerticalAlignment="Center" Margin="0,0,12,0"/>
          <RadioButton x:Name="ChocolateyRadio" Content="Chocolatey" Foreground="#FFFFFF" VerticalAlignment="Center" Margin="0,0,16,0"/>
          <Button x:Name="RestartElevatedButton" Content="Als Admin neu starten" Background="#F2B84B" BorderBrush="#F2B84B" Foreground="#081A2B" Visibility="Collapsed"/>
          <Button x:Name="ClearSelectionButton" Content="Auswahl zurücksetzen" Background="#16324A" BorderBrush="#31506B"/>
          <Button x:Name="InstallButton" Content="Installieren" IsEnabled="False"/>
        </StackPanel>
      </Grid>
    </Border>
  </Grid>
</Window>
"@

    $reader = [System.Xml.XmlNodeReader]::new($xaml)
    $window = [Windows.Markup.XamlReader]::Load($reader)
    $ui = [ordered]@{ Window = $window }

    foreach ($node in $xaml.SelectNodes("//*[@*[local-name()='Name']]")) {
        $attribute = $node.Attributes | Where-Object { $_.LocalName -eq "Name" } | Select-Object -First 1
        if ($attribute) {
            $ui[$attribute.Value] = $window.FindName($attribute.Value)
        }
    }

    return $ui
}

function Set-JSoftView {
    param(
        [Parameter(Mandatory)]
        [string]$ViewName
    )

    $script:JSoft.Ui.SoftwareView.Visibility = "Collapsed"
    $script:JSoft.Ui.PresetEditorView.Visibility = "Collapsed"
    $script:JSoft.Ui.HistoryView.Visibility = "Collapsed"
    $script:JSoft.Ui.PreparedView.Visibility = "Collapsed"

    switch ($ViewName) {
        "Software" { $script:JSoft.Ui.SoftwareView.Visibility = "Visible" }
        "History" { $script:JSoft.Ui.HistoryView.Visibility = "Visible" }
        "Presets" {
            $script:JSoft.Ui.PresetEditorView.Visibility = "Visible"
            Refresh-JSoftPresetEditorList
            Refresh-JSoftPresetApplicationEditor
        }
        "Settings" {
            $script:JSoft.Ui.PreparedView.Visibility = "Visible"
            $script:JSoft.Ui.PreparedTitle.Text = "Einstellungen"
            $script:JSoft.Ui.PreparedMessage.Text = "Einstellungen werden aus config/settings.json geladen. Eine bearbeitbare Oberfläche folgt mit dem separaten J-Soft-Editor."
        }
        "About" {
            $script:JSoft.Ui.PreparedView.Visibility = "Visible"
            $script:JSoft.Ui.PreparedTitle.Text = "Über J-Soft"
            $script:JSoft.Ui.PreparedMessage.Text = "J-Soft by Jonas Bernert. Lokales Software-Center für Windows. WinUtil wurde als technische Referenz analysiert, aber diese Anwendung ist eigenständig aufgebaut."
        }
    }
}

function Set-JSoftPresetEditorMode {
    param(
        [Parameter(Mandatory)]
        [bool]$Editing
    )

    $script:JSoft.PresetEditMode = $Editing
    $script:JSoft.Ui.PresetEditorTitle.Text = if ($Editing) { "Preset bearbeiten" } else { "Preset auswählen" }
    $script:JSoft.Ui.PresetNameBox.IsReadOnly = -not $Editing
    $script:JSoft.Ui.PresetDescriptionBox.IsReadOnly = -not $Editing
    $script:JSoft.Ui.PresetAppSearchBox.IsEnabled = $true
    $script:JSoft.Ui.PresetAvailableTitle.Visibility = if ($Editing) { "Visible" } else { "Collapsed" }
    $script:JSoft.Ui.PresetAvailablePanel.Visibility = if ($Editing) { "Visible" } else { "Collapsed" }
    $script:JSoft.Ui.EditPresetButton.Visibility = if ($Editing) { "Collapsed" } else { "Visible" }
    $script:JSoft.Ui.CancelPresetEditButton.Visibility = if ($Editing) { "Visible" } else { "Collapsed" }
    $script:JSoft.Ui.SavePresetButton.Visibility = if ($Editing) { "Visible" } else { "Collapsed" }
    $script:JSoft.Ui.NewPresetButton.IsEnabled = -not $Editing
    $script:JSoft.Ui.DeletePresetButton.IsEnabled = -not $Editing
}

function Refresh-JSoftPresetSelector {
    $selectedId = [string]$script:JSoft.Ui.PresetBox.SelectedValue
    $script:JSoft.Ui.PresetBox.Items.Clear()
    foreach ($preset in $script:JSoft.Presets | Sort-Object name) {
        $script:JSoft.Ui.PresetBox.Items.Add($preset) | Out-Null
    }

    if ($script:JSoft.Ui.PresetBox.Items.Count -gt 0) {
        $selectedIndex = 0
        for ($index = 0; $index -lt $script:JSoft.Ui.PresetBox.Items.Count; $index++) {
            if ([string]$script:JSoft.Ui.PresetBox.Items[$index].id -eq $selectedId) {
                $selectedIndex = $index
                break
            }
        }
        $script:JSoft.Ui.PresetBox.SelectedIndex = $selectedIndex
    }
}

function Refresh-JSoftPresetEditorList {
    $selectedId = [string]$script:JSoft.Ui.PresetNameBox.Tag
    $script:JSoft.Ui.PresetListBox.Items.Clear()
    foreach ($preset in $script:JSoft.Presets | Sort-Object name) {
        $script:JSoft.Ui.PresetListBox.Items.Add($preset) | Out-Null
    }

    if ($script:JSoft.Ui.PresetListBox.Items.Count -gt 0) {
        $selectedIndex = 0
        for ($index = 0; $index -lt $script:JSoft.Ui.PresetListBox.Items.Count; $index++) {
            if ([string]$script:JSoft.Ui.PresetListBox.Items[$index].id -eq $selectedId) {
                $selectedIndex = $index
                break
            }
        }
        $script:JSoft.Ui.PresetListBox.SelectedIndex = $selectedIndex
    } else {
        New-JSoftPresetEditor
    }
}

function Toggle-JSoftPresetEditorApplication {
    param(
        [Parameter(Mandatory)]
        [string]$AppId
    )

    if ($script:JSoft.PresetEditorSelected.Contains($AppId)) {
        [void]$script:JSoft.PresetEditorSelected.Remove($AppId)
    } else {
        [void]$script:JSoft.PresetEditorSelected.Add($AppId)
    }
    Refresh-JSoftPresetApplicationEditor
}

function Refresh-JSoftPresetCategoryButtons {
    $script:JSoft.Ui.PresetCategoryButtonPanel.Children.Clear()
    $buttonNames = @("Alle Kategorien") + @($script:JSoft.Categories | Sort-Object order, name | ForEach-Object name)
    foreach ($name in $buttonNames) {
        $button = [Windows.Controls.Button]::new()
        $button.Content = $name
        $button.Tag = $name
        $button.MinHeight = 28
        $button.MinWidth = if ($name -eq "Alle Kategorien") { 112 } else { 88 }
        $button.Padding = [Windows.Thickness]::new(8, 3, 8, 3)
        $button.Margin = [Windows.Thickness]::new(0, 0, 5, 4)
        $button.FontSize = 11
        $button.Add_Click({
            $script:JSoft.PresetActiveCategory = [string]$this.Tag
            Refresh-JSoftPresetCategoryButtons
            Refresh-JSoftPresetApplicationEditor
        })
        if ($name -eq $script:JSoft.PresetActiveCategory) {
            $button.Background = [Windows.Media.SolidColorBrush]::new([Windows.Media.ColorConverter]::ConvertFromString("#8B3DFF"))
            $button.BorderBrush = [Windows.Media.SolidColorBrush]::new([Windows.Media.ColorConverter]::ConvertFromString("#8B3DFF"))
        } else {
            $button.Background = [Windows.Media.SolidColorBrush]::new([Windows.Media.ColorConverter]::ConvertFromString("#16324A"))
            $button.BorderBrush = [Windows.Media.SolidColorBrush]::new([Windows.Media.ColorConverter]::ConvertFromString("#31506B"))
        }
        $script:JSoft.Ui.PresetCategoryButtonPanel.Children.Add($button) | Out-Null
    }
}

function New-JSoftPresetApplicationCard {
    param(
        [Parameter(Mandatory)]
        [pscustomobject]$Application,

        [Parameter(Mandatory)]
        [bool]$Included
    )

    $card = [Windows.Controls.Border]::new()
    $card.Width = 220
    $card.Height = 48
    $card.Margin = [Windows.Thickness]::new(0, 0, 8, 8)
    $card.Padding = [Windows.Thickness]::new(10, 6, 10, 6)
    $card.CornerRadius = [Windows.CornerRadius]::new(6)
    $card.Cursor = [Windows.Input.Cursors]::Hand
    $card.Tag = $Application.id
    $card.ToolTip = if ($Included) { "Aus Preset entfernen" } else { "Zum Preset hinzufügen" }
    $card.Background = [Windows.Media.SolidColorBrush]::new([Windows.Media.ColorConverter]::ConvertFromString($(if ($Included) { "#5D2BB2" } else { "#102A43" })))
    $card.BorderBrush = [Windows.Media.SolidColorBrush]::new([Windows.Media.ColorConverter]::ConvertFromString($(if ($Included) { "#A766FF" } else { "#31506B" })))
    $card.BorderThickness = [Windows.Thickness]::new(1)

    $name = [Windows.Controls.TextBlock]::new()
    $name.Text = $Application.name
    $name.TextWrapping = "Wrap"
    $name.VerticalAlignment = "Center"
    $name.Foreground = [Windows.Media.SolidColorBrush]::new([Windows.Media.ColorConverter]::ConvertFromString("#FFFFFF"))
    $name.FontWeight = "SemiBold"
    $content = [Windows.Controls.StackPanel]::new()
    $content.Orientation = "Horizontal"
    $content.VerticalAlignment = "Center"
    [void]$content.Children.Add((New-JSoftApplicationIcon -Application $Application -Size 28))
    [void]$content.Children.Add($name)
    $card.Child = $content
    $card.Add_MouseLeftButtonUp({
        Toggle-JSoftPresetEditorApplication -AppId ([string]$this.Tag)
        $_.Handled = $true
    })
    return $card
}

function Add-JSoftPresetApplicationGroups {
    param(
        [Parameter(Mandatory)]
        [Windows.Controls.StackPanel]$TargetPanel,

        [Parameter(Mandatory)]
        [object[]]$Applications,

        [Parameter(Mandatory)]
        [bool]$Included
    )

    $categoryOrder = @{}
    foreach ($category in $script:JSoft.Categories) {
        $categoryOrder[[string]$category.name] = [int]$category.order
    }
    $groups = @($Applications | Group-Object category | Sort-Object {
        if ($categoryOrder.ContainsKey([string]$_.Name)) { $categoryOrder[[string]$_.Name] } else { 999 }
    }, Name)

    foreach ($group in $groups) {
        $header = [Windows.Controls.TextBlock]::new()
        $header.Text = "- {0} ({1})" -f $group.Name, $group.Count
        $header.Foreground = [Windows.Media.SolidColorBrush]::new([Windows.Media.ColorConverter]::ConvertFromString("#8BD8FF"))
        $header.FontSize = 14
        $header.FontWeight = "SemiBold"
        $header.Margin = [Windows.Thickness]::new(0, 6, 0, 6)
        $TargetPanel.Children.Add($header) | Out-Null

        $cards = [Windows.Controls.WrapPanel]::new()
        foreach ($app in $group.Group | Sort-Object name) {
            $cards.Children.Add((New-JSoftPresetApplicationCard -Application $app -Included $Included)) | Out-Null
        }
        $TargetPanel.Children.Add($cards) | Out-Null
    }
}

function New-JSoftApplicationIcon {
    param(
        [Parameter(Mandatory)]
        [pscustomobject]$Application,

        [Parameter(Mandatory)]
        [double]$Size
    )

    $icon = [Windows.Controls.Grid]::new()
    $icon.Width = $Size
    $icon.Height = $Size
    $icon.Margin = [Windows.Thickness]::new(0, 0, 9, 0)

    $fallbackText = ([string]$Application.name).Trim()
    $fallback = [Windows.Controls.TextBlock]::new()
    $fallback.Text = if ($fallbackText.Length -gt 0) { $fallbackText.Substring(0, 1).ToUpperInvariant() } else { "?" }
    $fallback.HorizontalAlignment = "Center"
    $fallback.VerticalAlignment = "Center"
    $fallback.FontSize = [Math]::Max(11, $Size * 0.42)
    $fallback.FontWeight = "Bold"
    $fallback.Foreground = [Windows.Media.SolidColorBrush]::new([Windows.Media.ColorConverter]::ConvertFromString("#FFFFFF"))

    $iconFrame = [Windows.Controls.Border]::new()
    $iconFrame.Width = $Size
    $iconFrame.Height = $Size
    $iconFrame.CornerRadius = [Windows.CornerRadius]::new(6)
    $iconFrame.Background = [Windows.Media.SolidColorBrush]::new([Windows.Media.ColorConverter]::ConvertFromString("#0B1F33"))
    $iconFrame.BorderBrush = [Windows.Media.SolidColorBrush]::new([Windows.Media.ColorConverter]::ConvertFromString("#31506B"))
    $iconFrame.BorderThickness = [Windows.Thickness]::new(1)
    $iconFrame.Child = $fallback
    [void]$icon.Children.Add($iconFrame)

    $website = [string]$Application.website
    if (-not [string]::IsNullOrWhiteSpace($website)) {
        try {
            $websiteUri = [uri]::new($website)
            $host = $websiteUri.Host
            $iconSources = @(
                "https://icons.duckduckgo.com/ip3/$host.ico",
                "https://www.google.com/s2/favicons?sz=64&domain_url=$([uri]::EscapeDataString($website))"
            )

            $fallback.Visibility = "Visible"
            for ($sourceIndex = $iconSources.Count - 1; $sourceIndex -ge 0; $sourceIndex--) {
                $logo = [Windows.Controls.Image]::new()
                $logo.Width = $Size - 4
                $logo.Height = $Size - 4
                $logo.Margin = [Windows.Thickness]::new(2)
                $logo.Stretch = [Windows.Media.Stretch]::Uniform
                $logo.ToolTip = "Originales Programmsymbol von $($Application.name)"
                $logo.Add_ImageFailed({
                    $failedImage = $this
                    $failedImage.Visibility = "Collapsed"
                    $nextImage = @($failedImage.Parent.Children | Where-Object {
                        $_ -is [Windows.Controls.Image] -and $_ -ne $failedImage -and $_.Visibility -eq "Collapsed"
                    } | Select-Object -First 1)
                    if ($nextImage.Count -gt 0) {
                        $nextImage[0].Visibility = "Visible"
                    } else {
                        $failedImage.Parent.Children[0].Child.Visibility = "Visible"
                    }
                })
                $logo.Visibility = if ($sourceIndex -eq 0) { "Visible" } else { "Collapsed" }
                try {
                    $logo.Source = $iconSources[$sourceIndex]
                } catch {
                    $logo.Visibility = "Collapsed"
                }
                [void]$icon.Children.Insert(1, $logo)
            }
        } catch {
            $fallback.Visibility = "Visible"
        }
    }

    return $icon
}

function Refresh-JSoftPresetApplicationEditor {
    $script:JSoft.Ui.PresetIncludedPanel.Children.Clear()
    $script:JSoft.Ui.PresetAvailablePanel.Children.Clear()
    Refresh-JSoftPresetCategoryButtons
    $search = [string]$script:JSoft.Ui.PresetAppSearchBox.Text
    $apps = @($script:JSoft.Applications)
    if (-not [string]::IsNullOrWhiteSpace($search)) {
        $needle = $search.Trim()
        $apps = @($apps | Where-Object {
            $_.name -like "*$needle*" -or $_.category -like "*$needle*" -or $_.packageId -like "*$needle*"
        })
    }
    if ($script:JSoft.PresetActiveCategory -ne "Alle Kategorien") {
        $apps = @($apps | Where-Object { $_.category -eq $script:JSoft.PresetActiveCategory })
    }

    $included = @($apps | Where-Object { $script:JSoft.PresetEditorSelected.Contains([string]$_.id) } | Sort-Object category, name)
    $available = @($apps | Where-Object { -not $script:JSoft.PresetEditorSelected.Contains([string]$_.id) } | Sort-Object category, name)
    $script:JSoft.Ui.PresetIncludedTitle.Text = "Im Preset ({0})" -f $script:JSoft.PresetEditorSelected.Count
    $script:JSoft.Ui.PresetAvailableTitle.Text = "Weitere Programme ({0})" -f $available.Count

    Add-JSoftPresetApplicationGroups -TargetPanel $script:JSoft.Ui.PresetIncludedPanel -Applications $included -Included $true
    if ($script:JSoft.PresetEditMode) {
        Add-JSoftPresetApplicationGroups -TargetPanel $script:JSoft.Ui.PresetAvailablePanel -Applications $available -Included $false
    }

    $script:JSoft.Ui.PresetEditorStatusText.Text = "{0} Programm(e) ausgewählt" -f $script:JSoft.PresetEditorSelected.Count
}

function Load-JSoftPresetEditor {
    $preset = $script:JSoft.Ui.PresetListBox.SelectedItem
    if (-not $preset) {
        return
    }

    $script:JSoft.Ui.PresetNameBox.Tag = [string]$preset.id
    $script:JSoft.Ui.PresetNameBox.Text = [string]$preset.name
    $script:JSoft.Ui.PresetDescriptionBox.Text = [string]$preset.description
    $script:JSoft.PresetEditorSelected = [System.Collections.Generic.HashSet[string]]::new()
    $script:JSoft.PresetActiveCategory = "Alle Kategorien"
    foreach ($appId in @($preset.applications)) {
        [void]$script:JSoft.PresetEditorSelected.Add([string]$appId)
    }
    Refresh-JSoftPresetApplicationEditor
}

function New-JSoftPresetEditor {
    $script:JSoft.Ui.PresetListBox.SelectedItem = $null
    $script:JSoft.Ui.PresetNameBox.Tag = $null
    $script:JSoft.Ui.PresetNameBox.Text = ""
    $script:JSoft.Ui.PresetDescriptionBox.Text = ""
    $script:JSoft.PresetEditorSelected = [System.Collections.Generic.HashSet[string]]::new()
    $script:JSoft.PresetActiveCategory = "Alle Kategorien"
    Set-JSoftPresetEditorMode -Editing $true
    Refresh-JSoftPresetApplicationEditor
    $script:JSoft.Ui.PresetEditorStatusText.Text = "Neues Preset"
}

function Save-JSoftPresetEditor {
    $name = [string]$script:JSoft.Ui.PresetNameBox.Text
    if ([string]::IsNullOrWhiteSpace($name)) {
        [System.Windows.MessageBox]::Show("Bitte einen Preset-Namen eingeben.", "J-Soft", "OK", "Information") | Out-Null
        return
    }

    $currentId = [string]$script:JSoft.Ui.PresetNameBox.Tag
    if ([string]::IsNullOrWhiteSpace($currentId)) {
        $currentId = ConvertTo-JSoftPresetId -Name $name
        $baseId = $currentId
        $suffix = 2
        while (@($script:JSoft.Presets | Where-Object { $_.id -eq $currentId }).Count -gt 0) {
            $currentId = "$baseId-$suffix"
            $suffix++
        }
    }

    $newPreset = [pscustomobject][ordered]@{
        id = $currentId
        name = $name.Trim()
        description = ([string]$script:JSoft.Ui.PresetDescriptionBox.Text).Trim()
        applications = @($script:JSoft.PresetEditorSelected | Sort-Object)
    }

    $updated = [System.Collections.Generic.List[object]]::new()
    $replaced = $false
    foreach ($preset in $script:JSoft.Presets) {
        if ([string]$preset.id -eq $currentId) {
            $updated.Add($newPreset)
            $replaced = $true
        } else {
            $updated.Add($preset)
        }
    }
    if (-not $replaced) {
        $updated.Add($newPreset)
    }

    try {
        Write-JSoftPresetsFile -ConfigPath (Join-Path $script:JSoft.RootPath "config") -Presets @($updated)
        $script:JSoft.Presets = @($updated)
        $script:JSoft.Ui.PresetNameBox.Tag = $currentId
        Refresh-JSoftPresetSelector
        Refresh-JSoftPresetEditorList
        Set-JSoftPresetEditorMode -Editing $false
        Refresh-JSoftPresetApplicationEditor
        $script:JSoft.Ui.PresetEditorStatusText.Text = "Preset gespeichert: $name"
    } catch {
        [System.Windows.MessageBox]::Show("Das Preset konnte nicht gespeichert werden.`n`n$($_.Exception.Message)", "J-Soft", "OK", "Error") | Out-Null
    }
}

function Remove-JSoftPresetEditor {
    $preset = $script:JSoft.Ui.PresetListBox.SelectedItem
    if (-not $preset) {
        return
    }

    $answer = [System.Windows.MessageBox]::Show("Preset '$($preset.name)' wirklich löschen?", "J-Soft", "YesNo", "Warning")
    if ($answer -ne "Yes") {
        return
    }

    $remaining = @($script:JSoft.Presets | Where-Object { $_.id -ne $preset.id })
    try {
        Write-JSoftPresetsFile -ConfigPath (Join-Path $script:JSoft.RootPath "config") -Presets $remaining
        $script:JSoft.Presets = $remaining
        $script:JSoft.Ui.PresetNameBox.Tag = $null
        Set-JSoftPresetEditorMode -Editing $false
        Refresh-JSoftPresetSelector
        Refresh-JSoftPresetEditorList
        Refresh-JSoftPresetApplicationEditor
    } catch {
        [System.Windows.MessageBox]::Show("Das Preset konnte nicht gelöscht werden.`n`n$($_.Exception.Message)", "J-Soft", "OK", "Error") | Out-Null
    }
}

function Get-JSoftStatusBrush {
    param([string]$Status)

    $color = switch ($Status) {
        "Nicht gestartet" { "#B8C4D0" }
        "Wird geprüft" { "#F2B84B" }
        "Wird installiert" { "#8B3DFF" }
        "Erfolgreich" { "#3DBE7A" }
        "Bereits installiert" { "#3DBE7A" }
        "Fehlgeschlagen" { "#E85D68" }
        default { "#B8C4D0" }
    }

    return [Windows.Media.SolidColorBrush]::new([Windows.Media.ColorConverter]::ConvertFromString($color))
}

function Update-JSoftCardVisual {
    param(
        [Parameter(Mandatory)]
        [string]$AppId
    )

    if (-not $script:JSoft.CardControls.ContainsKey($AppId)) {
        return
    }

    $card = $script:JSoft.CardControls[$AppId]
    $status = [string]$script:JSoft.Status[$AppId]
    $card.Background = [Windows.Media.SolidColorBrush]::new([Windows.Media.ColorConverter]::ConvertFromString(
        $(if ($script:JSoft.Selected.Contains($AppId)) { "#5D2BB2" } else { "#16324A" })
    ))
    $card.BorderBrush = Get-JSoftStatusBrush -Status $status
    $card.ToolTip = "Status: $status"
}

function Toggle-JSoftApplicationSelection {
    param(
        [Parameter(Mandatory)]
        [string]$AppId
    )

    if ($script:JSoft.Selected.Contains($AppId)) {
        [void]$script:JSoft.Selected.Remove($AppId)
    } else {
        [void]$script:JSoft.Selected.Add($AppId)
    }
    Update-JSoftSelectionUi
}

function Show-JSoftApplicationDetails {
    param(
        [Parameter(Mandatory)]
        [string]$AppId
    )

    $application = $script:JSoft.Applications | Where-Object { $_.id -eq $AppId } | Select-Object -First 1
    if (-not $application) {
        return
    }

    $window = [Windows.Window]::new()
    $window.Title = "Details - $($application.name)"
    $window.Width = 560
    $window.Height = 610
    $window.MinWidth = 480
    $window.MinHeight = 420
    $window.WindowStartupLocation = "CenterOwner"
    $window.Owner = $script:JSoft.Ui.Window
    $window.Background = [Windows.Media.SolidColorBrush]::new([Windows.Media.ColorConverter]::ConvertFromString("#0B1F33"))

    $scroll = [Windows.Controls.ScrollViewer]::new()
    $scroll.VerticalScrollBarVisibility = "Auto"
    $content = [Windows.Controls.StackPanel]::new()
    $content.Margin = [Windows.Thickness]::new(24)

    $title = [Windows.Controls.TextBlock]::new()
    $title.Text = $application.name
    $title.Foreground = [Windows.Media.SolidColorBrush]::new([Windows.Media.ColorConverter]::ConvertFromString("#FFFFFF"))
    $title.FontSize = 24
    $title.FontWeight = "Bold"
    $title.TextWrapping = "Wrap"
    $content.Children.Add($title) | Out-Null

    $description = [Windows.Controls.TextBlock]::new()
    $description.Text = $application.description
    $description.Foreground = [Windows.Media.SolidColorBrush]::new([Windows.Media.ColorConverter]::ConvertFromString("#D8E1EA"))
    $description.TextWrapping = "Wrap"
    $description.Margin = [Windows.Thickness]::new(0, 14, 0, 18)
    $content.Children.Add($description) | Out-Null

    $details = @(
        @{ Label = "Kategorie"; Value = [string]$application.category },
        @{ Label = "Paketmanager"; Value = [string]$application.packageManager },
        @{ Label = "Paket-ID"; Value = [string]$application.packageId },
        @{ Label = "Quelle"; Value = if ([string]::IsNullOrWhiteSpace([string]$application.packageSource)) { "winget" } else { [string]$application.packageSource } },
        @{ Label = "Chocolatey-ID"; Value = if ([string]::IsNullOrWhiteSpace([string]$application.chocolateyPackageId)) { "Nicht verfügbar" } else { [string]$application.chocolateyPackageId } },
        @{ Label = "Freie/Open-Source-Software"; Value = if ($application.isFoss) { "Ja" } else { "Nein" } },
        @{ Label = "Administratorrechte"; Value = if ($application.requiresAdmin) { "Empfohlen" } else { "Nicht markiert" } },
        @{ Label = "Installationsstatus"; Value = [string]$script:JSoft.Status[$application.id] }
    )

    foreach ($detail in $details) {
        $line = [Windows.Controls.TextBlock]::new()
        $line.Text = "{0}: {1}" -f $detail.Label, $detail.Value
        $line.Foreground = [Windows.Media.SolidColorBrush]::new([Windows.Media.ColorConverter]::ConvertFromString("#B8C4D0"))
        $line.TextWrapping = "Wrap"
        $line.Margin = [Windows.Thickness]::new(0, 3, 0, 3)
        $content.Children.Add($line) | Out-Null
    }

    if (-not [string]::IsNullOrWhiteSpace([string]$application.website)) {
        $websiteButton = [Windows.Controls.Button]::new()
        $websiteButton.Content = "Website öffnen"
        $websiteButton.HorizontalAlignment = "Left"
        $websiteButton.Margin = [Windows.Thickness]::new(0, 16, 0, 0)
        $websiteButton.Tag = [string]$application.website
        $websiteButton.Add_Click({ Start-Process -FilePath ([string]$this.Tag) })
        $content.Children.Add($websiteButton) | Out-Null
    }

    $closeButton = [Windows.Controls.Button]::new()
    $closeButton.Content = "Schließen"
    $closeButton.HorizontalAlignment = "Right"
    $closeButton.Margin = [Windows.Thickness]::new(0, 20, 0, 0)
    $closeButton.Add_Click({ $window.Close() })
    $content.Children.Add($closeButton) | Out-Null

    $scroll.Content = $content
    $window.Content = $scroll
    $window.ShowDialog() | Out-Null
}

function New-JSoftApplicationCard {
    param([Parameter(Mandatory)][pscustomobject]$Application)

    $card = [Windows.Controls.Border]::new()
    $card.Width = 286
    $card.Height = 64
    $card.Margin = [Windows.Thickness]::new(0, 0, 14, 14)
    $card.Padding = [Windows.Thickness]::new(12)
    $card.CornerRadius = [Windows.CornerRadius]::new(8)
    $card.Background = [Windows.Media.SolidColorBrush]::new([Windows.Media.ColorConverter]::ConvertFromString("#16324A"))
    $card.BorderBrush = [Windows.Media.SolidColorBrush]::new([Windows.Media.ColorConverter]::ConvertFromString("#31506B"))
    $card.BorderThickness = [Windows.Thickness]::new(1)
    $card.Tag = $Application.id
    $card.Cursor = [Windows.Input.Cursors]::Hand
    $card.ToolTip = "Status: $($script:JSoft.Status[$Application.id])"

    $name = [Windows.Controls.TextBlock]::new()
    $name.Text = $Application.name
    $name.TextWrapping = "Wrap"
    $name.VerticalAlignment = "Center"
    $name.Foreground = [Windows.Media.SolidColorBrush]::new([Windows.Media.ColorConverter]::ConvertFromString("#FFFFFF"))
    $name.FontSize = 15
    $name.FontWeight = "SemiBold"
    $content = [Windows.Controls.StackPanel]::new()
    $content.Orientation = "Horizontal"
    $content.VerticalAlignment = "Center"
    [void]$content.Children.Add((New-JSoftApplicationIcon -Application $Application -Size 36))
    [void]$content.Children.Add($name)
    $card.Child = $content

    $card.Add_MouseLeftButtonUp({
        Toggle-JSoftApplicationSelection -AppId ([string]$this.Tag)
        $_.Handled = $true
    })

    $contextMenu = [Windows.Controls.ContextMenu]::new()
    $detailsItem = [Windows.Controls.MenuItem]::new()
    $detailsItem.Header = "Details anzeigen"
    $detailsItem.Tag = $Application.id
    $detailsItem.Add_Click({ Show-JSoftApplicationDetails -AppId ([string]$this.Tag) })
    $contextMenu.Items.Add($detailsItem) | Out-Null
    $card.ContextMenu = $contextMenu

    $script:JSoft.CardControls[$Application.id] = $card
    Update-JSoftCardVisual -AppId $Application.id

    return $card
}

function New-JSoftCategoryButton {
    param(
        [Parameter(Mandatory)]
        [string]$Name
    )

    $button = [Windows.Controls.Button]::new()
    $button.Content = $Name
    $button.Tag = $Name
    $button.MinHeight = 30
    $button.MinWidth = if ($Name -eq "Alle Kategorien") { 118 } else { 92 }
    $button.Padding = [Windows.Thickness]::new(10, 4, 10, 4)
    $button.Margin = [Windows.Thickness]::new(0, 0, 6, 4)
    $button.FontSize = 12
    $button.Add_Click({
        $script:JSoft.ActiveCategory = [string]$this.Tag
        Refresh-JSoftApplicationsUi
    })
    return $button
}

function Refresh-JSoftCategoryButtons {
    $script:JSoft.Ui.CategoryButtonPanel.Children.Clear()

    $buttonNames = @("Alle Kategorien") + @($script:JSoft.Categories | Sort-Object order, name | ForEach-Object name)
    foreach ($name in $buttonNames) {
        $button = New-JSoftCategoryButton -Name $name
        if ($name -eq $script:JSoft.ActiveCategory) {
            $button.Background = [Windows.Media.SolidColorBrush]::new([Windows.Media.ColorConverter]::ConvertFromString("#8B3DFF"))
            $button.BorderBrush = [Windows.Media.SolidColorBrush]::new([Windows.Media.ColorConverter]::ConvertFromString("#8B3DFF"))
        } else {
            $button.Background = [Windows.Media.SolidColorBrush]::new([Windows.Media.ColorConverter]::ConvertFromString("#16324A"))
            $button.BorderBrush = [Windows.Media.SolidColorBrush]::new([Windows.Media.ColorConverter]::ConvertFromString("#31506B"))
        }
        $script:JSoft.Ui.CategoryButtonPanel.Children.Add($button) | Out-Null
    }
}

function Get-JSoftFilteredApplications {
    $search = [string]$script:JSoft.Ui.SearchBox.Text
    $category = [string]$script:JSoft.ActiveCategory
    $apps = @($script:JSoft.Applications)

    if (-not [string]::IsNullOrWhiteSpace($search)) {
        $needle = $search.Trim()
        $apps = @($apps | Where-Object {
            $_.name -like "*$needle*" -or $_.description -like "*$needle*" -or $_.packageId -like "*$needle*" -or $_.category -like "*$needle*"
        })
    }

    if (-not [string]::IsNullOrWhiteSpace($category) -and $category -ne "Alle Kategorien") {
        $apps = @($apps | Where-Object { $_.category -eq $category })
    }

    return @($apps)
}

function New-JSoftApplicationCategorySection {
    param(
        [Parameter(Mandatory)]
        [string]$CategoryName,

        [Parameter(Mandatory)]
        [object[]]$Applications
    )

    $expander = [Windows.Controls.Expander]::new()
    $expander.IsExpanded = $true
    $expander.Margin = [Windows.Thickness]::new(0, 0, 0, 10)
    $expander.Foreground = [Windows.Media.SolidColorBrush]::new([Windows.Media.ColorConverter]::ConvertFromString("#FFFFFF"))

    $header = [Windows.Controls.TextBlock]::new()
    $header.Text = "- {0} ({1})" -f $CategoryName, $Applications.Count
    $header.Foreground = [Windows.Media.SolidColorBrush]::new([Windows.Media.ColorConverter]::ConvertFromString("#8BD8FF"))
    $header.FontSize = 16
    $header.FontWeight = "SemiBold"
    $header.Margin = [Windows.Thickness]::new(4, 0, 0, 6)
    $expander.Header = $header

    $applicationPanel = [Windows.Controls.WrapPanel]::new()
    foreach ($app in $Applications | Sort-Object name) {
        $applicationPanel.Children.Add((New-JSoftApplicationCard -Application $app)) | Out-Null
    }
    $expander.Content = $applicationPanel
    return $expander
}

function Refresh-JSoftApplicationsUi {
    Refresh-JSoftCategoryButtons
    $apps = @(Get-JSoftFilteredApplications)

    $script:JSoft.Ui.ApplicationPanel.Children.Clear()
    $script:JSoft.CardControls.Clear()

    $categoryOrder = @{}
    foreach ($category in $script:JSoft.Categories) {
        $categoryOrder[[string]$category.name] = [int]$category.order
    }

    $groups = @($apps | Group-Object category | Sort-Object {
        if ($categoryOrder.ContainsKey([string]$_.Name)) { $categoryOrder[[string]$_.Name] } else { 999 }
    }, Name)
    foreach ($group in $groups) {
        $section = New-JSoftApplicationCategorySection -CategoryName $group.Name -Applications @($group.Group)
        $script:JSoft.Ui.ApplicationPanel.Children.Add($section) | Out-Null
    }

    $script:JSoft.Ui.CurrentStatusText.Text = "{0} Anwendung(en) sichtbar." -f $apps.Count
    Update-JSoftSelectionUi
}

function Set-JSoftCategoryExpansion {
    param(
        [Parameter(Mandatory)]
        [bool]$Expanded
    )

    foreach ($child in $script:JSoft.Ui.ApplicationPanel.Children) {
        if ($child -is [Windows.Controls.Expander]) {
            $child.IsExpanded = $Expanded
        }
    }
}

function Select-JSoftVisibleApplications {
    foreach ($app in @(Get-JSoftFilteredApplications)) {
        [void]$script:JSoft.Selected.Add([string]$app.id)
    }
    Refresh-JSoftApplicationsUi
    $script:JSoft.Ui.CurrentStatusText.Text = "Sichtbare Anwendungen ausgewählt."
}

function Update-JSoftSelectionUi {
    $count = $script:JSoft.Selected.Count
    $script:JSoft.Ui.SelectedCountText.Text = "{0} ausgewählt" -f $count
    $managerReady = if ($script:JSoft.Ui.ChocolateyRadio.IsChecked) {
        $script:JSoft.ChocolateyStatus.IsInstalled
    } else {
        $script:JSoft.WingetStatus.IsInstalled -and $script:JSoft.WingetStatus.SourceAvailable
    }
    $script:JSoft.Ui.InstallButton.IsEnabled = ($count -gt 0 -and -not $script:JSoft.InstallationRunning -and $managerReady)

    foreach ($appId in $script:JSoft.CardControls.Keys) {
        Update-JSoftCardVisual -AppId ([string]$appId)
    }

    $requiresAdmin = $false
    foreach ($app in $script:JSoft.Applications) {
        if ($script:JSoft.Selected.Contains($app.id) -and $app.requiresAdmin) {
            $requiresAdmin = $true
            break
        }
    }

    if ($requiresAdmin -and -not $script:JSoft.IsAdministrator) {
        $script:JSoft.Ui.RestartElevatedButton.Visibility = "Visible"
        $script:JSoft.Ui.CurrentStatusText.Text = "Mindestens eine Auswahl empfiehlt Administratorrechte."
    } else {
        $script:JSoft.Ui.RestartElevatedButton.Visibility = "Collapsed"
    }
}

function Set-JSoftAppStatus {
    param(
        [Parameter(Mandatory)][string]$AppId,
        [Parameter(Mandatory)][string]$Status
    )

    $script:JSoft.Status[$AppId] = $Status
    Update-JSoftCardVisual -AppId $AppId
}

function Select-JSoftPresetUi {
    $presetId = [string]$script:JSoft.Ui.PresetBox.SelectedValue
    if ([string]::IsNullOrWhiteSpace($presetId)) {
        return
    }

    $preset = $script:JSoft.Presets | Where-Object { $_.id -eq $presetId } | Select-Object -First 1
    if (-not $preset) {
        return
    }

    $script:JSoft.Selected.Clear()
    foreach ($id in @($preset.applications)) {
        [void]$script:JSoft.Selected.Add([string]$id)
    }

    Refresh-JSoftApplicationsUi
    $script:JSoft.Ui.CurrentStatusText.Text = "Profil geladen. Anwendungen können vor der Installation abgewählt werden."
}

function Clear-JSoftSelectionUi {
    $script:JSoft.Selected.Clear()
    Update-JSoftSelectionUi
}

function Add-JSoftHistoryItem {
    param([Parameter(Mandatory)][pscustomobject]$Item)

    $script:JSoft.Ui.HistoryList.Items.Add([pscustomobject]@{
        Name = $Item.Name
        StartTime = $Item.StartTime.ToString("HH:mm:ss")
        EndTime = $Item.EndTime.ToString("HH:mm:ss")
        Status = $Item.Status
        ExitCode = $Item.ExitCode
        ErrorMessage = $Item.ErrorMessage
    }) | Out-Null
}

function Start-JSoftInstallationUi {
    if ($script:JSoft.InstallationRunning) {
        return
    }

    $selectedApps = @($script:JSoft.Applications | Where-Object { $script:JSoft.Selected.Contains($_.id) })
    if ($selectedApps.Count -eq 0) {
        [System.Windows.MessageBox]::Show("Bitte mindestens eine Anwendung auswählen.", "J-Soft", "OK", "Information") | Out-Null
        return
    }

    $requiresAdmin = @($selectedApps | Where-Object { $_.requiresAdmin }).Count -gt 0
    if ($requiresAdmin -and -not $script:JSoft.IsAdministrator) {
        $answer = [System.Windows.MessageBox]::Show("Mindestens eine ausgewählte Anwendung empfiehlt Administratorrechte. Jetzt erhöht neu starten?", "J-Soft", "YesNoCancel", "Warning")
        if ($answer -eq "Yes") {
            Start-JSoftElevated -ScriptPath $script:JSoft.MainScript
            return
        }
        if ($answer -ne "No") {
            return
        }
    }

    $manager = if ($script:JSoft.Ui.ChocolateyRadio.IsChecked) { "chocolatey" } else { "winget" }
    if ($manager -eq "chocolatey" -and -not $script:JSoft.ChocolateyStatus.IsInstalled) {
        [System.Windows.MessageBox]::Show("Chocolatey ist nicht installiert. Bitte WinGet verwenden oder Chocolatey separat installieren.", "J-Soft", "OK", "Warning") | Out-Null
        return
    }

    foreach ($app in $selectedApps) {
        Set-JSoftAppStatus -AppId $app.id -Status "Nicht gestartet"
    }

    $script:JSoft.InstallationRunning = $true
    $script:JSoft.Ui.InstallButton.IsEnabled = $false
    $script:JSoft.Ui.ClearSelectionButton.IsEnabled = $false
    $script:JSoft.Ui.CurrentStatusText.Text = "Installation läuft..."

    $installQueue = New-JSoftInstallQueue
    if ($null -eq $installQueue) {
        $script:JSoft.InstallationRunning = $false
        $script:JSoft.Ui.ClearSelectionButton.IsEnabled = $true
        Write-JSoftLog -Level "ERROR" -Message "Die Installationswarteschlange konnte nicht erstellt werden."
        [System.Windows.MessageBox]::Show("Die Installationswarteschlange konnte nicht erstellt werden.", "J-Soft", "OK", "Error") | Out-Null
        Update-JSoftSelectionUi
        return
    }

    $script:JSoft.InstallQueue = $installQueue
    try {
        $script:JSoft.InstallRunspace = Start-JSoftInstallRunspace -Applications $selectedApps -PackageManager $manager -RootPath $script:JSoft.RootPath -LogPath $script:JSoft.LogPath -Queue $installQueue
    } catch {
        $script:JSoft.InstallationRunning = $false
        $script:JSoft.InstallQueue = $null
        $script:JSoft.InstallRunspace = $null
        $script:JSoft.Ui.ClearSelectionButton.IsEnabled = $true
        Write-JSoftLog -Level "ERROR" -Message ("Installationslauf konnte nicht gestartet werden: {0}" -f $_.Exception.Message)
        [System.Windows.MessageBox]::Show("Der Installationslauf konnte nicht gestartet werden.`n`n$($_.Exception.Message)", "J-Soft", "OK", "Error") | Out-Null
        Update-JSoftSelectionUi
        return
    }
    $script:JSoft.InstallTimer.Start()
}

function Process-JSoftInstallQueue {
    $item = $null
    while ($script:JSoft.InstallQueue -and $script:JSoft.InstallQueue.TryDequeue([ref]$item)) {
        switch ($item.Type) {
            "status" {
                Set-JSoftAppStatus -AppId $item.AppId -Status $item.Status
                $script:JSoft.Ui.CurrentStatusText.Text = $item.Message
            }
            "history" {
                Add-JSoftHistoryItem -Item $item
            }
            "done" {
                $script:JSoft.InstallTimer.Stop()
                $script:JSoft.InstallationRunning = $false
                $script:JSoft.Ui.ClearSelectionButton.IsEnabled = $true
                $script:JSoft.Ui.CurrentStatusText.Text = "Abgeschlossen: $($item.Success) erfolgreich, $($item.AlreadyInstalled) bereits installiert, $($item.Failed) fehlgeschlagen."
                if ($script:JSoft.InstallRunspace) {
                    try { $script:JSoft.InstallRunspace.PowerShell.EndInvoke($script:JSoft.InstallRunspace.Handle) | Out-Null } catch {}
                    $script:JSoft.InstallRunspace.PowerShell.Dispose()
                    $script:JSoft.InstallRunspace = $null
                }
                Update-JSoftSelectionUi
            }
        }
    }
}

function Initialize-JSoftUi {
    $script:JSoft.Ui = New-JSoftMainWindow

    $script:JSoft.Ui.VersionText.Text = "Version $($script:JSoft.Settings.version)"
    $script:JSoft.Ui.WingetStatusText.Text = "WinGet: $($script:JSoft.WingetStatus.Version) - $($script:JSoft.WingetStatus.Message)"
    $script:JSoft.Ui.AdminStatusText.Text = if ($script:JSoft.IsAdministrator) { "Administratorrechte: ja" } else { "Administratorrechte: nein" }

    $script:JSoft.ActiveCategory = "Alle Kategorien"

    $script:JSoft.PresetEditorSelected = [System.Collections.Generic.HashSet[string]]::new()
    $script:JSoft.PresetActiveCategory = "Alle Kategorien"
    $script:JSoft.PresetEditMode = $false

    $script:JSoft.Ui.InstallButton.IsEnabled = $false

    if (-not $script:JSoft.WingetStatus.IsInstalled -or -not $script:JSoft.WingetStatus.SourceAvailable) {
        $script:JSoft.Ui.CurrentStatusText.Text = $script:JSoft.WingetStatus.Message
    }

    $script:JSoft.Ui.SearchBox.Add_TextChanged({ Refresh-JSoftApplicationsUi })
    $script:JSoft.Ui.WingetRadio.Add_Checked({ Update-JSoftSelectionUi })
    $script:JSoft.Ui.ChocolateyRadio.Add_Checked({ Update-JSoftSelectionUi })
    $script:JSoft.Ui.ApplyPresetButton.Add_Click({ Select-JSoftPresetUi })
    $script:JSoft.Ui.PresetListBox.Add_SelectionChanged({ Load-JSoftPresetEditor })
    $script:JSoft.Ui.PresetAppSearchBox.Add_TextChanged({ Refresh-JSoftPresetApplicationEditor })
    $script:JSoft.Ui.EditPresetButton.Add_Click({
        Set-JSoftPresetEditorMode -Editing $true
        Refresh-JSoftPresetApplicationEditor
    })
    $script:JSoft.Ui.CancelPresetEditButton.Add_Click({
        $currentId = [string]$script:JSoft.Ui.PresetNameBox.Tag
        $preset = $script:JSoft.Presets | Where-Object { [string]$_.id -eq $currentId } | Select-Object -First 1
        if ($preset) {
            Load-JSoftPresetEditor
        } else {
            $script:JSoft.Ui.PresetNameBox.Text = ""
            $script:JSoft.Ui.PresetDescriptionBox.Text = ""
            $script:JSoft.PresetEditorSelected = [System.Collections.Generic.HashSet[string]]::new()
            Refresh-JSoftPresetApplicationEditor
        }
        Set-JSoftPresetEditorMode -Editing $false
        Refresh-JSoftPresetApplicationEditor
    })
    $script:JSoft.Ui.NewPresetButton.Add_Click({ New-JSoftPresetEditor })
    $script:JSoft.Ui.SavePresetButton.Add_Click({ Save-JSoftPresetEditor })
    $script:JSoft.Ui.DeletePresetButton.Add_Click({ Remove-JSoftPresetEditor })
    $script:JSoft.Ui.ClearSelectionButton.Add_Click({ Clear-JSoftSelectionUi })
    $script:JSoft.Ui.ExpandCategoriesButton.Add_Click({ Set-JSoftCategoryExpansion -Expanded $true })
    $script:JSoft.Ui.CollapseCategoriesButton.Add_Click({ Set-JSoftCategoryExpansion -Expanded $false })
    $script:JSoft.Ui.SelectVisibleButton.Add_Click({ Select-JSoftVisibleApplications })
    $script:JSoft.Ui.InstallButton.Add_Click({ Start-JSoftInstallationUi })
    $script:JSoft.Ui.RestartElevatedButton.Add_Click({ Start-JSoftElevated -ScriptPath $script:JSoft.MainScript })

    $script:JSoft.Ui.NavSoftwareButton.Add_Click({ Set-JSoftView -ViewName "Software" })
    $script:JSoft.Ui.NavPresetsButton.Add_Click({ Set-JSoftView -ViewName "Presets" })
    $script:JSoft.Ui.NavHistoryButton.Add_Click({ Set-JSoftView -ViewName "History" })
    $script:JSoft.Ui.NavSettingsButton.Add_Click({ Set-JSoftView -ViewName "Settings" })
    $script:JSoft.Ui.NavAboutButton.Add_Click({ Set-JSoftView -ViewName "About" })

    $script:JSoft.InstallTimer = [Windows.Threading.DispatcherTimer]::new()
    $script:JSoft.InstallTimer.Interval = [TimeSpan]::FromMilliseconds(250)
    $script:JSoft.InstallTimer.Add_Tick({ Process-JSoftInstallQueue })

    $script:JSoft.Ui.Window.Add_Closing({
        if ($script:JSoft.InstallationRunning) {
            $answer = [System.Windows.MessageBox]::Show("Eine Installation läuft noch. Fenster trotzdem schließen?", "J-Soft", "YesNo", "Warning")
            if ($answer -ne "Yes") {
                $_.Cancel = $true
            }
        }
    })

    foreach ($app in $script:JSoft.Applications) {
        $script:JSoft.Status[$app.id] = "Nicht gestartet"
    }

    Set-JSoftPresetEditorMode -Editing $false
    Refresh-JSoftPresetSelector
    Refresh-JSoftPresetEditorList
    Refresh-JSoftApplicationsUi
}
