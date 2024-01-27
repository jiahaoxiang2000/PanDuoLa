CMAKE_MINIMUM_REQUIRED(VERSION 3.10)

SET(CMAKE_SYSTEM_NAME Generic)
SET(CMAKE_SYSTEM_PROCESSOR cortex-m4)
#SET(CMAKE_VERBOSE_MAKEFILE ON)

SET(CMAKE_EXPORT_COMPILE_COMMANDS ON)

SET(CMAKE_C_COMPILER "/usr/bin/arm-none-eabi-gcc")
SET(CMAKE_ASM_COMPILER "/usr/bin/arm-none-eabi-gcc")
SET(CMAKE_C_FLAGS " -mcpu=cortex-m4 -mthumb -mfpu=fpv4-sp-d16 -mfloat-abi=hard -ffunction-sections -fdata-sections -Dgcc -fstack-usage -fdump-rtl-dfinish -O0 -gdwarf-2 -g")
SET(CMAKE_ASM_FLAGS " -c -mcpu=cortex-m4 -mthumb -mfpu=fpv4-sp-d16 -mfloat-abi=hard -ffunction-sections -fdata-sections -x assembler-with-cpp -Wa,-mimplicit-it=thumb  -gdwarf-2")
SET(CMAKE_C_COMPILER_WORKS TRUE)

SET(CMAKE_CXX_COMPILER "/usr/bin/arm-none-eabi-g++")
SET(CMAKE_CXX_FLAGS " -mcpu=cortex-m4 -mthumb -mfpu=fpv4-sp-d16 -mfloat-abi=hard -ffunction-sections -fdata-sections -Dgcc -fstack-usage -fdump-rtl-dfinish -O0 -gdwarf-2 -g")
SET(CMAKE_CXX_COMPILER_WORKS TRUE)

SET(CMAKE_OBJCOPY "/usr/bin/arm-none-eabi-objcopy")
SET(CMAKE_SIZE "/usr/bin/arm-none-eabi-size")

SET(CMAKE_EXE_LINKER_FLAGS " -mcpu=cortex-m4 -mthumb -mfpu=fpv4-sp-d16 -mfloat-abi=hard -ffunction-sections -fdata-sections -Wl,--gc-sections,-Map=rt-thread.map,-cref,-u,Reset_Handler -T ${CMAKE_SOURCE_DIR}/board/linker_scripts/link.lds")

SET(CMAKE_CXX_STANDARD 14)
PROJECT(rtthread C CXX ASM)
INCLUDE_DIRECTORIES(
	applications
	rt-thread/components/libc/compilers/common/include
	rt-thread/components/libc/compilers/newlib
	rt-thread/libcpu/arm/common
	rt-thread/libcpu/arm/cortex-m4
	rt-thread/components/drivers/spi
	rt-thread/components/drivers/include
	board
	board/CubeMX_Config/Inc
	libraries/HAL_Drivers
	libraries/HAL_Drivers/config
	libraries/HAL_Drivers/CMSIS/Include
	board/ports/lcd
	rt-thread/components/finsh
	.
	rt-thread/include
	libraries/STM32L4xx_HAL/STM32L4xx_HAL_Driver/Inc
	libraries/STM32L4xx_HAL/CMSIS/Device/ST/STM32L4xx/Include
	rt-thread/components/libc/posix/ipc
	rt-thread/components/libc/posix/io/poll
	rt-thread/components/libc/posix/io/epoll
	rt-thread/components/libc/posix/io/eventfd
)

ADD_DEFINITIONS(
	-DRT_USING_LIBC
	-DRT_USING_NEWLIBC
	-DSTM32L475xx
	-DUSE_HAL_DRIVER
	-D_POSIX_C_SOURCE=1
	-D__RTTHREAD__
)

