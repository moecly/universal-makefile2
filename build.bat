@if "%1"=="cl" (
    @goto clean
)

@if "%1"=="mk" (
    @goto make
)

@if "%1"=="" (
    @goto make
)

@if "%1"=="re" (
    @goto rebuild
)

:clean
bash ./build.sh clean
@goto end

:make
bash ./build.sh all
@goto end

:rebuild
bash ./build.sh clean 
bash ./build.sh all
@goto end

:end
