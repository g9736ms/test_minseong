from tkinter import Tk, messagebox, filedialog, ttk
from boto3.s3.transfer import TransferConfig
import tkinter as tk
import boto3, time, threading, os, sys, aws_info

class MyFirstGUI:
    #틀
    def __init__(self, app):
        self.a = []
        self.b = []
        self.app = app
        app.title("4by4inc")
        app.geometry('720x520')
        app.resizable(False, False)

        #매뉴바 생성
        menubar = tk.Menu(app)
        filemenu = tk.Menu(menubar, tearoff=0)
        menubar.add_cascade(label="Open", menu=filemenu)
        filemenu.add_command(label="Open file(s) ...", command=self.defopen)
        filemenu.add_separator()
        filemenu.add_command(label="Open folder ...", command=self.open_folder)
        root.config(menu=menubar)

        # 라벨 설정
        my_file_list = tk.Label(app, text="- Upload list")
        my_file_list.place(x=20, y=35)

        s3_file_list = tk.Label(app, text="- Cloud storage")
        s3_file_list.place(x=370, y=35)


        #로그인 되면  바꿔주고 사람 이름 넣어주는 라밸
        self.wellcome_lable = tk.Label(app, text="Click the login button", font=20)
        self.wellcome_lable.place(x=20, y=2)
        #프로그래스 바의 진행 상황을 알려주는 라벨
        self.progressbar_label = tk.Label(app, text="( ready ... )")
        self.progressbar_label.place(x=640, y=432)

        #스크롤바 만들기
        scrollbar1 = tk.Scrollbar(app, orient="horizontal")
        scrollbar1.place(x=220, y=375, width=135)

        scrollbar2 = tk.Scrollbar(app, orient="horizontal")
        scrollbar2.place(x=367, y=375, width=135)

        # 파일 불러오는 텍스트 박스
        self.file_list_box = tk.Listbox(app,
                                        xscrollcommand=scrollbar1.set,
                                        selectmode='multiple',
                                        height=20, width=47)
        scrollbar1.config(command=self.file_list_box.xview)
        self.file_list_box.place(x=20, y=55)

        # s3 버킷에 있는 파일들을 불러오는 텍스트 박스
        self.s3_list_box = tk.Listbox(app,
                                      xscrollcommand=scrollbar2.set,
                                      selectmode='multiple',
                                      height=20, width=47)
        scrollbar2.config(command=self.s3_list_box.xview)
        self.s3_list_box.place(x=370, y=55)

        #Log를 나타낼 엔트리 박스
        self.log_list = tk.Listbox(app, height=3, width=97)
        self.log_list.insert(tk.END, "ready ...")
        self.log_list.place(x=20, y=450)

        # 로그인 버튼
        self.main_button = tk.Button(app,
                                     text="Login",
                                     height=2, width=8,
                                     command=self.aws_access)
        self.main_button.place(x=640, y=8)
        self.login_point = 0


        # ADD 버튼
        open_file = tk.Button(app,
                              text="File(s)",
                              command=self.defopen)
        open_file.place(x=20, y=380)

        #folder 버튼
        open_folders = tk.Button(app,
                                 text="Folder",
                                 command=self.open_folder)
        open_folders.place(x=65, y=380)

        #delete 버튼
        self.item_del = tk.Button(app,
                                  text="delete",
                                  command=self.delete_item)
        self .item_del.place(x=170, y=380)

        # 파일 보내는 버튼(state=tk.DISABLED)
        self.send_file = tk.Button(app,
                                   state=tk.DISABLED,
                                   text="send file(s)",
                                   command=lambda: threading.Thread(target=self.defsend).start())
        self.send_file.place(x=635, y=380)
        self.thread_point = 0

        #프로그래스바
        self.progressbar = tk.ttk.Progressbar(maximum=100, length=680, mode="determinate")
        self.progressbar.place(x=20, y=413)



    #Access 버튼에서 값 받아오는 부분
    def aws_access(self):
        if self.login_point == 0:
            #외부 함수 호출 후 리턴값 받아옴
            add_aws = aws_info.info()
            self.bucket_name = add_aws[0]
            self.aws_name = add_aws[1]
            self.aws_id = add_aws[2]
            self.aws_key = add_aws[3]
            try:
                # s3 버킷 로그인하여 엑세스 함
                self.s3 = boto3.client(
                    's3',  # 버킷 실행
                    aws_access_key_id=self.aws_id,
                    aws_secret_access_key=self.aws_key
                )
                self.wellcome_lable.config(text="Hello, "+self.aws_name)
                #response = s3.list_buckets()  # 버킷 리스트 확인 하는
                #print(response)
                #엑세스 해서 s3버킷 안 사용자 파일에 대한 정보를 넘겨줌
                paginator = self.s3.get_paginator('list_objects_v2')
                response_iterator = paginator.paginate(
                    Bucket=self.bucket_name,
                    Prefix=self.aws_name
                )
                #값이 보이는 것을 초기화 함
                self.s3_list_box.delete(0, tk.END)
                #s3버킷에 있는 컨텐츠들을 가져옴
                for page in response_iterator:
                    for content in page['Contents']:
                        self.s3_list_box.insert(tk.END, content['Key'])
                #로그인 완료 후 버튼의 상태를 바꿔줌
                self.main_button.config(text='LogOut')

                self.log_list.insert(tk.END, "Select the desired file or folder "
                                             "type from the menu(Open) to open it.")
                self.login_point = 1
                self.send_file.config(state=tk.NORMAL)
            #예외 처리 실패시 실패 창을 띄워 준다.
            except:
                messagebox.showinfo("error", "Your information is wrong. "
                                             "Please contact the 4by4 manager.")
        else:
            #로그 아웃 버튼은 아예 프로그램 재시작 해버림
            executable = sys.executable  # 경로를 저장함
            args = sys.argv[:]
            args.insert(0, sys.executable)
            time.sleep(1)
            os.execvp(executable, args)
            self.s3_list_box.delete(0, tk.END)
            self.main_button.config(text='Login')
            self.login_point = 0

    #a나 b의 값이 0이면 삭제해준다
    def zero_del(self):
        a = 0
        for x in self.b:
            if self.b[a] == 0:
                del self.b[a]
                del self.a[a]
            a = a + 1

    #폴더나 디렉터리 여는 함수
    def open_folder(self):
        root.dirName = filedialog.askdirectory()
        num = 0
        for (path, dir, files) in os.walk(root.dirName):
            for _filename in files:
                fullname = ("%s/%s" % (path, _filename))
                self.file_list_box.insert(tk.END, fullname)
                num = num + 1
        self.item_open_qty = self.file_list_box.size()

        upload_place = root.dirName.rsplit('/', 1)
        self.a.append(upload_place[1])
        self.b.append(num)

        how_much_file = "{0}, {1} files were opened.".format(self.item_open_qty, upload_place[1])
        self.log_list.insert(tk.END, how_much_file)
        self.log_list.see("end")

    #open 버튼 파일 여는 버튼의 함수
    def defopen(self):
        num = 0
        # 파일 여는거 나오는 거임 버튼 눌러서 나오게 하자
        file_add = filedialog.askopenfilenames(initialdir="/", title="Select file",
                                               filetypes=(("all files", "*.*"), ("txt files", "*.txt")))
        # print(filename) 그냥 END 쓰면 안되서 tk.END씀 거기에 있는걸 불러오는듯 함
        for file_add_name in file_add:
            self.file_list_box.insert(tk.END, file_add_name)
            num = num + 1
        self.a.append("file")
        self.b.append(num)
        self.zero_del()
        print(self.a, self.b)

    #파일 삭제 버튼
    def delete_item(self):
        box_sel_idx = self.file_list_box.curselection()
        num = 0
        in_num = 0
        out_num = 0
        select_item = []
        delete_qty = []

        #눌렀을때 self.b[]가 0이면 그 튜플은 지워라라
        self.zero_del()

        #리스트 박스 내용 삭제
        for x in box_sel_idx:
            select_item.append(x)

        select_item.reverse()
        for x in select_item:
            self.file_list_box.delete(x)

        #배열 삭제 구하기
        for x_b in self.b:
            out_num = out_num + self.b[num]
            x = 0
            for x_box_sel_idx in box_sel_idx:
                if in_num <= x_box_sel_idx and x_box_sel_idx < out_num:
                    x = x + 1
            if x != 0:
                delete_qty.append(x)
            else:
                delete_qty.append(0)
            in_num = in_num + self.b[num]

            num = num + 1

        #배열 삭제
        a = 0
        for x in delete_qty:
            self.b[a] = self.b[a] - x
            a = a + 1

        # self.b[]가 0이면 그 튜플은 지워라라
        self.zero_del()

    #프로그레스바 영역
    def test_def(self, bytes_amount):
        #print("in")
        #print(self.filename_index)
        _size = float(os.path.getsize(self.filename_index))
        _lock = threading.Lock()
        _seen_so_far = 0
        with _lock:
            _seen_so_far += bytes_amount
            percentage = (_seen_so_far / _size) * 100
            #sys.stdout.write(
            #    "\r%s  %s / %s  (%.2f%%)" % (
            #        self.filename_index, _seen_so_far, _size,
            #        percentage))
            #sys.stdout.flush()
            self.progressbar.step(percentage)
        self.percentage_1 = self.percentage_1 + percentage
        _on = int(self.percentage_1)
        str(_on)
        #몇 퍼센트 진행중인지 보여줌
        self.progressbar_label.config(text=str(_on)+"% "+"( " +
                                           str(self.item_run_qty) + "/" +
                                           str(self.item_qty) + " )")

    #send버튼 부분
    def defsend(self):
        self.send_file.config(state=tk.DISABLED)
        # 리스트 박스에 있는 정보들을 가져와 저장시킴
        # filename = (self.file_list_box.get(0, tk.END))
        try:
            self.item_qty = self.file_list_box.size()
            self.item_run_qty = 0

            for idx, val in enumerate(self.b):
                while val != 0:
                    filename = (self.file_list_box.get(0, tk.END))
                    self.filename_index = filename[0]  # 프로그래스바에서 사용하는 변수임
                    # 몇개의 파일이 전송중인지 보여준다.
                    self.item_run_qty = self.item_run_qty + 1
                    # 진행 상황을 가르쳐준다.
                    test_1 = "Sending ..." + self.filename_index
                    self.log_list.insert(tk.END, test_1)
                    self.log_list.see("end")
                    self.percentage_1 = 0

                    # 파일 경로/ 명 추출 if 문 (파일/폴더에 따라 다르니까)
                    if self.a[idx] == "file":
                        filename = filename[0].rsplit('/', 1)
                        bucket_file = "{0}/{1}".format(self.aws_name, filename[1])
                    else:
                        filename = filename[0].split(self.a[idx])
                        filename = filename[1].rsplit("\\")
                        x = len(filename) - 1
                        if x == 0:
                            bucket_file = "{0}/{1}{2}".format(self.aws_name, self.a[idx], filename[x])
                        else:
                            bucket_file = "{0}/{1}/{2}".format(self.aws_name, self.a[idx], filename[x])

                    config = TransferConfig(multipart_threshold=1024 * 25, max_concurrency=10,
                                            multipart_chunksize=1024 * 25, use_threads=True)

                    # boto3로 파일을 전송해줌
                    self.s3.upload_file(str(self.filename_index), str(self.bucket_name),
                                        str(bucket_file), Config=config,
                                        Callback=self.test_def)
                    # self.s3.upload_file(filename_index, bucket_name, bucket_file, Config=config, Callback=ProgressPercentage(filename_index))  # (넘길 파일/ 버킷이름/ 파일경로)
                    # 끝이라고 로그에 표현해주기
                    test_1 = "( " + self.filename_index + " ) transfer complete."
                    self.log_list.insert(tk.END, test_1)
                    self.log_list.see("end")
                    self.progressbar_label.config(text="Done")
                    # 값이 보이는 것을 초기화 함
                    self.s3_list_box.delete(0, tk.END)

                    # 엑세스 해서 s3버킷 안 사용자 파일에 대한 정보를 넘겨줌
                    paginator = self.s3.get_paginator('list_objects_v2')
                    response_iterator = paginator.paginate(
                        Bucket=self.bucket_name,
                        Prefix=self.aws_name)
                    for page in response_iterator:
                        for content in page['Contents']:
                            self.s3_list_box.insert(tk.END, content['Key'])
                    self.send_file.config(state=tk.NORMAL, text='send file(s)')

                    # while문 조정 하고 삭제홰주는것
                    val = int(val) - 1
                    self.file_list_box.delete(0)
        except:
            if self.login_point == 0:
                self.send_file.config(state=tk.NORMAL, text='send file(s)')
                messagebox.showinfo("error", "Click the login button")
            else:
                self.send_file.config(state=tk.NORMAL, text='send file(s)')
                messagebox.showinfo("error", "File send Error. "
                                             "Please contact the 4by4 manager.")
        self.a = []
        self.b = []
        self.send_file.config(state=tk.NORMAL)


if __name__ == '__main__':
    root = Tk()
    my_gui = MyFirstGUI(root)
    root.mainloop()
