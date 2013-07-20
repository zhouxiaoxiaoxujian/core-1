/**
 * 			var ifs:FileStream = new FileStream;
			ifs.open(inputFile, FileMode.READ);
			var fr:FileReader = new FileReader(ifs);

			var ofs:FileStream = new FileStream;
			ofs.open(outputFile, FileMode.WRITE);


			var rep:RegExp;
			var replace:String;
			for (var line:String = fr.readLine(); line != null; line = fr.readLine())
			{

				for (var key:String in map)
				{
					rep = new RegExp(key)
					replace = map[key];
					line = line.replace(rep, replace);
				}
				ofs.writeUTFBytes(line);
			}

			fr.close();
			ofs.close();
 *
 */
package cactus.common.file
{
	import flash.filesystem.FileStream;


	public class FileReader
	{
		private var _stream:FileStream;

		public function FileReader(fs:FileStream)
		{
			_stream = fs;
		}

		public function close():void
		{
			_stream.close();
		}

		/**
		 * 读一行
		 * @return
		 */
		public function readLine():String
		{
			return FileUtil.readLine(_stream);
		}
	}
}