SET(PROJECT_SOURCES
	applications/star.c
	applications/main.c
	applications/nrf24l01_init.c
	rt-thread/components/libc/compilers/common/cctype.c
	rt-thread/components/libc/compilers/common/cstdlib.c
	rt-thread/components/libc/compilers/common/cstring.c
	rt-thread/components/libc/compilers/common/ctime.c
	rt-thread/components/libc/compilers/common/cunistd.c
	rt-thread/components/libc/compilers/common/cwchar.c
	rt-thread/components/libc/compilers/newlib/syscalls.c
	rt-thread/libcpu/arm/common/atomic_arm.c
	rt-thread/libcpu/arm/common/div0.c
	rt-thread/libcpu/arm/common/showmem.c
	rt-thread/libcpu/arm/cortex-m4/context_gcc.S
	rt-thread/libcpu/arm/cortex-m4/cpuport.c
	rt-thread/components/drivers/core/device.c
	rt-thread/components/drivers/ipc/completion.c
	rt-thread/components/drivers/ipc/dataqueue.c
	rt-thread/components/drivers/ipc/pipe.c
	rt-thread/components/drivers/ipc/ringblk_buf.c
	rt-thread/components/drivers/ipc/ringbuffer.c
	rt-thread/components/drivers/ipc/waitqueue.c
	rt-thread/components/drivers/ipc/workqueue.c
	rt-thread/components/drivers/misc/pin.c
	rt-thread/components/drivers/misc/rt_drv_pwm.c
	rt-thread/components/drivers/serial/serial.c
	rt-thread/components/drivers/spi/spi_core.c
	rt-thread/components/drivers/spi/spi_dev.c
	board/CubeMX_Config/Src/stm32l4xx_hal_msp.c
	board/board.c
	libraries/HAL_Drivers/drv_common.c
	libraries/HAL_Drivers/drv_gpio.c
	libraries/HAL_Drivers/drv_pwm.c
	libraries/HAL_Drivers/drv_spi.c
	libraries/HAL_Drivers/drv_tim.c
	libraries/HAL_Drivers/drv_usart.c
	libraries/STM32L4xx_HAL/CMSIS/Device/ST/STM32L4xx/Source/Templates/gcc/startup_stm32l475xx.s
	board/ports/lcd/demo/lcd_sample.c
	board/ports/lcd/drv_lcd.c
	rt-thread/components/finsh/msh.c
	rt-thread/components/finsh/shell.c
	rt-thread/components/finsh/cmd.c
	rt-thread/components/finsh/msh_parse.c
	rt-thread/src/clock.c
	rt-thread/src/components.c
	rt-thread/src/idle.c
	rt-thread/src/ipc.c
	rt-thread/src/irq.c
	rt-thread/src/kservice.c
	rt-thread/src/mem.c
	rt-thread/src/mempool.c
	rt-thread/src/object.c
	rt-thread/src/scheduler_up.c
	rt-thread/src/thread.c
	rt-thread/src/timer.c
	libraries/STM32L4xx_HAL/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_crc.c
	libraries/STM32L4xx_HAL/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_cryp_ex.c
	libraries/STM32L4xx_HAL/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_lptim.c
	libraries/STM32L4xx_HAL/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_qspi.c
	libraries/STM32L4xx_HAL/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_usart_ex.c
	libraries/STM32L4xx_HAL/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_cortex.c
	libraries/STM32L4xx_HAL/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_spi.c
	libraries/STM32L4xx_HAL/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal.c
	libraries/STM32L4xx_HAL/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_pwr_ex.c
	libraries/STM32L4xx_HAL/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_dma.c
	libraries/STM32L4xx_HAL/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_dma_ex.c
	libraries/STM32L4xx_HAL/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_gpio.c
	libraries/STM32L4xx_HAL/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_uart_ex.c
	libraries/STM32L4xx_HAL/CMSIS/Device/ST/STM32L4xx/Source/Templates/system_stm32l4xx.c
	libraries/STM32L4xx_HAL/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_exti.c
	libraries/STM32L4xx_HAL/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_comp.c
	libraries/STM32L4xx_HAL/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_rcc_ex.c
	libraries/STM32L4xx_HAL/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_usart.c
	libraries/STM32L4xx_HAL/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_crc_ex.c
	libraries/STM32L4xx_HAL/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_rcc.c
	libraries/STM32L4xx_HAL/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_uart.c
	libraries/STM32L4xx_HAL/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_spi_ex.c
	libraries/STM32L4xx_HAL/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_tim.c
	libraries/STM32L4xx_HAL/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_rng.c
	libraries/STM32L4xx_HAL/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_tim_ex.c
	libraries/STM32L4xx_HAL/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_cryp.c
	libraries/STM32L4xx_HAL/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_pwr.c
)

LINK_DIRECTORIES(
)

LINK_LIBRARIES(
	c
	m
)

ADD_EXECUTABLE(${CMAKE_PROJECT_NAME}.elf ${PROJECT_SOURCES})
ADD_CUSTOM_COMMAND(TARGET ${CMAKE_PROJECT_NAME}.elf POST_BUILD 
COMMAND ${CMAKE_OBJCOPY} -O binary ${CMAKE_PROJECT_NAME}.elf ${CMAKE_PROJECT_NAME}.bin COMMAND ${CMAKE_SIZE} ${CMAKE_PROJECT_NAME}.elf)