# <center> Enhance App Robust </center>

## Enhance App Robust for macOS

    macOS下，增强APP稳定性的功能
    
## Brief
    
    1. ExceptionCatchManager，负责管理捕获异常
    2. BacktraceLogger，是一个开源的记录线程栈信息的功能
    3. SwizzledManager，负责类实例方法swizzle开启关闭管理
    4. Categories目录，所有类实例方法的swizzle都是通过category方式实现
    
    
    

## Usage

    1. 通过开启异常捕获与Swizzling，当APP发生异常时，尝试try-catch恢复APP，并且将异常捕获记录用于分析
    2. 在AppDelegate.m中执行异常捕获和类实例方法swizzling初始化，即可捕获异常和方法替换，同时将所有异常信息线程栈信息打印出来（当前并未添加上传异常信息代码）
        
        - (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
            // Insert code here to initialize your application
            [self initConfig];
        }

        #pragma mark - app init config
        -(void)initConfig{
    
            [self configExceptionCatch];
            [self configSizeeleMethodManager];
        }

        #pragma mark - config exception catch
        -(void)configExceptionCatch{
    
            [[ExceptionCatchManager sharedManager] initConfigExceptionCatch];
        }

        -(void)configSizeeleMethodManager{
    
            [[SwizzleMethodManager sharedManager] swizzlingInstanceMethod];
        }
     
## install
    
        