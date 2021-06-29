// Ошибка раземр записывется старый а не в архиве
unit FormBuildGAIExAnim;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,Math,
  ToolEdit, StdCtrls, Mask,GraphBuf,Grids;

type
  TForm_BuildGAIExAnim = class(TForm)
    ButtonLoad: TButton;
    OpenDialogFile: TOpenDialog;
    ButtonBuild: TButton;
    ButtonClose: TButton;
    MemoText: TMemo;
    ListBoxFiles: TListBox;
    Label2: TLabel;
    FilenameEditDesGAI: TFilenameEdit;
    Label1: TLabel;
    EditRadius: TEdit;
    CheckBoxCompress: TCheckBox;
    CheckBoxDithering: TCheckBox;
    Label3: TLabel;
    ComboBoxChannels: TComboBox;
    Label4: TLabel;
    EditScale: TEdit;
    Label5: TLabel;
    ComboBoxFilter: TComboBox;
    CheckBoxSubBlackColor: TCheckBox;
    Label6: TLabel;
    EditFrame: TEdit;
    Label7: TLabel;
    EditPF: TEdit;
    Label8: TLabel;
    FilenameEditDesGI: TFilenameEdit;
    Label9: TLabel;
    ComboBoxFormat: TComboBox;
    ButtonDrop: TButton;
    EditDrop: TEdit;
    procedure ButtonLoadClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ButtonBuildClick(Sender: TObject);
    procedure ButtonDropClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

    procedure BuildDifferent(sou1,sou2,desadd,dessub:TGraphBuf; cntchan:integer; errcnt:BYTE);
    procedure BuildAdd(des,sou,bufadd,bufsub:TGraphBuf; cntchan:integer);
    procedure ShowStat(bufadd,bufsub:TGraphBuf; cntchan:integer);

    function FindRect(gb1,gb2:TGraphBuf):TRect; overload;
    function FindRect(gb:TGraphBuf):TRect; overload;
    function FindRectChan(gb:TGraphBuf; cntchan:integer):TRect;
    function FindRect(gb:TGraphBuf; channel:integer):TRect; overload;

    function FindRectEx(gb1,gb2:TGraphBuf; tr:TRect):TRect; overload;
    function FindRectEx(gb:TGraphBuf; tr:TRect):TRect; overload;
    function FindRectEx(gb:TGraphBuf; channel:integer; tr:TRect):TRect; overload;

    function FindRectExDWORD(gb:TGraphBuf; tr:TRect):TRect; overload;

    procedure ClearIfAlpha0(gb:TGraphBuf);
  end;

var
  Form_BuildGAIExAnim: TForm_BuildGAIExAnim;

implementation

uses EC_Mem,EC_Str,EC_File,EC_Buf,FormMain,GraphBufList,Globals,
  FormDifferent,FormSaveGAI,OImage, FormCorrectImageByAlpha;

var
    s_CountPixel:array[0..7] of integer;
    s_CountPixelZ:array[0..7] of integer;

//    GBuf1:TBufEC;
//    GBuf2:TBufEC;

{$R *.DFM}

function CMode(zn:BYTE):BYTE;
begin
    if zn=0 then Result:=255
    else if zn<=2 then Result:=0
    else if zn<=4 then Result:=1
    else if zn<=16 then Result:=2
    else Result:=3;
end;

function ST2(cnt:integer):integer;
var
    i:integer;
begin
    if cnt<1 then begin Result:=1; Exit; end;
    Result:=2;
    for i:=1 to cnt-1 do Result:=Result*2;
end;

function CntRaz(zn:integer):integer;
begin
    Result:=1;
    zn:=zn shr 1;
    while zn<>0 do begin
        inc(Result);
        zn:=zn shr 1;
    end;
end;

// F5-Control byte
// 1zmmcccc  cccc+1-count fill z-znak m-mode
// 00000000  end row
// 00111111  next WORD count pixel skip
// 00cccccc  cccccc-count pixel skip
// 01000000  end image
//========= 01111111  next WORD count line skip
//========= 01cccccc  cccccc-count row skip

function CBuildRowF5(desadd,dessub:TGraphBuf; startx,endx,y,channel:integer; buf:Pointer):integer;
var
    x:integer;
    pa,ps:integer;
    cnt,size,zs:integer;
    cb,cbo:BYTE;
    pst:Pointer;
begin
    size:=0;
    cbo:=0;
    cnt:=0;
    pst:=nil;
    buf:=PAdd(buf,-1);
    for x:=startx to endx-1 do begin
        pa:=desadd.PixelChannel(x,y,channel);
        ps:=dessub.PixelChannel(x,y,channel);

        if pa<>0 then cb:=(1 shl 7) or (CMode(pa) shl 4)
        else if ps<>0 then cb:=(1 shl 7) or (1 shl 6) or (CMode(ps) shl 4)
        else cb:=0;

        if (cb=0) and (cbo=0) then begin
            inc(cnt);
        end else if (cb=cbo) then begin
            zs:=cnt mod ST2(3-((cbo shr 4) and 3));
            if zs=0 then begin inc(size); buf:=PAdd(buf,1); end;
            PSet(buf,PGetBYTE(buf) or ((max(pa,ps)-1) shl (zs*ST2((cbo shr 4) and 3))));

            inc(cnt);
            PSet(pst,BYTE(cbo or BYTE((cnt-1))));

            inc(s_CountPixel[(cb shr 4) and 3]);

//if pa>0 then SFTne(' '+IntToStr(pa))
//else SFTne(' -'+IntToStr(ps));

            if cnt=16 then begin cb:=0; cnt:=0; end;
        end else if cb=0 then begin
            cnt:=1;
        end else begin
            if (cnt>0) and (cbo=0) then begin

//SFTne(' ~');

                inc(size); buf:=PAdd(buf,1);
                if cnt<63 then begin
                    PSet(buf,BYTE(cnt));
                end else begin
                    PSet(buf,BYTE($3f));
                    inc(size,2); buf:=PAdd(buf,1);
                    PSet(buf,WORD(cnt));
                    buf:=PAdd(buf,1);
                end;
            end;
            inc(size); buf:=PAdd(buf,1);
            pst:=buf;
            PSet(buf,cb);
            inc(size); buf:=PAdd(buf,1);
            PSet(buf,BYTE(max(pa,ps)-1));
            cnt:=1;

            inc(s_CountPixel[(cb shr 4) and 3]);
            inc(s_CountPixelZ[(cb shr 4) and 3]);

//if pa>0 then SFTne(' ('+IntToStr((cbo shr 4) and 3)+')')
//else SFTne(' (-'+IntToStr((cbo shr 4) and 3)+')');

//if pa>0 then SFTne(' '+IntToStr(pa))
//else SFTne(' -'+IntToStr(ps));

        end;

        cbo:=cb;
    end;

