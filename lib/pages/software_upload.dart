import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:helixio_app/modules/core/managers/software_upload_manager.dart';

import 'package:helixio_app/pages/page_scaffold.dart';

class SoftwareUploadPage extends StatefulWidget {
  const SoftwareUploadPage({Key? key}) : super(key: key);

  @override
  State<SoftwareUploadPage> createState() => _SoftwareUploadPageState();
}

class _SoftwareUploadPageState extends State<SoftwareUploadPage> {
  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: 'Software Upload',
      body: Row(
        children: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                child: const Text('Select Folder'),
                onPressed: () {
                  _handleSelectPress();
                },
              )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Consumer<SoftwareUploadManager>(
              builder: (context, softwareUploadManager, child) {
                return Text(softwareUploadManager.softwareDirectory);
              },
            ),
          )
        ],
      ),
    );
  }

  Future<void> _handleSelectPress() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory != null) {
      // User didn't cancel the picker
      Provider.of<SoftwareUploadManager>(context, listen: false)
          .updateDirectory(selectedDirectory);
    }
    setState(() {});
  }

  Future<void> _uploadSoftware() async {
    final client = SSHClient(
      await SSHSocket.connect('localhost', 22),
      username: '<username>',
      onPasswordRequest: () => '<password>',
    );
    final sftp = await client.sftp();
    final file = await sftp.open('new_directory',
        mode: SftpFileOpenMode.create | SftpFileOpenMode.write);
    await file.write(
        File(context.read<SoftwareUploadManager>().softwareDirectory)
            .openRead()
            .cast());
  }
}
