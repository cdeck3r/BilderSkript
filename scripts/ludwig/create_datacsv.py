import csv
import os
from dataclasses import dataclass
import click
from itertools import zip_longest

"""Creates csv data files for image classification in Ludwig.

This csv file associates /path/to/images with class names.

Usage: create_datacsv.py [OPTIONS] IMG_BASE_PATH

Options:
  -l, --labels TEXT   class labels as list
  -h, --headers TEXT  header fieldnames as list
  -o, --outfile TEXT  data csv filename
  --help              Show this message and exit.


We assume the following directory structure, 
where the class label is the directory name, 
e.g. img_base_path/<class label>/*.jpg

Using the CLI option 
    `--labels "label1, label2, label3, ..."` 
one may specify alternative class labels for
each subdir name in `img_base_path/<subdir name>/*.jpg`.
Instead of the `<subdir name>`, it assigns the corresponding label
to each image in `<subdir name>`. The `<subdir names>` are in 
lexicographical order; the order of labels is the one in which 
they were specified in the option.

The csv output file name is by default the last directory 
name of the img_base_path. Use a CLI option
    `--outfile`
to specify an alternative name.

"""

# This clever approach uses a dataclass to keep track 
# of images and their class names.
#
# It originates from masters student F. Mastouri
@dataclass
class Image:
    base_path: str
    file_name: str
    cls: str

    @property
    def path(self):
        return os.path.abspath(os.path.join(self.base_path, self.file_name))

def collect_images(path, cls):
    """Collects all files in given path and return Image objects.
    
    It creates Images dataclass objects associated with the given 
    class name from each file.
    
    Keyword arguments:
    path -- the path to traverse for files
    cls -- the class name used for all files in path
    
    """

    for img_name in next(os.walk(path))[2]:
        img = Image(path, img_name, cls)

        yield img


def string2list(liststr):
    """Creates a list from a string formatted list.
    
    Keyword arguments:
    liststr -- string such as "(label1, label2, ...)" or "label1, label2, ..."
 
    """
    replacements = {"(":"", ")":"", "[":"", "]":""}
    stripped_liststr = "".join([replacements.get(c, c) for c in liststr])
    no_whitespace_str = "".join(stripped_liststr.split())
    return list(no_whitespace_str.split(","))

def write_datacsv(outfile, fieldnames, img_base_path, imgsubdir_cls):
    """Write the data csv file for use in Ludwig.
    
    Keyword arguments:
    outfile -- output file name
    fieldnames -- list of header fieldnames in the outfile
    img_base_path -- the path to search for images within their respective subdirs
    imgsubdir_cls -- list of class name assigned to each subdir in img_base_path
    
    """
    
    with open(outfile, mode='w', newline='') as csvfile:
        csv_writer = csv.writer(csvfile, delimiter=',', quoting=csv.QUOTE_MINIMAL)
        # write header
        csv_writer.writerow(fieldnames)
        # iterate through subdirs, collect image files 
        # and write everything in outfile
        for subdir,cls in imgsubdir_cls:
            img_path = os.path.join(img_base_path, subdir)
            for img in collect_images(img_path, cls):
                csv_writer.writerow((img.path, img.cls))


@click.command()
@click.argument('img_base_path')
@click.option('--labels', '-l', type=str, help='class labels as list')
@click.option('--headers', '-h', type=str, help="header fieldnames as list")
@click.option('--outfile', '-o', type=str, help="data csv file name")
def cli(img_base_path, labels, headers, outfile):
    # by default the class names are the directory names in img_base_path
    # os.walk(...) sources from https://stackoverflow.com/a/142535
    cls_names = next(os.walk(img_base_path))[1]
    img_subdirs = cls_names
    # if the labels option is specified, we use them as class names instead
    if labels:
        cls_names = string2list(labels)
        # cut cls_names to img_subdirs
        if len(cls_names) > len(img_subdirs):
            cls_names = cls_names[0:len(img_subdirs)]

    # We perform `zip(img_subdirs, cls_names)` 
    # if less labels than class names from subdirs are provided
    # we will the missing names with "?" string and replace it afterwards
    # with the subdir name
    def replace_fillvalue(iterator, fillvalue='?'):
        """Replaces a given value, mostly UNK, with the other element's value in the iterator.

        Works only for iterators with two aggregated elements.
        
        Keyword arguments:
        iterator -- contains two aggregated elements 
        fillvalue -- the string to search and to replace with the other element
        
        """
        for elem1, elem2 in iterator:
            if elem1 == fillvalue:
                elem1 = elem2
            if elem2 == fillvalue:
                elem2 = elem1
            yield tuple([elem1, elem2])

    imgsubdir_cls = replace_fillvalue(zip_longest(img_subdirs, cls_names, fillvalue='?'))
    imgsubdir_cls = list(imgsubdir_cls)
    
    # test: we should have as many class names as there are subdirs
    # ...
    
    # if outfile is not provided, it's set to the last directory name 
    if not outfile:
        outfile = os.path.basename(os.path.normpath(img_base_path))
        outfile = outfile + ".csv"

    # default header fields
    fieldnames = ('image_path', 'class')
    # if headers option is specified, we use them instead of default
    if headers:
        fieldnames = string2list(headers)

    # debug
    print("Image base path:", img_base_path)
    print("CSV filename:", outfile)
    print("Provided labels:", cls_names)
    print("Provided headers:", fieldnames)
    print("image subdirs and class names:", imgsubdir_cls)
    
    # let's create the csv data file
    write_datacsv(outfile, fieldnames, img_base_path, imgsubdir_cls)


if __name__ == '__main__':
    cli()
             