//SFTne('           RowSize='+IntToStr(size));

    inc(size); buf:=PAdd(buf,1);
    PSet(buf,0);

    Result:=size;
end;

function CBuildF5(desadd,dessub:TGraphBuf; cntchan:integer; rc:TRect; buf:Pointer; bufsize:integer; pf0,pf1,pf2,pf3:integer):integer;
var
    t,size,y,c:integer;
    zag:PGIZag;
    zagunit:PGIUnit;
    rows,zagdata:Pointer;
begin
    size:=0;

    ZeroMemory(buf,bufsize);

    zag:=buf;
    zag.id0:=Ord('g');
    zag.id1:=Ord('i');
    zag.id2:=0;
    zag.id3:=0;
    zag.ver:=1;
    zag.rect:=rc;
    zag.mR:=(ST2(pf0)-1);//$00000001f;
    if cntchan>=2 then zag.mG:=(ST2(pf1)-1) shl 8;
    if cntchan>=3 then begin
        zag.mB:=zag.mR;
        zag.mR:=(ST2(pf2)-1) shl 16;
    end;
    if cntchan>=4 then zag.mA:=(ST2(pf3)-1) shl 24;
    zag.format:=5;
    zag.countUnit:=1;
    zag.countUpdateRect:=0;
    zag.smeUpdateRect:=0;

    buf:=PAdd(buf,sizeof(SGIZag));
    size:=size+sizeof(SGIZag);

    if ((rc.Right-rc.Left)<1) or ((rc.Bottom-rc.Top)<1) then begin
        zag.countUnit:=0;
        Result:=size;
        Exit;
    end;

    zagunit:=buf;
    zagunit.rect:=rc;

    buf:=PAdd(buf,sizeof(SGIUnit));
    size:=size+sizeof(SGIUnit);

    zagunit.sme:=DWORD(buf)-DWORD(zag);
    zagdata:=buf;
    PSet(buf,DWORD(0)); buf:=PAdd(buf,4); size:=size+4;
    PSet(buf,DWORD(rc.Right-rc.Left)); buf:=PAdd(buf,4); size:=size+4;
    PSet(buf,DWORD(rc.Bottom-rc.Top)); buf:=PAdd(buf,4); size:=size+4;
    PSet(buf,DWORD(pf0 or (pf1 shl 4) or (pf2 shl 8) or (pf2 shl 12))); buf:=PAdd(buf,4); size:=size+4;

    rows:=buf;
    buf:=PAdd(buf,(rc.Bottom-rc.Top)*4);
    size:=size+(rc.Bottom-rc.Top)*4;

    for t:=0 to 7 do s_CountPixel[t]:=0;
    for t:=0 to 7 do s_CountPixelZ[t]:=0;

    for y:=rc.Top to rc.Bottom-1 do begin
        PSet(PAdd(rows,(y-rc.Top)*4),DWORD(buf)-DWORD(zagdata));
        for c:=0 to cntchan-1 do begin
            t:=CBuildRowF5(desadd,dessub,rc.Left,rc.Right,y,c,buf);
            buf:=PAdd(buf,t);
            size:=size+t;
//SFT('    BufSize='+IntToStr(size));
        end;
    end;

    PSet(buf,BYTE($40)); buf:=PAdd(buf,1); size:=size+1;

    PSet(zagdata,DWORD(buf)-DWORD(zagdata)-16-DWORD((rc.Bottom-rc.Top)*4));

    zagunit.size:=size-sizeof(SGIZag)-sizeof(SGIUnit);

    Result:=size;
end;

// F6
// Zag :
//      1 byte - cnt bit channel 0 and 1
//      1 byte - cnt bit channel 2 and 3
//      2 byte - block count
// Block :
//      10b - smex
//      10b - smey
// Block data :
//   For channels :
//      Zag:    3b - bit per pixel
//              2b - nom channel
//         (bit per pixel=0) and (nom channels=0) - end row
//         (bit per pixel=0) and (nom channels=1) - end block
//         (bit per pixel=0) and (nom channels=2) - zero channel
//              1b - 0-sub 1-add
//      Data:
//              1b - 0-skip 1-fill
//              for skip :
//                  3b - count          count=0 - end channel
//              for fill :
//                  fill data for pixel

var
rmask:array[0..8] of BYTE=(0,1,3,7,15,31,63,127,255);

procedure CBuildAddBitF6(var buf:pointer; var bufbit:integer; bits:DWORD; cnt:integer);
var
    zn,cf:DWORD;
begin
//SFT(Format('%d    %x',[cnt,bits]));
    while (true) do begin
        if (bufbit+cnt)<=8 then begin
            zn:=bits and rmask[cnt];
            PSet(buf,PGetBYTE(buf) or ((zn) shl bufbit));

            bufbit:=bufbit+cnt;
            if bufbit=8 then begin
                bufbit:=0;
                buf:=PAdd(buf,1);
            end;
            Exit;
        end else begin
            cf:=8-bufbit;
            zn:=(bits shr (cnt{bits}-integer(cf))) and rmask[cf];
            PSet(buf,PGetBYTE(buf) or ((zn) shl bufbit));
            buf:=PAdd(buf,1);
            cnt:=cnt-integer(cf);
            bufbit:=0;
        end;
    end;
end;

procedure CBuildAddBitCntF6(var buf:pointer; var bufbit:integer; cnt:integer);
var
    f,zn:integer;
begin
    zn:=CntRaz(cnt);
    if zn<=2 then begin zn:=2; f:=0; end
    else if zn<=4 then begin zn:=4; f:=1; end
    else if zn<=6 then begin zn:=6; f:=2; end
    else if zn<=8 then begin zn:=8; f:=3; end
    else raise Exception.Create('CBuildAddBitCntF6');

    CBuildAddBitF6(buf,bufbit,f,2);
    CBuildAddBitF6(buf,bufbit,cnt,zn);

if CntRaz(cnt)<8 then inc(s_CountPixel[CntRaz(cnt)],2+zn)
else inc(s_CountPixelZ[CntRaz(cnt)-8],2+zn);
end;

function CBuildCntF6(buf,desimg:TGraphBuf; startx,endx,y,channel:integer; maxraz:integer):integer;
var
    x:integer;
    bz:BYTE;
begin
    x:=startx;
    while x<endx do begin
        bz:=buf.PixelChannel(x,y,channel);
        if bz=0 then break;
        if CntRaz(bz-1)>maxraz then break;
        if PGetDWORD(desimg.PixelBuf(x,y))=0 then break;
        inc(x);
    end;
    Result:=x-startx;
end;

function CBuildCntSkipF6(buf,desimg:TGraphBuf; startx,endx,y,channel:integer; maxraz:integer):integer;
var
    x:integer;
    bz:BYTE;
