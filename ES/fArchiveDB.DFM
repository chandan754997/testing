�
 TFRMARCHIVEDB 0�  TPF0�TFrmArchiveDBFrmArchiveDBCaption!Archivo jornal electr�nico (Demo)PixelsPerInch`
TextHeight � TLabelLblArchiveDateLeft(TopQWidth<HeightCaptionFecha del archivo  �
TStatusBar
StsBarExecTop6  �TProgressBar
PgsBarExecTop&  �TPanel
PnlBtnsTop �TSpeedButtonBtnStartCaption	&Exportar   �	TGroupBox
GbxLoggingTop�   �TDateTimePickerDTPickerArchiveDateLeft� TopPWidth� HeightDate���ߝX��?Time���ߝX��?TabOrder  TQueryqryJobStatusDatabaseNameDBFlexPointSQL.Strings@SELECT CONVERT(VARCHAR(1000),job_id) as JobID FROM msdb..sysjobs2  WHERE name = 'Manual back-up electronic journal'  Left�Top0  TStoredProcSprJobStatusDatabaseNameDBFlexPointStoredProcNamemsdb..sp_get_composite_job_infoLeftTopx	ParamDataDataTypeftStringName@Job_ID	ParamTypeptInput    TStoredProcSprManArchiveDatabaseNameDBFlexPointStoredProcNamemsdb..sp_start_jobLeft Top� 	ParamDataDataTypeftStringName	@Job_Name	ParamTypeptInput     