#!/usr/bin/python3

import frontmatter
import os
import glob
import yaml

path = '../'
print(os.getcwd())

def check(extensions, foldername, flag):
	files_all = []
	all_authors = []

	for e in extensions:
		formed_glob_input = path + foldername + "/**/" + e
		# print(formed_glob_input )
		files_all.extend(glob.glob( formed_glob_input, recursive = True))

#	print(files_all)
	print("files_all: " + str(len(files_all)))
	
	for checked_file in files_all:
		try:
			p = frontmatter.load(checked_file)
			loaded_authors_list = p.metadata['author']
			# print(loaded_authors_list)
			all_authors.extend(loaded_authors_list)
		except Exception as error:
			print(error)

	with open(path + '_data/authors.yml', 'r') as f:
		authors_from_yaml = yaml.safe_load(f)
	
	print("=== Sprawdzamy _data/authors.yml pod kątem autorów ujętych w artykułach ===")
	for author in sorted(set(all_authors)):
		try:
			author_status = authors_from_yaml[author][flag]
			if author_status:
				k = ("Status " + flag + " dla "+ str(author) + " to " + str(author_status) )
				# print(k)
				pass
			else:
				print('Flaga ' + flag + ' dla '+ str(author) + " - oto zawartosc: " + str(author_status))
		except:
			if author in authors_from_yaml:
				print('Nie wypełniono w ogóle flagi ' + flag + ' dla '+ str(author))
			else:
				print('Nie ma wpisanego w ogóle autora ' + str(author))
	print("=== A teraz od drugiej strony - sprawdzamy prawdziwość ustawionych flag ===")
	for author in set(authors_from_yaml.keys()):
		try:
			author_status_from_yaml = authors_from_yaml[author][flag]
			is_author_amongst_article_authors = author in all_authors
			# print("Author: " + author)
			# print("Author status set in file: " + str(author_status_from_yaml))
			# print("Did he/she rly: " + str(is_author_amongst_article_authors))
			# print("=====")

			if (author_status_from_yaml and not is_author_amongst_article_authors):
				print("Autor " + str(author) + " ma wpisane true w " + str(flag) + " ale nie ma strony na podparcie tej tezy")
			elif(is_author_amongst_article_authors and not author_status_from_yaml):
				print("Autor " + str(author) + " ma wpisane false w " + str(flag) + " choć są dowody na to, że to nieprawda")

		except Exception as error:
			print("Autor " + str(author) + " nie ma w ogóle ustawionej flagi " + str(flag))


ext = ['*.md','*.html',"*.htm"]
check(ext, '_puk', 'constructor')
check(ext, '_talks', 'speaker')

