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
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                child: const Text('Upload'),
                onPressed: () {
                  _uploadSoftware();
                },
              ))
        ],
      ),
    );
  }

  Future<void> _handleSelectPress() async {
    //String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      // User didn't cancel the picker
      String selectedDirectory = result.files.single.path!;
      Provider.of<SoftwareUploadManager>(context, listen: false)
          .updateDirectory(selectedDirectory);
    }
    setState(() {});
  }

  Future<void> _uploadSoftware() async {
    final client = SSHClient(
      await SSHSocket.connect('192.168.0.106', 22),
      username: 'helixio',
      onPasswordRequest: () => 'password',
    );

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
      allowMultiple: true,
    );

    final sftp = await client.sftp();

    if (result != null) {
      List<File> filesToUpload =
          result.paths.map((path) => File(path!)).toList();
      for (final fileToUpload in filesToUpload) {
        final file = await sftp.open(
            'helixio/helixio/experiments/' + fileToUpload.uri.pathSegments.last,
            mode: SftpFileOpenMode.create | SftpFileOpenMode.write);
        await file.write(fileToUpload.openRead().cast());
      }
    } else {
      // User canceled the picker
    }

    //await sftp.mkdir('new_directory');
    // final file = await sftp.open('uploaded_file.txt',
    //     mode: SftpFileOpenMode.create | SftpFileOpenMode.write);
    // await file.write(
    //     File(context.read<SoftwareUploadManager>().softwareDirectory)
    //         .openRead()
    //         .cast());

    // final items = await sftp.listdir('/home/helixio/');
    // bool hasSoftware = false;

    // for (final item in items) {
    //   if (item.filename == 'helixio') {
    //     hasSoftware = true;

    //     break;
    //   }
    // }

    // if (!hasSoftware) {
    //   await sftp.mkdir('helixio');
    // }

    client.close();
    await client.done;
  }
}
