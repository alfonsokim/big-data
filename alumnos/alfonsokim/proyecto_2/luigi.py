import luigi
import luigi.contrib
import luigi.contrib.hdfs
import luigi.contrib.hadoop

class GetFile_Task(luigi.Task):

    url = u'http://data.gdeltproject.org/events/20150602.export.CSV.zip'

    def output(self):
        import urllib
        urllib.urlretrieve(self.url, '20150602.export.CSV.zip')
        return luigi.LocalTarget('get_task.txt')


class Decompress_Task(luigi.Task):
    def requires(self):
        return GetFile_Task()

    def output(self):
        import os
        print "Descomprimiento...\n"
        os.system('unzip -q 20150602.export.CSV.zip')
        return luigi.LocalTarget('20150602.export.CSV')

    def run(self):
        with self.input().open() as f:
            print f.read()

        with self.output().open('w') as f:
            f.write('done')

class UploadHDFS_Task(luigi.Task):

    def requires(self):
        return Decompress_Task() # [Decompress_Task(date) for date in self.date_interval]


    def output(self):
        print("Moviendo archivo...\n")
        return luigi.contrib.hdfs.HdfsTarget("/user/itam/datasets/gdelt/20150602.export.CSV",format=luigi.contrib.hdfs.Plain)

    def run(self):
        with self.input().open() as f:
            # process the result here
            print f.read()
        with self.output().open('w') as f:
            # crate the final output
            f.write('done')



if __name__=='__main__':
    luigi.run()