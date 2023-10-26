CMAKE_MINIMUM_REQUIRED(VERSION 3.10)

SET(CMAKE_SYSTEM_NAME Generic)
SET(CMAKE_SYSTEM_PROCESSOR cortex-m4)
#SET(CMAKE_VERBOSE_MAKEFILE ON)

SET(CMAKE_EXPORT_COMPILE_COMMANDS ON)

SET(CMAKE_C_COMPILER "D:/Tools/env/tools/ConEmu/ConEmu/../../../tools/gnu_gcc/arm_gcc/mingw/bin/arm-none-eabi-gcc.exe")
SET(CMAKE_ASM_COMPILER "D:/Tools/env/tools/ConEmu/ConEmu/../../../tools/gnu_gcc/arm_gcc/mingw/bin/arm-none-eabi-gcc.exe")
SET(CMAKE_C_FLAGS " -mcpu=cortex-m4 -mthumb -mfpu=fpv4-sp-d16 -mfloat-abi=hard -ffunction-sections -fdata-sections -Dgcc -fstack-usage -fdump-rtl-dfinish -O0 -gdwarf-2 -g")
SET(CMAKE_ASM_FLAGS " -c -mcpu=cortex-m4 -mthumb -mfpu=fpv4-sp-d16 -mfloat-abi=hard -ffunction-sections -fdata-sections -x assembler-with-cpp -Wa,-mimplicit-it=thumb  -gdwarf-2")
SET(CMAKE_C_COMPILER_WORKS TRUE)

SET(CMAKE_CXX_COMPILER "D:/Tools/env/tools/ConEmu/ConEmu/../../../tools/gnu_gcc/arm_gcc/mingw/bin/arm-none-eabi-g++.exe")
SET(CMAKE_CXX_FLAGS " -mcpu=cortex-m4 -mthumb -mfpu=fpv4-sp-d16 -mfloat-abi=hard -ffunction-sections -fdata-sections -Dgcc -fstack-usage -fdump-rtl-dfinish -O0 -gdwarf-2 -g")
SET(CMAKE_CXX_COMPILER_WORKS TRUE)

SET(CMAKE_OBJCOPY "D:/Tools/env/tools/ConEmu/ConEmu/../../../tools/gnu_gcc/arm_gcc/mingw/bin/arm-none-eabi-objcopy.exe")
SET(CMAKE_SIZE "D:/Tools/env/tools/ConEmu/ConEmu/../../../tools/gnu_gcc/arm_gcc/mingw/bin/arm-none-eabi-size.exe")

SET(CMAKE_EXE_LINKER_FLAGS " -mcpu=cortex-m4 -mthumb -mfpu=fpv4-sp-d16 -mfloat-abi=hard -ffunction-sections -fdata-sections -Wl,--gc-sections,-Map=rt-thread.map,-cref,-u,Reset_Handler -T ${CMAKE_SOURCE_DIR}/board/linker_scripts/link.lds")

SET(CMAKE_CXX_STANDARD 14)
PROJECT(rtthread C CXX ASM)
INCLUDE_DIRECTORIES(
	applications
	applications/cloud
	rt-thread/components/net/at/include
	rt-thread/components/net/at/at_socket
	packages/at_device-latest/inc
	packages/at_device-latest/class/esp8266
	rt-thread/components/libc/compilers/common/include
	rt-thread/components/libc/compilers/newlib
	rt-thread/libcpu/arm/common
	rt-thread/libcpu/arm/cortex-m4
	rt-thread/components/drivers/include
	rt-thread/components/drivers/spi
	board
	board/CubeMX_Config/Inc
	libraries/HAL_Drivers
	libraries/HAL_Drivers/config
	libraries/HAL_Drivers/CMSIS/Include
	board/ports/lcd
	rt-thread/components/dfs/dfs_v1/include
	rt-thread/components/dfs/dfs_v1/filesystems/devfs
	rt-thread/components/finsh
	.
	rt-thread/include
	libraries/STM32L4xx_HAL/STM32L4xx_HAL_Driver/Inc
	libraries/STM32L4xx_HAL/CMSIS/Device/ST/STM32L4xx/Include
	rt-thread/components/libc/posix/io/epoll
	rt-thread/components/libc/posix/io/eventfd
	rt-thread/components/libc/posix/io/poll
	rt-thread/components/libc/posix/ipc
	packages/rc522-v1.4.10
	packages/rc522-v1.4.10/inc
	rt-thread/components/net/netdev/include
	rt-thread/components/net/sal/include
	rt-thread/components/net/sal/include/socket
	rt-thread/components/net/sal/impl
	rt-thread/components/net/sal/include/dfs_net
	rt-thread/components/net/sal/include/socket/sys_socket
	packages/tencent-iot-sdk-latest/ports/ssl
	packages/tencent-iot-sdk-latest/qcloud-iot-explorer-sdk-embedded-c/include
	packages/tencent-iot-sdk-latest/qcloud-iot-explorer-sdk-embedded-c/include/exports
	packages/tencent-iot-sdk-latest/qcloud-iot-explorer-sdk-embedded-c/sdk_src/internal_inc
)

