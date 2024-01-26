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

@goto end

:clean
bash mk.sh clean
@goto end

:make
bash mk.sh all
@goto end

:rebuild
bash mk.sh clean 
bash mk.sh all
@goto end

:end