begin
    x:=startx;
    while x<endx do begin
        if PGetDWORD(desimg.PixelBuf(x,y))<>0 then begin
            bz:=buf.PixelChannel(x,y,channel);
            if (bz<>0) and (CntRaz(bz-1)<=maxraz) then break;
        end;
        inc(x);
    end;
    Result:=x-startx;
end;

procedure CBuildChannelF6(desadd,dessub,desimg:TGraphBuf; var buf:pointer; var bufbit:integer; startx,endx,y,channel:integer; analiz:boolean);
var
    x,i,u,fsub,cnt,nmax,zmin:integer;
    curbuf:TGraphBuf;
    crs:array[0..16] of integer;
    tb:BYTE;
begin
    curbuf:=desadd;
    for fsub:=0 to 1 do begin

        for i:=0 to 7 do crs[i]:=0;
        for x:=startx to endx-1 do begin
            if PGetDWORD(desimg.PixelBuf(x,y))=0 then continue;
            tb:=curbuf.PixelChannel(x,y,channel);
            if tb<>0 then inc(crs[CntRaz(tb-1)-1]);
        end;

        nmax:=0;
        while true do begin
            cnt:=0;
            for i:=0 to 7 do if crs[i]>0 then begin nmax:=i; inc(cnt); end;
            if cnt<=4 then break;

            u:=nmax-1; zmin:=crs[u];
            while zmin=0 do begin dec(u); zmin:=crs[u]; end;
            for i:=nmax-2 downto 0 do if (crs[i]<>0) and (zmin>crs[i]) then begin zmin:=crs[i]; u:=i; end;

            i:=u+1;
            while crs[i]=0 do inc(i);

            crs[i]:=crs[i]+crs[u];
            crs[u]:=0;
        end;

        u:=nmax;
        for i:=nmax-1 downto 0 do begin
            if crs[i]=0 then continue;
            if crs[i]>6 then begin
                u:=i;
            end else begin
                crs[u]:=crs[u]+crs[i];
                crs[i]:=0;
            end;
        end;
//Form_BuildGAIExAnim.MemoText.Lines.Add(Format('        %d,%d,%d,%d,%d,%d,%d,%d',[crs[0],crs[1],crs[2],crs[3],crs[4],crs[5],crs[6],crs[7]]));

        for i:=0 to 7 do begin
            if crs[i]=0 then continue;
            if not analiz then begin
                CBuildAddBitF6(buf,bufbit,i+1,3);
                CBuildAddBitF6(buf,bufbit,channel,2);
                CBuildAddBitF6(buf,bufbit,fsub,1);
            end;

            x:=startx;
            while true do begin
                cnt:=CBuildCntSkipF6(curbuf,desimg,x,endx,y,channel,i+1);
                if ((x+cnt)>=endx) then begin // end channel
                    if not analiz then begin
                        CBuildAddBitF6(buf,bufbit,0,1);
//                        CBuildAddBitCntF6(buf,bufbit,0);
                        CBuildAddBitF6(buf,bufbit,0,3);
                    end;

                    break;
                end else if cnt>0 then begin // skip
                    if cnt>7 then cnt:=7;

                    if analiz then begin
                        inc(s_CountPixel[cnt]);
                    end else begin
                        CBuildAddBitF6(buf,bufbit,0,1);

{                        if (s_CountPixel[3]<>0) and (cnt>=s_CountPixel[3]) then begin cnt:=s_CountPixel[3]; tb:=3; end
                        else if (s_CountPixel[2]<>0) and (cnt>=s_CountPixel[2]) then begin cnt:=s_CountPixel[2]; tb:=2; end
                        else begin cnt:=1; tb:=1; end;}

{                        if cnt>=5 then begin cnt:=5; tb:=3; end
                        else if cnt>=3 then begin cnt:=3; tb:=2; end
                        else begin cnt:=1; tb:=1; end;}

{                       CBuildAddBitF6(buf,bufbit,tb,2);}

{                        if cnt>=7 then begin
                            cnt:=7;
                            CBuildAddBitF6(buf,bufbit,1,1);
                        end else begin
                            if cnt>3 then cnt:=3;
                            CBuildAddBitF6(buf,bufbit,0,1);
                            CBuildAddBitF6(buf,bufbit,cnt,2);
                        end;}

                        CBuildAddBitF6(buf,bufbit,cnt,3);

//SFT('                     '+IntToStr(cnt));
                    end;


//SFT(Format('        %d',[cnt]));

                    x:=x+cnt;
                end;
                cnt:=CBuildCntF6(curbuf,desimg,x,endx,y,channel,i+1);
                if cnt>0 then begin // fill
//SFT(Format('%d',[cnt]));
//GBuf2.AddBYTE(cnt);
                    if not analiz then begin
                        CBuildAddBitF6(buf,bufbit,1,1);
//                    CBuildAddBitCntF6(buf,bufbit,cnt);
//                    CBuildAddBitF6(buf,bufbit,cnt,2);

                        CBuildAddBitF6(buf,bufbit,curbuf.PixelChannel(x,y,channel)-1,i+1);
                    end;

                    curbuf.SetPixelChannel(x,y,channel,0);

                    inc(x);

                end;
            end;
        end;

        curbuf:=dessub;
    end;
end;

procedure CBuildZeroF6(desadd,dessub,desadd2,dessub2,desimg2,desimg:TGraphBuf; var buf:pointer; var bufbit:integer; startx,endx,y:integer);
var
    x,tx,cnt:integer;
begin
    x:=startx;
    while x<endx do begin
        if (PGetDWORD(desadd.PixelBuf(x,y))<>0) or (PGetDWORD(dessub.PixelBuf(x,y))<>0) then break;
        inc(x);
    end;
    if x>=endx then exit;

    CBuildAddBitF6(buf,bufbit,0,3);
    CBuildAddBitF6(buf,bufbit,2,2);

    x:=startx;
    while true do begin
//        cnt:=CBuildCntSkipF6(curbuf,desimg,x,endx,y,channel,i+1);
        cnt:=0;
        for tx:=x to endx-1 do begin
            if (PGetDWORD(desadd.PixelBuf(tx,y))<>0) or (PGetDWORD(dessub.PixelBuf(tx,y))<>0) then break;
            inc(cnt);
        end;

        if ((x+cnt)>=endx) then begin // end channel
            CBuildAddBitF6(buf,bufbit,0,1);
            CBuildAddBitF6(buf,bufbit,0,3);
            break;
        end else if cnt>0 then begin // skip
            if cnt>7 then cnt:=7;

            CBuildAddBitF6(buf,bufbit,0,1);
            CBuildAddBitF6(buf,bufbit,cnt,3);
            x:=x+cnt;
        end;

