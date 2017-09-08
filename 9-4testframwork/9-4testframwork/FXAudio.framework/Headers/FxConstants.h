//
// Created by Paint on 2017/6/8.
//

#ifndef KTVDEMO_FXCONSTANTS_H
#define KTVDEMO_FXCONSTANTS_H

const static int FX_TYPE_FILTER = 0;
const static int FX_TYPE_REVERB = 1;
const static int FX_TYPE_FLANGER = 2;
const static int FX_TYPE_3_BAND_EQ = 3;
const static int FX_TYPE_GATE = 4;
const static int FX_TYPE_ROLL = 5;
const static int FX_TYPE_ECHO = 6;
const static int FX_TYPE_WOOSH = 7;
const static int FX_TYPE_LIMITER = 8;
const static int FX_TYPE_CLIPPER = 9;


const static int FX_POSITION_BEFORE_MIXER = 0;
const static int FX_POSITION_AFTER_MIXER = 1;
const static int FX_POSITION_ON_ACCOMPANIMENT = 2;

const static int FX_VALUE_ID_WET = 0;
const static int FX_VALUE_ID_DRY = 1;
const static int FX_VALUE_ID_MIX = 2;
const static int FX_VALUE_ID_WIDTH = 3;
const static int FX_VALUE_ID_DAMP = 4;
const static int FX_VALUE_ID_ROOMSIZE = 5;
const static int FX_VALUE_ID_CEILING_DB = 6;     //Ceiling in decibels, limited between 0.0f and -40.0f. Default: 0.
const static int FX_VALUE_ID_THRESHOLD_DB = 7;   //Threshold in decibels, limited between 0.0f and -40.0f. Default: 0.
const static int FX_VALUE_ID_RELEASE_SEC = 8;    //Release in seconds (not milliseconds!). Limited between 0.1f and 1.6f. Default: 0.05f (50 ms).
const static int FX_VALUE_ID_BEATS = 9;
const static int FX_VALUE_ID_LOW_FREQ = 10;
const static int FX_VALUE_ID_MID_FREQ = 11;
const static int FX_VALUE_ID_HIGH_FREQ = 12;


#endif //KTVDEMO_FXCONSTANTS_H
