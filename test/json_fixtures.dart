// JSON produced by the original (pre-quality-pass) implementation of
// responsive_property 0.0.8. The tests check that the current
// implementation still produces and reads exactly these strings, so data
// stored by older versions stays compatible.

const String scopeDefaultJson =
    r'{"minWidth":0.0,"maxWidth":999999.0,"minHeight":0.0,"maxHeight":999999.0}';

const String scopeFullJson =
    r'{"minWidth":100.0,"maxWidth":200.5,"minHeight":300.0,"maxHeight":400.0,"orientation":"landscape"}';

const String intMobileTabletDesktopJson =
    r'{"{\"minWidth\":0.0,\"maxWidth\":480.0,\"minHeight\":0.0,\"maxHeight\":999999.0}":2,"{\"minWidth\":480.0,\"maxWidth\":840.0,\"minHeight\":0.0,\"maxHeight\":999999.0}":4,"{\"minWidth\":840.0,\"maxWidth\":999999.0,\"minHeight\":0.0,\"maxHeight\":999999.0}":6}';

const String doubleSmallBigJson =
    r'{"{\"minWidth\":0.0,\"maxWidth\":600.0,\"minHeight\":0.0,\"maxHeight\":999999.0}":1.5,"{\"minWidth\":600.0,\"maxWidth\":999999.0,\"minHeight\":0.0,\"maxHeight\":999999.0}":3.0}';

const String stringOrientationJson =
    r'{"{\"minWidth\":0.0,\"maxWidth\":480.0,\"minHeight\":0.0,\"maxHeight\":999999.0,\"orientation\":\"portrait\"}":"mp","{\"minWidth\":480.0,\"maxWidth\":840.0,\"minHeight\":0.0,\"maxHeight\":999999.0,\"orientation\":\"portrait\"}":"tp","{\"minWidth\":840.0,\"maxWidth\":999999.0,\"minHeight\":0.0,\"maxHeight\":999999.0,\"orientation\":\"portrait\"}":"dp","{\"minWidth\":0.0,\"maxWidth\":840.0,\"minHeight\":0.0,\"maxHeight\":999999.0,\"orientation\":\"landscape\"}":"ml","{\"minWidth\":840.0,\"maxWidth\":1200.0,\"minHeight\":0.0,\"maxHeight\":999999.0,\"orientation\":\"landscape\"}":"tl","{\"minWidth\":1200.0,\"maxWidth\":999999.0,\"minHeight\":0.0,\"maxHeight\":999999.0,\"orientation\":\"landscape\"}":"dl"}';

const String boolHeightJson =
    r'{"{\"minWidth\":0.0,\"maxWidth\":999999.0,\"minHeight\":0.0,\"maxHeight\":500.0}":true,"{\"minWidth\":0.0,\"maxWidth\":999999.0,\"minHeight\":500.0,\"maxHeight\":999999.0,\"orientation\":\"portrait\"}":false}';

const String colorEncodedJson =
    r'{"{\"minWidth\":0.0,\"maxWidth\":1000.0,\"minHeight\":0.0,\"maxHeight\":999999.0,\"orientation\":\"landscape\"}":"ff2196f3","{\"minWidth\":1000.0,\"maxWidth\":999999.0,\"minHeight\":0.0,\"maxHeight\":999999.0,\"orientation\":\"landscape\"}":"80ff0000"}';

const String listMapJson =
    r'{"{\"minWidth\":0.0,\"maxWidth\":600.0,\"minHeight\":0.0,\"maxHeight\":999999.0,\"orientation\":\"portrait\"}":[1,2.5,"a"],"{\"minWidth\":600.0,\"maxWidth\":999999.0,\"minHeight\":0.0,\"maxHeight\":999999.0,\"orientation\":\"portrait\"}":{"k":null,"n":1}}';

const String axisEncodedJson =
    r'{"{\"minWidth\":0.0,\"maxWidth\":480.0,\"minHeight\":0.0,\"maxHeight\":999999.0}":"vertical","{\"minWidth\":840.0,\"maxWidth\":999999.0,\"minHeight\":0.0,\"maxHeight\":999999.0}":"horizontal"}';

const String edgeInsetsEncodedJson =
    r'{"{\"minWidth\":0.0,\"maxWidth\":480.0,\"minHeight\":0.0,\"maxHeight\":999999.0}":{"left":8.0,"right":8.0,"top":8.0,"bottom":8.0},"{\"minWidth\":840.0,\"maxWidth\":999999.0,\"minHeight\":0.0,\"maxHeight\":999999.0}":{"left":1.0,"right":3.0,"top":2.0,"bottom":4.0}}';