//        cnt:=CBuildCntF6(curbuf,desimg,x,endx,y,channel,i+1);
        cnt:=0;
        for tx:=x to endx-1 do begin
            if (PGetDWORD(desadd.PixelBuf(tx,y))=0) and (PGetDWORD(dessub.PixelBuf(tx,y))=0) then break;
            inc(cnt);
        end;

        if cnt>0 then begin // fill
            CBuildAddBitF6(buf,bufbit,1,1);

            PSet(desadd2.PixelBuf(x,y),DWORD(0));
            PSet(dessub2.PixelBuf(x,y),DWORD(0));
            PSet(desimg2.PixelBuf(x,y),DWORD(0));

            inc(x);
        end;
    end;
end;

function CBuildF6(desadd,dessub,desadd2,dessub2,desimg2,desimg:TGraphBuf; cntchan:integer; rc:TRect; buf:pointer; bufsize:integer; pf0,pf1,pf2,pf3:integer):integer;
var
    y,c,i,t,zmin1,zmin2,imin1,imin2:integer;
    bufbit:integer;
    zag:PGIZag;
    startbufdata:Pointer;
    cntcol,cntrow,col,row:integer;
    smex,smey,brscnt:integer;
    brs:array of TRect;
    zagunit:PGIUnit;
//    desadd_a,dessub_a:TGraphBuf;
    blocksizeX,blocksizeY:integer;
begin
    blocksizeX:=16;
    blocksizeY:=16;

    ZeroMemory(buf,bufsize);

    zag:=buf;
    zag.id0:=Ord('g');
    zag.id1:=Ord('i');
    zag.id2:=0;
    zag.id3:=0;
    zag.ver:=1;
    zag.rect:=rc;
    zag.mR:=(ST2(pf0)-1);//$00000001f;
    if cntchan>=2 then zag.mG:=(ST2(pf1)-1) shl 8;
    if cntchan>=3 then begin
        zag.mB:=zag.mR;
        zag.mR:=(ST2(pf2)-1) shl 16;
    end;
    if cntchan>=4 then zag.mA:=(ST2(pf3)-1) shl 24;
    zag.format:=6;
    zag.countUnit:=1;
    zag.countUpdateRect:=0;
    zag.smeUpdateRect:=0;

    buf:=PAdd(buf,sizeof(SGIZag));

    if ((rc.Right-rc.Left)<1) or ((rc.Bottom-rc.Top)<1) then begin
        zag.countUnit:=0;
        Result:=sizeof(SGIZag);
        Exit;
    end;

    zagunit:=buf;
    zagunit.rect:=rc;

    buf:=PAdd(buf,sizeof(SGIUnit));

    zagunit.sme:=DWORD(buf)-DWORD(zag);

    startbufdata:=buf;

    PSet(buf,WORD(pf0 or (pf1 shl 4) or (pf2 shl 8) or (pf2 shl 12))); buf:=PAdd(buf,2);

//    GBuf1.Clear;
//    GBuf2.Clear;
    for t:=0 to 7 do s_CountPixel[t]:=0;
    for t:=0 to 7 do s_CountPixelZ[t]:=0;

    smex:=rc.Left;
    smey:=rc.Top;

    cntcol:=ceil((rc.Right-rc.Left)/blocksizeX);
    cntrow:=ceil((rc.Bottom-rc.Top)/blocksizeY);
    SetLength(brs,cntcol*cntrow);
    brscnt:=0;
    for row:=0 to cntrow-1 do begin
        for col:=0 to cntcol-1 do begin
            with brs[brscnt] do begin
                Left:=col*blocksizeX+smex;
                Top:=row*blocksizeY+smey;
                Right:=min((col+1)*blocksizeX,rc.Right-rc.Left)+smex;
                Bottom:=min((row+1)*blocksizeY,rc.Bottom-rc.Top)+smey;

            end;
            brs[brscnt]:=Form_BuildGAIExAnim.FindRectEx(desadd,dessub,brs[brscnt]);
            if brs[brscnt].Left<>brs[brscnt].Right then begin
//Form_BuildGAIExAnim.MemoText.Lines.Add(Format(' BS=%d,%d',[brs[brscnt].Right-brs[brscnt].Left,brs[brscnt].Bottom-brs[brscnt].Top]));
                inc(brscnt);
            end;
        end;
    end;

{    c:=0;
    for i:=0 to brscnt-1 do begin
        if (brs[i].Right-brs[i].Left)<1 then continue;
        for t:=i+1 to brscnt-1 do begin
            if (brs[t].Right-brs[t].Left)<1 then continue;

            if (brs[i].Right=brs[t].Left) and
               (brs[i].Top=brs[t].Top) and
               (brs[i].Bottom=brs[t].Bottom) then
            begin
                brs[i].Right:=brs[t].Right;
                brs[t]:=Rect(0,0,0,0);
                inc(c);
            end;
        end;
    end;}

    PSet(buf,WORD(brscnt{-c})); buf:=PAdd(buf,2);
    bufbit:=0;

//    desadd_a:=TGraphBuf.Create; desadd_a.Load(desadd);
//    dessub_a:=TGraphBuf.Create; dessub_a.Load(dessub);

    for i:=0 to brscnt-1 do begin
        if (brs[i].Right-brs[i].Left)<1 then continue;
//SFT('Block start');
        CBuildAddBitF6(buf,bufbit,brs[i].Left-smex,10);
        CBuildAddBitF6(buf,bufbit,brs[i].Top-smey,10);

{        for t:=0 to 7 do s_CountPixel[t]:=0;

        for y:=brs[i].Top to brs[i].Bottom-1 do begin
            for c:=0 to cntchan-1 do begin
                CBuildChannelF6(desadd_a,dessub_a,buf,bufbit,brs[i].Left,brs[i].Right,y,c,true);
            end;
        end;

        imin1:=-1; zmin1:=1000000;
        imin2:=-1; zmin2:=1000000;
        for t:=2 to 7 do begin
            if s_CountPixel[t]=0 then continue;
            if zmin1>s_CountPixel[t] then begin zmin1:=s_CountPixel[t]; imin1:=t; end;
        end;
        if imin1<0 then begin
            CBuildAddBitF6(buf,bufbit,0,3);
            CBuildAddBitF6(buf,bufbit,0,3);
            s_CountPixel[2]:=0;
            s_CountPixel[3]:=0;
        end else begin
            for t:=2 to 7 do begin
                if (t=imin1) or (s_CountPixel[t]=0) then continue;
                if zmin2>s_CountPixel[t] then begin zmin2:=s_CountPixel[t]; imin2:=t; end;
            end;
            if imin2<0 then begin
                CBuildAddBitF6(buf,bufbit,imin1,3);
                s_CountPixel[2]:=imin1;
                CBuildAddBitF6(buf,bufbit,0,3);
                s_CountPixel[3]:=0;
            end else begin
                CBuildAddBitF6(buf,bufbit,min(imin1,imin2),3);
                CBuildAddBitF6(buf,bufbit,max(imin1,imin2),3);
                s_CountPixel[2]:=min(imin1,imin2);
                s_CountPixel[3]:=max(imin1,imin2);
            end;
        end;}

        for y:=brs[i].Top to brs[i].Bottom-1 do begin
                for c:=0 to cntchan-1 do begin
                    CBuildChannelF6(desadd,dessub,desimg,buf,bufbit,brs[i].Left,brs[i].Right,y,c,false);
                end;
                CBuildZeroF6(desadd,dessub,desadd2,dessub2,desimg2,desimg,buf,bufbit,brs[i].Left,brs[i].Right,y);
                if y<(brs[i].Bottom-1) then begin // end row
                    CBuildAddBitF6(buf,bufbit,0,3);
                    CBuildAddBitF6(buf,bufbit,0,2);
                end else begin // end block
                    CBuildAddBitF6(buf,bufbit,0,3);
                    CBuildAddBitF6(buf,bufbit,1,2);
                end;
        end;