ADD_DEFINITIONS(
	-DAUTH_MODE_KEY
	-DAUTH_WITH_NOTLS
	-DMQTT_COMM_ENABLED
	-DRT_USING_LIBC
	-DRT_USING_NEWLIBC
	-DSTM32L475xx
	-DUSE_HAL_DRIVER
	-D_POSIX_C_SOURCE=1
	-D__RTTHREAD__
)

SET(PROJECT_SOURCES
	applications/cloud/data_config.c
	applications/cloud/tencent_cloud.c
	applications/ic_card_cipher.c
	applications/main.c
	applications/nrf24l01_init.c
	applications/star.c
	rt-thread/components/net/at/at_socket/at_socket.c
	rt-thread/components/net/at/src/at_cli.c
	rt-thread/components/net/at/src/at_client.c
	rt-thread/components/net/at/src/at_utils.c
	packages/at_device-latest/src/at_device.c
	packages/at_device-latest/samples/at_sample_esp8266.c
	packages/at_device-latest/class/esp8266/at_socket_esp8266.c
	packages/at_device-latest/class/esp8266/at_device_esp8266.c
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
	board/ports/lcd/drv_lcd.c
	rt-thread/components/dfs/dfs_v1/filesystems/devfs/devfs.c
	rt-thread/components/dfs/dfs_v1/src/dfs.c
	rt-thread/components/dfs/dfs_v1/src/dfs_file.c
	rt-thread/components/dfs/dfs_v1/src/dfs_fs.c
	rt-thread/components/dfs/dfs_v1/src/dfs_posix.c
	rt-thread/components/finsh/shell.c
	rt-thread/components/finsh/msh.c
	rt-thread/components/finsh/msh_parse.c
	rt-thread/components/finsh/cmd.c
	rt-thread/components/finsh/msh_file.c
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
	libraries/STM32L4xx_HAL/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_cryp.c
	libraries/STM32L4xx_HAL/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_spi.c
	libraries/STM32L4xx_HAL/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_cortex.c
	libraries/STM32L4xx_HAL/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_rcc.c
	libraries/STM32L4xx_HAL/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_pwr.c
	libraries/STM32L4xx_HAL/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_usart_ex.c
	libraries/STM32L4xx_HAL/CMSIS/Device/ST/STM32L4xx/Source/Templates/system_stm32l4xx.c
	libraries/STM32L4xx_HAL/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_pwr_ex.c
	libraries/STM32L4xx_HAL/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_tim.c
	libraries/STM32L4xx_HAL/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_usart.c
	libraries/STM32L4xx_HAL/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_cryp_ex.c
	libraries/STM32L4xx_HAL/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_tim_ex.c
	libraries/STM32L4xx_HAL/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_rcc_ex.c
	libraries/STM32L4xx_HAL/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_uart.c
	libraries/STM32L4xx_HAL/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_lptim.c
	libraries/STM32L4xx_HAL/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_dma_ex.c
	libraries/STM32L4xx_HAL/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_spi_ex.c
	libraries/STM32L4xx_HAL/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_gpio.c
	libraries/STM32L4xx_HAL/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_crc_ex.c
	libraries/STM32L4xx_HAL/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_dma.c
	libraries/STM32L4xx_HAL/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal.c
	libraries/STM32L4xx_HAL/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_comp.c
	libraries/STM32L4xx_HAL/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_qspi.c
	libraries/STM32L4xx_HAL/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_exti.c
	libraries/STM32L4xx_HAL/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_rng.c
	libraries/STM32L4xx_HAL/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_crc.c
	libraries/STM32L4xx_HAL/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_uart_ex.c
	rt-thread/components/libc/posix/io/poll/poll.c
	rt-thread/components/libc/posix/io/poll/select.c
	packages/rc522-v1.4.10/examples/dunp_info.c
	packages/rc522-v1.4.10/src/mfrc522.c
	packages/rc522-v1.4.10/port/mfrc522_rtt_port.c
	packages/rc522-v1.4.10/examples/change_uid.c
	packages/rc522-v1.4.10/examples/firmware_check.c
	packages/rc522-v1.4.10/examples/mifare_classic_value_block.c
	packages/rc522-v1.4.10/examples/fix_brickeduid.c
	packages/rc522-v1.4.10/examples/read_nuid.c
	rt-thread/components/net/netdev/src/netdev.c
	rt-thread/components/net/netdev/src/netdev_ipaddr.c
	rt-thread/components/net/sal/dfs_net/dfs_net.c
	rt-thread/components/net/sal/impl/af_inet_at.c
	rt-thread/components/net/sal/socket/net_netdb.c
	rt-thread/components/net/sal/socket/net_sockets.c
	rt-thread/components/net/sal/src/sal_socket.c
	packages/tencent-iot-sdk-latest/samples/data_template/data_template_sample.c
	packages/tencent-iot-sdk-latest/samples/scenarized/light_data_template_sample.c
	packages/tencent-iot-sdk-latest/qcloud-iot-explorer-sdk-embedded-c/sdk_src/utils/string_utils.c
	packages/tencent-iot-sdk-latest/qcloud-iot-explorer-sdk-embedded-c/sdk_src/utils/json_parser.c
	packages/tencent-iot-sdk-latest/qcloud-iot-explorer-sdk-embedded-c/sdk_src/protocol/mqtt/mqtt_client_connect.c
	packages/tencent-iot-sdk-latest/qcloud-iot-explorer-sdk-embedded-c/sdk_src/services/data_template/data_template_client_manager.c
	packages/tencent-iot-sdk-latest/qcloud-iot-explorer-sdk-embedded-c/sdk_src/utils/utils_aes.c
	packages/tencent-iot-sdk-latest/qcloud-iot-explorer-sdk-embedded-c/sdk_src/network/tls/network_tls.c
	packages/tencent-iot-sdk-latest/qcloud-iot-explorer-sdk-embedded-c/sdk_src/protocol/mqtt/mqtt_client_publish.c
	packages/tencent-iot-sdk-latest/qcloud-iot-explorer-sdk-embedded-c/sdk_src/utils/utils_hmac.c
	packages/tencent-iot-sdk-latest/qcloud-iot-explorer-sdk-embedded-c/sdk_src/network/network_interface.c
	packages/tencent-iot-sdk-latest/qcloud-iot-explorer-sdk-embedded-c/sdk_src/utils/utils_base64.c
	packages/tencent-iot-sdk-latest/qcloud-iot-explorer-sdk-embedded-c/sdk_src/utils/utils_timer.c
	packages/tencent-iot-sdk-latest/qcloud-iot-explorer-sdk-embedded-c/sdk_src/services/data_template/data_template_client_common.c
	packages/tencent-iot-sdk-latest/qcloud-iot-explorer-sdk-embedded-c/sdk_src/protocol/mqtt/mqtt_client_unsubscribe.c
	packages/tencent-iot-sdk-latest/qcloud-iot-explorer-sdk-embedded-c/sdk_src/services/data_template/data_template_client_json.c
	packages/tencent-iot-sdk-latest/qcloud-iot-explorer-sdk-embedded-c/sdk_src/utils/utils_getopt.c
	packages/tencent-iot-sdk-latest/qcloud-iot-explorer-sdk-embedded-c/sdk_src/protocol/mqtt/mqtt_client_yield.c
	packages/tencent-iot-sdk-latest/qcloud-iot-explorer-sdk-embedded-c/sdk_src/utils/utils_md5.c
	packages/tencent-iot-sdk-latest/ports/rtthread/HAL_OS_rtthread.c
	packages/tencent-iot-sdk-latest/qcloud-iot-explorer-sdk-embedded-c/sdk_src/protocol/mqtt/mqtt_client.c
	packages/tencent-iot-sdk-latest/qcloud-iot-explorer-sdk-embedded-c/sdk_src/network/socket/network_socket.c
	packages/tencent-iot-sdk-latest/qcloud-iot-explorer-sdk-embedded-c/sdk_src/services/data_template/data_template_event.c
	packages/tencent-iot-sdk-latest/qcloud-iot-explorer-sdk-embedded-c/sdk_src/utils/utils_list.c
	packages/tencent-iot-sdk-latest/qcloud-iot-explorer-sdk-embedded-c/sdk_src/utils/qcloud_iot_log.c
	packages/tencent-iot-sdk-latest/ports/rtthread/HAL_Timer_rtthread.c
	packages/tencent-iot-sdk-latest/qcloud-iot-explorer-sdk-embedded-c/sdk_src/protocol/mqtt/mqtt_client_net.c
	packages/tencent-iot-sdk-latest/qcloud-iot-explorer-sdk-embedded-c/sdk_src/utils/utils_ringbuff.c
	packages/tencent-iot-sdk-latest/qcloud-iot-explorer-sdk-embedded-c/sdk_src/services/data_template/data_template_client.c
	packages/tencent-iot-sdk-latest/qcloud-iot-explorer-sdk-embedded-c/sdk_src/utils/qcloud_iot_ca.c
	packages/tencent-iot-sdk-latest/qcloud-iot-explorer-sdk-embedded-c/sdk_src/protocol/mqtt/mqtt_client_common.c
	packages/tencent-iot-sdk-latest/ports/rtthread/HAL_TCP_rtthread.c
	packages/tencent-iot-sdk-latest/qcloud-iot-explorer-sdk-embedded-c/sdk_src/utils/json_token.c
	packages/tencent-iot-sdk-latest/qcloud-iot-explorer-sdk-embedded-c/sdk_src/utils/qcloud_iot_device.c
	packages/tencent-iot-sdk-latest/qcloud-iot-explorer-sdk-embedded-c/sdk_src/utils/utils_sha1.c
	packages/tencent-iot-sdk-latest/qcloud-iot-explorer-sdk-embedded-c/sdk_src/protocol/mqtt/mqtt_client_subscribe.c
	packages/tencent-iot-sdk-latest/ports/rtthread/HAL_Device_rtthread.c
	packages/tencent-iot-sdk-latest/qcloud-iot-explorer-sdk-embedded-c/sdk_src/services/data_template/data_template_aciton.c
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