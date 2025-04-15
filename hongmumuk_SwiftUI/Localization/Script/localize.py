import os
import sys
import time
import gspread
from oauth2client.service_account import ServiceAccountCredentials

# MARK: - 스크립트 실행 명령어 /Library/Frameworks/Python.framework/Versions/3.11/bin/python3 localize.py
# TODO: 파이썬 버전을 강제해줘야 스크립트가 실행됨 python3 localize.py 명령어로는 라이브러리가 없다는 에러 발생

# 파싱된 데이터를 .string 파일로 저장
def save_strings_to_file(strings, path):
    with open(path, 'w', encoding='utf-8') as file:
        file.write(strings)

# sheet 데이터를 파싱해, .strig파일에 들어갈 데이터로 변환
def process_sheets(all_sheets, ko_strings_path, en_strings_path, zh_strings_path):
    # 각 언어에 대한 문자열을 초기화
    ko_strings = []
    en_strings = []
    zh_strings = []
    
    for sheet in all_sheets:
        print(f"Processing sheet: {sheet.title}")  # 현재 시트 제목 출력
        sheet_data = sheet.get_all_values()[1:]  # 첫 번째 행은 헤더이므로 제외

        if not sheet_data:
            print(f"No data found in sheet: {sheet.title}")
            continue

        for sheet_row in sheet_data:
            description = sheet_row[0].strip() if len(sheet_row) > 0 else ''  # A열: Description
            key = sheet_row[1].strip() if len(sheet_row) > 1 else ''           # B열: Key
            ko_value = sheet_row[2].strip() if len(sheet_row) > 2 else ''      # C열: ko
            en_value = sheet_row[3].strip() if len(sheet_row) > 3 else ''      # D열: en
            zh_value = sheet_row[4].strip() if len(sheet_row) > 4 else ''      # E열: zh-Hans

            # 한글 .strings에 주석 포함
            if description:  # 설명이 비어있지 않은 경우에만 추가
                ko_strings.append(f"// {description}\n")
            ko_strings.append(f'"{key}" = "{ko_value}";\n')

            # 영어 .strings에 주석 포함
            if description:  # 설명이 비어있지 않은 경우에만 추가
                en_strings.append(f"// {description}\n")
            en_strings.append(f'"{key}" = "{en_value}";\n')

            # 중국어 .strings에 주석 포함
            if description:  # 설명이 비어있지 않은 경우에만 추가
                zh_strings.append(f"// {description}\n")
            zh_strings.append(f'"{key}" = "{zh_value}";\n')

    # 모든 시트를 처리한 후, 파일에 저장
    save_strings_to_file("".join(ko_strings), ko_strings_path)
    save_strings_to_file("".join(en_strings), en_strings_path)
    save_strings_to_file("".join(zh_strings), zh_strings_path)


# 실행 시작
start = time.time()

# 구글 스프레드시트 인증 및 API 접근 범위 설정
scope = [
    "https://spreadsheets.google.com/feeds",
    "https://www.googleapis.com/auth/drive",
]

# 현재 작업 디렉토리 가져오기
HOME_DIR = os.getcwd()   # 현재 작업 디렉토리

# JSON_KEY_PATH를 현재 디렉토리와 앱 내에서의 경로로 설정
JSON_KEY_PATH = HOME_DIR + "/hongmumuk-localization-456509-c03bc9f5eaee.json"

credential = ServiceAccountCredentials.from_json_keyfile_name(JSON_KEY_PATH, scope)
gc = gspread.authorize(credential)

spreadsheet_key = "1I1nCFUcWB2VlG8fTgQHryHG7jJhZL0Hca-d7ZOlSQv4"
doc = gc.open_by_key(spreadsheet_key)
all_sheets = doc.worksheets()

# .strings 파일 저장 경로 설정
ko_strings_file_path = HOME_DIR + "/ko.lproj/Localizable.strings"
en_strings_file_path = HOME_DIR + "/en.lproj/Localizable.strings"
zh_strings_file_path = HOME_DIR + "/zh.lproj/Localizable.strings"

# 모든 시트를 순회
process_sheets(all_sheets, ko_strings_file_path, en_strings_file_path, zh_strings_file_path)

print("localization 완료:", time.time() - start)