//Form_BuildGAIExAnim.MemoText.Lines.Add(IntToStr(DWORD(buf)-DWORD(zag)));
    end;

//    desadd_a.Free;
//    dessub_a.Free;

    if bufbit<>0 then buf:=PAdd(buf,1);

    zagunit.size:=DWORD(buf)-DWORD(startbufdata);

    brs:=nil;

    Result:=DWORD(buf)-DWORD(zag);
end;

procedure TForm_BuildGAIExAnim.FormShow(Sender: TObject);
begin
    OpenDialogFile.InitialDir:=RegUser_GetString('','BuildGAIExAnimPath',GetCurrentDir);

    ComboBoxChannels.ItemIndex:=1;
    ComboBoxFilter.ItemIndex:=5;
    ComboBoxFormat.ItemIndex:=1;
end;

procedure TForm_BuildGAIExAnim.ButtonLoadClick(Sender: TObject);
var
    i,u:integer;
begin
    if not OpenDialogFile.Execute then Exit;

    RegUser_SetString('','BuildGAIExAnimPath',File_Path(OpenDialogFile.FileName));

    for i:=0 to OpenDialogFile.Files.Count-1 do begin
        for u:=0 to i do begin
            if CompareStr(OpenDialogFile.Files.Strings[i],OpenDialogFile.Files.Strings[u])<0 then begin
                OpenDialogFile.Files.Exchange(i,u);
            end;
        end;
    end;

    ListBoxFiles.Items.Clear;
    for i:=0 to OpenDialogFile.Files.Count-1 do begin
        ListBoxFiles.Items.Add(OpenDialogFile.Files.Strings[i]);
    end;

    EditFrame.Text:='[50,0-'+IntToStr(OpenDialogFile.Files.Count-1)+']';
end;

procedure TForm_BuildGAIExAnim.ButtonBuildClick(Sender: TObject);
var
    sg:TStringGrid;
    i,u,x,y,ibufsize,size,size2,size3,cntchan,scalex,scaley,tpos:integer;
    gbe,gbe2,sou,badd,bsub,badd2,bsub2,tbuf:TGraphBuf;
    ibuf,ibuf2,ibuf3:Pointer;
    fi:TFileEC;
    tr:TRect;
    zag:SGAIZag;
    bd:TBufEC;
    pf:array[0..3] of integer;

    procedure SwapBuf(var b1:TGraphBuf; var b2:TGraphBuf);
    var
        bt:TGraphBuf;
    begin
        bt:=b1; b1:=b2; b2:=bt;
    end;
    function tttDiv(zn1:integer; zn2:integer):single;
    begin
        if zn2=0 then begin Result:=0; Exit; end;
        Result:=zn1/zn2;
    end;
begin
    MemoText.Lines.Clear;

    if GetCountParEC(EditPF.Text,',')<>4 then Exit;
    pf[0]:=StrToIntEC(GetStrParEC(EditPF.Text,0,','));
    pf[1]:=StrToIntEC(GetStrParEC(EditPF.Text,1,','));
    pf[2]:=StrToIntEC(GetStrParEC(EditPF.Text,2,','));
    pf[3]:=StrToIntEC(GetStrParEC(EditPF.Text,3,','));

    cntchan:=StrToIntEC(ComboBoxChannels.Text);
    if (cntchan<>1) and (cntchan<>3) and (cntchan<>4) then Exit;

    if GetCountParEC(EditScale.Text,',')<>2 then Exit;
    scalex:=StrToIntEC(GetStrParEC(EditScale.Text,0,','));
    scaley:=StrToIntEC(GetStrParEC(EditScale.Text,1,','));
    if (scalex<1) or (scaley<1) then Exit;

    if ListBoxFiles.Items.Count<2 then Exit;

    Screen.Cursor:=crHourglass;

    bd:=TBufEC.Create;
    tbuf:=TGraphBuf.Create;
    gbe:=TGraphBuf.Create;
    gbe2:=TGraphBuf.Create;
    sou:=TGraphBuf.Create;
    badd:=TGraphBuf.Create;
    bsub:=TGraphBuf.Create;
    badd2:=TGraphBuf.Create;
    bsub2:=TGraphBuf.Create;
