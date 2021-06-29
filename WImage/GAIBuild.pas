unit GAIBuild;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ToolEdit, StdCtrls, Mask,GraphBuf,Grids,EC_Mem,EC_Str,EC_File,EC_Buf,FormMain,GraphBufList,Globals,
  FormDifferent,FormSaveGAI,OImage,FormBuildGAIAnim;

type
TGAIBuild = class(TObject)
    public
        FZag:SGAIZag;
        FFile:TFileEC;
        FBD:TBufEC;
        FI:integer;
    public
        constructor Create(filename:WideString; cnt:integer; series:boolean; frame:WideString);
        destructor Destroy; override;

        procedure AddImage(gb:TGraphBuf; rformat:integer; autosize:boolean);
end;

implementation

constructor TGAIBuild.Create(filename:WideString; cnt:integer; series:boolean; frame:WideString);
var
    sg:TStringGrid;
    tstr:WideString;
    i:integer;
begin
    inherited Create;
    ZeroMemory(@FZag,sizeof(SGAIZag));
    FZag.id0:=Ord('g');
    FZag.id1:=Ord('a');
    FZag.id2:=Ord('i');
    FZag.ver:=1;
    FZag.count:=cnt;
    FZag.series:=0; if series then FZag.series:=1;

    FBD:=TBufEC.Create;

    FFile:=TFileEC.Create;
    FFile.Init(AnsiString(filename));
    FFile.CreateNew;

    FFile.Write(@FZag,sizeof(SGAIZag));

    FBD.Len:=FZag.count*8;
    ZeroMemory(FBD.Buf,FBD.Len);
    FFile.Write(FBD.Buf,FBD.Len);

    if frame<>'' then begin
        sg:=TStringGrid.Create(Form_BuildGAIAnim);
        sg.RowCount:=GetCountParEC(frame,'~');
        sg.ColCount:=2;
        for i:=0 to sg.RowCount-1 do begin
            tstr:=GetStrParEC(frame,i,'~');
            if GetCountParEC(tstr,'=')<2 then begin
                sg.Cells[0,i]:='';
                sg.Cells[1,i]:=tstr;
            end else begin
                sg.Cells[0,i]:=GetStrParEC(tstr,0,'=');
                sg.Cells[1,i]:=GetStrParEC(tstr,1,'=');
            end;
        end;
        Form_SaveGAI.BuildAnim(sg,FBD);
        if FBD.Len>0 then begin
            FZag.smeAnim:=FFile.GetPointer;
            FZag.sizeAnim:=FBD.Len;
            FFile.Write(FBD.Buf,FBD.Len);
        end;
        sg.Free;
    end;

    FI:=0;
end;

destructor TGAIBuild.Destroy;
begin
    FFile.SetPointer(0);
    FFile.Write(@FZag,sizeof(SGAIZag));
    FFile.Close;
    FFile.Free;
    FFile:=nil;

    FBD.Free;
    FBD:=nil;

    inherited Destroy;
end;

procedure TGAIBuild.AddImage(gb:TGraphBuf; rformat:integer; autosize:boolean);
var
    tpos,zn:DWORD;
    zaggi:PGIZag;
begin
    FBD.Clear;
    if rformat=1 then begin
        gb.BuildGI_Trans(FBD,autosize);
    end else if rformat=2 then begin
        gb.BuildGI_Alpha(FBD,autosize);
    end else if rformat=3 then begin
        gb.BuildGI_AlphaIndexed8(FBD,autosize);
    end else begin
        raise Exception.Create('TGAIBuild.AddImage. Format not support');
    end;

    tpos:=FFile.GetPointer;
    FFile.SetPointer(sizeof(SGAIZag)+FI*8);
    FFile.Write(@tpos,4);
    zn:=FBD.Len;
    FFile.Write(@zn,4);
    FFile.SetPointer(tpos);
    FFile.Write(FBD.Buf,FBD.Len);

    zaggi:=FBD.Buf;
    if ((zaggi.rect.right-zaggi.rect.left)>0) and ((zaggi.rect.bottom-zaggi.rect.top)>0) then begin
        if (FZag.rect.right-FZag.rect.left)<1 then FZag.rect:=zaggi.rect
        else UnionRect(FZag.rect,FZag.rect,zaggi.rect);
    end;

    inc(FI);
end;

end.
