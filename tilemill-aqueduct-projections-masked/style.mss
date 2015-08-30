Map {
}

#mask {
  raster-opacity:1;
  [zoom<=4] { raster-scaling:lanczos; }
  [zoom>4] { raster-scaling:bilinear; }
  raster-colorizer-stops:
    stop(2,rgba(255,255,255,0))
    stop(10,rgba(255,255,255,.5))
    stop(50,rgba(255,255,255,.8))
    stop(255,rgba(255,255,255,1))
    ;
  comp-op: dst-in;
}

@d4:#ff1900;
@d3:#ff7351;
@d2:#f8ab95;
@mid:#ddd;
@i2:#abc7d9;
@i3:#73afd1;
@i4:#0099cc;

/*
#aqueductprojections2 {
  polygon-opacity:1;
  polygon-gamma:.2;
  polygon-fill: rgba(0,0,0,0);
  [bt4028cl="1.7x or greater decrease"] { polygon-fill:@d4; }
  [bt4028cl="1.4x decrease"] { polygon-fill:@d3;  }
  [bt4028cl="1.2x decrease"] { polygon-fill:@d2;  }
  [bt4028cl="Near normal"]   { polygon-fill:@mid; }
  [bt4028cl="1.2x increase"] { polygon-fill:@i2;  }
  [bt4028cl="1.4x increase"] { polygon-fill:@i3;  }
  [bt4028cl="1.7x or greater increase"] { polygon-fill:@i4; }
}

/*/
#aqueductprojections2 {
  polygon-opacity:1;
  polygon-gamma:.2;
  polygon-fill: rgba(0,0,0,0);
  [ws4028cl="2.8x or greater decrease"] { polygon-fill:@i4; }
  [ws4028cl="2x decrease"]   { polygon-fill:@i3;  }
  [ws4028cl="1.4x decrease"] { polygon-fill:@i2;  }
  [ws4028cl="Near normal"]   { polygon-fill:@mid; }
  [ws4028cl="1.4x increase"] { polygon-fill:@d2;  }
  [ws4028cl="2x increase"]   { polygon-fill:@d3;  }
  [ws4028cl="2.8x or greater increase"] { polygon-fill:@d4; }
}//*/