//    GBuf1:=TBufEC.Create;
//    GBuf2:=TBufEC.Create;

    fi:=TFileEC.Create;
    fi.Init(FilenameEditDesGAI.Text);
    fi.CreateNew;

    ZeroMemory(@zag,sizeof(SGAIZag));
    zag.id0:=Ord('g');
    zag.id1:=Ord('a');
    zag.id2:=Ord('i');
    zag.ver:=1;
    zag.count:=ListBoxFiles.Items.Count;
    zag.series:=1;
    fi.Write(@zag,sizeof(SGAIZag));

    bd.Len:=zag.count*8;
    ZeroMemory(bd.Buf,bd.Len);
    fi.Write(bd.Buf,bd.Len);

    sg:=TStringGrid.Create(self);
    sg.RowCount:=1;
    sg.ColCount:=2;
    sg.Cells[0,0]:='';
    sg.Cells[1,0]:=EditFrame.Text;

    Form_SaveGAI.BuildAnim(sg,bd);
    if bd.Len>0 then begin
        zag.smeAnim:=fi.GetPointer;
        zag.sizeAnim:=bd.Len;
        fi.Write(bd.Buf,bd.Len);
    end;

    sg.Free;

    gbe.LoadRGBA(ListBoxFiles.Items.Strings[0]);
    gbe.SwapChannels(0,2);
    if cntchan=3 then gbe.FillRectChannel(3,Rect(0,0,gbe.FLenX,gbe.FLenY),0);
    if cntchan=4 then ClearIfAlpha0(gbe);
    if (gbe.FLenX<>scalex) or (gbe.FLenY<>scaley) then begin
        tbuf.ImageCreate(scalex,scaley,gbe.FChannels);
        OKGF_Rescale(tbuf.FBuf,tbuf.FLenX,tbuf.FLenY,tbuf.FLenLine,
                     gbe.FBuf,gbe.FLenX,gbe.FLenY,gbe.FLenLine,
                     gbe.FChannels,ComboBoxFilter.ItemIndex);
        SwapBuf(gbe,tbuf);
    end;
    if (cntchan=4) and (CheckBoxSubBlackColor.Checked) then begin
        tbuf.ImageCreate(gbe.FLenX,gbe.FLenY,gbe.FChannels);
        Form_CorrectImageByAlpha.Build(gbe,tbuf,1,'0,0,0','0,0,0');
        SwapBuf(gbe,tbuf);
    end;
    if CheckBoxDithering.Checked then begin
        tbuf.ImageCreate(gbe.FLenX,gbe.FLenY,gbe.FChannels);
        ODithering16bit(gbe,tbuf);
        SwapBuf(gbe,tbuf);
    end;
    for u:=0 to gbe.FChannels-1 do gbe.ShrRectChannel(u,RECT(0,0,gbe.FLenX,gbe.FLenY),8-pf[u]);
    gbe2.Load(gbe);
    for u:=0 to gbe2.FChannels-1 do gbe2.ShlRectChannel(u,RECT(0,0,gbe2.FLenX,gbe2.FLenY),8-pf[u]);

    zag.Rect:=FindRectChan(gbe,cntchan);

    ibufsize:=gbe.FLenX*gbe.FLenY*gbe.FChannels*2;
    ibuf:=AllocEC(ibufsize);
    ibuf2:=AllocEC(ibufsize);

    try
        for i:=1 to ListBoxFiles.Items.Count-1 do begin

            MemoText.Lines.Add(ListBoxFiles.Items.Strings[i]);

            sou.LoadRGBA(ListBoxFiles.Items.Strings[i]);
            sou.SwapChannels(0,2);
            if cntchan=3 then sou.FillRectChannel(3,Rect(0,0,sou.FLenX,sou.FLenY),0);
            if cntchan=4 then ClearIfAlpha0(sou);
            if (sou.FLenX<>scalex) or (sou.FLenY<>scaley) then begin
                tbuf.ImageCreate(scalex,scaley,sou.FChannels);
                OKGF_Rescale(tbuf.FBuf,tbuf.FLenX,tbuf.FLenY,tbuf.FLenLine,
                             sou.FBuf,sou.FLenX,sou.FLenY,sou.FLenLine,
                             sou.FChannels,ComboBoxFilter.ItemIndex);
                SwapBuf(sou,tbuf);
            end;
            if (cntchan=4) and (CheckBoxSubBlackColor.Checked) then begin
                tbuf.ImageCreate(sou.FLenX,sou.FLenY,sou.FChannels);
                Form_CorrectImageByAlpha.Build(sou,tbuf,1,'0,0,0','0,0,0');
                SwapBuf(sou,tbuf);
            end;
            if CheckBoxDithering.Checked then begin
                tbuf.ImageCreate(sou.FLenX,sou.FLenY,sou.FChannels);
                ODithering16bit(sou,tbuf);
                SwapBuf(sou,tbuf);
            end;
            for u:=0 to sou.FChannels-1 do sou.ShrRectChannel(u,RECT(0,0,sou.FLenX,sou.FLenY),8-pf[u]);

            BuildDifferent(gbe,sou,badd,bsub,cntchan,StrToIntEC(EditRadius.Text));

{tbuf.ImageCreate(badd.FLenX,badd.FLenY,badd.FChannels);
tbuf.FillZero;
for y:=0 to badd.FLenY-1 do begin
    for x:=0 to badd.FLenX-1 do begin
        if (PGetDWORD(badd.PixelBuf(x,y))<>0) or (PGetDWORD(bsub.PixelBuf(x,y))<>0) then begin
            PSet(tbuf.PixelBuf(x,y),DWORD($ffffffff));
        end;
    end;
end;
tbuf.WritePNG('c:\######'+IntToStr(i)+'.png');}

            tr:=FindRect(badd,bsub);
            if ((zag.Rect.Right-zag.Rect.Left)<1) or ((zag.Rect.Bottom-zag.Rect.Top)<1) then begin
                zag.Rect:=tr;
            end else begin
                UnionRect(zag.Rect,zag.Rect,tr);
            end;

//            ShowStat(badd,bsub,cntchan);

            if ComboBoxFormat.ItemIndex=1 then begin
                badd2.Load(badd);
                bsub2.Load(bsub);
                size:=CBuildF6(badd2,bsub2,badd,bsub,gbe,sou,cntchan,tr,ibuf,ibufsize,pf[0],pf[1],pf[2],pf[3]);
            end else begin
                size:=CBuildF5(badd,bsub,cntchan,tr,ibuf,ibufsize,pf[0],pf[1],pf[2],pf[3]);
                MemoText.Lines.Add(Format('     ISize=%d    PixelCount=(%d)(%d)(%d)(%d) PixelStat=(%f)(%f)(%f)(%f)',
                                   [size,
                                   s_CountPixel[0]+s_CountPixel[4],
                                   s_CountPixel[1]+s_CountPixel[5],
                                   s_CountPixel[2]+s_CountPixel[6],
                                   s_CountPixel[3]+s_CountPixel[7],
                                   tttDiv(s_CountPixel[0]+s_CountPixel[4],s_CountPixelZ[0]+s_CountPixelZ[4]),
                                   tttDiv(s_CountPixel[1]+s_CountPixel[5],s_CountPixelZ[1]+s_CountPixelZ[5]),
                                   tttDiv(s_CountPixel[2]+s_CountPixel[6],s_CountPixelZ[2]+s_CountPixelZ[6]),
                                   tttDiv(s_CountPixel[3]+s_CountPixel[7],s_CountPixelZ[3]+s_CountPixelZ[7])
                                   ]));
            end;

//            MemoText.Lines.Add(Format('     GBuf1=%d GBuf2=%d',[GBuf1.Len,GBuf2.Len]));
//            GBuf1.Compress; GBuf2.Compress;
//            MemoText.Lines.Add(Format('     GBuf1=%d GBuf2=%d',[GBuf1.Len,GBuf2.Len]));

            size2:=0;
            if CheckBoxCompress.Checked then begin
                size2:=OKGF_ZLib_Compress(ibuf2, ibuf,size,0);
                if size2<>0 then begin
                    ibuf3:=ibuf; ibuf:=ibuf2; ibuf2:=ibuf3;
                    size3:=size; size:=size2; size2:=size3;
                end;
            end;

            tpos:=fi.GetPointer;
            fi.SetPointer(sizeof(SGAIZag)+i*8);
            fi.Write(@tpos,4);
            fi.Write(@size,4);
            fi.SetPointer(tpos);
            fi.Write(ibuf,size);

            MemoText.Lines.Add(Format('     ISize=%d ISizeN=%d',[size,size2]));

            BuildAdd(gbe,gbe,badd,bsub,cntchan);

