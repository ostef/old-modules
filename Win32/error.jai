// The operation completed successfully.
ERROR_SUCCESS :: 0;
// Incorrect function.
ERROR_INVALID_FUNCTION :: 1;
// The system cannot find the file specified.
ERROR_FILE_NOT_FOUND :: 2;
// The system cannot find the path specified.
ERROR_PATH_NOT_FOUND :: 3;
// The system cannot open the file.
ERROR_TOO_MANY_OPEN_FILES :: 4;
// Access is denied.
ERROR_ACCESS_DENIED :: 5;
// The handle is invalid.
ERROR_INVALID_HANDLE :: 6;
// The storage control blocks were destroyed.
ERROR_ARENA_TRASHED :: 7;
// Not enough storage is available to process this command.
ERROR_NOT_ENOUGH_MEMORY :: 8;
// The storage control block address is invalid.
ERROR_INVALID_BLOCK :: 9;
// The environment is incorrect.
ERROR_BAD_ENVIRONMENT :: 10;
// An attempt was made to load a program with an incorrect format.
ERROR_BAD_FORMAT :: 11;
// The access code is invalid.
ERROR_INVALID_ACCESS :: 12;
// The data is invalid.
ERROR_INVALID_DATA :: 13;
// Not enough storage is available to complete this operation.
ERROR_OUTOFMEMORY :: 14;
// The system cannot find the drive specified.
ERROR_INVALID_DRIVE :: 15;
// The directory cannot be removed.
ERROR_CURRENT_DIRECTORY :: 16;
// The system cannot move the file to a different disk drive.
ERROR_NOT_SAME_DEVICE :: 17;
// There are no more files.
ERROR_NO_MORE_FILES :: 18;
// The media is write protected.
ERROR_WRITE_PROTECT :: 19;
// The system cannot find the device specified.
ERROR_BAD_UNIT :: 20;
// The device is not ready.
ERROR_NOT_READY :: 21;
// The device does not recognize the command.
ERROR_BAD_COMMAND :: 22;
// Data error (cyclic redundancy check).
ERROR_CRC :: 23;
// The program issued a command but the command length is incorrect.
ERROR_BAD_LENGTH :: 24;
// The drive cannot locate a specific area or track on the disk.
ERROR_SEEK :: 25;
// The specified disk or diskette cannot be accessed.
ERROR_NOT_DOS_DISK :: 26;
// The drive cannot find the sector requested.
ERROR_SECTOR_NOT_FOUND :: 27;
// The printer is out of paper.
ERROR_OUT_OF_PAPER :: 28;
// The system cannot write to the specified device.
ERROR_WRITE_FAULT :: 29;
// The system cannot read from the specified device.
ERROR_READ_FAULT :: 30;
// A device attached to the system is not functioning.
ERROR_GEN_FAILURE :: 31;
// The process cannot access the file because it is being used by another process.
ERROR_SHARING_VIOLATION :: 32;
// The process cannot access the file because another process has locked a portion of the file.
ERROR_LOCK_VIOLATION :: 33;
// The wrong diskette is in the drive. Insert %2 (Volume Serial Number: %3) into drive %1.
ERROR_WRONG_DISK :: 34;
// Too many files opened for sharing.
ERROR_SHARING_BUFFER_EXCEEDED :: 36;
// Reached the end of the file.
ERROR_HANDLE_EOF :: 38;
// The disk is full.
ERROR_HANDLE_DISK_FULL :: 39;
// The network request is not supported.
ERROR_NOT_SUPPORTED :: 50;
// The remote computer is not available.
ERROR_REM_NOT_LIST :: 51;
// A duplicate name exists on the network.
ERROR_DUP_NAME :: 52;
// The network path was not found.
ERROR_BAD_NETPATH :: 53;
// The network is busy.
ERROR_NETWORK_BUSY :: 54;
// The specified network resource or device is no longer available.
ERROR_DEV_NOT_EXIST :: 55;
// The network BIOS command limit has been reached.
ERROR_TOO_MANY_CMDS :: 56;
// A network adapter hardware error occurred.
ERROR_ADAP_HDW_ERR :: 57;
// The specified server cannot perform the requested operation.
ERROR_BAD_NET_RESP :: 58;
// An unexpected network error occurred.
ERROR_UNEXP_NET_ERR :: 59;
// The remote adapter is not compatible.
ERROR_BAD_REM_ADAP :: 60;
// The printer queue is full.
ERROR_PRINTQ_FULL :: 61;
// Space to store the file waiting to be printed is not available on the server.
ERROR_NO_SPOOL_SPACE :: 62;
// Your file waiting to be printed was deleted.
ERROR_PRINT_CANCELED :: 63;
// The specified network name is no longer available.
ERROR_NETNAME_DELETED :: 64;
// Network access is denied.
ERROR_NETWORK_ACCESS_DENIED :: 65;
// The network resource type is not correct.
ERROR_BAD_DEV_TYPE :: 66;
// The network name cannot be found.
ERROR_BAD_NET_NAME :: 67;
// The name limit for the local computer network adapter card was exceeded.
ERROR_TOO_MANY_NAMES :: 68;
// The network BIOS session limit was exceeded.
ERROR_TOO_MANY_SESS :: 69;
// The remote server has been paused or is in the process of being started.
ERROR_SHARING_PAUSED :: 70;
// No more connections can be made to this remote computer at this time because there are already as many connections as the computer can accept.
ERROR_REQ_NOT_ACCEP :: 71;
// The specified printer or disk device has been paused.
ERROR_REDIR_PAUSED :: 72;
// The file exists.
ERROR_FILE_EXISTS :: 80;
// The directory or file cannot be created.
ERROR_CANNOT_MAKE :: 82;
// Fail on INT 24.
ERROR_FAIL_I24 :: 83;
// Storage to process this request is not available.
ERROR_OUT_OF_STRUCTURES :: 84;
// The local device name is already in use.
ERROR_ALREADY_ASSIGNED :: 85;
// The specified network password is not correct.
ERROR_INVALID_PASSWORD :: 86;
// The parameter is incorrect.
ERROR_INVALID_PARAMETER :: 87;
// A write fault occurred on the network.
ERROR_NET_WRITE_FAULT :: 88;
// The system cannot start another process at this time.
ERROR_NO_PROC_SLOTS :: 89;
// Cannot create another system semaphore.
ERROR_TOO_MANY_SEMAPHORES :: 100;
// The exclusive semaphore is owned by another process.
ERROR_EXCL_SEM_ALREADY_OWNED :: 101;
// The semaphore is set and cannot be closed.
ERROR_SEM_IS_SET :: 102;
// The semaphore cannot be set again.
ERROR_TOO_MANY_SEM_REQUESTS :: 103;
// Cannot request exclusive semaphores at interrupt time.
ERROR_INVALID_AT_INTERRUPT_TIME :: 104;
// The previous ownership of this semaphore has ended.
ERROR_SEM_OWNER_DIED :: 105;
// Insert the diskette for drive %1.
ERROR_SEM_USER_LIMIT :: 106;
// The program stopped because an alternate diskette was not inserted.
ERROR_DISK_CHANGE :: 107;
// The disk is in use or locked by another process.
ERROR_DRIVE_LOCKED :: 108;
// The pipe has been ended.
ERROR_BROKEN_PIPE :: 109;
// The system cannot open the device or file specified.
ERROR_OPEN_FAILED :: 110;
// The file name is too long.
ERROR_BUFFER_OVERFLOW :: 111;
// There is not enough space on the disk.
ERROR_DISK_FULL :: 112;
// No more internal file identifiers available.
ERROR_NO_MORE_SEARCH_HANDLES :: 113;
// The target internal file identifier is incorrect.
ERROR_INVALID_TARGET_HANDLE :: 114;
// The IOCTL call made by the application program is not correct.
ERROR_INVALID_CATEGORY :: 117;
// The verify-on-write switch parameter value is not correct.
ERROR_INVALID_VERIFY_SWITCH :: 118;
// The system does not support the command requested.
ERROR_BAD_DRIVER_LEVEL :: 119;
// This function is not supported on this system.
ERROR_CALL_NOT_IMPLEMENTED :: 120;
// The semaphore timeout period has expired.
ERROR_SEM_TIMEOUT :: 121;
// The data area passed to a system call is too small.
ERROR_INSUFFICIENT_BUFFER :: 122;
// The filename, directory name, or volume label syntax is incorrect.
ERROR_INVALID_NAME :: 123;
// The system call level is not correct.
ERROR_INVALID_LEVEL :: 124;
// The disk has no volume label.
ERROR_NO_VOLUME_LABEL :: 125;
// The specified module could not be found.
ERROR_MOD_NOT_FOUND :: 126;
// The specified procedure could not be found.
ERROR_PROC_NOT_FOUND :: 127;
// There are no child processes to wait for.
ERROR_WAIT_NO_CHILDREN :: 128;
// The %1 application cannot be run in Win32 mode.
ERROR_CHILD_NOT_COMPLETE :: 129;
// Attempt to use a file handle to an open disk partition for an operation other than raw disk I/O.
ERROR_DIRECT_ACCESS_HANDLE :: 130;
// An attempt was made to move the file pointer before the beginning of the file.
ERROR_NEGATIVE_SEEK :: 131;
// The file pointer cannot be set on the specified device or file.
ERROR_SEEK_ON_DEVICE :: 132;
// A JOIN or SUBST command cannot be used for a drive that contains previously joined drives.
ERROR_IS_JOIN_TARGET :: 133;
// An attempt was made to use a JOIN or SUBST command on a drive that has already been joined.
ERROR_IS_JOINED :: 134;
// An attempt was made to use a JOIN or SUBST command on a drive that has already been substituted.
ERROR_IS_SUBSTED :: 135;
// The system tried to delete the JOIN of a drive that is not joined.
ERROR_NOT_JOINED :: 136;
// The system tried to delete the substitution of a drive that is not substituted.
ERROR_NOT_SUBSTED :: 137;
// The system tried to join a drive to a directory on a joined drive.
ERROR_JOIN_TO_JOIN :: 138;
// The system tried to substitute a drive to a directory on a substituted drive.
ERROR_SUBST_TO_SUBST :: 139;
// The system tried to join a drive to a directory on a substituted drive.
ERROR_JOIN_TO_SUBST :: 140;
// The system tried to SUBST a drive to a directory on a joined drive.
ERROR_SUBST_TO_JOIN :: 141;
// The system cannot perform a JOIN or SUBST at this time.
ERROR_BUSY_DRIVE :: 142;
// The system cannot join or substitute a drive to or for a directory on the same drive.
ERROR_SAME_DRIVE :: 143;
// The directory is not a subdirectory of the root directory.
ERROR_DIR_NOT_ROOT :: 144;
// The directory is not empty.
ERROR_DIR_NOT_EMPTY :: 145;
// The path specified is being used in a substitute.
ERROR_IS_SUBST_PATH :: 146;
// Not enough resources are available to process this command.
ERROR_IS_JOIN_PATH :: 147;
// The path specified cannot be used at this time.
ERROR_PATH_BUSY :: 148;
// An attempt was made to join or substitute a drive for which a directory on the drive is the target of a previous substitute.
ERROR_IS_SUBST_TARGET :: 149;
// System trace information was not specified in your CONFIG.SYS file, or tracing is disallowed.
ERROR_SYSTEM_TRACE :: 150;
// The number of specified semaphore events for DosMuxSemWait is not correct.
ERROR_INVALID_EVENT_COUNT :: 151;
// DosMuxSemWait did not execute; too many semaphores are already set.
ERROR_TOO_MANY_MUXWAITERS :: 152;
// The DosMuxSemWait list is not correct.
ERROR_INVALID_LIST_FORMAT :: 153;
// The volume label you entered exceeds the label character limit of the target file system.
ERROR_LABEL_TOO_LONG :: 154;
// Cannot create another thread.
ERROR_TOO_MANY_TCBS :: 155;
// The recipient process has refused the signal.
ERROR_SIGNAL_REFUSED :: 156;
// The segment is already discarded and cannot be locked.
ERROR_DISCARDED :: 157;
// The segment is already unlocked.
ERROR_NOT_LOCKED :: 158;
// The address for the thread ID is not correct.
ERROR_BAD_THREADID_ADDR :: 159;
// The argument string passed to DosExecPgm is not correct.
ERROR_BAD_ARGUMENTS :: 160;
// The specified path is invalid.
ERROR_BAD_PATHNAME :: 161;
// A signal is already pending.
ERROR_SIGNAL_PENDING :: 162;
// No more threads can be created in the system.
ERROR_MAX_THRDS_REACHED :: 164;
// Unable to lock a region of a file.
ERROR_LOCK_FAILED :: 167;
// The requested resource is in use.
ERROR_BUSY :: 170;
// A lock request was not outstanding for the supplied cancel region.
ERROR_CANCEL_VIOLATION :: 173;
// The file system does not support atomic changes to the lock type.
ERROR_ATOMIC_LOCKS_NOT_SUPPORTED :: 174;
// The system detected a segment number that was not correct.
ERROR_INVALID_SEGMENT_NUMBER :: 180;
// The operating system cannot run %1.
ERROR_INVALID_ORDINAL :: 182;
// Cannot create a file when that file already exists.
ERROR_ALREADY_EXISTS :: 183;
// The flag passed is not correct.
ERROR_INVALID_FLAG_NUMBER :: 186;
// The specified system semaphore name was not found.
ERROR_SEM_NOT_FOUND :: 187;
// The operating system cannot run %1.
ERROR_INVALID_STARTING_CODESEG :: 188;
// The operating system cannot run %1.
ERROR_INVALID_STACKSEG :: 189;
// The operating system cannot run %1.
ERROR_INVALID_MODULETYPE :: 190;
// Cannot run %1 in Win32 mode.
ERROR_INVALID_EXE_SIGNATURE :: 191;
// The operating system cannot run %1.
ERROR_EXE_MARKED_INVALID :: 192;
// %1 is not a valid Win32 application.
ERROR_BAD_EXE_FORMAT :: 193;
// The operating system cannot run %1.
ERROR_ITERATED_DATA_EXCEEDS_64k :: 194;
// The operating system cannot run %1.
ERROR_INVALID_MINALLOCSIZE :: 195;
// The operating system cannot run this application program.
ERROR_DYNLINK_FROM_INVALID_RING :: 196;
// The operating system is not presently configured to run this application.
ERROR_IOPL_NOT_ENABLED :: 197;
// The operating system cannot run %1.
ERROR_INVALID_SEGDPL :: 198;
// The operating system cannot run this application program.
ERROR_AUTODATASEG_EXCEEDS_64k :: 199;
// The code segment cannot be greater than or equal to 64K.
ERROR_RING2SEG_MUST_BE_MOVABLE :: 200;
// The operating system cannot run %1.
ERROR_RELOC_CHAIN_XEEDS_SEGLIM :: 201;
// The operating system cannot run %1.
ERROR_INFLOOP_IN_RELOC_CHAIN :: 202;
// The system could not find the environment option that was entered.
ERROR_ENVVAR_NOT_FOUND :: 203;
// No process in the command subtree has a signal handler.
ERROR_NO_SIGNAL_SENT :: 205;
// The filename or extension is too long.
ERROR_FILENAME_EXCED_RANGE :: 206;
// The ring 2 stack is in use.
ERROR_RING2_STACK_IN_USE :: 207;
// The global filename characters, * or ?, are entered incorrectly or too many global filename characters are specified.
ERROR_META_EXPANSION_TOO_LONG :: 208;
// The signal being posted is not correct.
ERROR_INVALID_SIGNAL_NUMBER :: 209;
// The signal handler cannot be set.
ERROR_THREAD_1_INACTIVE :: 210;
// The segment is locked and cannot be reallocated.
ERROR_LOCKED :: 212;
// Too many dynamic-link modules are attached to this program or dynamic-link module.
ERROR_TOO_MANY_MODULES :: 214;
// Cannot nest calls to LoadModule.
ERROR_NESTING_NOT_ALLOWED :: 215;
// The image file %1 is valid, but is for a machine type other than the current machine.
ERROR_EXE_MACHINE_TYPE_MISMATCH :: 216;
// The pipe state is invalid.
ERROR_BAD_PIPE :: 230;
// All pipe instances are busy.
ERROR_PIPE_BUSY :: 231;
// The pipe is being closed.
ERROR_NO_DATA :: 232;
// No process is on the other end of the pipe.
ERROR_PIPE_NOT_CONNECTED :: 233;
// More data is available.
ERROR_MORE_DATA :: 234;
// The session was canceled.
ERROR_VC_DISCONNECTED :: 240;
// The specified extended attribute name was invalid.
ERROR_INVALID_EA_NAME :: 254;
// The extended attributes are inconsistent.
ERROR_EA_LIST_INCONSISTENT :: 255;
// The wait operation timed out.
WAIT_TIMEOUT :: 258;
// No more data is available.
ERROR_NO_MORE_ITEMS :: 259;
// The copy functions cannot be used.
ERROR_CANNOT_COPY :: 266;
// The directory name is invalid.
ERROR_DIRECTORY :: 267;
// The extended attributes did not fit in the buffer.
ERROR_EAS_DIDNT_FIT :: 275;
// The extended attribute file on the mounted file system is corrupt.
ERROR_EA_FILE_CORRUPT :: 276;
// The extended attribute table file is full.
ERROR_EA_TABLE_FULL :: 277;
// The specified extended attribute handle is invalid.
ERROR_INVALID_EA_HANDLE :: 278;
// The mounted file system does not support extended attributes.
ERROR_EAS_NOT_SUPPORTED :: 282;
// Attempt to release mutex not owned by caller.
ERROR_NOT_OWNER :: 288;
// Too many posts were made to a semaphore.
ERROR_TOO_MANY_POSTS :: 298;
// Only part of a ReadProcessMemory or WriteProcessMemory request was completed.
ERROR_PARTIAL_COPY :: 299;
// The oplock request is denied.
ERROR_OPLOCK_NOT_GRANTED :: 300;
// An invalid oplock acknowledgment was received by the system.
ERROR_INVALID_OPLOCK_PROTOCOL :: 301;
// The system cannot find message text for message number 0x%1 in the message file for %2.
ERROR_MR_MID_NOT_FOUND :: 317;
// Attempt to access invalid address.
ERROR_INVALID_ADDRESS :: 487;
// Arithmetic result exceeded 32 bits.
ERROR_ARITHMETIC_OVERFLOW :: 534;
// There is a process on other end of the pipe.
ERROR_PIPE_CONNECTED :: 535;
// Waiting for a process to open the other end of the pipe.
ERROR_PIPE_LISTENING :: 536;
// Access to the extended attribute was denied.
ERROR_EA_ACCESS_DENIED :: 994;
// The I/O operation has been aborted because of either a thread exit or an application request.
ERROR_OPERATION_ABORTED :: 995;
// Overlapped I/O event is not in a signaled state.
ERROR_IO_INCOMPLETE :: 996;
// Overlapped I/O operation is in progress.
ERROR_IO_PENDING :: 997;
// Invalid access to memory location.
ERROR_NOACCESS :: 998;
// Error performing inpage operation. 
ERROR_SWAPERROR  :: 999;
// Recursion too deep; the stack overflowed.
ERROR_STACK_OVERFLOW :: 1001;
// The window cannot act on the sent message.
ERROR_INVALID_MESSAGE :: 1002;
// Cannot complete this function.
ERROR_CAN_NOT_COMPLETE :: 1003;
// Invalid flags.
ERROR_INVALID_FLAGS :: 1004;
// The volume does not contain a recognized file system. Please make sure that all required file system drivers are loaded and that the volume is not corrupted.
ERROR_UNRECOGNIZED_VOLUME :: 1005;
// The volume for a file has been externally altered so that the opened file is no longer valid.
ERROR_FILE_INVALID :: 1006;
// The requested operation cannot be performed in full-screen mode.
ERROR_FULLSCREEN_MODE :: 1007;
// An attempt was made to reference a token that does not exist.
ERROR_NO_TOKEN :: 1008;
// The configuration registry database is corrupt.
ERROR_BADDB :: 1009;
// The configuration registry key is invalid.
ERROR_BADKEY :: 1010;
// The configuration registry key could not be opened.
ERROR_CANTOPEN :: 1011;
// The configuration registry key could not be read.
ERROR_CANTREAD :: 1012;
// The configuration registry key could not be written.
ERROR_CANTWRITE :: 1013;
// One of the files in the registry database had to be recovered by use of a log or alternate copy. The recovery was successful.
ERROR_REGISTRY_RECOVERED :: 1014;
// The registry is corrupted. The structure of one of the files that contains registry data is corrupted, or the system's image of the file in memory is corrupted, or the file could not be recovered because the alternate copy or log was absent or corrupted.
ERROR_REGISTRY_CORRUPT :: 1015;
// An I/O operation initiated by the registry failed unrecoverably. The registry could not read in, or write out, or flush, one of the files that contain the system's image of the registry.
ERROR_REGISTRY_IO_FAILED :: 1016;
// The system has attempted to load or restore a file into the registry, but the specified file is not in a registry file format.
ERROR_NOT_REGISTRY_FILE :: 1017;
// Illegal operation attempted on a registry key that has been marked for deletion.
ERROR_KEY_DELETED :: 1018;
// System could not allocate the required space in a registry log.
ERROR_NO_LOG_SPACE :: 1019;
// Cannot create a symbolic link in a registry key that already has subkeys or values.
ERROR_KEY_HAS_CHILDREN :: 1020;
// Cannot create a stable subkey under a volatile parent key.
ERROR_CHILD_MUST_BE_VOLATILE :: 1021;
// A notify change request is being completed and the information is not being returned in the caller's buffer. The caller now must enumerate the files to find the changes.
ERROR_NOTIFY_ENUM_DIR :: 1022;
// A stop control has been sent to a service that other running services are dependent on.
ERROR_DEPENDENT_SERVICES_RUNNING :: 1051;
// The requested control is not valid for this service.
ERROR_INVALID_SERVICE_CONTROL :: 1052;
// The service did not respond to the start or control request in a timely fashion.
ERROR_SERVICE_REQUEST_TIMEOUT :: 1053;
// A thread could not be created for the service.
ERROR_SERVICE_NO_THREAD :: 1054;
// The service database is locked.
ERROR_SERVICE_DATABASE_LOCKED :: 1055;
// An instance of the service is already running.
ERROR_SERVICE_ALREADY_RUNNING :: 1056;
// The account name is invalid or does not exist.
ERROR_INVALID_SERVICE_ACCOUNT :: 1057;
// The service cannot be started, either because it is disabled or because it has no enabled devices associated with it.
ERROR_SERVICE_DISABLED :: 1058;
// Circular service dependency was specified.
ERROR_CIRCULAR_DEPENDENCY :: 1059;
// The specified service does not exist as an installed service.
ERROR_SERVICE_DOES_NOT_EXIST :: 1060;
// The service cannot accept control messages at this time.
ERROR_SERVICE_CANNOT_ACCEPT_CTRL :: 1061;
// The service has not been started.
ERROR_SERVICE_NOT_ACTIVE :: 1062;
// The service process could not connect to the service controller.
ERROR_FAILED_SERVICE_CONTROLLER_CONNECT :: 1063;
// An exception occurred in the service when handling the control request.
ERROR_EXCEPTION_IN_SERVICE :: 1064;
// The database specified does not exist.
ERROR_DATABASE_DOES_NOT_EXIST :: 1065;
// The service has returned a service-specific error code.
ERROR_SERVICE_SPECIFIC_ERROR :: 1066;
// The process terminated unexpectedly.
ERROR_PROCESS_ABORTED :: 1067;
// The dependency service or group failed to start.
ERROR_SERVICE_DEPENDENCY_FAIL :: 1068;
// The service did not start due to a logon failure.
ERROR_SERVICE_LOGON_FAILED :: 1069;
// After starting, the service hung in a start-pending state.
ERROR_SERVICE_START_HANG :: 1070;
// The specified service database lock is invalid.
ERROR_INVALID_SERVICE_LOCK :: 1071;
// The specified service has been marked for deletion.
ERROR_SERVICE_MARKED_FOR_DELETE :: 1072;
// The specified service already exists.
ERROR_SERVICE_EXISTS :: 1073;
// The system is currently running with the last-known-good configuration.
ERROR_ALREADY_RUNNING_LKG :: 1074;
// The dependency service does not exist or has been marked for deletion.
ERROR_SERVICE_DEPENDENCY_DELETED :: 1075;
// The current boot has already been accepted for use as the last-known-good control set.
ERROR_BOOT_ALREADY_ACCEPTED :: 1076;
// No attempts to start the service have been made since the last boot.
ERROR_SERVICE_NEVER_STARTED :: 1077;
// The name is already in use as either a service name or a service display name.
ERROR_DUPLICATE_SERVICE_NAME :: 1078;
// The account specified for this service is different from the account specified for other services running in the same process.
ERROR_DIFFERENT_SERVICE_ACCOUNT :: 1079;
// Failure actions can only be set for Win32 services, not for drivers.
ERROR_CANNOT_DETECT_DRIVER_FAILURE :: 1080;
// This service runs in the same process as the service control manager. Therefore, the service control manager cannot take action if this service's process terminates unexpectedly.
ERROR_CANNOT_DETECT_PROCESS_ABORT :: 1081;
// No recovery program has been configured for this service.
ERROR_NO_RECOVERY_PROGRAM :: 1082;
// The executable program that this service is configured to run in does not implement the service.
ERROR_SERVICE_NOT_IN_EXE :: 1083;
// The physical end of the tape has been reached.
ERROR_END_OF_MEDIA :: 1100;
// A tape access reached a filemark.
ERROR_FILEMARK_DETECTED :: 1101;
// The beginning of the tape or a partition was encountered.
ERROR_BEGINNING_OF_MEDIA :: 1102;
// A tape access reached the end of a set of files.
ERROR_SETMARK_DETECTED :: 1103;
// No more data is on the tape.
ERROR_NO_DATA_DETECTED :: 1104;
// Tape could not be partitioned.
ERROR_PARTITION_FAILURE :: 1105;
// When accessing a new tape of a multivolume partition, the current block size is incorrect.
ERROR_INVALID_BLOCK_LENGTH :: 1106;
// Tape partition information could not be found when loading a tape.
ERROR_DEVICE_NOT_PARTITIONED :: 1107;
// Unable to lock the media eject mechanism.
ERROR_UNABLE_TO_LOCK_MEDIA :: 1108;
// Unable to unload the media.
ERROR_UNABLE_TO_UNLOAD_MEDIA :: 1109;
// The media in the drive can have changed.
ERROR_MEDIA_CHANGED :: 1110;
// The I/O bus was reset.
ERROR_BUS_RESET :: 1111;
// No media in drive.
ERROR_NO_MEDIA_IN_DRIVE :: 1112;
// No mapping for the Unicode character exists in the target multi-byte code page.
ERROR_NO_UNICODE_TRANSLATION :: 1113;
// A dynamic link library (DLL) initialization routine failed.
ERROR_DLL_INIT_FAILED :: 1114;
// A system shutdown is in progress.
ERROR_SHUTDOWN_IN_PROGRESS :: 1115;
// Unable to abort the system shutdown because no shutdown was in progress.
ERROR_NO_SHUTDOWN_IN_PROGRESS :: 1116;
// The request could not be performed because of an I/O device error.
ERROR_IO_DEVICE :: 1117;
// No serial device was successfully initialized. The serial driver will unload.
ERROR_SERIAL_NO_DEVICE :: 1118;
// Unable to open a device that was sharing an interrupt request (IRQ) with other devices. At least one other device that uses that IRQ was already opened.
ERROR_IRQ_BUSY :: 1119;
// A serial I/O operation was completed by another write to the serial port. (The IOCTL_SERIAL_XOFF_COUNTER reached zero.)
ERROR_MORE_WRITES :: 1120;
// A serial I/O operation completed because the timeout period expired. (The IOCTL_SERIAL_XOFF_COUNTER did not reach zero.)
ERROR_COUNTER_TIMEOUT :: 1121;
// No ID address mark was found on the floppy disk.
ERROR_FLOPPY_ID_MARK_NOT_FOUND :: 1122;
// Mismatch between the floppy disk sector ID field and the floppy disk controller track address.
ERROR_FLOPPY_WRONG_CYLINDER :: 1123;
// The floppy disk controller reported an error that is not recognized by the floppy disk driver.
ERROR_FLOPPY_UNKNOWN_ERROR :: 1124;
// The floppy disk controller returned inconsistent results in its registers.
ERROR_FLOPPY_BAD_REGISTERS :: 1125;
// While accessing the hard disk, a recalibrate operation failed, even after retries.
ERROR_DISK_RECALIBRATE_FAILED :: 1126;
// While accessing the hard disk, a disk operation failed even after retries.
ERROR_DISK_OPERATION_FAILED :: 1127;
// While accessing the hard disk, a disk controller reset was needed, but even that failed.
ERROR_DISK_RESET_FAILED :: 1128;
// Physical end of tape encountered.
ERROR_EOM_OVERFLOW :: 1129;
// Not enough server storage is available to process this command.
ERROR_NOT_ENOUGH_SERVER_MEMORY :: 1130;
// A potential deadlock condition has been detected.
ERROR_POSSIBLE_DEADLOCK :: 1131;
// The base address or the file offset specified does not have the proper alignment.
ERROR_MAPPED_ALIGNMENT :: 1132;
// An attempt to change the system power state was vetoed by another application or driver.
ERROR_SET_POWER_STATE_VETOED :: 1140;
// The system BIOS failed an attempt to change the system power state.
ERROR_SET_POWER_STATE_FAILED :: 1141;
// An attempt was made to create more links on a file than the file system supports.
ERROR_TOO_MANY_LINKS :: 1142;
// The specified program requires a newer version of Windows.
ERROR_OLD_WIN_VERSION :: 1150;
// The specified program is not a Windows or MS-DOS program.
ERROR_APP_WRONG_OS :: 1151;
// Cannot start more than one instance of the specified program.
ERROR_SINGLE_INSTANCE_APP :: 1152;
// The specified program was written for an earlier version of Windows.
ERROR_RMODE_APP :: 1153;
// One of the library files needed to run this application is damaged.
ERROR_INVALID_DLL :: 1154;
// No application is associated with the specified file for this operation.
ERROR_NO_ASSOCIATION :: 1155;
// An error occurred in sending the command to the application.
ERROR_DDE_FAIL :: 1156;
// One of the library files needed to run this application cannot be found.
ERROR_DLL_NOT_FOUND :: 1157;
// The current process has used all of its system allowance of handles for Window Manager objects.
ERROR_NO_MORE_USER_HANDLES :: 1158;
// The message can be used only with synchronous operations.
ERROR_MESSAGE_SYNC_ONLY :: 1159;
// The indicated source element has no media.
ERROR_SOURCE_ELEMENT_EMPTY :: 1160;
// The indicated destination element already contains media.
ERROR_DESTINATION_ELEMENT_FULL :: 1161;
// The indicated element does not exist.
ERROR_ILLEGAL_ELEMENT_ADDRESS :: 1162;
// The indicated element is part of a magazine that is not present.
ERROR_MAGAZINE_NOT_PRESENT :: 1163;
// The indicated device requires reinitialization due to hardware errors.
ERROR_DEVICE_REINITIALIZATION_NEEDED :: 1164;
// The device has indicated that cleaning is required before further operations are attempted.
ERROR_DEVICE_REQUIRES_CLEANING :: 1165;
// The device has indicated that its door is open.
ERROR_DEVICE_DOOR_OPEN :: 1166;
// The device is not connected.
ERROR_DEVICE_NOT_CONNECTED :: 1167;
// Element not found.
ERROR_NOT_FOUND :: 1168;
// There was no match for the specified key in the index.
ERROR_NO_MATCH :: 1169;
// The property set specified does not exist on the object.
ERROR_SET_NOT_FOUND :: 1170;
// The point passed to GetMouseMovePointsEx is not in the buffer.
ERROR_POINT_NOT_FOUND :: 1171;
// The tracking (workstation) service is not running.
ERROR_NO_TRACKING_SERVICE :: 1172;
// The Volume ID could not be found.
ERROR_NO_VOLUME_ID :: 1173;
// The specified Very Large Memory (64-bit) operation is invalid.
ERROR_INVALID_VLM_OPERATION :: 1174;
// Unable to remove the file to be replaced.
ERROR_UNABLE_TO_REMOVE_REPLACED :: 1175;
// Unable to move the replacement file to the file to be replaced. The file to be replaced has retained its original name.
ERROR_UNABLE_TO_MOVE_REPLACEMENT :: 1176;
// Unable to move the replacement file to the file to be replaced. The file to be replaced has been renamed using the backup name.
ERROR_UNABLE_TO_MOVE_REPLACEMENT_2 :: 1177;
// The volume change journal is being deleted.
ERROR_JOURNAL_DELETE_IN_PROGRESS :: 1178;
// The volume change journal service is not active.
ERROR_JOURNAL_NOT_ACTIVE :: 1179;
// A file was found, but it cannot be the correct file.
ERROR_POTENTIAL_FILE_FOUND :: 1180;
// The journal entry has been deleted from the journal.
ERROR_JOURNAL_ENTRY_DELETED :: 1181;
// The specified device name is invalid.
ERROR_BAD_DEVICE :: 1200;
// The device is not currently connected but it is a remembered connection.
ERROR_CONNECTION_UNAVAIL :: 1201;
// An attempt was made to remember a device that had previously been remembered.
ERROR_DEVICE_ALREADY_REMEMBERED :: 1202;
// No network provider accepted the given network path.
ERROR_NO_NET_OR_BAD_PATH :: 1203;
// The specified network provider name is invalid.
ERROR_BAD_PROVIDER :: 1204;
// Unable to open the network connection profile.
ERROR_CANNOT_OPEN_PROFILE :: 1205;
// The network connection profile is corrupted.
ERROR_BAD_PROFILE :: 1206;
// Cannot enumerate a noncontainer.
ERROR_NOT_CONTAINER :: 1207;
// An extended error has occurred.
ERROR_EXTENDED_ERROR :: 1208;
// The format of the specified group name is invalid.
ERROR_INVALID_GROUPNAME :: 1209;
// The format of the specified computer name is invalid.
ERROR_INVALID_COMPUTERNAME :: 1210;
// The format of the specified event name is invalid.
ERROR_INVALID_EVENTNAME :: 1211;
// The format of the specified domain name is invalid.
ERROR_INVALID_DOMAINNAME :: 1212;
// The format of the specified service name is invalid.
ERROR_INVALID_SERVICENAME :: 1213;
// The format of the specified network name is invalid.
ERROR_INVALID_NETNAME :: 1214;
// The format of the specified share name is invalid.
ERROR_INVALID_SHARENAME :: 1215;
// The format of the specified password is invalid.
ERROR_INVALID_PASSWORDNAME :: 1216;
// The format of the specified message name is invalid.
ERROR_INVALID_MESSAGENAME :: 1217;
// The format of the specified message destination is invalid.
ERROR_INVALID_MESSAGEDEST :: 1218;
// The credentials supplied conflict with an existing set of credentials.
ERROR_SESSION_CREDENTIAL_CONFLICT :: 1219;
// An attempt was made to establish a session to a network server, but there are already too many sessions established to that server.
ERROR_REMOTE_SESSION_LIMIT_EXCEEDED :: 1220;
// The workgroup or domain name is already in use by another computer on the network.
ERROR_DUP_DOMAINNAME :: 1221;
// The network is not present or not started.
ERROR_NO_NETWORK :: 1222;
// The operation was canceled by the user.
ERROR_CANCELED :: 1223;
// The requested operation cannot be performed on a file with a user-mapped section open.
ERROR_USER_MAPPED_FILE :: 1224;
// The remote system refused the network connection.
ERROR_CONNECTION_REFUSED :: 1225;
// The network connection was gracefully closed.
ERROR_GRACEFUL_DISCONNECT :: 1226;
// The network transport endpoint already has an address associated with it.
ERROR_ADDRESS_ALREADY_ASSOCIATED :: 1227;
// An address has not yet been associated with the network endpoint.
ERROR_ADDRESS_NOT_ASSOCIATED :: 1228;
// An operation was attempted on a nonexistent network connection.
ERROR_CONNECTION_INVALID :: 1229;
// An invalid operation was attempted on an active network connection.
ERROR_CONNECTION_ACTIVE :: 1230;
// The remote network is not reachable by the transport.
ERROR_NETWORK_UNREACHABLE :: 1231;
// The remote system is not reachable by the transport.
ERROR_HOST_UNREACHABLE :: 1232;
// The remote system does not support the transport protocol.
ERROR_PROTOCOL_UNREACHABLE :: 1233;
// No service is operating at the destination network endpoint on the remote system.
ERROR_PORT_UNREACHABLE :: 1234;
// The request was aborted.
ERROR_REQUEST_ABORTED :: 1235;
// The network connection was aborted by the local system.
ERROR_CONNECTION_ABORTED :: 1236;
// The operation could not be completed. A retry should be performed.
ERROR_RETRY :: 1237;
// A connection to the server could not be made because the limit on the number of concurrent connections for this account has been reached.
ERROR_CONNECTION_COUNT_LIMIT :: 1238;
// Attempting to log in during an unauthorized time of day for this account.
ERROR_LOGIN_TIME_RESTRICTION :: 1239;
// The account is not authorized to log in from this station.
ERROR_LOGIN_WKSTA_RESTRICTION :: 1240;
// The network address could not be used for the operation requested.
ERROR_INCORRECT_ADDRESS :: 1241;
// The service is already registered.
ERROR_ALREADY_REGISTERED :: 1242;
// The specified service does not exist.
ERROR_SERVICE_NOT_FOUND :: 1243;
// The operation being requested was not performed because the user has not been authenticated.
ERROR_NOT_AUTHENTICATED :: 1244;
// The operation being requested was not performed because the user has not logged on to the network. The specified service does not exist.
ERROR_NOT_LOGGED_ON :: 1245;
// Continue with work in progress.
ERROR_CONTINUE :: 1246;
// An attempt was made to perform an initialization operation when initialization has already been completed.
ERROR_ALREADY_INITIALIZED :: 1247;
// No more local devices.
ERROR_NO_MORE_DEVICES :: 1248;
// The specified site does not exist.
ERROR_NO_SUCH_SITE :: 1249;
// A domain controller with the specified name already exists.
ERROR_DOMAIN_CONTROLLER_EXISTS :: 1250;
// This operation is supported only when you are connected to the server.
ERROR_ONLY_IF_CONNECTED :: 1251;
// Not all privileges referenced are assigned to the caller.
ERROR_NOT_ALL_ASSIGNED :: 1300;
// Some mapping between account names and security IDs was not done.
ERROR_SOME_NOT_MAPPED :: 1301;
// No system quota limits are specifically set for this account.
ERROR_NO_QUOTAS_FOR_ACCOUNT :: 1302;
// No encryption key is available. A well-known encryption key was returned.
ERROR_LOCAL_USER_SESSION_KEY :: 1303;
// The Windows NT password is too complex to be converted to a LAN Manager password. The LAN Manager password returned is a NULL string.
ERROR_NULL_LM_PASSWORD :: 1304;
// The revision level is unknown.
ERROR_UNKNOWN_REVISION :: 1305;
// Indicates two revision levels are incompatible.
ERROR_REVISION_MISMATCH :: 1306;
// This security ID cannot be assigned as the owner of this object.
ERROR_INVALID_OWNER :: 1307;
// This security ID cannot be assigned as the primary group of an object.
ERROR_INVALID_PRIMARY_GROUP :: 1308;
// An attempt has been made to operate on an impersonation token by a thread that is not currently impersonating a client.
ERROR_NO_IMPERSONATION_TOKEN :: 1309;
// The group cannot be disabled.
ERROR_CANT_DISABLE_MANDATORY :: 1310;
// There are currently no logon servers available to service the logon request.
ERROR_NO_LOGON_SERVERS :: 1311;
// A specified logon session does not exist. It can already have been terminated.
ERROR_NO_SUCH_LOGON_SESSION :: 1312;
// A specified privilege does not exist.
ERROR_NO_SUCH_PRIVILEGE :: 1313;
// A required privilege is not held by the client.
ERROR_PRIVILEGE_NOT_HELD :: 1314;
// The name provided is not a properly formed account name.
ERROR_INVALID_ACCOUNT_NAME :: 1315;
// The specified user already exists.
ERROR_USER_EXISTS :: 1316;
// The specified user does not exist.
ERROR_NO_SUCH_USER :: 1317;
// The specified group already exists.
ERROR_GROUP_EXISTS :: 1318;
// The specified group does not exist.
ERROR_NO_SUCH_GROUP :: 1319;
// Either the specified user account is already a member of the specified group, or the specified group cannot be deleted because it contains a member.
ERROR_MEMBER_IN_GROUP :: 1320;
// The specified user account is not a member of the specified group account.
ERROR_MEMBER_NOT_IN_GROUP :: 1321;
// The last remaining administration account cannot be disabled or deleted.
ERROR_LAST_ADMIN :: 1322;
// Unable to update the password. The value provided as the current password is incorrect.
ERROR_WRONG_PASSWORD :: 1323;
// Unable to update the password. The value provided for the new password contains values that are not allowed in passwords.
ERROR_ILL_FORMED_PASSWORD :: 1324;
// Unable to update the password because a password update rule has been violated.
ERROR_PASSWORD_RESTRICTION :: 1325;
// Logon failure: unknown user name or bad password.
ERROR_LOGON_FAILURE :: 1326;
// Logon failure: user account restriction.
ERROR_ACCOUNT_RESTRICTION :: 1327;
// Logon failure: account logon time restriction violation.
ERROR_INVALID_LOGON_HOURS :: 1328;
// Logon failure: user not allowed to log on to this computer.
ERROR_INVALID_WORKSTATION :: 1329;
// Logon failure: the specified account password has expired.
ERROR_PASSWORD_EXPIRED :: 1330;
// Logon failure: account currently disabled.
ERROR_ACCOUNT_DISABLED :: 1331;
// No mapping between account names and security IDs was done.
ERROR_NONE_MAPPED :: 1332;
// Too many local user identifiers (LUIDs) were requested at one time.
ERROR_TOO_MANY_LUIDS_REQUESTED :: 1333;
// No more local user identifiers (LUIDs) are available.
ERROR_LUIDS_EXHAUSTED :: 1334;
// The subauthority part of a security ID is invalid for this particular use.
ERROR_INVALID_SUB_AUTHORITY :: 1335;
// The access control list (ACL) structure is invalid.
ERROR_INVALID_ACL :: 1336;
// The security ID structure is invalid.
ERROR_INVALID_SID :: 1337;
// The security descriptor structure is invalid.
ERROR_INVALID_SECURITY_DESCR :: 1338;
// The inherited access control list (ACL) or access control entry (ACE) could not be built.
ERROR_BAD_INHERITANCE_ACL :: 1340;
// The server is currently disabled.
ERROR_SERVER_DISABLED :: 1341;
// The server is currently enabled.
ERROR_SERVER_NOT_DISABLED :: 1342;
// The value provided was an invalid value for an identifier authority.
ERROR_INVALID_ID_AUTHORITY :: 1343;
// No more memory is available for security information updates.
ERROR_ALLOTTED_SPACE_EXCEEDED :: 1344;
// The specified attributes are invalid, or incompatible with the attributes for the group as a whole.
ERROR_INVALID_GROUP_ATTRIBUTES :: 1345;
// Either a required impersonation level was not provided, or the provided impersonation level is invalid.
ERROR_BAD_IMPERSONATION_LEVEL :: 1346;
// Cannot open an anonymous level security token.
ERROR_CANT_OPEN_ANONYMOUS :: 1347;
// The validation information class requested was invalid.
ERROR_BAD_VALIDATION_CLASS :: 1348;
// The type of the token is inappropriate for its attempted use.
ERROR_BAD_TOKEN_TYPE :: 1349;
// Unable to perform a security operation on an object that has no associated security.
ERROR_NO_SECURITY_ON_OBJECT :: 1350;
// Configuration information could not be read from the domain controller, either because the machine is unavailable, or access has been denied.
ERROR_CANT_ACCESS_DOMAIN_INFO :: 1351;
// The security account manager (SAM) or local security authority (LSA) server was in the wrong state to perform the security operation.
ERROR_INVALID_SERVER_STATE :: 1352;
// The domain was in the wrong state to perform the security operation.
ERROR_INVALID_DOMAIN_STATE :: 1353;
// This operation is only allowed for the Primary Domain Controller of the domain.
ERROR_INVALID_DOMAIN_ROLE :: 1354;
// The specified domain did not exist.
ERROR_NO_SUCH_DOMAIN :: 1355;
// The specified domain already exists.
ERROR_DOMAIN_EXISTS :: 1356;
// An attempt was made to exceed the limit on the number of domains per server.
ERROR_DOMAIN_LIMIT_EXCEEDED :: 1357;
// Unable to complete the requested operation because of either a catastrophic media failure or a data structure corruption on the disk.
ERROR_INTERNAL_DB_CORRUPTION :: 1358;
// The security account database contains an internal inconsistency.
ERROR_INTERNAL_ERROR :: 1359;
// Generic access types were contained in an access mask which should already be mapped to nongeneric types.
ERROR_GENERIC_NOT_MAPPED :: 1360;
// A security descriptor is not in the right format (absolute or self-relative).
ERROR_BAD_DESCRIPTOR_FORMAT :: 1361;
// The requested action is restricted for use by logon processes only. The calling process has not registered as a logon process.
ERROR_NOT_LOGON_PROCESS :: 1362;
// Cannot start a new logon session with an ID that is already in use.
ERROR_LOGON_SESSION_EXISTS :: 1363;
// A specified authentication package is unknown.
ERROR_NO_SUCH_PACKAGE :: 1364;
// The logon session is not in a state that is consistent with the requested operation.
ERROR_BAD_LOGON_SESSION_STATE :: 1365;
// The logon session ID is already in use.
ERROR_LOGON_SESSION_COLLISION :: 1366;
// A logon request contained an invalid logon type value.
ERROR_INVALID_LOGON_TYPE :: 1367;
// Unable to impersonate using a named pipe until data has been read from that pipe.
ERROR_CANNOT_IMPERSONATE :: 1368;
// The transaction state of a registry subtree is incompatible with the requested operation.
ERROR_RXACT_INVALID_STATE :: 1369;
// An internal security database corruption has been encountered.
ERROR_RXACT_COMMIT_FAILURE :: 1370;
// Cannot perform this operation on built-in accounts.
ERROR_SPECIAL_ACCOUNT :: 1371;
// Cannot perform this operation on this built-in special group.
ERROR_SPECIAL_GROUP :: 1372;
// Cannot perform this operation on this built-in special user.
ERROR_SPECIAL_USER :: 1373;
// The user cannot be removed from a group because the group is currently the user's primary group.
ERROR_MEMBERS_PRIMARY_GROUP :: 1374;
// The token is already in use as a primary token.
ERROR_TOKEN_ALREADY_IN_USE :: 1375;
// The specified local group does not exist.
ERROR_NO_SUCH_ALIAS :: 1376;
// The specified account name is not a member of the local group.
ERROR_MEMBER_NOT_IN_ALIAS :: 1377;
// The specified account name is already a member of the local group.
ERROR_MEMBER_IN_ALIAS :: 1378;
// The specified local group already exists.
ERROR_ALIAS_EXISTS :: 1379;
// Logon failure: the user has not been granted the requested logon type at this computer.
ERROR_LOGON_NOT_GRANTED :: 1380;
// The maximum number of secrets that can be stored in a single system has been exceeded.
ERROR_TOO_MANY_SECRETS :: 1381;
// The length of a secret exceeds the maximum length allowed.
ERROR_SECRET_TOO_LONG :: 1382;
// The local security authority database contains an internal inconsistency.
ERROR_INTERNAL_DB_ERROR :: 1383;
// During a logon attempt, the user's security context accumulated too many security IDs.
ERROR_TOO_MANY_CONTEXT_IDS :: 1384;
// Logon failure: the user has not been granted the requested logon type at this computer.
ERROR_LOGON_TYPE_NOT_GRANTED :: 1385;
// A cross-encrypted password is necessary to change a user password.
ERROR_NT_CROSS_ENCRYPTION_REQUIRED :: 1386;
// A new member could not be added to a local group because the member does not exist.
ERROR_NO_SUCH_MEMBER :: 1387;
// A new member could not be added to a local group because the member has the wrong account type.
ERROR_INVALID_MEMBER :: 1388;
// Too many security IDs have been specified.
ERROR_TOO_MANY_SIDS :: 1389;
// A cross-encrypted password is necessary to change this user password.
ERROR_LM_CROSS_ENCRYPTION_REQUIRED :: 1390;
// Indicates an ACL contains no inheritable components.
ERROR_NO_INHERITANCE :: 1391;
// The file or directory is corrupted and unreadable.
ERROR_FILE_CORRUPT :: 1392;
// The disk structure is corrupted and unreadable.
ERROR_DISK_CORRUPT :: 1393;
// There is no user session key for the specified logon session.
ERROR_NO_USER_SESSION_KEY :: 1394;
// The service being accessed is licensed for a particular number of connections. No more connections can be made to the service at this time because there are already as many connections as the service can accept.
ERROR_LICENSE_QUOTA_EXCEEDED :: 1395;
// Logon Failure: The target account name is incorrect.
ERROR_WRONG_TARGET_NAME :: 1396;
// Mutual Authentication failed. The server's password is out of date at the domain controller.
ERROR_MUTUAL_AUTH_FAILED :: 1397;
// There is a time difference between the client and server.
ERROR_TIME_SKEW :: 1398;
// Invalid window handle.
ERROR_INVALID_WINDOW_HANDLE :: 1400;
// Invalid menu handle.
ERROR_INVALID_MENU_HANDLE :: 1401;
// Invalid cursor handle.
ERROR_INVALID_CURSOR_HANDLE :: 1402;
// Invalid accelerator table handle.
ERROR_INVALID_ACCEL_HANDLE :: 1403;
// Invalid hook handle.
ERROR_INVALID_HOOK_HANDLE :: 1404;
// Invalid handle to a multiple-window position structure.
ERROR_INVALID_DWP_HANDLE :: 1405;
// Cannot create a top-level child window.
ERROR_TLW_WITH_WSCHILD :: 1406;
// Cannot find window class.
ERROR_CANNOT_FIND_WND_CLASS :: 1407;
// Invalid window; it belongs to other thread.
ERROR_WINDOW_OF_OTHER_THREAD :: 1408;
// Hot key is already registered.
ERROR_HOTKEY_ALREADY_REGISTERED :: 1409;
// Class already exists.
ERROR_CLASS_ALREADY_EXISTS :: 1410;
// Class does not exist.
ERROR_CLASS_DOES_NOT_EXIST :: 1411;
// Class still has open windows.
ERROR_CLASS_HAS_WINDOWS :: 1412;
// Invalid index.
ERROR_INVALID_INDEX :: 1413;
// Invalid icon handle.
ERROR_INVALID_ICON_HANDLE :: 1414;
// Using private DIALOG window words.
ERROR_PRIVATE_DIALOG_INDEX :: 1415;
// The list box identifier was not found.
ERROR_LISTBOX_ID_NOT_FOUND :: 1416;
// No wildcards were found.
ERROR_NO_WILDCARD_CHARACTERS :: 1417;
// Thread does not have a clipboard open.
ERROR_CLIPBOARD_NOT_OPEN :: 1418;
// Hot key is not registered.
ERROR_HOTKEY_NOT_REGISTERED :: 1419;
// The window is not a valid dialog window.
ERROR_WINDOW_NOT_DIALOG :: 1420;
// Control ID not found.
ERROR_CONTROL_ID_NOT_FOUND :: 1421;
// Invalid message for a combo box because it does not have an edit control.
ERROR_INVALID_COMBOBOX_MESSAGE :: 1422;
// The window is not a combo box.
ERROR_WINDOW_NOT_COMBOBOX :: 1423;
// Height must be less than 256.
ERROR_INVALID_EDIT_HEIGHT :: 1424;
// Invalid device context (DC) handle.
ERROR_DC_NOT_FOUND :: 1425;
// Invalid hook procedure type.
ERROR_INVALID_HOOK_FILTER :: 1426;
// Invalid hook procedure.
ERROR_INVALID_FILTER_PROC :: 1427;
// Cannot set nonlocal hook without a module handle.
ERROR_HOOK_NEEDS_HMOD :: 1428;
// This hook procedure can only be set globally.
ERROR_GLOBAL_ONLY_HOOK :: 1429;
// The journal hook procedure is already installed.
ERROR_JOURNAL_HOOK_SET :: 1430;
// The hook procedure is not installed.
ERROR_HOOK_NOT_INSTALLED :: 1431;
// Invalid message for single-selection list box.
ERROR_INVALID_LB_MESSAGE :: 1432;
// LB_SETCOUNT sent to non-lazy list box.
ERROR_SETCOUNT_ON_BAD_LB :: 1433;
// This list box does not support tab stops.
ERROR_LB_WITHOUT_TABSTOPS :: 1434;
// Cannot destroy object created by another thread.
ERROR_DESTROY_OBJECT_OF_OTHER_THREAD :: 1435;
// Child windows cannot have menus.
ERROR_CHILD_WINDOW_MENU :: 1436;
// The window does not have a system menu.
ERROR_NO_SYSTEM_MENU :: 1437;
// Invalid message box style.
ERROR_INVALID_MSGBOX_STYLE :: 1438;
// Invalid system-wide (SPI_*) parameter.
ERROR_INVALID_SPI_VALUE :: 1439;
// Screen already locked.
ERROR_SCREEN_ALREADY_LOCKED :: 1440;
// All handles to windows in a multiple-window position structure must have the same parent.
ERROR_HWNDS_HAVE_DIFF_PARENT :: 1441;
// The window is not a child window.
ERROR_NOT_CHILD_WINDOW :: 1442;
// Invalid GW_* command.
ERROR_INVALID_GW_COMMAND :: 1443;
// Invalid thread identifier.
ERROR_INVALID_THREAD_ID :: 1444;
// Cannot process a message from a window that is not a multiple document interface (MDI) window.
ERROR_NON_MDICHILD_WINDOW :: 1445;
// Context menu already active.
ERROR_POPUP_ALREADY_ACTIVE :: 1446;
// The window does not have scroll bars.
ERROR_NO_SCROLLBARS :: 1447;
// Scroll bar range cannot be greater than 0x7FFF.
ERROR_INVALID_SCROLLBAR_RANGE :: 1448;
// Cannot show or remove the window in the way specified.
ERROR_INVALID_SHOWWIN_COMMAND :: 1449;
// Insufficient system resources exist to complete the requested service.
ERROR_NO_SYSTEM_RESOURCES :: 1450;
// Insufficient system resources exist to complete the requested service.
ERROR_NONPAGED_SYSTEM_RESOURCES :: 1451;
// Insufficient system resources exist to complete the requested service.
ERROR_PAGED_SYSTEM_RESOURCES :: 1452;
// Insufficient quota to complete the requested service.
ERROR_WORKING_SET_QUOTA :: 1453;
// Insufficient quota to complete the requested service.
ERROR_PAGEFILE_QUOTA :: 1454;
// The paging file is too small for this operation to complete.
ERROR_COMMITMENT_LIMIT :: 1455;
// A menu item was not found.
ERROR_MENU_ITEM_NOT_FOUND :: 1456;
// Invalid keyboard layout handle.
ERROR_INVALID_KEYBOARD_HANDLE :: 1457;
// Hook type not allowed.
ERROR_HOOK_TYPE_NOT_ALLOWED :: 1458;
// This operation requires an interactive window station.
ERROR_REQUIRES_INTERACTIVE_WINDOWSTATION :: 1459;
// This operation returned because the timeout period expired.
ERROR_TIMEOUT :: 1460;
// Invalid monitor handle.
ERROR_INVALID_MONITOR_HANDLE :: 1461;
// The event log file is corrupted.
ERROR_EVENTLOG_FILE_CORRUPT :: 1500;
// No event log file could be opened, so the event logging service did not start.
ERROR_EVENTLOG_CANT_START :: 1501;
// The event log file is full.
ERROR_LOG_FILE_FULL :: 1502;
// The event log file has changed between read operations.
ERROR_EVENTLOG_FILE_CHANGED :: 1503;
// Failure accessing installation service.
ERROR_INSTALL_SERVICE_FAILURE :: 1601;
// User canceled installation.
ERROR_INSTALL_USEREXIT :: 1602;
// Fatal error during installation.
ERROR_INSTALL_FAILURE :: 1603;
// Installation suspended, incomplete.
ERROR_INSTALL_SUSPEND :: 1604;
// Product is not installed.
ERROR_UNKNOWN_PRODUCT :: 1605;
// Feature ID not registered.
ERROR_UNKNOWN_FEATURE :: 1606;
// Component ID not registered.
ERROR_UNKNOWN_COMPONENT :: 1607;
// Unknown property.
ERROR_UNKNOWN_PROPERTY :: 1608;
// Handle is in an invalid state.
ERROR_INVALID_HANDLE_STATE :: 1609;
// Configuration data corrupt.
ERROR_BAD_CONFIGURATION :: 1610;
// Component qualifier not present.
ERROR_INDEX_ABSENT :: 1611;
// Install source unavailable.
ERROR_INSTALL_SOURCE_ABSENT :: 1612;
// Database version unsupported.
ERROR_INSTALL_PACKAGE_VERSION :: 1613;
// Product is uninstalled.
ERROR_PRODUCT_UNINSTALLED :: 1614;
// SQL query syntax invalid or unsupported.
ERROR_BAD_QUERY_SYNTAX :: 1615;
// Record field does not exist.
ERROR_INVALID_FIELD :: 1616;
// The device has been removed.
ERROR_DEVICE_REMOVED :: 1617;
// An installation is in progress.
ERROR_INSTALL_ALREADY_RUNNING :: 1618;
// Installation package could not be opened.
ERROR_INSTALL_PACKAGE_OPEN_FAILED :: 1619;
// Installation package invalid.
ERROR_INSTALL_PACKAGE_INVALID :: 1620;
// Could not initialize installer UserInterface.
ERROR_INSTALL_UI_FAILURE :: 1621;
// Error opening installation log file.
ERROR_INSTALL_LOG_FAILURE :: 1622;
// Product language not supported by system.
ERROR_INSTALL_LANGUAGE_UNSUPPORTED :: 1623;
// Error applying transform to install package.
ERROR_INSTALL_TRANSFORM_FAILURE :: 1624;
// Install package signature not accepted.
ERROR_INSTALL_PACKAGE_REJECTED :: 1625;
// Function could not be executed.
ERROR_FUNCTION_NOT_CALLED :: 1626;
// Function failed during execution.
ERROR_FUNCTION_FAILED :: 1627;
// Invalid or unknown table specified.
ERROR_INVALID_TABLE :: 1628;
// Data supplied is of wrong type.
ERROR_DATATYPE_MISMATCH :: 1629;
// Data of this type is not supported.
ERROR_UNSUPPORTED_TYPE :: 1630;
// Unable to create requested object.
ERROR_CREATE_FAILED :: 1631;
// Temp folder is full or inaccessible.
ERROR_INSTALL_TEMP_UNWRITABLE :: 1632;
// Product platform not supported.
ERROR_INSTALL_PLATFORM_UNSUPPORTED :: 1633;
// Component not used on this computer.
ERROR_INSTALL_NOTUSED :: 1634;
// Patch package could not be opened.
ERROR_PATCH_PACKAGE_OPEN_FAILED :: 1635;
// Patch package invalid.
ERROR_PATCH_PACKAGE_INVALID :: 1636;
// Patch package unsupported.
ERROR_PATCH_PACKAGE_UNSUPPORTED :: 1637;
// Invalid command line argument.
ERROR_INVALID_COMMAND_LINE :: 1638;
// The string binding is invalid.
RPC_S_INVALID_STRING_BINDING :: 1700;
// The binding handle is not the correct type.
RPC_S_WRONG_KIND_OF_BINDING :: 1701;
// The binding handle is invalid.
RPC_S_INVALID_BINDING :: 1702;
// The RPC protocol sequence is not supported.
RPC_S_PROTSEQ_NOT_SUPPORTED :: 1703;
// The RPC protocol sequence is invalid.
RPC_S_INVALID_RPC_PROTSEQ :: 1704;
// The string universal unique identifier (UUID) is invalid.
RPC_S_INVALID_STRING_UUID :: 1705;
// The endpoint format is invalid.
RPC_S_INVALID_ENDPOINT_FORMAT :: 1706;
// The network address is invalid.
RPC_S_INVALID_NET_ADDR :: 1707;
// No endpoint was found.
RPC_S_NO_ENDPOINT_FOUND :: 1708;
// The timeout value is invalid.
RPC_S_INVALID_TIMEOUT :: 1709;
// The object universal unique identifier (UUID) was not found.
RPC_S_OBJECT_NOT_FOUND :: 1710;
// The object universal unique identifier (UUID) has already been registered.
RPC_S_ALREADY_REGISTERED :: 1711;
// The type universal unique identifier (UUID) has already been registered.
RPC_S_TYPE_ALREADY_REGISTERED :: 1712;
// The RPC server is already listening.
RPC_S_ALREADY_LISTENING :: 1713;
// No protocol sequences have been registered.
RPC_S_NO_PROTSEQS_REGISTERED :: 1714;
// The RPC server is not listening.
RPC_S_NOT_LISTENING :: 1715;
// The manager type is unknown.
RPC_S_UNKNOWN_MGR_TYPE :: 1716;
// The interface is unknown.
RPC_S_UNKNOWN_IF :: 1717;
// There are no bindings.
RPC_S_NO_BINDINGS :: 1718;
// There are no protocol sequences.
RPC_S_NO_PROTSEQS :: 1719;
// The endpoint cannot be created.
RPC_S_CANT_CREATE_ENDPOINT :: 1720;
// Not enough resources are available to complete this operation.
RPC_S_OUT_OF_RESOURCES :: 1721;
// The RPC server is unavailable.
RPC_S_SERVER_UNAVAILABLE :: 1722;
// The RPC server is too busy to complete this operation.
RPC_S_SERVER_TOO_BUSY :: 1723;
// The network options are invalid.
RPC_S_INVALID_NETWORK_OPTIONS :: 1724;
// There are no remote procedure calls active on this thread.
RPC_S_NO_CALL_ACTIVE :: 1725;
// The remote procedure call failed.
RPC_S_CALL_FAILED :: 1726;
// The remote procedure call failed and did not execute.
RPC_S_CALL_FAILED_DNE :: 1727;
// A remote procedure call (RPC) protocol error occurred.
RPC_S_PROTOCOL_ERROR :: 1728;
// The transfer syntax is not supported by the RPC server.
RPC_S_UNSUPPORTED_TRANS_SYN :: 1730;
// The universal unique identifier (UUID) type is not supported.
RPC_S_UNSUPPORTED_TYPE :: 1732;
// The tag is invalid.
RPC_S_INVALID_TAG :: 1733;
// The array bounds are invalid.
RPC_S_INVALID_BOUND :: 1734;
// The binding does not contain an entry name.
RPC_S_NO_ENTRY_NAME :: 1735;
// The name syntax is invalid.
RPC_S_INVALID_NAME_SYNTAX :: 1736;
// The name syntax is not supported.
RPC_S_UNSUPPORTED_NAME_SYNTAX :: 1737;
// No network address is available to use to construct a universal unique identifier (UUID).
RPC_S_UUID_NO_ADDRESS :: 1739;
// The endpoint is a duplicate.
RPC_S_DUPLICATE_ENDPOINT :: 1740;
// The authentication type is unknown.
RPC_S_UNKNOWN_AUTHN_TYPE :: 1741;
// The maximum number of calls is too small.
RPC_S_MAX_CALLS_TOO_SMALL :: 1742;
// The string is too long.
RPC_S_STRING_TOO_LONG :: 1743;
// The RPC protocol sequence was not found.
RPC_S_PROTSEQ_NOT_FOUND :: 1744;
// The procedure number is out of range.
RPC_S_PROCNUM_OUT_OF_RANGE :: 1745;
// The binding does not contain any authentication information.
RPC_S_BINDING_HAS_NO_AUTH :: 1746;
// The authentication service is unknown.
RPC_S_UNKNOWN_AUTHN_SERVICE :: 1747;
// The authentication level is unknown.
RPC_S_UNKNOWN_AUTHN_LEVEL :: 1748;
// The security context is invalid.
RPC_S_INVALID_AUTH_IDENTITY :: 1749;
// The authorization service is unknown.
RPC_S_UNKNOWN_AUTHZ_SERVICE :: 1750;
// The entry is invalid.
EPT_S_INVALID_ENTRY :: 1751;
// The server endpoint cannot perform the operation.
EPT_S_CANT_PERFORM_OP :: 1752;
// There are no more endpoints available from the endpoint mapper.
EPT_S_NOT_REGISTERED :: 1753;
// No interfaces have been exported.
RPC_S_NOTHING_TO_EXPORT :: 1754;
// The entry name is incomplete.
RPC_S_INCOMPLETE_NAME :: 1755;
// The version option is invalid.
RPC_S_INVALID_VERS_OPTION :: 1756;
// There are no more members.
RPC_S_NO_MORE_MEMBERS :: 1757;
// There is nothing to unexport.
RPC_S_NOT_ALL_OBJS_UNEXPORTED :: 1758;
// The interface was not found.
RPC_S_INTERFACE_NOT_FOUND :: 1759;
// The entry already exists.
RPC_S_ENTRY_ALREADY_EXISTS :: 1760;
// The entry is not found.
RPC_S_ENTRY_NOT_FOUND :: 1761;
// The name service is unavailable.
RPC_S_NAME_SERVICE_UNAVAILABLE :: 1762;
// The network address family is invalid.
RPC_S_INVALID_NAF_ID :: 1763;
// The requested operation is not supported.
RPC_S_CANNOT_SUPPORT :: 1764;
// No security context is available to allow impersonation.
RPC_S_NO_CONTEXT_AVAILABLE :: 1765;
// An internal error occurred in a remote procedure call (RPC).
RPC_S_INTERNAL_ERROR :: 1766;
// The RPC server attempted an integer division by zero.
RPC_S_ZERO_DIVIDE :: 1767;
// An addressing error occurred in the RPC server.
RPC_S_ADDRESS_ERROR :: 1768;
// A floating-point operation at the RPC server caused a division by zero.
RPC_S_FP_DIV_ZERO :: 1769;
// A floating-point underflow occurred at the RPC server.
RPC_S_FP_UNDERFLOW :: 1770;
// A floating-point overflow occurred at the RPC server.
RPC_S_FP_OVERFLOW :: 1771;
// The list of RPC servers available for the binding of auto handles has been exhausted.
RPC_X_NO_MORE_ENTRIES :: 1772;
// Unable to open the character translation table file.
RPC_X_SS_CHAR_TRANS_OPEN_FAIL :: 1773;
// The file containing the character translation table has fewer than 512 bytes.
RPC_X_SS_CHAR_TRANS_SHORT_FILE :: 1774;
// A null context handle was passed from the client to the host during a remote procedure call.
RPC_X_SS_IN_NULL_CONTEXT :: 1775;
// The context handle changed during a remote procedure call.
RPC_X_SS_CONTEXT_DAMAGED :: 1777;
// The binding handles passed to a remote procedure call do not match.
RPC_X_SS_HANDLES_MISMATCH :: 1778;
// The stub is unable to get the remote procedure call handle.
RPC_X_SS_CANNOT_GET_CALL_HANDLE :: 1779;
// A null reference pointer was passed to the stub.
RPC_X_NULL_REF_POINTER :: 1780;
// The enumeration value is out of range.
RPC_X_ENUM_VALUE_OUT_OF_RANGE :: 1781;
// The byte count is too small.
RPC_X_BYTE_COUNT_TOO_SMALL :: 1782;
// The stub received bad data.
RPC_X_BAD_STUB_DATA :: 1783;
// The supplied user buffer is not valid for the requested operation.
ERROR_INVALID_USER_BUFFER :: 1784;
// The disk media is not recognized. It cannot be formatted.
ERROR_UNRECOGNIZED_MEDIA :: 1785;
// The workstation does not have a trust secret.
ERROR_NO_TRUST_LSA_SECRET :: 1786;
// The SAM database on the Windows NT Server does not have a computer account for this workstation trust relationship.
ERROR_NO_TRUST_SAM_ACCOUNT :: 1787;
// The trust relationship between the primary domain and the trusted domain failed.
ERROR_TRUSTED_DOMAIN_FAILURE :: 1788;
// The trust relationship between this workstation and the primary domain failed.
ERROR_TRUSTED_RELATIONSHIP_FAILURE :: 1789;
// The network logon failed.
ERROR_TRUST_FAILURE :: 1790;
// A remote procedure call is already in progress for this thread.
RPC_S_CALL_IN_PROGRESS :: 1791;
// An attempt was made to logon, but the network logon service was not started.
ERROR_NETLOGON_NOT_STARTED :: 1792;
// The user's account has expired.
ERROR_ACCOUNT_EXPIRED :: 1793;
// The redirector is in use and cannot be unloaded.
ERROR_REDIRECTOR_HAS_OPEN_HANDLES :: 1794;
// The specified printer driver is already installed.
ERROR_PRINTER_DRIVER_ALREADY_INSTALLED :: 1795;
// The specified port is unknown.
ERROR_UNKNOWN_PORT :: 1796;
// The printer driver is unknown.
ERROR_UNKNOWN_PRINTER_DRIVER :: 1797;
// The print processor is unknown.
ERROR_UNKNOWN_PRINTPROCESSOR :: 1798;
// The specified separator file is invalid.
ERROR_INVALID_SEPARATOR_FILE :: 1799;
// The specified priority is invalid.
ERROR_INVALID_PRIORITY :: 1800;
// The printer name is invalid.
ERROR_INVALID_PRINTER_NAME :: 1801;
// The printer already exists.
ERROR_PRINTER_ALREADY_EXISTS :: 1802;
// The printer command is invalid.
ERROR_INVALID_PRINTER_COMMAND :: 1803;
// The specified datatype is invalid.
ERROR_INVALID_DATATYPE :: 1804;
// The environment specified is invalid.
ERROR_INVALID_ENVIRONMENT :: 1805;
// There are no more bindings.
RPC_S_NO_MORE_BINDINGS :: 1806;
// The account used is an interdomain trust account. Use your global user account or local user account to access this server.
ERROR_NOLOGON_INTERDOMAIN_TRUST_ACCOUNT :: 1807;
// The account used is a computer account. Use your global user account or local user account to access this server.
ERROR_NOLOGON_WORKSTATION_TRUST_ACCOUNT :: 1808;
// The account used is a server trust account. Use your global user account or local user account to access this server.
ERROR_NOLOGON_SERVER_TRUST_ACCOUNT :: 1809;
// The name or security ID (SID) of the domain specified is inconsistent with the trust information for that domain.
ERROR_DOMAIN_TRUST_INCONSISTENT :: 1810;
// The server is in use and cannot be unloaded.
ERROR_SERVER_HAS_OPEN_HANDLES :: 1811;
// The specified image file did not contain a resource section.
ERROR_RESOURCE_DATA_NOT_FOUND :: 1812;
// The specified resource type cannot be found in the image file.
ERROR_RESOURCE_TYPE_NOT_FOUND :: 1813;
// The specified resource name cannot be found in the image file.
ERROR_RESOURCE_NAME_NOT_FOUND :: 1814;
// The specified resource language ID cannot be found in the image file.
ERROR_RESOURCE_LANG_NOT_FOUND :: 1815;
// Not enough quota is available to process this command.
ERROR_NOT_ENOUGH_QUOTA :: 1816;
// No interfaces have been registered.
RPC_S_NO_INTERFACES :: 1817;
// The remote procedure call was canceled.
RPC_S_CALL_CANCELED :: 1818;
// The binding handle does not contain all required information.
RPC_S_BINDING_INCOMPLETE :: 1819;
// A communications failure occurred during a remote procedure call.
RPC_S_COMM_FAILURE :: 1820;
// The requested authentication level is not supported.
RPC_S_UNSUPPORTED_AUTHN_LEVEL :: 1821;
// No principal name registered.
RPC_S_NO_PRINC_NAME :: 1822;
// The error specified is not a valid Windows RPC error code.
RPC_S_NOT_RPC_ERROR :: 1823;
// A UUID that is valid only on this computer has been allocated.
RPC_S_UUID_LOCAL_ONLY :: 1824;
// A security package specific error occurred.
RPC_S_SEC_PKG_ERROR :: 1825;
// Thread is not canceled.
RPC_S_NOT_CANCELED :: 1826;
// Invalid operation on the encoding/decoding handle.
RPC_X_INVALID_ES_ACTION :: 1827;
// Incompatible version of the serializing package.
RPC_X_WRONG_ES_VERSION :: 1828;
// Incompatible version of the RPC stub.
RPC_X_WRONG_STUB_VERSION :: 1829;
// The RPC pipe object is invalid or corrupted.
RPC_X_INVALID_PIPE_OBJECT :: 1830;
// An invalid operation was attempted on an RPC pipe object.
RPC_X_WRONG_PIPE_ORDER :: 1831;
// Unsupported RPC pipe version.
RPC_X_WRONG_PIPE_VERSION :: 1832;
// The group member was not found.
RPC_S_GROUP_MEMBER_NOT_FOUND :: 1898;
// The endpoint mapper database entry could not be created.
EPT_S_CANT_CREATE :: 1899;
// The object universal unique identifier (UUID) is the nil UUID.
RPC_S_INVALID_OBJECT :: 1900;
// The specified time is invalid.
ERROR_INVALID_TIME :: 1901;
// The specified form name is invalid.
ERROR_INVALID_FORM_NAME :: 1902;
// The specified form size is invalid.
ERROR_INVALID_FORM_SIZE :: 1903;
// The specified printer handle is already being waited on
ERROR_ALREADY_WAITING :: 1904;
// The specified printer has been deleted.
ERROR_PRINTER_DELETED :: 1905;
// The state of the printer is invalid.
ERROR_INVALID_PRINTER_STATE :: 1906;
// The user must change his password before he logs on the first time.
ERROR_PASSWORD_MUST_CHANGE :: 1907;
// Could not find the domain controller for this domain.
ERROR_DOMAIN_CONTROLLER_NOT_FOUND :: 1908;
// The referenced account is currently locked out and cannot be logged on to.
ERROR_ACCOUNT_LOCKED_OUT :: 1909;
// The object exporter specified was not found.
OR_INVALID_OXID :: 1910;
// The object specified was not found.
OR_INVALID_OID :: 1911;
// The object resolver set specified was not found.
OR_INVALID_SET :: 1912;
// Some data remains to be sent in the request buffer.
RPC_S_SEND_INCOMPLETE :: 1913;
// Invalid asynchronous remote procedure call handle.
RPC_S_INVALID_ASYNC_HANDLE :: 1914;
// Invalid asynchronous RPC call handle for this operation.
RPC_S_INVALID_ASYNC_CALL :: 1915;
// The RPC pipe object has already been closed.
RPC_X_PIPE_CLOSED :: 1916;
// The RPC call completed before all pipes were processed.
RPC_X_PIPE_DISCIPLINE_ERROR :: 1917;
// No more data is available from the RPC pipe.
RPC_X_PIPE_EMPTY :: 1918;
// No site name is available for this machine.
ERROR_NO_SITENAME :: 1919;
// The file cannot be accessed by the system.
ERROR_CANT_ACCESS_FILE :: 1920;
// The name of the file cannot be resolved by the system.
ERROR_CANT_RESOLVE_FILENAME :: 1921;
// The entry is not of the expected type.
RPC_S_ENTRY_TYPE_MISMATCH :: 1922;
// Not all object UUIDs could be exported to the specified entry.
RPC_S_NOT_ALL_OBJS_EXPORTED :: 1923;
// Interface could not be exported to the specified entry.
RPC_S_INTERFACE_NOT_EXPORTED :: 1924;
// The specified profile entry could not be added.
RPC_S_PROFILE_NOT_ADDED :: 1925;
// The specified profile element could not be added.
RPC_S_PRF_ELT_NOT_ADDED :: 1926;
// The specified profile element could not be removed.
RPC_S_PRF_ELT_NOT_REMOVED :: 1927;
// The group element could not be added.
RPC_S_GRP_ELT_NOT_ADDED :: 1928;
// The group element could not be removed. 
RPC_S_GRP_ELT_NOT_REMOVED  :: 1929;
// The pixel format is invalid.
ERROR_INVALID_PIXEL_FORMAT :: 2000;
// The specified driver is invalid.
ERROR_BAD_DRIVER :: 2001;
// The window style or class attribute is invalid for this operation.
ERROR_INVALID_WINDOW_STYLE :: 2002;
// The requested metafile operation is not supported.
ERROR_METAFILE_NOT_SUPPORTED :: 2003;
// The requested transformation operation is not supported.
ERROR_TRANSFORM_NOT_SUPPORTED :: 2004;
// The requested clipping operation is not supported.
ERROR_CLIPPING_NOT_SUPPORTED :: 2005;
// The specified color management module is invalid.
ERROR_INVALID_CMM :: 2010;
// The specified color profile is invalid.
ERROR_INVALID_PROFILE :: 2011;
// The specified tag was not found.
ERROR_TAG_NOT_FOUND :: 2012;
// A required tag is not present.
ERROR_TAG_NOT_PRESENT :: 2013;
// The specified tag is already present.
ERROR_DUPLICATE_TAG :: 2014;
// The specified color profile is not associated with any device.
ERROR_PROFILE_NOT_ASSOCIATED_WITH_DEVICE :: 2015;
// The specified color profile was not found.
ERROR_PROFILE_NOT_FOUND :: 2016;
// The specified color space is invalid.
ERROR_INVALID_COLORSPACE :: 2017;
// Image Color Management is not enabled.
ERROR_ICM_NOT_ENABLED :: 2018;
// There was an error while deleting the color transform.
ERROR_DELETING_ICM_XFORM :: 2019;
// The specified color transform is invalid.
ERROR_INVALID_TRANSFORM :: 2020;
// The specified transform does not match the bitmap's color space.
ERROR_COLORSPACE_MISMATCH :: 2021;
// The specified named color index is not present in the profile.
ERROR_INVALID_COLORINDEX :: 2022;
// The network connection was made successfully, but the user had to be prompted for a password other than the one originally specified.
ERROR_CONNECTED_OTHER_PASSWORD :: 2108;
// The specified username is invalid.
ERROR_BAD_USERNAME :: 2202;
// This network connection does not exist.
ERROR_NOT_CONNECTED :: 2250;
// This network connection has files open or requests pending.
ERROR_OPEN_FILES :: 2401;
// Active connections still exist.
ERROR_ACTIVE_CONNECTIONS :: 2402;
// The device is in use by an active process and cannot be disconnected.
ERROR_DEVICE_IN_USE :: 2404;
// The specified print monitor is unknown.
ERROR_UNKNOWN_PRINT_MONITOR :: 3000;
// The specified printer driver is currently in use.
ERROR_PRINTER_DRIVER_IN_USE :: 3001;
// The spool file was not found.
ERROR_SPOOL_FILE_NOT_FOUND :: 3002;
// A StartDocPrinter call was not issued.
ERROR_SPL_NO_STARTDOC :: 3003;
// An AddJob call was not issued.
ERROR_SPL_NO_ADDJOB :: 3004;
// The specified print processor has already been installed.
ERROR_PRINT_PROCESSOR_ALREADY_INSTALLED :: 3005;
// The specified print monitor has already been installed.
ERROR_PRINT_MONITOR_ALREADY_INSTALLED :: 3006;
// The specified print monitor does not have the required functions.
ERROR_INVALID_PRINT_MONITOR :: 3007;
// The specified print monitor is currently in use.
ERROR_PRINT_MONITOR_IN_USE :: 3008;
// The requested operation is not allowed when there are jobs queued to the printer.
ERROR_PRINTER_HAS_JOBS_QUEUED :: 3009;
// The requested operation is successful. Changes will not be effective until the system reboots.
ERROR_SUCCESS_REBOOT_REQUIRED :: 3010;
// The requested operation is successful. Changes will not be effective until the service is restarted.
ERROR_SUCCESS_RESTART_REQUIRED :: 3011;
// No printers were found.
ERROR_PRINTER_NOT_FOUND :: 3012;
// WINS encountered an error while processing the command.
ERROR_WINS_INTERNAL :: 4000;
// The local WINS cannot be deleted.
ERROR_CAN_NOT_DEL_LOCAL_WINS :: 4001;
// The importation from the file failed.
ERROR_STATIC_INIT :: 4002;
// The backup failed. Was a full backup done before?
ERROR_INC_BACKUP :: 4003;
// The backup failed. Check the directory to which you are backing the database.
ERROR_FULL_BACKUP :: 4004;
// The name does not exist in the WINS database.
ERROR_REC_NON_EXISTENT :: 4005;
// Replication with a nonconfigured partner is not allowed.
ERROR_RPL_NOT_ALLOWED :: 4006;
// The DHCP client has obtained an IP address that is already in use on the network. The local interface will be disabled until the DHCP client can obtain a new address.
ERROR_DHCP_ADDRESS_CONFLICT :: 4100;
// The GUID passed was not recognized as valid by a WMI data provider.
ERROR_WMI_GUID_NOT_FOUND :: 4200;
// The instance name passed was not recognized as valid by a WMI data provider.
ERROR_WMI_INSTANCE_NOT_FOUND :: 4201;
// The data item ID passed was not recognized as valid by a WMI data provider.
ERROR_WMI_ITEMID_NOT_FOUND :: 4202;
// The WMI request could not be completed and should be retried.
ERROR_WMI_TRY_AGAIN :: 4203;
// The WMI data provider could not be located.
ERROR_WMI_DP_NOT_FOUND :: 4204;
// The WMI data provider references an instance set that has not been registered.
ERROR_WMI_UNRESOLVED_INSTANCE_REF :: 4205;
// The WMI data block or event notification has already been enabled.
ERROR_WMI_ALREADY_ENABLED :: 4206;
// The WMI data block is no longer available.
ERROR_WMI_GUID_DISCONNECTED :: 4207;
// The WMI data service is not available.
ERROR_WMI_SERVER_UNAVAILABLE :: 4208;
// The WMI data provider failed to carry out the request.
ERROR_WMI_DP_FAILED :: 4209;
// The WMI MOF information is not valid.
ERROR_WMI_INVALID_MOF :: 4210;
// The WMI registration information is not valid.
ERROR_WMI_INVALID_REGINFO :: 4211;
// The WMI data block or event notification has already been disabled.
ERROR_WMI_ALREADY_DISABLED :: 4212;
// The WMI data item or data block is read only.
ERROR_WMI_READ_ONLY :: 4213;
// The WMI data item or data block could not be changed.
ERROR_WMI_SET_FAILURE :: 4214;
// The media identifier does not represent a valid medium.
ERROR_INVALID_MEDIA :: 4300;
// The library identifier does not represent a valid library.
ERROR_INVALID_LIBRARY :: 4301;
// The media pool identifier does not represent a valid media pool.
ERROR_INVALID_MEDIA_POOL :: 4302;
// The drive and medium are not compatible or exist in different libraries.
ERROR_DRIVE_MEDIA_MISMATCH :: 4303;
// The medium currently exists in an offline library and must be online to perform this operation.
ERROR_MEDIA_OFFLINE :: 4304;
// The operation cannot be performed on an offline library.
ERROR_LIBRARY_OFFLINE :: 4305;
// The library, drive, or media pool is empty.
ERROR_EMPTY :: 4306;
// The library, drive, or media pool must be empty to perform this operation.
ERROR_NOT_EMPTY :: 4307;
// No media is currently available in this media pool or library.
ERROR_MEDIA_UNAVAILABLE :: 4308;
// A resource required for this operation is disabled.
ERROR_RESOURCE_DISABLED :: 4309;
// The media identifier does not represent a valid cleaner.
ERROR_INVALID_CLEANER :: 4310;
// The drive cannot be cleaned or does not support cleaning.
ERROR_UNABLE_TO_CLEAN :: 4311;
// The object identifier does not represent a valid object.
ERROR_OBJECT_NOT_FOUND :: 4312;
// Unable to read from or write to the database.
ERROR_DATABASE_FAILURE :: 4313;
// The database is full.
ERROR_DATABASE_FULL :: 4314;
// The medium is not compatible with the device or media pool.
ERROR_MEDIA_INCOMPATIBLE :: 4315;
// The resource required for this operation does not exist.
ERROR_RESOURCE_NOT_PRESENT :: 4316;
// The operation identifier is not valid.
ERROR_INVALID_OPERATION :: 4317;
// The media is not mounted or ready for use.
ERROR_MEDIA_NOT_AVAILABLE :: 4318;
// The device is not ready for use.
ERROR_DEVICE_NOT_AVAILABLE :: 4319;
// The operator or administrator has refused the request.
ERROR_REQUEST_REFUSED :: 4320;
// The drive identifier does not represent a valid drive.
ERROR_INVALID_DRIVE_OBJECT :: 4321;
// Library is full. No slot is available for use.
ERROR_LIBRARY_FULL :: 4322;
// The transport cannot access the medium.
ERROR_MEDIUM_NOT_ACCESSIBLE :: 4323;
// Unable to load the medium into the drive.
ERROR_UNABLE_TO_LOAD_MEDIUM :: 4324;
// Unable to retrieve status about the drive.
ERROR_UNABLE_TO_INVENTORY_DRIVE :: 4325;
// Unable to retrieve status about the slot.
ERROR_UNABLE_TO_INVENTORY_SLOT :: 4326;
// Unable to retrieve status about the transport.
ERROR_UNABLE_TO_INVENTORY_TRANSPORT :: 4327;
// Cannot use the transport because it is already in use.
ERROR_TRANSPORT_FULL :: 4328;
// Unable to open or close the inject/eject port.
ERROR_CONTROLLING_IEPORT :: 4329;
// Unable to eject the media because it is in a drive.
ERROR_UNABLE_TO_EJECT_MOUNTED_MEDIA :: 4330;
// A cleaner slot is already reserved.
ERROR_CLEANER_SLOT_SET :: 4331;
// A cleaner slot is not reserved.
ERROR_CLEANER_SLOT_NOT_SET :: 4332;
// The cleaner cartridge has performed the maximum number of drive cleanings.
ERROR_CLEANER_CARTRIDGE_SPENT :: 4333;
// Unexpected on-medium identifier.
ERROR_UNEXPECTED_OMID :: 4334;
// The last remaining item in this group or resource cannot be deleted.
ERROR_CANT_DELETE_LAST_ITEM :: 4335;
// The message provided exceeds the maximum size allowed for this parameter.
ERROR_MESSAGE_EXCEEDS_MAX_SIZE :: 4336;
// The volume contains system or paging files.
ERROR_VOLUME_CONTAINS_SYS_FILES :: 4337;
// The media type cannot be removed from this library since at least one drive in the library reports it can support this media type.
ERROR_INDIGENOUS_TYPE :: 4338;
// This offline media cannot be mounted on this system since no enabled drives are present which can be used.
ERROR_NO_SUPPORTING_DRIVES :: 4339;
// The remote storage service was not able to recall the file.
ERROR_FILE_OFFLINE :: 4350;
// The remote storage service is not operational at this time.
ERROR_REMOTE_STORAGE_NOT_ACTIVE :: 4351;
// The remote storage service encountered a media error.
ERROR_REMOTE_STORAGE_MEDIA_ERROR :: 4352;
// The file or directory is not a reparse point.
ERROR_NOT_A_REPARSE_POINT :: 4390;
// The reparse point attribute cannot be set because it conflicts with an existing attribute.
ERROR_REPARSE_ATTRIBUTE_CONFLICT :: 4391;
// The data present in the reparse point buffer is invalid.
ERROR_INVALID_REPARSE_DATA :: 4392;
// The tag present in the reparse point buffer is invalid.
ERROR_REPARSE_TAG_INVALID :: 4393;
// There is a mismatch between the tag specified in the request and the tag present in the reparse point.
ERROR_REPARSE_TAG_MISMATCH :: 4394;
// The cluster resource cannot be moved to another group because other resources are dependent on it.
ERROR_DEPENDENT_RESOURCE_EXISTS :: 5001;
// The cluster resource dependency cannot be found.
ERROR_DEPENDENCY_NOT_FOUND :: 5002;
// The cluster resource cannot be made dependent on the specified resource because it is already dependent.
ERROR_DEPENDENCY_ALREADY_EXISTS :: 5003;
// The cluster resource is not online.
ERROR_RESOURCE_NOT_ONLINE :: 5004;
// A cluster node is not available for this operation.
ERROR_HOST_NODE_NOT_AVAILABLE :: 5005;
// The cluster resource is not available.
ERROR_RESOURCE_NOT_AVAILABLE :: 5006;
// The cluster resource could not be found.
ERROR_RESOURCE_NOT_FOUND :: 5007;
// The cluster is being shut down.
ERROR_SHUTDOWN_CLUSTER :: 5008;
// A cluster node cannot be evicted from the cluster while it is online.
ERROR_CANT_EVICT_ACTIVE_NODE :: 5009;
// The object already exists.
ERROR_OBJECT_ALREADY_EXISTS :: 5010;
// The object is already in the list.
ERROR_OBJECT_IN_LIST :: 5011;
// The cluster group is not available for any new requests.
ERROR_GROUP_NOT_AVAILABLE :: 5012;
// The cluster group could not be found.
ERROR_GROUP_NOT_FOUND :: 5013;
// The operation could not be completed because the cluster group is not online.
ERROR_GROUP_NOT_ONLINE :: 5014;
// The cluster node is not the owner of the resource.
ERROR_HOST_NODE_NOT_RESOURCE_OWNER :: 5015;
// The cluster node is not the owner of the group.
ERROR_HOST_NODE_NOT_GROUP_OWNER :: 5016;
// The cluster resource could not be created in the specified resource monitor.
ERROR_RESMON_CREATE_FAILED :: 5017;
// The cluster resource could not be brought online by the resource monitor.
ERROR_RESMON_ONLINE_FAILED :: 5018;
// The operation could not be completed because the cluster resource is online.
ERROR_RESOURCE_ONLINE :: 5019;
// The cluster resource could not be deleted or brought offline because it is the quorum resource.
ERROR_QUORUM_RESOURCE :: 5020;
// The cluster could not make the specified resource a quorum resource because it is not capable of being a quorum resource.
ERROR_NOT_QUORUM_CAPABLE :: 5021;
// The cluster software is shutting down.
ERROR_CLUSTER_SHUTTING_DOWN :: 5022;
// The group or resource is not in the correct state to perform the requested operation.
ERROR_INVALID_STATE :: 5023;
// The properties were stored but not all changes will take effect until the next time the resource is brought online.
ERROR_RESOURCE_PROPERTIES_STORED :: 5024;
// The cluster could not make the specified resource a quorum resource because it does not belong to a shared storage class.
ERROR_NOT_QUORUM_CLASS :: 5025;
// The cluster resource could not be deleted since it is a core resource.
ERROR_CORE_RESOURCE :: 5026;
// The quorum resource failed to come online.
ERROR_QUORUM_RESOURCE_ONLINE_FAILED :: 5027;
// The quorum log could not be created or mounted successfully.
ERROR_QUORUMLOG_OPEN_FAILED :: 5028;
// The cluster log is corrupt.
ERROR_CLUSTERLOG_CORRUPT :: 5029;
// The record could not be written to the cluster log since it exceeds the maximum size.
ERROR_CLUSTERLOG_RECORD_EXCEEDS_MAXSIZE :: 5030;
// The cluster log exceeds its maximum size.
ERROR_CLUSTERLOG_EXCEEDS_MAXSIZE :: 5031;
// No checkpoint record was found in the cluster log.
ERROR_CLUSTERLOG_CHKPOINT_NOT_FOUND :: 5032;
// The minimum required disk space needed for logging is not available.
ERROR_CLUSTERLOG_NOT_ENOUGH_SPACE :: 5033;
// A cluster network is not available for this operation.
ERROR_NETWORK_NOT_AVAILABLE :: 5035;
// A cluster node is not available for this operation.
ERROR_NODE_NOT_AVAILABLE :: 5036;
// All cluster nodes must be running to perform this operation.
ERROR_ALL_NODES_NOT_AVAILABLE :: 5037;
// A cluster resource failed.
ERROR_RESOURCE_FAILED :: 5038;
// The cluster node is not valid.
ERROR_CLUSTER_INVALID_NODE :: 5039;
// The cluster node already exists.
ERROR_CLUSTER_NODE_EXISTS :: 5040;
// A node is in the process of joining the cluster.
ERROR_CLUSTER_JOIN_IN_PROGRESS :: 5041;
// The cluster node was not found.
ERROR_CLUSTER_NODE_NOT_FOUND :: 5042;
// The cluster local node information was not found.
ERROR_CLUSTER_LOCAL_NODE_NOT_FOUND :: 5043;
// The cluster network already exists.
ERROR_CLUSTER_NETWORK_EXISTS :: 5044;
// The cluster network was not found.
ERROR_CLUSTER_NETWORK_NOT_FOUND :: 5045;
// The cluster network interface already exists.
ERROR_CLUSTER_NETINTERFACE_EXISTS :: 5046;
// The cluster network interface was not found.
ERROR_CLUSTER_NETINTERFACE_NOT_FOUND :: 5047;
// The cluster request is not valid for this object.
ERROR_CLUSTER_INVALID_REQUEST :: 5048;
// The cluster network provider is not valid.
ERROR_CLUSTER_INVALID_NETWORK_PROVIDER :: 5049;
// The cluster node is down.
ERROR_CLUSTER_NODE_DOWN :: 5050;
// The cluster node is not reachable.
ERROR_CLUSTER_NODE_UNREACHABLE :: 5051;
// The cluster node is not a member of the cluster.
ERROR_CLUSTER_NODE_NOT_MEMBER :: 5052;
// A cluster join operation is not in progress.
ERROR_CLUSTER_JOIN_NOT_IN_PROGRESS :: 5053;
// The cluster network is not valid.
ERROR_CLUSTER_INVALID_NETWORK :: 5054;
// The cluster node is up.
ERROR_CLUSTER_NODE_UP :: 5056;
// The cluster IP address is already in use.
ERROR_CLUSTER_IPADDR_IN_USE :: 5057;
// The cluster node is not paused.
ERROR_CLUSTER_NODE_NOT_PAUSED :: 5058;
// No cluster security context is available.
ERROR_CLUSTER_NO_SECURITY_CONTEXT :: 5059;
// The cluster network is not configured for internal cluster communication.
ERROR_CLUSTER_NETWORK_NOT_INTERNAL :: 5060;
// The cluster node is already up.
ERROR_CLUSTER_NODE_ALREADY_UP :: 5061;
// The cluster node is already down.
ERROR_CLUSTER_NODE_ALREADY_DOWN :: 5062;
// The cluster network is already online.
ERROR_CLUSTER_NETWORK_ALREADY_ONLINE :: 5063;
// The cluster network is already offline.
ERROR_CLUSTER_NETWORK_ALREADY_OFFLINE :: 5064;
// The cluster node is already a member of the cluster.
ERROR_CLUSTER_NODE_ALREADY_MEMBER :: 5065;
// The cluster network is the only one configured for internal cluster communication between two or more active cluster nodes. The internal communication capability cannot be removed from the network.
ERROR_CLUSTER_LAST_INTERNAL_NETWORK :: 5066;
// One or more cluster resources depend on the network to provide service to clients. The client access capability cannot be removed from the network.
ERROR_CLUSTER_NETWORK_HAS_DEPENDENTS :: 5067;
// This operation cannot be performed on the cluster resource as it the quorum resource. You cannot bring the quorum resource offline or modify its possible owners list.
ERROR_INVALID_OPERATION_ON_QUORUM :: 5068;
// The cluster quorum resource is not allowed to have any dependencies.
ERROR_DEPENDENCY_NOT_ALLOWED :: 5069;
// The cluster node is paused.
ERROR_CLUSTER_NODE_PAUSED :: 5070;
// The cluster resource cannot be brought online. The owner node cannot run this resource.
ERROR_NODE_CANT_HOST_RESOURCE :: 5071;
// The cluster node is not ready to perform the requested operation.
ERROR_CLUSTER_NODE_NOT_READY :: 5072;
// The cluster node is shutting down.
ERROR_CLUSTER_NODE_SHUTTING_DOWN :: 5073;
// The cluster join operation was aborted.
ERROR_CLUSTER_JOIN_ABORTED :: 5074;
// The cluster join operation failed due to incompatible software versions between the joining node and its sponsor.
ERROR_CLUSTER_INCOMPATIBLE_VERSIONS :: 5075;
// This resource cannot be created because the cluster has reached the limit on the number of resources it can monitor.
ERROR_CLUSTER_MAXNUM_OF_RESOURCES_EXCEEDED :: 5076;
// The system configuration changed during the cluster join or form operation. The join or form operation was aborted.
ERROR_CLUSTER_SYSTEM_CONFIG_CHANGED :: 5077;
// The specified resource type was not found.
ERROR_CLUSTER_RESOURCE_TYPE_NOT_FOUND :: 5078;
// The specified node does not support a resource of this type. This can be due to version inconsistencies or due to the absence of the resource DLL on this node.
ERROR_CLUSTER_RESTYPE_NOT_SUPPORTED :: 5079;
// The specified resource name is supported by this resource DLL. This can be due to a bad (or changed) name supplied to the resource DLL.
ERROR_CLUSTER_RESNAME_NOT_FOUND :: 5080;
// No authentication package could be registered with the RPC server.
ERROR_CLUSTER_NO_RPC_PACKAGES_REGISTERED :: 5081;
// You cannot bring the group online because the owner of the group is not in the preferred list for the group. To change the owner node for the group, move the group.
ERROR_CLUSTER_OWNER_NOT_IN_PREFLIST :: 5082;
// The join operation failed because the cluster database sequence number has changed or is incompatible with the locker node. This can happen during a join operation if the cluster database was changing during the join.
ERROR_CLUSTER_DATABASE_SEQMISMATCH :: 5083;
// The resource monitor will not allow the fail operation to be performed while the resource is in its current state. This can happen if the resource is in a pending state.
ERROR_RESMON_INVALID_STATE :: 5084;
// The specified file could not be encrypted.
ERROR_ENCRYPTION_FAILED :: 6000;
// The specified file could not be decrypted.
ERROR_DECRYPTION_FAILED :: 6001;
// The specified file is encrypted and the user does not have the ability to decrypt it.
ERROR_FILE_ENCRYPTED :: 6002;
// There is no encryption recovery policy configured for this system.
ERROR_NO_RECOVERY_POLICY :: 6003;
// The required encryption driver is not loaded for this system.
ERROR_NO_EFS :: 6004;
// The file was encrypted with a different encryption driver than is currently loaded.
ERROR_WRONG_EFS :: 6005;
// There are no EFS keys defined for the user.
ERROR_NO_USER_KEYS :: 6006;
// The specified file is not encrypted.
ERROR_FILE_NOT_ENCRYPTED :: 6007;
// The specified file is not in the defined EFS export format.
ERROR_NOT_EXPORT_FORMAT :: 6008;
// The specified file is read only.
ERROR_FILE_READ_ONLY :: 6009;
// The list of servers for this workgroup is not currently available
ERROR_NO_BROWSER_SERVERS_FOUND :: 6118;
// The specified session name is invalid.
ERROR_CTX_WINSTATION_NAME_INVALID :: 7001;
// The specified protocol driver is invalid.
ERROR_CTX_INVALID_PD :: 7002;
// The specified protocol driver was not found in the system path.
ERROR_CTX_PD_NOT_FOUND :: 7003;
// The specified terminal connection driver was not found in the system path.
ERROR_CTX_WD_NOT_FOUND :: 7004;
// A registry key for event logging could not be created for this session.
ERROR_CTX_CANNOT_MAKE_EVENTLOG_ENTRY :: 7005;
// A service with the same name already exists on the system.
ERROR_CTX_SERVICE_NAME_COLLISION :: 7006;
// A close operation is pending on the session.
ERROR_CTX_CLOSE_PENDING :: 7007;
// There are no free output buffers available.
ERROR_CTX_NO_OUTBUF :: 7008;
// The MODEM.INF file was not found.
ERROR_CTX_MODEM_INF_NOT_FOUND :: 7009;
// The modem name was not found in MODEM.INF.
ERROR_CTX_INVALID_MODEMNAME :: 7010;
// The modem did not accept the command sent to it. Verify that the configured modem name matches the attached modem.
ERROR_CTX_MODEM_RESPONSE_ERROR :: 7011;
// The modem did not respond to the command sent to it. Verify that the modem is properly cabled and powered on.
ERROR_CTX_MODEM_RESPONSE_TIMEOUT :: 7012;
// Carrier detect has failed or carrier has been dropped due to disconnect.
ERROR_CTX_MODEM_RESPONSE_NO_CARRIER :: 7013;
// Dial tone not detected within the required time. Verify that the phone cable is properly attached and functional.
ERROR_CTX_MODEM_RESPONSE_NO_DIALTONE :: 7014;
// Busy signal detected at remote site on callback.
ERROR_CTX_MODEM_RESPONSE_BUSY :: 7015;
// Voice detected at remote site on callback.
ERROR_CTX_MODEM_RESPONSE_VOICE :: 7016;
// Transport driver error
ERROR_CTX_TD_ERROR :: 7017;
// The specified session cannot be found.
ERROR_CTX_WINSTATION_NOT_FOUND :: 7022;
// The specified session name is already in use.
ERROR_CTX_WINSTATION_ALREADY_EXISTS :: 7023;
// The requested operation cannot be completed because the terminal connection is currently busy processing a connect, disconnect, reset, or delete operation.
ERROR_CTX_WINSTATION_BUSY :: 7024;
// An attempt has been made to connect to a session whose video mode is not supported by the current client.
ERROR_CTX_BAD_VIDEO_MODE :: 7025;
// The application attempted to enable DOS graphics mode. DOS graphics mode is not supported.
ERROR_CTX_GRAPHICS_INVALID :: 7035;
// Your interactive logon privilege has been disabled. Please contact your administrator.
ERROR_CTX_LOGON_DISABLED :: 7037;
// The requested operation can be performed only on the system console. This is most often the result of a driver or system DLL requiring direct console access.
ERROR_CTX_NOT_CONSOLE :: 7038;
// The client failed to respond to the server connect message.
ERROR_CTX_CLIENT_QUERY_TIMEOUT :: 7040;
// Disconnecting the console session is not supported.
ERROR_CTX_CONSOLE_DISCONNECT :: 7041;
// Reconnecting a disconnected session to the console is not supported.
ERROR_CTX_CONSOLE_CONNECT :: 7042;
// The request to shadow another session was denied.
ERROR_CTX_SHADOW_DENIED :: 7044;
// The requested session access is denied.
ERROR_CTX_WINSTATION_ACCESS_DENIED :: 7045;
// The specified terminal connection driver is invalid.
ERROR_CTX_INVALID_WD :: 7049;
// The requested session cannot be shadowed. This can be because the session is disconnected or does not currently have a user logged on. Also, you cannot shadow a session from the system console or shadow the system console.
ERROR_CTX_SHADOW_INVALID :: 7050;
// The requested session is not configured to allow shadowing.
ERROR_CTX_SHADOW_DISABLED :: 7051;
// Your request to connect to this Terminal Server has been rejected. Your Terminal Server client license number is currently being used by another user. Please call your system administrator to obtain a new copy of the Terminal Server client with a valid, unique license number.
ERROR_CTX_CLIENT_LICENSE_IN_USE :: 7052;
// Your request to connect to this Terminal Server has been rejected. Your Terminal Server client license number has not been entered for this copy of the Terminal Server client. Please call your system administrator for help in entering a valid, unique license number for this Terminal Server client.
ERROR_CTX_CLIENT_LICENSE_NOT_SET :: 7053;
// The system has reached its licensed logon limit. Please try again later.
ERROR_CTX_LICENSE_NOT_AVAILABLE :: 7054;
// The client you are using is not licensed to use this system. Your logon request is denied.
ERROR_CTX_LICENSE_CLIENT_INVALID :: 7055;
// The system license has expired. Your logon request is denied.
ERROR_CTX_LICENSE_EXPIRED :: 7056;
// The file replication service API was called incorrectly.
FRS_ERR_INVALID_API_SEQUENCE :: 8001;
// The file replication service cannot be started.
FRS_ERR_STARTING_SERVICE :: 8002;
// The file replication service cannot be stopped.
FRS_ERR_STOPPING_SERVICE :: 8003;
// The file replication service API terminated the request.
FRS_ERR_INTERNAL_API :: 8004;
// The file replication service terminated the request.
FRS_ERR_INTERNAL :: 8005;
// The file replication service cannot be contacted.
FRS_ERR_SERVICE_COMM :: 8006;
// The file replication service cannot satisfy the request because the user is not a member of the Administrators group.
FRS_ERR_INSUFFICIENT_PRIV :: 8007;
// The file replication service cannot satisfy the request because authenticated RPC is not available.
FRS_ERR_AUTHENTICATION :: 8008;
// The file replication service cannot satisfy the request because the user is not a member of Administrators group on the domain controller.
FRS_ERR_PARENT_INSUFFICIENT_PRIV :: 8009;
// The file replication service cannot satisfy the request because authenticated RPC is not available on the domain controller.
FRS_ERR_PARENT_AUTHENTICATION :: 8010;
// The file replication service cannot communicate with the file replication service on the domain controller.
FRS_ERR_CHILD_TO_PARENT_COMM :: 8011;
// The file replication service on the domain controller cannot communicate with the file replication service on this computer.
FRS_ERR_PARENT_TO_CHILD_COMM :: 8012;
// The file replication service cannot populate the system volume because of an internal error.
FRS_ERR_SYSVOL_POPULATE :: 8013;
// The file replication service cannot populate the system volume because of an internal timeout.
FRS_ERR_SYSVOL_POPULATE_TIMEOUT :: 8014;
// The file replication service cannot process the request. The system volume is busy with a previous request.
FRS_ERR_SYSVOL_IS_BUSY :: 8015;
// The file replication service cannot stop replicating the system volume because of an internal error.
FRS_ERR_SYSVOL_DEMOTE :: 8016;
// The file replication service detected an invalid parameter.
FRS_ERR_INVALID_SERVICE_PARAMETER :: 8017;
// An error occurred while installing the Windows NT directory service. For more information, see the event log.
ERROR_DS_NOT_INSTALLED :: 8200;
// The directory service evaluated group memberships locally.
ERROR_DS_MEMBERSHIP_EVALUATED_LOCALLY :: 8201;
// The specified directory service attribute or value does not exist.
ERROR_DS_NO_ATTRIBUTE_OR_VALUE :: 8202;
// The attribute syntax specified to the directory service is invalid.
ERROR_DS_INVALID_ATTRIBUTE_SYNTAX :: 8203;
// The attribute type specified to the directory service is not defined.
ERROR_DS_ATTRIBUTE_TYPE_UNDEFINED :: 8204;
// The specified directory service attribute or value already exists.
ERROR_DS_ATTRIBUTE_OR_VALUE_EXISTS :: 8205;
// The directory service is busy.
ERROR_DS_BUSY :: 8206;
// The directory service is unavailable.
ERROR_DS_UNAVAILABLE :: 8207;
// The directory service was unable to allocate a relative identifier.
ERROR_DS_NO_RIDS_ALLOCATED :: 8208;
// The directory service has exhausted the pool of relative identifiers.
ERROR_DS_NO_MORE_RIDS :: 8209;
// The requested operation could not be performed because the directory service is not the master for that type of operation.
ERROR_DS_INCORRECT_ROLE_OWNER :: 8210;
// The directory service was unable to initialize the subsystem that allocates relative identifiers.
ERROR_DS_RIDMGR_INIT_ERROR :: 8211;
// The requested operation did not satisfy one or more constraints associated with the class of the object.
ERROR_DS_OBJ_CLASS_VIOLATION :: 8212;
// The directory service can perform the requested operation only on a leaf object.
ERROR_DS_CANT_ON_NON_LEAF :: 8213;
// The directory service cannot perform the requested operation on the RDN attribute of an object.
ERROR_DS_CANT_ON_RDN :: 8214;
// The directory service detected an attempt to modify the object class of an object.
ERROR_DS_CANT_MOD_OBJ_CLASS :: 8215;
// The requested cross-domain move operation could not be performed.
ERROR_DS_CROSS_DOM_MOVE_ERROR :: 8216;
// Unable to contact the global catalog server.
ERROR_DS_GC_NOT_AVAILABLE :: 8217;
// The policy object is shared and can only be modified at the root.
ERROR_SHARED_POLICY :: 8218;
// The policy object does not exist.
ERROR_POLICY_OBJECT_NOT_FOUND :: 8219;
// The requested policy information is only in the directory service.
ERROR_POLICY_ONLY_IN_DS :: 8220;
// A domain controller promotion is currently active.
ERROR_PROMOTION_ACTIVE :: 8221;
// A domain controller promotion is not currently active
ERROR_NO_PROMOTION_ACTIVE :: 8222;
// An operations error occurred.
ERROR_DS_OPERATIONS_ERROR :: 8224;
// A protocol error occurred.
ERROR_DS_PROTOCOL_ERROR :: 8225;
// The time limit for this request was exceeded.
ERROR_DS_TIMELIMIT_EXCEEDED :: 8226;
// The size limit for this request was exceeded.
ERROR_DS_SIZELIMIT_EXCEEDED :: 8227;
// The administrative limit for this request was exceeded.
ERROR_DS_ADMIN_LIMIT_EXCEEDED :: 8228;
// The compare response was false.
ERROR_DS_COMPARE_FALSE :: 8229;
// The compare response was true.
ERROR_DS_COMPARE_TRUE :: 8230;
// The requested authentication method is not supported by the server.
ERROR_DS_AUTH_METHOD_NOT_SUPPORTED :: 8231;
// A more secure authentication method is required for this server.
ERROR_DS_STRONG_AUTH_REQUIRED :: 8232;
// Inappropriate authentication.
ERROR_DS_INAPPROPRIATE_AUTH :: 8233;
// The authentication mechanism is unknown.
ERROR_DS_AUTH_UNKNOWN :: 8234;
// A referral was returned from the server.
ERROR_DS_REFERRAL :: 8235;
// The server does not support the requested critical extension.
ERROR_DS_UNAVAILABLE_CRIT_EXTENSION :: 8236;
// This request requires a secure connection.
ERROR_DS_CONFIDENTIALITY_REQUIRED :: 8237;
// Inappropriate matching.
ERROR_DS_INAPPROPRIATE_MATCHING :: 8238;
// A constraint violation occurred.
ERROR_DS_CONSTRAINT_VIOLATION :: 8239;
// There is no such object on the server.
ERROR_DS_NO_SUCH_OBJECT :: 8240;
// There is an alias problem.
ERROR_DS_ALIAS_PROBLEM :: 8241;
// An invalid dn syntax has been specified.
ERROR_DS_INVALID_DN_SYNTAX :: 8242;
// The object is a leaf object.
ERROR_DS_IS_LEAF :: 8243;
// There is an alias dereferencing problem.
ERROR_DS_ALIAS_DEREF_PROBLEM :: 8244;
// The server is unwilling to process the request.
ERROR_DS_UNWILLING_TO_PERFORM :: 8245;
// A loop has been detected.
ERROR_DS_LOOP_DETECT :: 8246;
// There is a naming violation.
ERROR_DS_NAMING_VIOLATION :: 8247;
// The result set is too large.
ERROR_DS_OBJECT_RESULTS_TOO_LARGE :: 8248;
// The operation affects multiple DSAs
ERROR_DS_AFFECTS_MULTIPLE_DSAS :: 8249;
// The server is not operational.
ERROR_DS_SERVER_DOWN :: 8250;
// A local error has occurred.
ERROR_DS_LOCAL_ERROR :: 8251;
// An encoding error has occurred.
ERROR_DS_ENCODING_ERROR :: 8252;
// A decoding error has occurred.
ERROR_DS_DECODING_ERROR :: 8253;
// The search filter cannot be recognized.
ERROR_DS_FILTER_UNKNOWN :: 8254;
// One or more parameters are illegal.
ERROR_DS_PARAM_ERROR :: 8255;
// The specified method is not supported.
ERROR_DS_NOT_SUPPORTED :: 8256;
// No results were returned.
ERROR_DS_NO_RESULTS_RETURNED :: 8257;
// The specified control is not supported by the server.
ERROR_DS_CONTROL_NOT_FOUND :: 8258;
// A referral loop was detected by the client.
ERROR_DS_CLIENT_LOOP :: 8259;
// The preset referral limit was exceeded.
ERROR_DS_REFERRAL_LIMIT_EXCEEDED :: 8260;
// The root object must be the head of a naming context. The root object cannot have an instantiated parent.
ERROR_DS_ROOT_MUST_BE_NC :: 8301;
// The add replica operation cannot be performed. The naming context must be writable in order to create the replica.
ERROR_DS_ADD_REPLICA_INHIBITED :: 8302;
// A reference to an attribute that is not defined in the schema occurred.
ERROR_DS_ATT_NOT_DEF_IN_SCHEMA :: 8303;
// The maximum size of an object has been exceeded.
ERROR_DS_MAX_OBJ_SIZE_EXCEEDED :: 8304;
// An attempt was made to add an object to the directory with a name that is already in use.
ERROR_DS_OBJ_STRING_NAME_EXISTS :: 8305;
// An attempt was made to add an object of a class that does not have an RDN defined in the schema.
ERROR_DS_NO_RDN_DEFINED_IN_SCHEMA :: 8306;
// An attempt was made to add an object using an RDN that is not the RDN defined in the schema.
ERROR_DS_RDN_DOESNT_MATCH_SCHEMA :: 8307;
// None of the requested attributes were found on the objects.
ERROR_DS_NO_REQUESTED_ATTS_FOUND :: 8308;
// The user buffer is too small.
ERROR_DS_USER_BUFFER_TO_SMALL :: 8309;
// The attribute specified in the operation is not present on the object.
ERROR_DS_ATT_IS_NOT_ON_OBJ :: 8310;
// Illegal modify operation. Some aspect of the modification is not allowed.
ERROR_DS_ILLEGAL_MOD_OPERATION :: 8311;
// The specified object is too large.
ERROR_DS_OBJ_TOO_LARGE :: 8312;
// The specified instance type is not valid.
ERROR_DS_BAD_INSTANCE_TYPE :: 8313;
// The operation must be performed at the master DSA. The DNS root attribute is missing on the cross-reference object.
ERROR_DS_MASTERDSA_REQUIRED :: 8314;
// The object class attribute must be specified.
ERROR_DS_OBJECT_CLASS_REQUIRED :: 8315;
// A required attribute is missing.
ERROR_DS_MISSING_REQUIRED_ATT :: 8316;
// An attempt was made to modify an object to include an attribute that is not legal for its class
ERROR_DS_ATT_NOT_DEF_FOR_CLASS :: 8317;
// The specified attribute is already present on the object.
ERROR_DS_ATT_ALREADY_EXISTS :: 8318;
// The specified attribute is not present, or has no values.
ERROR_DS_CANT_ADD_ATT_VALUES :: 8320;
// An attribute's single value constraint has been violated.
ERROR_DS_SINGLE_VALUE_CONSTRAINT :: 8321;
// An attribute's range constraint has been violated.
ERROR_DS_RANGE_CONSTRAINT :: 8322;
// The specified value already exists.
ERROR_DS_ATT_VAL_ALREADY_EXISTS :: 8323;
// The attribute cannot be removed because it is not present on the object.
ERROR_DS_CANT_REM_MISSING_ATT :: 8324;
// The attribute value cannot be removed because it is not present on the object.
ERROR_DS_CANT_REM_MISSING_ATT_VAL :: 8325;
// The specified root object cannot be a subref.
ERROR_DS_ROOT_CANT_BE_SUBREF :: 8326;
// Chaining is not allowed.
ERROR_DS_NO_CHAINING :: 8327;
// Chained evaluation is not allowed.
ERROR_DS_NO_CHAINED_EVAL :: 8328;
// The operation could not be performed because the object's parent is either uninstantiated or deleted.
ERROR_DS_NO_PARENT_OBJECT :: 8329;
// Having a parent that is an alias is not allowed. Aliases are leaf objects.
ERROR_DS_PARENT_IS_AN_ALIAS :: 8330;
// The object and parent must be of the same type, either both masters or both replicas.
ERROR_DS_CANT_MIX_MASTER_AND_REPS :: 8331;
// The operation cannot be performed because child objects exist. This operation can only be performed on a leaf object.
ERROR_DS_CHILDREN_EXIST :: 8332;
// Directory object not found.
ERROR_DS_OBJ_NOT_FOUND :: 8333;
// The aliased object is missing.
ERROR_DS_ALIASED_OBJ_MISSING :: 8334;
// The object name has bad syntax.
ERROR_DS_BAD_NAME_SYNTAX :: 8335;
// It is not allowed for an alias to refer to another alias.
ERROR_DS_ALIAS_POINTS_TO_ALIAS :: 8336;
// The alias cannot be dereferenced.
ERROR_DS_CANT_DEREF_ALIAS :: 8337;
// The operation is out of scope.
ERROR_DS_OUT_OF_SCOPE :: 8338;
// The DSA object cannot be deleted.
ERROR_DS_CANT_DELETE_DSA_OBJ :: 8340;
// A directory service error has occurred.
ERROR_DS_GENERIC_ERROR :: 8341;
// The operation can only be performed on an internal master DSA object.
ERROR_DS_DSA_MUST_BE_INT_MASTER :: 8342;
// The object must be of class DSA.
ERROR_DS_CLASS_NOT_DSA :: 8343;
// Insufficient access rights to perform the operation.
ERROR_DS_INSUFF_ACCESS_RIGHTS :: 8344;
// The object cannot be added because the parent is not on the list of possible superiors.
ERROR_DS_ILLEGAL_SUPERIOR :: 8345;
// Access to the attribute is not allowed because the attribute is owned by the Security Accounts Manager (SAM).
ERROR_DS_ATTRIBUTE_OWNED_BY_SAM :: 8346;
// The name has too many parts.
ERROR_DS_NAME_TOO_MANY_PARTS :: 8347;
// The name is too long.
ERROR_DS_NAME_TOO_LONG :: 8348;
// The name value is too long.
ERROR_DS_NAME_VALUE_TOO_LONG :: 8349;
// The directory service encountered an error parsing a name.
ERROR_DS_NAME_UNPARSEABLE :: 8350;
// The directory service cannot get the attribute type for a name.
ERROR_DS_NAME_TYPE_UNKNOWN :: 8351;
// The name does not identify an object; the name identifies a phantom.
ERROR_DS_NOT_AN_OBJECT :: 8352;
// The security descriptor is too short.
ERROR_DS_SEC_DESC_TOO_SHORT :: 8353;
// The security descriptor is invalid.
ERROR_DS_SEC_DESC_INVALID :: 8354;
// Failed to create name for deleted object.
ERROR_DS_NO_DELETED_NAME :: 8355;
// The parent of a new subref must exist.
ERROR_DS_SUBREF_MUST_HAVE_PARENT :: 8356;
// The object must be a naming context.
ERROR_DS_NCNAME_MUST_BE_NC :: 8357;
// It is not allowed to add an attribute which is owned by the system.
ERROR_DS_CANT_ADD_SYSTEM_ONLY :: 8358;
// The class of the object must be structural; you cannot instantiate an abstract class.
ERROR_DS_CLASS_MUST_BE_CONCRETE :: 8359;
// The schema object could not be found.
ERROR_DS_INVALID_DMD :: 8360;
// A local object with this GUID (dead or alive) already exists.
ERROR_DS_OBJ_GUID_EXISTS :: 8361;
// The operation cannot be performed on a back link.
ERROR_DS_NOT_ON_BACKLINK :: 8362;
// The cross reference for the specified naming context could not be found.
ERROR_DS_NO_CROSSREF_FOR_NC :: 8363;
// The operation could not be performed because the directory service is shutting down.
ERROR_DS_SHUTTING_DOWN :: 8364;
// The directory service request is invalid.
ERROR_DS_UNKNOWN_OPERATION :: 8365;
// The role owner attribute could not be read.
ERROR_DS_INVALID_ROLE_OWNER :: 8366;
// The requested FSMO operation failed. The current FSMO holder could not be reached.
ERROR_DS_COULDNT_CONTACT_FSMO :: 8367;
// Modification of a DN across a naming context is not allowed.
ERROR_DS_CROSS_NC_DN_RENAME :: 8368;
// The attribute cannot be modified because it is owned by the system.
ERROR_DS_CANT_MOD_SYSTEM_ONLY :: 8369;
// Only the replicator can perform this function.
ERROR_DS_REPLICATOR_ONLY :: 8370;
// The specified class is not defined.
ERROR_DS_OBJ_CLASS_NOT_DEFINED :: 8371;
// The specified class is not a subclass.
ERROR_DS_OBJ_CLASS_NOT_SUBCLASS :: 8372;
// The name reference is invalid.
ERROR_DS_NAME_REFERENCE_INVALID :: 8373;
// A cross reference already exists.
ERROR_DS_CROSS_REF_EXISTS :: 8374;
// It is not allowed to delete a master cross reference.
ERROR_DS_CANT_DEL_MASTER_CROSSREF :: 8375;
// Subtree notifications are only supported on NC heads.
ERROR_DS_SUBTREE_NOTIFY_NOT_NC_HEAD :: 8376;
// Notification filter is too complex.
ERROR_DS_NOTIFY_FILTER_TOO_COMPLEX :: 8377;
// Schema update failed: duplicate RDN.
ERROR_DS_DUP_RDN :: 8378;
// Schema update failed: duplicate OID
ERROR_DS_DUP_OID :: 8379;
// Schema update failed: duplicate MAPI identifier.
ERROR_DS_DUP_MAPI_ID :: 8380;
// Schema update failed: duplicate schema-id GUID.
ERROR_DS_DUP_SCHEMA_ID_GUID :: 8381;
// Schema update failed: duplicate LDAP display name.
ERROR_DS_DUP_LDAP_DISPLAY_NAME :: 8382;
// Schema update failed: range-lower less than range upper
ERROR_DS_SEMANTIC_ATT_TEST :: 8383;
// Schema update failed: syntax mismatch
ERROR_DS_SYNTAX_MISMATCH :: 8384;
// Schema deletion failed: attribute is used in must-contain
ERROR_DS_EXISTS_IN_MUST_HAVE :: 8385;
// Schema deletion failed: attribute is used in can-contain
ERROR_DS_EXISTS_IN_can_HAVE :: 8386;
// Schema update failed: attribute in can-contain does not exist
ERROR_DS_NONEXISTENT_can_HAVE :: 8387;
// Schema update failed: attribute in must-contain does not exist
ERROR_DS_NONEXISTENT_MUST_HAVE :: 8388;
// Schema update failed: class in aux-class list does not exist or is not an auxiliary class
ERROR_DS_AUX_CLS_TEST_FAIL :: 8389;
// Schema update failed: class in poss-superiors does not exist
ERROR_DS_NONEXISTENT_POSS_SUP :: 8390;
// Schema update failed: class in subclass of list does not exist or does not satisfy hierarchy rules
ERROR_DS_SUB_CLS_TEST_FAIL :: 8391;
// Schema update failed: Rdn-Att-Id has wrong syntax
ERROR_DS_BAD_RDN_ATT_ID_SYNTAX :: 8392;
// Schema deletion failed: class is used as auxiliary class
ERROR_DS_EXISTS_IN_AUX_CLS :: 8393;
// Schema deletion failed: class is used as sub class
ERROR_DS_EXISTS_IN_SUB_CLS :: 8394;
// Schema deletion failed: class is used as poss superior
ERROR_DS_EXISTS_IN_POSS_SUP :: 8395;
// Schema update failed in recalculating validation cache.
ERROR_DS_RECALCSCHEMA_FAILED :: 8396;
// The tree deletion is not finished.
ERROR_DS_TREE_DELETE_NOT_FINISHED :: 8397;
// The requested delete operation could not be performed.
ERROR_DS_CANT_DELETE :: 8398;
// Cannot read the governs class identifier for the schema record.
ERROR_DS_ATT_SCHEMA_REQ_ID :: 8399;
// The attribute schema has bad syntax.
ERROR_DS_BAD_ATT_SCHEMA_SYNTAX :: 8400;
// The attribute could not be cached.
ERROR_DS_CANT_CACHE_ATT :: 8401;
// The class could not be cached.
ERROR_DS_CANT_CACHE_CLASS :: 8402;
// The attribute could not be removed from the cache.
ERROR_DS_CANT_REMOVE_ATT_CACHE :: 8403;
// The class could not be removed from the cache.
ERROR_DS_CANT_REMOVE_CLASS_CACHE :: 8404;
// The distinguished name attribute could not be read.
ERROR_DS_CANT_RETRIEVE_DN :: 8405;
// A required subref is missing.
ERROR_DS_MISSING_SUPREF :: 8406;
// The instance type attribute could not be retrieved.
ERROR_DS_CANT_RETRIEVE_INSTANCE :: 8407;
// An internal error has occurred.
ERROR_DS_CODE_INCONSISTENCY :: 8408;
// A database error has occurred.
ERROR_DS_DATABASE_ERROR :: 8409;
// The attribute GOVERNSID is missing.
ERROR_DS_GOVERNSID_MISSING :: 8410;
// An expected attribute is missing.
ERROR_DS_MISSING_EXPECTED_ATT :: 8411;
// The specified naming context is missing a cross reference.
ERROR_DS_NCNAME_MISSING_CR_REF :: 8412;
// A security checking error has occurred.
ERROR_DS_SECURITY_CHECKING_ERROR :: 8413;
// The schema is not loaded.
ERROR_DS_SCHEMA_NOT_LOADED :: 8414;
// Schema allocation failed.
ERROR_DS_SCHEMA_ALLOC_FAILED :: 8415;
// Failed to obtain the required syntax for the attribute schema.
ERROR_DS_ATT_SCHEMA_REQ_SYNTAX :: 8416;
// The global catalog verification failed. The global catalog is not available or does not support the operation. Some part of the directory is currently not available.
ERROR_DS_GCVERIFY_ERROR :: 8417;
// The replication operation failed because of a schema mismatch between the servers involved.
ERROR_DS_DRA_SCHEMA_MISMATCH :: 8418;
// The DSA object could not be found.
ERROR_DS_CANT_FIND_DSA_OBJ :: 8419;
// The naming context could not be found.
ERROR_DS_CANT_FIND_EXPECTED_NC :: 8420;
// The naming context could not be found in the cache.
ERROR_DS_CANT_FIND_NC_IN_CACHE :: 8421;
// The child object could not be retrieved.
ERROR_DS_CANT_RETRIEVE_CHILD :: 8422;
// The modification was not allowed for security reasons.
ERROR_DS_SECURITY_ILLEGAL_MODIFY :: 8423;
// The operation cannot replace the hidden record.
ERROR_DS_CANT_REPLACE_HIDDEN_REC :: 8424;
// The hierarchy file is invalid.
ERROR_DS_BAD_HIERARCHY_FILE :: 8425;
// The attempt to build the hierarchy table failed.
ERROR_DS_BUILD_HIERARCHY_TABLE_FAILED :: 8426;
// The directory configuration parameter is missing from the registry.
ERROR_DS_CONFIG_PARAM_MISSING :: 8427;
// The attempt to count the address book indices failed.
ERROR_DS_COUNTING_AB_INDICES_FAILED :: 8428;
// The allocation of the hierarchy table failed.
ERROR_DS_HIERARCHY_TABLE_MALLOC_FAILED :: 8429;
// The directory service encountered an internal failure.
ERROR_DS_INTERNAL_FAILURE :: 8430;
// The directory service encountered an unknown failure.
ERROR_DS_UNKNOWN_ERROR :: 8431;
// A root object requires a class of 'top'.
ERROR_DS_ROOT_REQUIRES_CLASS_TOP :: 8432;
// This directory server is shutting down, and cannot take ownership of new floating single-master operation roles.
ERROR_DS_REFUSING_FSMO_ROLES :: 8433;
// The directory service is missing mandatory configuration information, and is unable to determine the ownership of floating single-master operation roles.
ERROR_DS_MISSING_FSMO_SETTINGS :: 8434;
// The directory service was unable to transfer ownership of one or more floating single-master operation roles to other servers.
ERROR_DS_UNABLE_TO_SURRENDER_ROLES :: 8435;
// The replication operation failed.
ERROR_DS_DRA_GENERIC :: 8436;
// An invalid parameter was specified for this replication operation.
ERROR_DS_DRA_INVALID_PARAMETER :: 8437;
// The Windows NT directory service is too busy to complete the replication operation at this time.
ERROR_DS_DRA_BUSY :: 8438;
// The distinguished name specified for this replication operation is invalid.
ERROR_DS_DRA_BAD_DN :: 8439;
// The naming context specified for this replication operation is invalid.
ERROR_DS_DRA_BAD_NC :: 8440;
// The distinguished name specified for this replication operation already exists.
ERROR_DS_DRA_DN_EXISTS :: 8441;
// The replication system encountered an internal error.
ERROR_DS_DRA_INTERNAL_ERROR :: 8442;
// The replication operation encountered a database inconsistency.
ERROR_DS_DRA_INCONSISTENT_DIT :: 8443;
// The server specified for this replication operation could not be contacted.
ERROR_DS_DRA_CONNECTION_FAILED :: 8444;
// The replication operation encountered an object with an invalid instance type.
ERROR_DS_DRA_BAD_INSTANCE_TYPE :: 8445;
// The replication operation failed to allocate memory.
ERROR_DS_DRA_OUT_OF_MEM :: 8446;
// The replication operation encountered an error with the mail system.
ERROR_DS_DRA_MAIL_PROBLEM :: 8447;
// The replication reference information for the target server already exists.
ERROR_DS_DRA_REF_ALREADY_EXISTS :: 8448;
// The replication reference information for the target server does not exist.
ERROR_DS_DRA_REF_NOT_FOUND :: 8449;
// The naming context cannot be removed because it is replicated to another server.
ERROR_DS_DRA_OBJ_IS_REP_SOURCE :: 8450;
// The replication operation encountered a database error.
ERROR_DS_DRA_DB_ERROR :: 8451;
// The naming context is in the process of being removed or is not replicated from the specified server.
ERROR_DS_DRA_NO_REPLICA :: 8452;
// Replication access was denied.
ERROR_DS_DRA_ACCESS_DENIED :: 8453;
// The requested operation is not supported by this version of the Windows NT directory service.
ERROR_DS_DRA_NOT_SUPPORTED :: 8454;
// The replication remote procedure call was canceled.
ERROR_DS_DRA_RPC_CANCELED :: 8455;
// The source server is currently rejecting replication requests.
ERROR_DS_DRA_SOURCE_DISABLED :: 8456;
// The destination server is currently rejecting replication requests.
ERROR_DS_DRA_SINK_DISABLED :: 8457;
// The replication operation failed due to a collision of object names.
ERROR_DS_DRA_NAME_COLLISION :: 8458;
// The replication source has been reinstalled.
ERROR_DS_DRA_SOURCE_REINSTALLED :: 8459;
// The replication operation failed because a required parent object is missing.
ERROR_DS_DRA_MISSING_PARENT :: 8460;
// The replication operation was preempted.
ERROR_DS_DRA_PREEMPTED :: 8461;
// The replication synchronization attempt was abandoned because of a lack of updates.
ERROR_DS_DRA_ABANDON_SYNC :: 8462;
// The replication operation was terminated because the system is shutting down.
ERROR_DS_DRA_SHUTDOWN :: 8463;
// The replication synchronization attempt failed as the destination partial attribute set is not a subset of source partial attribute set.
ERROR_DS_DRA_INCOMPATIBLE_PARTIAL_SET :: 8464;
// The replication synchronization attempt failed because a master replica attempted to sync from a partial replica.
ERROR_DS_DRA_SOURCE_IS_PARTIAL_REPLICA :: 8465;
// The server specified for this replication operation was contacted, but that server was unable to contact an additional server needed to complete the operation.
ERROR_DS_DRA_EXTN_CONNECTION_FAILED :: 8466;
// A schema mismatch is detected between the source and the build used during a replica install. The replica cannot be installed.
ERROR_DS_INSTALL_SCHEMA_MISMATCH :: 8467;
// Schema update failed: An attribute with the same link identifier already exists.
ERROR_DS_DUP_LINK_ID :: 8468;
// Name translation: Generic processing error.
ERROR_DS_NAME_ERROR_RESOLVING :: 8469;
// Name translation: Could not find the name or insufficient right to see name.
ERROR_DS_NAME_ERROR_NOT_FOUND :: 8470;
// Name translation: Input name mapped to more than one output name.
ERROR_DS_NAME_ERROR_NOT_UNIQUE :: 8471;
// Name translation: Input name found, but not the associated output format.
ERROR_DS_NAME_ERROR_NO_MAPPING :: 8472;
// Name translation: Unable to resolve completely, only the domain was found.
ERROR_DS_NAME_ERROR_DOMAIN_ONLY :: 8473;
// Name translation: Unable to perform purely syntactical mapping at the client without going out to the wire.
ERROR_DS_NAME_ERROR_NO_SYNTACTICAL_MAPPING :: 8474;
// Modification of a constructed att is not allowed.
ERROR_DS_CONSTRUCTED_ATT_MOD :: 8475;
// The OM-Object-Class specified is incorrect for an attribute with the specified syntax.
ERROR_DS_WRONG_OM_OBJ_CLASS :: 8476;
// The replication request has been posted; waiting for reply.
ERROR_DS_DRA_REPL_PENDING :: 8477;
// The requested operation requires a directory service, and none was available.
ERROR_DS_DS_REQUIRED :: 8478;
// The LDAP display name of the class or attribute contains non-ASCII characters.
ERROR_DS_INVALID_LDAP_DISPLAY_NAME :: 8479;
// The requested search operation is only supported for base searches.
ERROR_DS_NON_BASE_SEARCH :: 8480;
// The search failed to retrieve attributes from the database.
ERROR_DS_CANT_RETRIEVE_ATTS :: 8481;
// The schema update operation tried to add a backward link attribute that has no corresponding forward link.
ERROR_DS_BACKLINK_WITHOUT_LINK :: 8482;
// Source and destination of a cross domain move do not agree on the object's epoch number. Either source or destination does not have the latest version of the object.
ERROR_DS_EPOCH_MISMATCH :: 8483;
// Source and destination of a cross domain move do not agree on the object's current name. Either source or destination does not have the latest version of the object.
ERROR_DS_SRC_NAME_MISMATCH :: 8484;
// Source and destination of a cross domain move operation are identical. Caller should use local move operation instead of cross domain move operation.
ERROR_DS_SRC_AND_DST_NC_IDENTICAL :: 8485;
// Source and destination for a cross domain move are not in agreement on the naming contexts in the forest. Either source or destination does not have the latest version of the Partitions container.
ERROR_DS_DST_NC_MISMATCH :: 8486;
// Destination of a cross domain move is not authoritative for the destination naming context.
ERROR_DS_NOT_AUTHORITIVE_FOR_DST_NC :: 8487;
// Source and destination of a cross domain move do not agree on the identity of the source object. Either source or destination does not have the latest version of the source object.
ERROR_DS_SRC_GUID_MISMATCH :: 8488;
// Object being moved across domains is already known to be deleted by the destination server. The source server does not have the latest version of the source object.
ERROR_DS_CANT_MOVE_DELETED_OBJECT :: 8489;
// Another operation which requires exclusive access to the PDC PSMO is already in progress.
ERROR_DS_PDC_OPERATION_IN_PROGRESS :: 8490;
// A cross domain move operation failed such that the two versions of the moved object exist - one each in the source and destination domains. The destination object must be removed to restore the system to a consistent state.
ERROR_DS_CROSS_DOMAIN_CLEANUP_REQD :: 8491;
// This object cannot be moved across domain boundaries either because cross domain moves for this class are disallowed, or the object has some special characteristics, eg: trust account or restricted RID, which prevent its move.
ERROR_DS_ILLEGAL_XDOM_MOVE_OPERATION :: 8492;
// Can't move objects with memberships across domain boundaries as once moved, this would violate the membership conditions of the account group. Remove the object from any account group memberships and retry.
ERROR_DS_CANT_WITH_ACCT_GROUP_MEMBERSHPS :: 8493;
// A naming context head must be the immediate child of another naming context head, not of an interior node.
ERROR_DS_NC_MUST_HAVE_NC_PARENT :: 8494;
// The directory cannot validate the proposed naming context name because it does not hold a replica of the naming context above the proposed naming context.
ERROR_DS_CR_IMPOSSIBLE_TO_VALIDATE :: 8495;
// Destination of a cross domain move must be in native mode.
ERROR_DS_DST_DOMAIN_NOT_NATIVE :: 8496;
// The operation cannot be performed because the server does not have an infrastructure container in the domain of interest.
ERROR_DS_MISSING_INFRASTRUCTURE_CONTAINER :: 8497;
// Cross domain move of account groups is not allowed.
ERROR_DS_CANT_MOVE_ACCOUNT_GROUP :: 8498;
// Cross domain move of resource groups is not allowed.
ERROR_DS_CANT_MOVE_RESOURCE_GROUP :: 8499;
// The search flags for the attribute are invalid. The ANR bit is valid only on attributes of Unicode or Teletex strings.
ERROR_DS_INVALID_SEARCH_FLAG :: 8500;
// Tree deletions starting at an object which has an NC head as a descendant are not allowed.
ERROR_DS_NO_TREE_DELETE_ABOVE_NC :: 8501;
// The directory service failed to lock a tree in preparation for a tree deletion because the tree was in use.
ERROR_DS_COULDNT_LOCK_TREE_FOR_DELETE :: 8502;
// The directory service failed to identify the list of objects to delete while attempting a tree deletion.
ERROR_DS_COULDNT_IDENTIFY_OBJECTS_FOR_TREE_DELETE :: 8503;
ERROR_DS_SAM_INIT_FAILURE :: 8504;
// Only an administrator can modify the membership list of an administrative group.
ERROR_DS_SENSITIVE_GROUP_VIOLATION :: 8505;
// Cannot change the primary group ID of a domain controller account.
ERROR_DS_CANT_MOD_PRIMARYGROUPID :: 8506;
// DNS server unable to interpret format.
DNS_ERROR_RCODE_FORMAT_ERROR :: 9001;
// DNS server failure.
DNS_ERROR_RCODE_SERVER_FAILURE :: 9002;
// DNS name does not exist.
DNS_ERROR_RCODE_NAME_ERROR :: 9003;
// DNS request not supported by name server.
DNS_ERROR_RCODE_NOT_IMPLEMENTED :: 9004;
// DNS operation refused.
DNS_ERROR_RCODE_REFUSED :: 9005;
// DNS name that ought not exist, does exist.
DNS_ERROR_RCODE_YXDOMAIN :: 9006;
// DNS RR set that ought not exist, does exist.
DNS_ERROR_RCODE_YXRRSET :: 9007;
// DNS RR set that ought to exist, does not exist.
DNS_ERROR_RCODE_NXRRSET :: 9008;
// DNS server not authoritative for zone.
DNS_ERROR_RCODE_NOTAUTH :: 9009;
// DNS name in update or prereq is not in zone.
DNS_ERROR_RCODE_NOTZONE :: 9010;
// DNS signature failed to verify.
DNS_ERROR_RCODE_BADSIG :: 9016;
// DNS bad key.
DNS_ERROR_RCODE_BADKEY :: 9017;
// DNS signature validity expired.
DNS_ERROR_RCODE_BADTIME :: 9018;
// No records found for given DNS query.
DNS_INFO_NO_RECORDS :: 9501;
// Bad DNS packet.
DNS_ERROR_BAD_PACKET :: 9502;
// No DNS packet.
DNS_ERROR_NO_PACKET :: 9503;
// DNS error, check rcode.
DNS_ERROR_RCODE :: 9504;
// Unsecured DNS packet.
DNS_ERROR_UNSECURE_PACKET :: 9505;
// Invalid DNS type.
DNS_ERROR_INVALID_TYPE :: 9551;
// Invalid IP address.
DNS_ERROR_INVALID_IP_ADDRESS :: 9552;
// Invalid property.
DNS_ERROR_INVALID_PROPERTY :: 9553;
// Try DNS operation again later.
DNS_ERROR_TRY_AGAIN_LATER :: 9554;
// Record for given name and type is not unique.
DNS_ERROR_NOT_UNIQUE :: 9555;
// DNS name does not comply with RFC specifications.
DNS_ERROR_NON_RFC_NAME :: 9556;
// DNS name is a fully-qualified DNS name.
DNS_STATUS_FQDN :: 9557;
// DNS name is dotted (multi-label).
DNS_STATUS_DOTTED_NAME :: 9558;
// DNS name is a single-part name.
DNS_STATUS_SINGLE_PART_NAME :: 9559;
// DNS zone does not exist.
DNS_ERROR_ZONE_DOES_NOT_EXIST :: 9601;
// DNS zone information not available.
DNS_ERROR_NO_ZONE_INFO :: 9602;
// Invalid operation for DNS zone.
DNS_ERROR_INVALID_ZONE_OPERATION :: 9603;
// Invalid DNS zone configuration.
DNS_ERROR_ZONE_CONFIGURATION_ERROR :: 9604;
// DNS zone has no start of authority (SOA) record.
DNS_ERROR_ZONE_HAS_NO_SOA_RECORD :: 9605;
// DNS zone has no name server (NS) record.
DNS_ERROR_ZONE_HAS_NO_NS_RECORDS :: 9606;
// DNS zone is locked.
DNS_ERROR_ZONE_LOCKED :: 9607;
// DNS zone creation failed.
DNS_ERROR_ZONE_CREATION_FAILED :: 9608;
// DNS zone already exists.
DNS_ERROR_ZONE_ALREADY_EXISTS :: 9609;
// DNS automatic zone already exists.
DNS_ERROR_AUTOZONE_ALREADY_EXISTS :: 9610;
// Invalid DNS zone type.
DNS_ERROR_INVALID_ZONE_TYPE :: 9611;
// Secondary DNS zone requires master IP address.
DNS_ERROR_SECONDARY_REQUIRES_MASTER_IP :: 9612;
// DNS zone not secondary.
DNS_ERROR_ZONE_NOT_SECONDARY :: 9613;
// Need secondary IP address.
DNS_ERROR_NEED_SECONDARY_ADDRESSES :: 9614;
// WINS initialization failed.
DNS_ERROR_WINS_INIT_FAILED :: 9615;
// Need WINS servers.
DNS_ERROR_NEED_WINS_SERVERS :: 9616;
// NBTSTAT initialization call failed.
DNS_ERROR_NBSTAT_INIT_FAILED :: 9617;
// Invalid delete of start of authority (SOA)
DNS_ERROR_SOA_DELETE_INVALID :: 9618;
// Primary DNS zone requires datafile.
DNS_ERROR_PRIMARY_REQUIRES_DATAFILE :: 9651;
// Invalid datafile name for DNS zone.
DNS_ERROR_INVALID_DATAFILE_NAME :: 9652;
// Failed to open datafile for DNS zone.
DNS_ERROR_DATAFILE_OPEN_FAILURE :: 9653;
// Failed to write datafile for DNS zone.
DNS_ERROR_FILE_WRITEBACK_FAILED :: 9654;
// Failure while reading datafile for DNS zone.
DNS_ERROR_DATAFILE_PARSING :: 9655;
// DNS record does not exist.
DNS_ERROR_RECORD_DOES_NOT_EXIST :: 9701;
// DNS record format error.
DNS_ERROR_RECORD_FORMAT :: 9702;
// Node creation failure in DNS.
DNS_ERROR_NODE_CREATION_FAILED :: 9703;
// Unknown DNS record type.
DNS_ERROR_UNKNOWN_RECORD_TYPE :: 9704;
// DNS record timed out.
DNS_ERROR_RECORD_TIMED_OUT :: 9705;
// Name not in DNS zone.
DNS_ERROR_NAME_NOT_IN_ZONE :: 9706;
// CNAME loop detected.
DNS_ERROR_CNAME_LOOP :: 9707;
// Node is a CNAME DNS record.
DNS_ERROR_NODE_IS_CNAME :: 9708;
// A CNAME record already exists for given name.
DNS_ERROR_CNAME_COLLISION :: 9709;
// Record only at DNS zone root.
DNS_ERROR_RECORD_ONLY_AT_ZONE_ROOT :: 9710;
// DNS record already exists.
DNS_ERROR_RECORD_ALREADY_EXISTS :: 9711;
// Secondary DNS zone data error.
DNS_ERROR_SECONDARY_DATA :: 9712;
// Could not create DNS cache data.
DNS_ERROR_NO_CREATE_CACHE_DATA :: 9713;
// DNS name does not exist.
DNS_ERROR_NAME_DOES_NOT_EXIST :: 9714;
// Could not create pointer (PTR) record.
DNS_WARNING_PTR_CREATE_FAILED :: 9715;
// DNS domain was undeleted.
DNS_WARNING_DOMAIN_UNDELETED :: 9716;
// The Windows NT directory service is unavailable.
DNS_ERROR_DS_UNAVAILABLE :: 9717;
// DNS zone already exists in Windows NT directory service.
DNS_ERROR_DS_ZONE_ALREADY_EXISTS :: 9718;
// DNS server not creating or reading the boot file for the directory service integrated DNS zone.
DNS_ERROR_NO_BOOTFILE_IF_DS_ZONE :: 9719;
// DNS AXFR (zone transfer) complete.
DNS_INFO_AXFR_COMPLETE :: 9751;
// DNS zone transfer failed.
DNS_ERROR_AXFR :: 9752;
// Added local WINS server.
DNS_INFO_ADDED_LOCAL_WINS :: 9753;
// Secure update call must continue update request.
DNS_STATUS_CONTINUE_NEEDED :: 9801;
// TCP/IP network protocol not installed.
DNS_ERROR_NO_TCPIP :: 9851;
// No DNS servers configured for local system.
DNS_ERROR_NO_DNS_SERVERS :: 9852;
// A blocking operation was interrupted by a call to WSACancelBlockingCall.
WSAEINTR :: 10004;
// The file handle supplied is not valid.
WSAEBADF :: 10009;
// An attempt was made to access a socket in a way forbidden by its access permissions.
WSAEACCES :: 10013;
// The system detected an invalid pointer address in attempting to use a pointer argument in a call.
WSAEFAULT :: 10014;
// An invalid argument was supplied.
WSAEINVAL :: 10022;
// Too many open sockets.
WSAEMFILE :: 10024;
// A non-blocking socket operation could not be completed immediately.
WSAEWOULDBLOCK :: 10035;
// A blocking operation is currently executing.
WSAEINPROGRESS :: 10036;
// An operation was attempted on a non-blocking socket that already had an operation in progress.
WSAEALREADY :: 10037;
// An operation was attempted on something that is not a socket.
WSAENOTSOCK :: 10038;
// A required address was omitted from an operation on a socket.
WSAEDESTADDRREQ :: 10039;
// A message sent on a datagram socket was larger than the internal message buffer or some other network limit, or the buffer used to receive a datagram into was smaller than the datagram itself.
WSAEMSGSIZE :: 10040;
// A protocol was specified in the socket function call that does not support the semantics of the socket type requested.
WSAEPROTOTYPE :: 10041;
// An unknown, invalid, or unsupported option or level was specified in a getsockopt or setsockopt call.
WSAENOPROTOOPT :: 10042;
// The requested protocol has not been configured into the system, or no implementation for it exists.
WSAEPROTONOSUPPORT :: 10043;
// The support for the specified socket type does not exist in this address family.
WSAESOCKTNOSUPPORT :: 10044;
// The attempted operation is not supported for the type of object referenced.
WSAEOPNOTSUPP :: 10045;
// The protocol family has not been configured into the system or no implementation for it exists.
WSAEPFNOSUPPORT :: 10046;
// An address incompatible with the requested protocol was used.
WSAEAFNOSUPPORT :: 10047;
// Only one usage of each socket address (protocol/network address/port) is normally allowed.
WSAEADDRINUSE :: 10048;
// The requested address is not valid in its context.
WSAEADDRNOTAVAIL :: 10049;
// A socket operation encountered a dead network.
WSAENETDOWN :: 10050;
// A socket operation was attempted to an unreachable network.
WSAENETUNREACH :: 10051;
// The connection has been broken due to keep-alive activity detecting a failure while the operation was in progress.
WSAENETRESET :: 10052;
// An established connection was aborted by the software in your host machine.
WSAECONNABORTED :: 10053;
// An existing connection was forcibly closed by the remote host.
WSAECONNRESET :: 10054;
// An operation on a socket could not be performed because the system lacked sufficient buffer space or because a queue was full.
WSAENOBUFS :: 10055;
// A connect request was made on an already connected socket.
WSAEISCONN :: 10056;
// A request to send or receive data was disallowed because the socket is not connected and (when sending on a datagram socket using a sendto call) no address was supplied.
WSAENOTCONN :: 10057;
// A request to send or receive data was disallowed because the socket had already been shut down in that direction with a previous shutdown call.
WSAESHUTDOWN :: 10058;
// Too many references to some kernel object.
WSAETOOMANYREFS :: 10059;
// A connection attempt failed because the connected party did not properly respond after a period of time, or established connection failed because connected host has failed to respond.
WSAETIMEDOUT :: 10060;
// No connection could be made because the target machine actively refused it.
WSAECONNREFUSED :: 10061;
// Cannot translate name.
WSAELOOP :: 10062;
// Name component or name was too long.
WSAENAMETOOLONG :: 10063;
// A socket operation failed because the destination host was down.
WSAEHOSTDOWN :: 10064;
// A socket operation was attempted to an unreachable host.
WSAEHOSTUNREACH :: 10065;
// Cannot remove a directory that is not empty.
WSAENOTEMPTY :: 10066;
// A Windows Sockets implementation can have a limit on the number of applications that can use it simultaneously.
WSAEPROCLIM :: 10067;
// Ran out of quota.
WSAEUSERS :: 10068;
// Ran out of disk quota.
WSAEDQUOT :: 10069;
// File handle reference is no longer available.
WSAESTALE :: 10070;
// Item is not available locally.
WSAEREMOTE :: 10071;
// WSAStartup cannot function at this time because the underlying system it uses to provide network services is currently unavailable.
WSASYSNOTREADY :: 10091;
// The Windows Sockets version requested is not supported.
WSAVERNOTSUPPORTED :: 10092;
// Either the application has not called WSAStartup, or WSAStartup failed.
WSANOTINITIALISED :: 10093;
// Returned by WSARecv or WSARecvFrom to indicate the remote party has initiated a graceful shutdown sequence.
WSAEDISCON :: 10101;
// No more results can be returned by WSALookupServiceNext.
WSAENOMORE :: 10102;
// A call to WSALookupServiceEnd was made while this call was still processing. The call has been canceled.
WSAECANCELED :: 10103;
// The procedure call table is invalid.
WSAEINVALIDPROCTABLE :: 10104;
// The requested service provider is invalid.
WSAEINVALIDPROVIDER :: 10105;
// The requested service provider could not be loaded or initialized.
WSAEPROVIDERFAILEDINIT :: 10106;
// A system call that should never fail has failed.
WSASYSCALLFAILURE :: 10107;
// No such service is known. The service cannot be found in the specified name space.
WSASERVICE_NOT_FOUND :: 10108;
// The specified class was not found.
WSATYPE_NOT_FOUND :: 10109;
// No more results can be returned by WSALookupServiceNext.
WSA_E_NO_MORE :: 10110;
// A call to WSALookupServiceEnd was made while this call was still processing. The call has been canceled.
WSA_E_CANCELED :: 10111;
// A database query failed because it was actively refused.
WSAEREFUSED :: 10112;
// No such host is known.
WSAHOST_NOT_FOUND :: 11001;
// This is usually a temporary error during hostname resolution and means that the local server did not receive a response from an authoritative server.
WSATRY_AGAIN :: 11002;
// A non-recoverable error occurred during a database lookup.
WSANO_RECOVERY :: 11003;
// The requested name is valid and was found in the database, but it does not have the correct associated data being resolved for.
WSANO_DATA :: 11004;
// At least one reserve has arrived.
WSA_QOS_RECEIVERS :: 11005;
// At least one path has arrived.
WSA_QOS_SENDERS :: 11006;
// There are no senders.
WSA_QOS_NO_SENDERS :: 11007;
// There are no receivers.
WSA_QOS_NO_RECEIVERS :: 11008;
// Reserve has been confirmed.
WSA_QOS_REQUEST_CONFIRMED :: 11009;
// Error due to lack of resources.
WSA_QOS_ADMISSION_FAILURE :: 11010;
// Rejected for administrative reasons - bad credentials.
WSA_QOS_POLICY_FAILURE :: 11011;
// Unknown or conflicting style.
WSA_QOS_BAD_STYLE :: 11012;
// Problem with some part of the filterspec or provider-specific buffer in general.
WSA_QOS_BAD_OBJECT :: 11013;
// Problem with some part of the flowspec.
WSA_QOS_TRAFFIC_CTRL_ERROR :: 11014;
// General QOS error.
WSA_QOS_GENERIC_ERROR :: 11015;
