import PyPDF2
import os
from docx import Document

def remove_metadata_pdf(input_pdf, output_pdf):
    try:
        with open(input_pdf, 'rb') as file:
            reader = PyPDF2.PdfReader(file)
            writer = PyPDF2.PdfWriter()

            for page in reader.pages:
                writer.add_page(page)

            with open(output_pdf, 'wb') as output_file:
                writer.write(output_file)

    except Exception as e:
        print(f"error occurred: {e}")


def remove_metadata_docx(input_docx, output_docx):
    try:
        doc = Document(input_docx)
        metadata_properties = [
            'author', 'comments', 'category', 'content_status',
            'identifier', 'keywords', 'language', 'last_modified_by',
            'last_printed', 'revision', 'subject', 'title', 'version', 'created', 'modified'
        ]

        for prop in metadata_properties:
            try:
                setattr(doc.core_properties, prop, "")
            except ValueError:
                pass

        doc.save(output_docx)

    except Exception as e:
        print(f"error occurred: {e}")

def remove_metadata_from_files(root_directory):
    for dirpath, _, filenames in os.walk(root_directory):
        for filename in filenames:
            file_path = os.path.join(dirpath, filename)
            try:
                if file_path.endswith('.pdf'):
                    remove_metadata_pdf(file_path, file_path) # change output diretory if necessary. 
                if file_path.endswith('.docx'):
                    remove_metadata_docx(file_path, file_path) # here too. 
                    
                print(f"removed metadata from file: {file_path}")
            except Exception as e:
                print(f"failed to process {file_path}: error - {e}")


current_directory = os.getcwd()
remove_metadata_from_files(current_directory)
