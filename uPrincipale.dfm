object frmPrincipale: TfrmPrincipale
  Left = 0
  Top = 0
  Caption = 'Revision des Loyer'
  ClientHeight = 397
  ClientWidth = 680
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Loyer: TLabel
    Left = 176
    Top = 8
    Width = 27
    Height = 13
    Caption = 'Loyer'
  end
  object Label2: TLabel
    Left = 176
    Top = 38
    Width = 38
    Height = 13
    Caption = 'Date du'
  end
  object Label3: TLabel
    Left = 176
    Top = 65
    Width = 38
    Height = 13
    Caption = 'Date au'
  end
  object mmoLog: TMemo
    Left = 40
    Top = 89
    Width = 265
    Height = 272
    Lines.Strings = (
      'mmoLog')
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object btnMensualite: TBitBtn
    Left = 464
    Top = 8
    Width = 145
    Height = 25
    Caption = 'Creer Mensualit'#233's'
    TabOrder = 1
    OnClick = btnMensualiteClick
  end
  object txtDateDu: TDateTimePicker
    Left = 240
    Top = 35
    Width = 145
    Height = 21
    Date = 43536.687644942130000000
    Time = 43536.687644942130000000
    TabOrder = 3
  end
  object txtDateau: TDateTimePicker
    Left = 240
    Top = 62
    Width = 145
    Height = 21
    Date = 43536.687857835650000000
    Time = 43536.687857835650000000
    TabOrder = 4
  end
  object txtLoyer: TEdit
    Left = 240
    Top = 8
    Width = 145
    Height = 21
    TabOrder = 2
    Text = '1000'
  end
  object dbgMensualite: TDBGrid
    Left = 311
    Top = 89
    Width = 320
    Height = 272
    DataSource = dsM
    TabOrder = 5
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object dbedt: TDBEdit
    Left = 510
    Top = 368
    Width = 121
    Height = 21
    DataField = 'Total'
    DataSource = dsM
    TabOrder = 6
  end
  object dsMensualite: TClientDataSet
    Aggregates = <>
    AggregatesActive = True
    Params = <>
    Left = 112
    Top = 160
    object dsMensualiteDateDu: TDateField
      FieldName = 'DateDu'
    end
    object dsMensualiteDateAu: TDateField
      FieldName = 'DateAu'
    end
    object dsMensualiteLoyerPrincipal: TFloatField
      FieldName = 'LoyerPrincipal'
      DisplayFormat = '#,##0.00'
    end
    object dsMensualiteTotal: TAggregateField
      FieldName = 'Total'
      KeyFields = 'LoyerPrincipal'
      Active = True
      DisplayName = ''
      Expression = 'SUM(LoyerPrincipal)'
    end
  end
  object dsM: TDataSource
    DataSet = dsMensualite
    Left = 192
    Top = 160
  end
end
