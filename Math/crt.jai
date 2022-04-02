sin   :: (angle : f64) -> f64 #must #foreign crt;
cos   :: (angle : f64) -> f64 #must #foreign crt;
tan   :: (angle : f64) -> f64 #must #foreign crt;
acos  :: (x : f64) -> f64 #must #foreign crt;
asin  :: (x : f64) -> f64 #must #foreign crt;
atan  :: (x : f64) -> f64 #must #foreign crt;
atan2 :: (y : f64, x : f64) -> f64 #must #foreign crt;
sqrt  :: (x : f64) -> f64 #must #foreign crt;
pow   :: (x : f64, power: f64) -> f64 #must #foreign crt;
exp   :: (x : f64) -> f64 #must #foreign crt;
fmod  :: (x : f64, divisor: f64) -> f64 #must #foreign crt;
log   :: (x : f64) -> f64 #must #foreign crt;

sin   :: (angle: f32) -> f32 #must #foreign crt "sinf";
cos   :: (angle: f32) -> f32 #must #foreign crt "cosf";
tan   :: (angle: f32) -> f32 #must #foreign crt "tanf";
acos  :: (x : f32) -> f32 #must #foreign crt "acosf";
asin  :: (x : f32) -> f32 #must #foreign crt "asinf";
atan  :: (x : f32) -> f32 #must #foreign crt "atanf";
atan2 :: (y : f32, x : f32) -> f32 #must #foreign crt "atan2f";
sqrt  :: (x : f32) -> f32 #must #foreign crt "sqrtf";
pow   :: (x : f32, power: f32) -> f32 #must #foreign crt "powf";
exp   :: (x : f32) -> f32 #must #foreign crt "expf";
fmod  :: (x : f32, divisor: f32) -> f32 #must #foreign crt "fmodf";   // x64 & arm only.
log   :: (x : f32) -> f32 #must #foreign crt "logf";

#scope_file

#if OS == .WINDOWS    then crt :: #foreign_system_library "msvcrt";
else #if OS == .LINUX then crt :: #foreign_system_library "libm";

#scope_export