{for u:=0 to gbe.FChannels-1 do gbe.ShlRectChannel(u,RECT(0,0,gbe.FLenX,gbe.FLenY),8-pf[u]);
if i<10 then gbe.WritePNG('c:\02\00'+IntToStr(i)+'.png')
else if i<100 then gbe.WritePNG('c:\02\0'+IntToStr(i)+'.png')
else gbe.WritePNG('c:\02\'+IntToStr(i)+'.png');
for u:=0 to gbe.FChannels-1 do gbe.ShrRectChannel(u,RECT(0,0,gbe.FLenX,gbe.FLenY),8-pf[u]);}
        end;

        MemoText.Lines.Add(Format('Pos=%d,%d Size=%d,%d',[zag.Rect.Left,zag.Rect.Top,zag.Rect.Right-zag.Rect.Left,zag.Rect.Bottom-zag.Rect.Top]));

        OCutOffRect(gbe2,gbe,zag.Rect);
        bd.Clear;
        gbe.SwapChannels(0,2);
        if cntchan=4 then gbe.BuildGI_Bitmap(bd,2)
        else gbe.BuildGI_Bitmap(bd,2);
        gbe.SwapChannels(0,2);
        bd.SaveInFile(PChar(AnsiString(FilenameEditDesGI.Text)));

        fi.SetPointer(0);
        fi.Write(@zag,sizeof(SGAIZag));
    except
        on ex:Exception do begin
            ShowMessage(ex.message);
        end;
    end;

//    GBuf1.Free;
//    GBuf2.Free;
    bd.Free;
    FreeEC(ibuf2);
    FreeEC(ibuf);
    tbuf.Free;
    badd.Free;
    bsub.Free;
    badd2.Free;
    bsub2.Free;
    gbe.Free;
    gbe2.Free;
    sou.Free;
    fi.Free;

    Screen.Cursor:=crDefault;
end;

procedure TForm_BuildGAIExAnim.BuildDifferent(sou1,sou2,desadd,dessub:TGraphBuf; cntchan:integer; errcnt:BYTE);
var
    lenx,leny:integer;
    x,y,c:integer;
    p1,p2:BYTE;
begin
    if (sou1.FLenX<>sou2.FLenX) or (sou1.FLenY<>sou2.FLenY) or (sou1.FChannels<cntchan) or (sou2.FChannels<cntchan) then raise Exception.Create('TForm_BuildGAIExAnim.BuildDifferent.');

    desadd.ImageCreate(sou1.FLenX,sou1.FLenY,sou1.FChannels);
    dessub.ImageCreate(sou1.FLenX,sou1.FLenY,sou1.FChannels);

    lenx:=sou1.FLenX;
    leny:=sou1.FLenY;

    desadd.FillZero;
    dessub.FillZero;

    for y:=0 to leny-1 do begin
        for x:=0 to lenx-1 do begin
            for c:=0 to cntchan-1 do begin
                p1:=sou1.PixelChannel(x,y,c);
                p2:=sou2.PixelChannel(x,y,c);

                if (p2>p1) and (((p2-p1)>errcnt) {or (((p2-p1)=errcnt)) and (Random(2)=0)}) then begin
                    desadd.SetPixelChannel(x,y,c,p2-p1);
                end else if (p2<p1) and (((p1-p2)>errcnt) {or (((p2-p1)=errcnt)) and (Random(2)=0)}) then begin
                    dessub.SetPixelChannel(x,y,c,p1-p2);
                end;

            end;
        end;
    end;
end;

procedure TForm_BuildGAIExAnim.BuildAdd(des,sou,bufadd,bufsub:TGraphBuf; cntchan:integer);
var
    x,y,c:integer;
    p:BYTE;
begin
    for y:=0 to sou.FLenY-1 do begin
        for x:=0 to sou.FLenX-1 do begin
            for c:=0 to cntchan-1 do begin
                p:=sou.PixelChannel(x,y,c)+bufadd.PixelChannel(x,y,c)-bufsub.PixelChannel(x,y,c);
                des.SetPixelChannel(x,y,c,p);
            end;
        end;
    end;
end;

procedure TForm_BuildGAIExAnim.ShowStat(bufadd,bufsub:TGraphBuf; cntchan:integer);
var
    x,y,c:integer;
    padd,psub:BYTE;

    s_cntsub,s_cntadd:integer;
    s_1a,s_2a,s_4a,s_8a,s_1s,s_2s,s_4s,s_8s:integer;
begin
    for c:=0 to cntchan-1 do begin
        s_cntadd:=0; s_cntsub:=0;

        s_1a:=0; s_2a:=0; s_4a:=0; s_8a:=0;
        s_1s:=0; s_2s:=0; s_4s:=0; s_8s:=0;

        for y:=0 to bufadd.FLenY-1 do begin
            for x:=0 to bufadd.FLenX-1 do begin
                padd:=bufadd.PixelChannel(x,y,c);
                psub:=bufsub.PixelChannel(x,y,c);

                if padd<>0 then inc(s_cntadd);
                if psub<>0 then inc(s_cntsub);

                if padd=0 then
                else if padd<=2 then inc(s_8a)
                else if padd<=4 then inc(s_4a)
                else if padd<=16 then inc(s_2a)
                else inc(s_1a);

                if psub=0 then
                else if psub<=2 then inc(s_8s)
                else if psub<=4 then inc(s_4s)
                else if psub<=16 then inc(s_2s)
                else inc(s_1s);
            end;
        end;
        MemoText.Lines.Add(Format('     Cnanel=%d CntSub=%d CntAdd=%d (%d,%d,%d,%d)(%d,%d,%d,%d)',[c,s_cntsub,s_cntadd,s_1a,s_2a,s_4a,s_8a,s_1s,s_2s,s_4s,s_8s]));
    end;
end;

function TForm_BuildGAIExAnim.FindRect(gb1,gb2:TGraphBuf):TRect;
var
    tr1,tr2:TRect;
begin
    tr1:=FindRect(gb1);
    tr2:=FindRect(gb2);
    UnionRect(Result,tr1,tr2);
end;

function TForm_BuildGAIExAnim.FindRect(gb:TGraphBuf):TRect;
var
    rc:TRect;
    i:integer;
begin
    Result:=FindRect(gb,0);
    for i:=1 to gb.FChannels-1 do begin
        rc:=FindRect(gb,i);
        UnionRect(Result,Result,rc);
    end;
end;

function TForm_BuildGAIExAnim.FindRectChan(gb:TGraphBuf; cntchan:integer):TRect;
var
    rc:TRect;
    i:integer;
begin
    Result:=FindRect(gb,0);
    for i:=1 to cntchan-1 do begin
        rc:=FindRect(gb,i);
        UnionRect(Result,Result,rc);
    end;
end;

function TForm_BuildGAIExAnim.FindRect(gb:TGraphBuf; channel:integer):TRect;
var
    x,y:integer;
begin
    if (gb.FLenX<2) or (gb.FLenY<2) then raise Exception.Create('Error: size');
//    if (gb.FChannels<4) then raise Exception.Create('Error: channels');

	// Top
    y:=0;
    while y<gb.FLenY do begin
        x:=0;
        while x<gb.FLenX do begin if gb.PixelChannel(x,y,channel)>0 then break; inc(x); end;
        if x<gb.FLenX then break;
        inc(y);
	end;
	if y>=gb.FLenY then begin
		Result.Left:=0; Result.Top:=0;
		Result.Right:=0; Result.Bottom:=0;
		Exit;
	end;
	Result.Top:=y;

    y:=gb.FLenY-1;
    while y>=0 do begin
        x:=0;
        while x<gb.FLenX do begin if gb.PixelChannel(x,y,channel)>0 then break; inc(x); end;
        if x<gb.FLenX then break;
        dec(y);
	end;
	Result.Bottom:=y+1;

    x:=0;
    while x<gb.FLenX do begin
        y:=0;
        while y<gb.FLenY do begin if gb.PixelChannel(x,y,channel)>0 then break; inc(y); end;
        if y<gb.FLenY then break;
        inc(x);
	end;
	Result.Left:=x;

    x:=gb.FLenX-1;
    while x>=0 do begin
        y:=0;
        while y<gb.FLenY do begin if gb.PixelChannel(x,y,channel)>0 then break; inc(y); end;
        if y<gb.FLenY then break;
        dec(x);
	end;
	Result.Right:=x+1;
end;

function TForm_BuildGAIExAnim.FindRectEx(gb1,gb2:TGraphBuf; tr:TRect):TRect;
var
    tr1,tr2:TRect;
begin
    tr1:=FindRectEx(gb1,tr);
    tr2:=FindRectEx(gb2,tr);
    UnionRect(Result,tr1,tr2);
end;

function TForm_BuildGAIExAnim.FindRectEx(gb:TGraphBuf; tr:TRect):TRect;
var
    rc:TRect;
    i:integer;
begin

    if gb.FChannels=4 then begin
        Result:=FindRectExDWORD(gb,tr);
    end else begin
        Result:=FindRect(gb,0);
        for i:=1 to gb.FChannels-1 do begin
            rc:=FindRectEx(gb,i,tr);
            UnionRect(Result,Result,rc);
        end;
    end;
end;

function TForm_BuildGAIExAnim.FindRectEx(gb:TGraphBuf; channel:integer; tr:TRect):TRect;
var
    x,y:integer;
begin
    if (gb.FLenX<2) or (gb.FLenY<2) then raise Exception.Create('Error: size');
//    if (gb.FChannels<4) then raise Exception.Create('Error: channels');

    Result:=tr;

	// Top
    y:=Result.Top;
    while y<Result.Bottom do begin
        x:=Result.Left;
        while x<Result.Right do begin if gb.PixelChannel(x,y,channel)>0 then break; inc(x); end;
        if x<Result.Right then break;
        inc(y);
	end;
	if y>=Result.Bottom then begin
		Result.Left:=0; Result.Top:=0;
		Result.Right:=0; Result.Bottom:=0;
		Exit;
	end;
	Result.Top:=y;

    // Bottom
    y:=Result.Bottom-1;
    while y>=Result.Top do begin
        x:=Result.Left;
        while x<Result.Right do begin if gb.PixelChannel(x,y,channel)>0 then break; inc(x); end;
        if x<Result.Right then break;
        dec(y);
	end;
	Result.Bottom:=y+1;

    x:=Result.Left;
    while x<Result.Right do begin
        y:=Result.Top;
        while y<Result.Bottom do begin if gb.PixelChannel(x,y,channel)>0 then break; inc(y); end;
        if y<Result.Bottom then break;
        inc(x);
	end;
	Result.Left:=x;

    x:=Result.Right-1;
    while x>=Result.Left do begin
        y:=Result.Top;
        while y<Result.Bottom do begin if gb.PixelChannel(x,y,channel)>0 then break; inc(y); end;
        if y<Result.Bottom then break;
        dec(x);
	end;
	Result.Right:=x+1;
end;

function TForm_BuildGAIExAnim.FindRectExDWORD(gb:TGraphBuf; tr:TRect):TRect;
var
    x,y:integer;
begin
    if (gb.FLenX<2) or (gb.FLenY<2) then raise Exception.Create('Error: size');
//    if (gb.FChannels<4) then raise Exception.Create('Error: channels');

    Result:=tr;

	// Top
    y:=Result.Top;
    while y<Result.Bottom do begin
        x:=Result.Left;
        while x<Result.Right do begin if PGetDWORD(gb.PixelBuf(x,y))>0 then break; inc(x); end;
        if x<Result.Right then break;
        inc(y);
	end;
	if y>=Result.Bottom then begin
		Result.Left:=0; Result.Top:=0;
		Result.Right:=0; Result.Bottom:=0;
		Exit;
	end;
	Result.Top:=y;

    // Bottom
    y:=Result.Bottom-1;
    while y>=Result.Top do begin
        x:=Result.Left;
        while x<Result.Right do begin if PGetDWORD(gb.PixelBuf(x,y))>0 then break; inc(x); end;
        if x<Result.Right then break;
        dec(y);
	end;
	Result.Bottom:=y+1;

    x:=Result.Left;
    while x<Result.Right do begin
        y:=Result.Top;
        while y<Result.Bottom do begin if PGetDWORD(gb.PixelBuf(x,y))>0 then break; inc(y); end;
        if y<Result.Bottom then break;
        inc(x);
	end;
	Result.Left:=x;

    x:=Result.Right-1;
    while x>=Result.Left do begin
        y:=Result.Top;
        while y<Result.Bottom do begin if PGetDWORD(gb.PixelBuf(x,y))>0 then break; inc(y); end;
        if y<Result.Bottom then break;
        dec(x);
	end;
	Result.Right:=x+1;
end;

procedure TForm_BuildGAIExAnim.ClearIfAlpha0(gb:TGraphBuf);
var
    x,y:integer;
begin
    if gb.FChannels<4 then Exit;

    for y:=0 to gb.FLenY-1 do begin
        for x:=0 to gb.FLenX-1 do begin
            if gb.PixelChannel(x,y,3)=0 then begin
                PSet(gb.PixelBuf(x,y),DWORD(0));
            end;
        end;
    end;
end;

procedure TForm_BuildGAIExAnim.ButtonDropClick(Sender: TObject);
var
    step,i:integer;
begin
    step:=StrToIntEC(EditDrop.Text);
    i:=0;
    while i<ListBoxFiles.Items.Count do begin
        dec(step);
        if step<1 then begin
            ListBoxFiles.Items.Delete(i);
            step:=StrToIntEC(EditDrop.Text);
        end else inc(i);
    end;
end;

end.
