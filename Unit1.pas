unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, Buttons;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    ProgressBar1: TProgressBar;
    Edit1: TEdit;
    Edit2: TEdit;
    SpeedButton1: TSpeedButton;
    OpenDialog1: TOpenDialog;
    SpeedButton2: TSpeedButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);

  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}
function SplitFile(FileName : TFileName; SizeofFiles : Integer; ProgressBar : TProgressBar) : Boolean;
var
  i : Word;
  fs, sStream: TFileStream;
  SplitFileName: String;
begin
  ProgressBar.Position := 0;
  fs := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    for i := 1 to Trunc(fs.Size / SizeofFiles) + 1 do
    begin
      SplitFileName := ChangeFileExt(FileName, '.'+ FormatFloat('000', i));
      sStream := TFileStream.Create(SplitFileName, fmCreate or fmShareExclusive);
      try
        if fs.Size - fs.Position < SizeofFiles then
          SizeofFiles := fs.Size - fs.Position;
        sStream.CopyFrom(fs, SizeofFiles);
        ProgressBar.Position := Round((fs.Position / fs.Size) * 100);
      finally
        sStream.Free;
      end;
    end;
  finally
    fs.Free;
  end;

end;

function CombineFiles(FileName, CombinedFileName : TFileName) : Boolean;
var
  i: integer;
  fs, sStream: TFileStream;
  filenameOrg: String;
begin
  i := 1;
  fs := TFileStream.Create(CombinedFileName, fmCreate or fmShareExclusive);
  try
    while FileExists(FileName) do
    begin
      sStream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
      try
        fs.CopyFrom(sStream, 0);
      finally
        sStream.Free;
      end;
      Inc(i);
      FileName := ChangeFileExt(FileName, '.'+ FormatFloat('000', i));
    end;
  finally
    fs.Free;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
 SplitFile(Edit1.Text, 200000, ProgressBar1); 
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
 CombineFiles(Edit2.Text,ExtractFilePath(Application.ExeName)+'test.exe');
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
 if not OpenDialog1.Execute then Exit;
 Edit1.Text:=OpenDialog1.FileName;
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
 if not OpenDialog1.Execute then Exit;
 Edit2.Text:=OpenDialog1.FileName;
end;

end.
