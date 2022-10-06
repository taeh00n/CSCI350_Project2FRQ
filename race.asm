
_race:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "user.h"
#include "fcntl.h"
#include "condvar.h"

//We want Child 1 to execute first, then Child 2, and finally Parent.
int main() {
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
    struct condvar cv;
    int fd = open("flag", O_RDWR | O_CREATE);
    init_lock(&cv.lk);
  11:	8d 5d b4             	lea    -0x4c(%ebp),%ebx
int main() {
  14:	83 ec 60             	sub    $0x60,%esp
    int fd = open("flag", O_RDWR | O_CREATE);
  17:	68 02 02 00 00       	push   $0x202
  1c:	68 d8 08 00 00       	push   $0x8d8
  21:	e8 3f 04 00 00       	call   465 <open>
    init_lock(&cv.lk);
  26:	89 1c 24             	mov    %ebx,(%esp)
    int fd = open("flag", O_RDWR | O_CREATE);
  29:	89 c6                	mov    %eax,%esi
    init_lock(&cv.lk);
  2b:	e8 b0 03 00 00       	call   3e0 <init_lock>

    int pid = fork(); //fork the first child
  30:	e8 e8 03 00 00       	call   41d <fork>
    if(pid < 0) {
  35:	83 c4 10             	add    $0x10,%esp
  38:	85 c0                	test   %eax,%eax
  3a:	0f 88 d5 00 00 00    	js     115 <main+0x115>
        printf(1, "Error forking first child.\n");
    } else if (pid == 0) {
  40:	75 5d                	jne    9f <main+0x9f>
        sleep(5);
  42:	83 ec 0c             	sub    $0xc,%esp
  45:	6a 05                	push   $0x5
  47:	e8 69 04 00 00       	call   4b5 <sleep>
        printf(1, "Child 1 Executing\n");
  4c:	58                   	pop    %eax
  4d:	5a                   	pop    %edx
  4e:	68 f9 08 00 00       	push   $0x8f9
  53:	6a 01                	push   $0x1
  55:	e8 26 05 00 00       	call   580 <printf>
        lock(&cv.lk);
  5a:	89 1c 24             	mov    %ebx,(%esp)
  5d:	e8 8e 03 00 00       	call   3f0 <lock>
        write(fd, "done", 4);
  62:	83 c4 0c             	add    $0xc,%esp
  65:	6a 04                	push   $0x4
  67:	68 0c 09 00 00       	push   $0x90c
  6c:	56                   	push   %esi
  6d:	e8 d3 03 00 00       	call   445 <write>
        cv_signal(&cv);
  72:	89 1c 24             	mov    %ebx,(%esp)
  75:	e8 4b 04 00 00       	call   4c5 <cv_signal>
        unlock(&cv.lk);
  7a:	89 1c 24             	mov    %ebx,(%esp)
  7d:	e8 8e 03 00 00       	call   410 <unlock>
  82:	83 c4 10             	add    $0x10,%esp
            printf(1, "Children completed\n");
            printf(1, "Parent Executing\n");
            printf(1, "Parent exiting.\n");
        }
    }
    close(fd);
  85:	83 ec 0c             	sub    $0xc,%esp
  88:	56                   	push   %esi
  89:	e8 bf 03 00 00       	call   44d <close>
    unlink("flag");
  8e:	c7 04 24 d8 08 00 00 	movl   $0x8d8,(%esp)
  95:	e8 db 03 00 00       	call   475 <unlink>
    exit();
  9a:	e8 86 03 00 00       	call   425 <exit>
        pid = fork(); //fork the second child
  9f:	e8 79 03 00 00       	call   41d <fork>
        if(pid < 0) {
  a4:	85 c0                	test   %eax,%eax
  a6:	0f 88 c9 00 00 00    	js     175 <main+0x175>
        } else if(pid == 0) {
  ac:	75 7d                	jne    12b <main+0x12b>
            lock(&cv.lk);
  ae:	83 ec 0c             	sub    $0xc,%esp
  b1:	53                   	push   %ebx
  b2:	e8 39 03 00 00       	call   3f0 <lock>
            fstat(fd, &stats);
  b7:	5f                   	pop    %edi
  b8:	8d 7d a0             	lea    -0x60(%ebp),%edi
  bb:	58                   	pop    %eax
  bc:	eb 0d                	jmp    cb <main+0xcb>
  be:	66 90                	xchg   %ax,%ax
                cv_wait(&cv);
  c0:	83 ec 0c             	sub    $0xc,%esp
  c3:	53                   	push   %ebx
  c4:	e8 04 04 00 00       	call   4cd <cv_wait>
                fstat(fd, &stats);
  c9:	58                   	pop    %eax
  ca:	5a                   	pop    %edx
            fstat(fd, &stats);
  cb:	57                   	push   %edi
  cc:	56                   	push   %esi
  cd:	e8 ab 03 00 00       	call   47d <fstat>
            printf(1, "file size = %d\n", stats.size);
  d2:	83 c4 0c             	add    $0xc,%esp
  d5:	ff 75 b0             	pushl  -0x50(%ebp)
  d8:	68 2e 09 00 00       	push   $0x92e
  dd:	6a 01                	push   $0x1
  df:	e8 9c 04 00 00       	call   580 <printf>
            while(stats.size <= 0) {
  e4:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  e7:	83 c4 10             	add    $0x10,%esp
  ea:	85 c9                	test   %ecx,%ecx
  ec:	74 d2                	je     c0 <main+0xc0>
            cv_wait(&cv);
  ee:	83 ec 0c             	sub    $0xc,%esp
  f1:	53                   	push   %ebx
  f2:	e8 d6 03 00 00       	call   4cd <cv_wait>
            unlock(&cv.lk);
  f7:	89 1c 24             	mov    %ebx,(%esp)
  fa:	e8 11 03 00 00       	call   410 <unlock>
            printf(1, "Child 2 Executing\n");
  ff:	59                   	pop    %ecx
 100:	5b                   	pop    %ebx
 101:	68 3e 09 00 00       	push   $0x93e
 106:	6a 01                	push   $0x1
 108:	e8 73 04 00 00       	call   580 <printf>
 10d:	83 c4 10             	add    $0x10,%esp
 110:	e9 70 ff ff ff       	jmp    85 <main+0x85>
        printf(1, "Error forking first child.\n");
 115:	51                   	push   %ecx
 116:	51                   	push   %ecx
 117:	68 dd 08 00 00       	push   $0x8dd
 11c:	6a 01                	push   $0x1
 11e:	e8 5d 04 00 00       	call   580 <printf>
 123:	83 c4 10             	add    $0x10,%esp
 126:	e9 5a ff ff ff       	jmp    85 <main+0x85>
            printf(1, "Parent Waiting\n");
 12b:	50                   	push   %eax
 12c:	50                   	push   %eax
 12d:	68 51 09 00 00       	push   $0x951
 132:	6a 01                	push   $0x1
 134:	e8 47 04 00 00       	call   580 <printf>
                wait();
 139:	e8 ef 02 00 00       	call   42d <wait>
 13e:	e8 ea 02 00 00       	call   42d <wait>
            printf(1, "Children completed\n");
 143:	5a                   	pop    %edx
 144:	59                   	pop    %ecx
 145:	68 61 09 00 00       	push   $0x961
 14a:	6a 01                	push   $0x1
 14c:	e8 2f 04 00 00       	call   580 <printf>
            printf(1, "Parent Executing\n");
 151:	5b                   	pop    %ebx
 152:	5f                   	pop    %edi
 153:	68 75 09 00 00       	push   $0x975
 158:	6a 01                	push   $0x1
 15a:	e8 21 04 00 00       	call   580 <printf>
            printf(1, "Parent exiting.\n");
 15f:	58                   	pop    %eax
 160:	5a                   	pop    %edx
 161:	68 87 09 00 00       	push   $0x987
 166:	6a 01                	push   $0x1
 168:	e8 13 04 00 00       	call   580 <printf>
 16d:	83 c4 10             	add    $0x10,%esp
 170:	e9 10 ff ff ff       	jmp    85 <main+0x85>
            printf(1, "Error forking second child.\n");
 175:	50                   	push   %eax
 176:	50                   	push   %eax
 177:	68 11 09 00 00       	push   $0x911
 17c:	6a 01                	push   $0x1
 17e:	e8 fd 03 00 00       	call   580 <printf>
 183:	83 c4 10             	add    $0x10,%esp
 186:	e9 fa fe ff ff       	jmp    85 <main+0x85>
 18b:	66 90                	xchg   %ax,%ax
 18d:	66 90                	xchg   %ax,%ax
 18f:	90                   	nop

00000190 <strcpy>:
#include "x86.h"
#include "spinlock.h"

char*
strcpy(char *s, const char *t)
{
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	53                   	push   %ebx
 194:	8b 45 08             	mov    0x8(%ebp),%eax
 197:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 19a:	89 c2                	mov    %eax,%edx
 19c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1a0:	83 c1 01             	add    $0x1,%ecx
 1a3:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 1a7:	83 c2 01             	add    $0x1,%edx
 1aa:	84 db                	test   %bl,%bl
 1ac:	88 5a ff             	mov    %bl,-0x1(%edx)
 1af:	75 ef                	jne    1a0 <strcpy+0x10>
    ;
  return os;
}
 1b1:	5b                   	pop    %ebx
 1b2:	5d                   	pop    %ebp
 1b3:	c3                   	ret    
 1b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000001c0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	53                   	push   %ebx
 1c4:	8b 55 08             	mov    0x8(%ebp),%edx
 1c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 1ca:	0f b6 02             	movzbl (%edx),%eax
 1cd:	0f b6 19             	movzbl (%ecx),%ebx
 1d0:	84 c0                	test   %al,%al
 1d2:	75 1c                	jne    1f0 <strcmp+0x30>
 1d4:	eb 2a                	jmp    200 <strcmp+0x40>
 1d6:	8d 76 00             	lea    0x0(%esi),%esi
 1d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 1e0:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 1e3:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 1e6:	83 c1 01             	add    $0x1,%ecx
 1e9:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
 1ec:	84 c0                	test   %al,%al
 1ee:	74 10                	je     200 <strcmp+0x40>
 1f0:	38 d8                	cmp    %bl,%al
 1f2:	74 ec                	je     1e0 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 1f4:	29 d8                	sub    %ebx,%eax
}
 1f6:	5b                   	pop    %ebx
 1f7:	5d                   	pop    %ebp
 1f8:	c3                   	ret    
 1f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 200:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 202:	29 d8                	sub    %ebx,%eax
}
 204:	5b                   	pop    %ebx
 205:	5d                   	pop    %ebp
 206:	c3                   	ret    
 207:	89 f6                	mov    %esi,%esi
 209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000210 <strlen>:

uint
strlen(const char *s)
{
 210:	55                   	push   %ebp
 211:	89 e5                	mov    %esp,%ebp
 213:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 216:	80 39 00             	cmpb   $0x0,(%ecx)
 219:	74 15                	je     230 <strlen+0x20>
 21b:	31 d2                	xor    %edx,%edx
 21d:	8d 76 00             	lea    0x0(%esi),%esi
 220:	83 c2 01             	add    $0x1,%edx
 223:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 227:	89 d0                	mov    %edx,%eax
 229:	75 f5                	jne    220 <strlen+0x10>
    ;
  return n;
}
 22b:	5d                   	pop    %ebp
 22c:	c3                   	ret    
 22d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 230:	31 c0                	xor    %eax,%eax
}
 232:	5d                   	pop    %ebp
 233:	c3                   	ret    
 234:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 23a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000240 <memset>:

void*
memset(void *dst, int c, uint n)
{
 240:	55                   	push   %ebp
 241:	89 e5                	mov    %esp,%ebp
 243:	57                   	push   %edi
 244:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 247:	8b 4d 10             	mov    0x10(%ebp),%ecx
 24a:	8b 45 0c             	mov    0xc(%ebp),%eax
 24d:	89 d7                	mov    %edx,%edi
 24f:	fc                   	cld    
 250:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 252:	89 d0                	mov    %edx,%eax
 254:	5f                   	pop    %edi
 255:	5d                   	pop    %ebp
 256:	c3                   	ret    
 257:	89 f6                	mov    %esi,%esi
 259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000260 <strchr>:

char*
strchr(const char *s, char c)
{
 260:	55                   	push   %ebp
 261:	89 e5                	mov    %esp,%ebp
 263:	53                   	push   %ebx
 264:	8b 45 08             	mov    0x8(%ebp),%eax
 267:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 26a:	0f b6 10             	movzbl (%eax),%edx
 26d:	84 d2                	test   %dl,%dl
 26f:	74 1d                	je     28e <strchr+0x2e>
    if(*s == c)
 271:	38 d3                	cmp    %dl,%bl
 273:	89 d9                	mov    %ebx,%ecx
 275:	75 0d                	jne    284 <strchr+0x24>
 277:	eb 17                	jmp    290 <strchr+0x30>
 279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 280:	38 ca                	cmp    %cl,%dl
 282:	74 0c                	je     290 <strchr+0x30>
  for(; *s; s++)
 284:	83 c0 01             	add    $0x1,%eax
 287:	0f b6 10             	movzbl (%eax),%edx
 28a:	84 d2                	test   %dl,%dl
 28c:	75 f2                	jne    280 <strchr+0x20>
      return (char*)s;
  return 0;
 28e:	31 c0                	xor    %eax,%eax
}
 290:	5b                   	pop    %ebx
 291:	5d                   	pop    %ebp
 292:	c3                   	ret    
 293:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000002a0 <gets>:

char*
gets(char *buf, int max)
{
 2a0:	55                   	push   %ebp
 2a1:	89 e5                	mov    %esp,%ebp
 2a3:	57                   	push   %edi
 2a4:	56                   	push   %esi
 2a5:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2a6:	31 f6                	xor    %esi,%esi
 2a8:	89 f3                	mov    %esi,%ebx
{
 2aa:	83 ec 1c             	sub    $0x1c,%esp
 2ad:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 2b0:	eb 2f                	jmp    2e1 <gets+0x41>
 2b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 2b8:	8d 45 e7             	lea    -0x19(%ebp),%eax
 2bb:	83 ec 04             	sub    $0x4,%esp
 2be:	6a 01                	push   $0x1
 2c0:	50                   	push   %eax
 2c1:	6a 00                	push   $0x0
 2c3:	e8 75 01 00 00       	call   43d <read>
    if(cc < 1)
 2c8:	83 c4 10             	add    $0x10,%esp
 2cb:	85 c0                	test   %eax,%eax
 2cd:	7e 1c                	jle    2eb <gets+0x4b>
      break;
    buf[i++] = c;
 2cf:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 2d3:	83 c7 01             	add    $0x1,%edi
 2d6:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 2d9:	3c 0a                	cmp    $0xa,%al
 2db:	74 23                	je     300 <gets+0x60>
 2dd:	3c 0d                	cmp    $0xd,%al
 2df:	74 1f                	je     300 <gets+0x60>
  for(i=0; i+1 < max; ){
 2e1:	83 c3 01             	add    $0x1,%ebx
 2e4:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 2e7:	89 fe                	mov    %edi,%esi
 2e9:	7c cd                	jl     2b8 <gets+0x18>
 2eb:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 2ed:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 2f0:	c6 03 00             	movb   $0x0,(%ebx)
}
 2f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2f6:	5b                   	pop    %ebx
 2f7:	5e                   	pop    %esi
 2f8:	5f                   	pop    %edi
 2f9:	5d                   	pop    %ebp
 2fa:	c3                   	ret    
 2fb:	90                   	nop
 2fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 300:	8b 75 08             	mov    0x8(%ebp),%esi
 303:	8b 45 08             	mov    0x8(%ebp),%eax
 306:	01 de                	add    %ebx,%esi
 308:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 30a:	c6 03 00             	movb   $0x0,(%ebx)
}
 30d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 310:	5b                   	pop    %ebx
 311:	5e                   	pop    %esi
 312:	5f                   	pop    %edi
 313:	5d                   	pop    %ebp
 314:	c3                   	ret    
 315:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000320 <stat>:

int
stat(const char *n, struct stat *st)
{
 320:	55                   	push   %ebp
 321:	89 e5                	mov    %esp,%ebp
 323:	56                   	push   %esi
 324:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 325:	83 ec 08             	sub    $0x8,%esp
 328:	6a 00                	push   $0x0
 32a:	ff 75 08             	pushl  0x8(%ebp)
 32d:	e8 33 01 00 00       	call   465 <open>
  if(fd < 0)
 332:	83 c4 10             	add    $0x10,%esp
 335:	85 c0                	test   %eax,%eax
 337:	78 27                	js     360 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 339:	83 ec 08             	sub    $0x8,%esp
 33c:	ff 75 0c             	pushl  0xc(%ebp)
 33f:	89 c3                	mov    %eax,%ebx
 341:	50                   	push   %eax
 342:	e8 36 01 00 00       	call   47d <fstat>
  close(fd);
 347:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 34a:	89 c6                	mov    %eax,%esi
  close(fd);
 34c:	e8 fc 00 00 00       	call   44d <close>
  return r;
 351:	83 c4 10             	add    $0x10,%esp
}
 354:	8d 65 f8             	lea    -0x8(%ebp),%esp
 357:	89 f0                	mov    %esi,%eax
 359:	5b                   	pop    %ebx
 35a:	5e                   	pop    %esi
 35b:	5d                   	pop    %ebp
 35c:	c3                   	ret    
 35d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 360:	be ff ff ff ff       	mov    $0xffffffff,%esi
 365:	eb ed                	jmp    354 <stat+0x34>
 367:	89 f6                	mov    %esi,%esi
 369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000370 <atoi>:

int
atoi(const char *s)
{
 370:	55                   	push   %ebp
 371:	89 e5                	mov    %esp,%ebp
 373:	53                   	push   %ebx
 374:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 377:	0f be 11             	movsbl (%ecx),%edx
 37a:	8d 42 d0             	lea    -0x30(%edx),%eax
 37d:	3c 09                	cmp    $0x9,%al
  n = 0;
 37f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 384:	77 1f                	ja     3a5 <atoi+0x35>
 386:	8d 76 00             	lea    0x0(%esi),%esi
 389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 390:	8d 04 80             	lea    (%eax,%eax,4),%eax
 393:	83 c1 01             	add    $0x1,%ecx
 396:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 39a:	0f be 11             	movsbl (%ecx),%edx
 39d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 3a0:	80 fb 09             	cmp    $0x9,%bl
 3a3:	76 eb                	jbe    390 <atoi+0x20>
  return n;
}
 3a5:	5b                   	pop    %ebx
 3a6:	5d                   	pop    %ebp
 3a7:	c3                   	ret    
 3a8:	90                   	nop
 3a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000003b0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3b0:	55                   	push   %ebp
 3b1:	89 e5                	mov    %esp,%ebp
 3b3:	56                   	push   %esi
 3b4:	53                   	push   %ebx
 3b5:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3b8:	8b 45 08             	mov    0x8(%ebp),%eax
 3bb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3be:	85 db                	test   %ebx,%ebx
 3c0:	7e 14                	jle    3d6 <memmove+0x26>
 3c2:	31 d2                	xor    %edx,%edx
 3c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 3c8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 3cc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 3cf:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 3d2:	39 d3                	cmp    %edx,%ebx
 3d4:	75 f2                	jne    3c8 <memmove+0x18>
  return vdst;
}
 3d6:	5b                   	pop    %ebx
 3d7:	5e                   	pop    %esi
 3d8:	5d                   	pop    %ebp
 3d9:	c3                   	ret    
 3da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000003e0 <init_lock>:

void
init_lock(struct spinlock * lk) {
 3e0:	55                   	push   %ebp
 3e1:	89 e5                	mov    %esp,%ebp
  lk->locked = 0;
 3e3:	8b 45 08             	mov    0x8(%ebp),%eax
 3e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
 3ec:	5d                   	pop    %ebp
 3ed:	c3                   	ret    
 3ee:	66 90                	xchg   %ax,%ax

000003f0 <lock>:

void lock(struct spinlock * lk) {
 3f0:	55                   	push   %ebp
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
 3f1:	b9 01 00 00 00       	mov    $0x1,%ecx
 3f6:	89 e5                	mov    %esp,%ebp
 3f8:	8b 55 08             	mov    0x8(%ebp),%edx
 3fb:	90                   	nop
 3fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 400:	89 c8                	mov    %ecx,%eax
 402:	f0 87 02             	lock xchg %eax,(%edx)
  while(xchg(&lk->locked, 1) != 0);
 405:	85 c0                	test   %eax,%eax
 407:	75 f7                	jne    400 <lock+0x10>
}
 409:	5d                   	pop    %ebp
 40a:	c3                   	ret    
 40b:	90                   	nop
 40c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000410 <unlock>:

void unlock(struct spinlock * lk) {
 410:	55                   	push   %ebp
 411:	31 c0                	xor    %eax,%eax
 413:	89 e5                	mov    %esp,%ebp
 415:	8b 55 08             	mov    0x8(%ebp),%edx
 418:	f0 87 02             	lock xchg %eax,(%edx)
  xchg(&lk->locked, 0);
}
 41b:	5d                   	pop    %ebp
 41c:	c3                   	ret    

0000041d <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 41d:	b8 01 00 00 00       	mov    $0x1,%eax
 422:	cd 40                	int    $0x40
 424:	c3                   	ret    

00000425 <exit>:
SYSCALL(exit)
 425:	b8 02 00 00 00       	mov    $0x2,%eax
 42a:	cd 40                	int    $0x40
 42c:	c3                   	ret    

0000042d <wait>:
SYSCALL(wait)
 42d:	b8 03 00 00 00       	mov    $0x3,%eax
 432:	cd 40                	int    $0x40
 434:	c3                   	ret    

00000435 <pipe>:
SYSCALL(pipe)
 435:	b8 04 00 00 00       	mov    $0x4,%eax
 43a:	cd 40                	int    $0x40
 43c:	c3                   	ret    

0000043d <read>:
SYSCALL(read)
 43d:	b8 05 00 00 00       	mov    $0x5,%eax
 442:	cd 40                	int    $0x40
 444:	c3                   	ret    

00000445 <write>:
SYSCALL(write)
 445:	b8 10 00 00 00       	mov    $0x10,%eax
 44a:	cd 40                	int    $0x40
 44c:	c3                   	ret    

0000044d <close>:
SYSCALL(close)
 44d:	b8 15 00 00 00       	mov    $0x15,%eax
 452:	cd 40                	int    $0x40
 454:	c3                   	ret    

00000455 <kill>:
SYSCALL(kill)
 455:	b8 06 00 00 00       	mov    $0x6,%eax
 45a:	cd 40                	int    $0x40
 45c:	c3                   	ret    

0000045d <exec>:
SYSCALL(exec)
 45d:	b8 07 00 00 00       	mov    $0x7,%eax
 462:	cd 40                	int    $0x40
 464:	c3                   	ret    

00000465 <open>:
SYSCALL(open)
 465:	b8 0f 00 00 00       	mov    $0xf,%eax
 46a:	cd 40                	int    $0x40
 46c:	c3                   	ret    

0000046d <mknod>:
SYSCALL(mknod)
 46d:	b8 11 00 00 00       	mov    $0x11,%eax
 472:	cd 40                	int    $0x40
 474:	c3                   	ret    

00000475 <unlink>:
SYSCALL(unlink)
 475:	b8 12 00 00 00       	mov    $0x12,%eax
 47a:	cd 40                	int    $0x40
 47c:	c3                   	ret    

0000047d <fstat>:
SYSCALL(fstat)
 47d:	b8 08 00 00 00       	mov    $0x8,%eax
 482:	cd 40                	int    $0x40
 484:	c3                   	ret    

00000485 <link>:
SYSCALL(link)
 485:	b8 13 00 00 00       	mov    $0x13,%eax
 48a:	cd 40                	int    $0x40
 48c:	c3                   	ret    

0000048d <mkdir>:
SYSCALL(mkdir)
 48d:	b8 14 00 00 00       	mov    $0x14,%eax
 492:	cd 40                	int    $0x40
 494:	c3                   	ret    

00000495 <chdir>:
SYSCALL(chdir)
 495:	b8 09 00 00 00       	mov    $0x9,%eax
 49a:	cd 40                	int    $0x40
 49c:	c3                   	ret    

0000049d <dup>:
SYSCALL(dup)
 49d:	b8 0a 00 00 00       	mov    $0xa,%eax
 4a2:	cd 40                	int    $0x40
 4a4:	c3                   	ret    

000004a5 <getpid>:
SYSCALL(getpid)
 4a5:	b8 0b 00 00 00       	mov    $0xb,%eax
 4aa:	cd 40                	int    $0x40
 4ac:	c3                   	ret    

000004ad <sbrk>:
SYSCALL(sbrk)
 4ad:	b8 0c 00 00 00       	mov    $0xc,%eax
 4b2:	cd 40                	int    $0x40
 4b4:	c3                   	ret    

000004b5 <sleep>:
SYSCALL(sleep)
 4b5:	b8 0d 00 00 00       	mov    $0xd,%eax
 4ba:	cd 40                	int    $0x40
 4bc:	c3                   	ret    

000004bd <uptime>:
SYSCALL(uptime)
 4bd:	b8 0e 00 00 00       	mov    $0xe,%eax
 4c2:	cd 40                	int    $0x40
 4c4:	c3                   	ret    

000004c5 <cv_signal>:
SYSCALL(cv_signal)
 4c5:	b8 16 00 00 00       	mov    $0x16,%eax
 4ca:	cd 40                	int    $0x40
 4cc:	c3                   	ret    

000004cd <cv_wait>:
SYSCALL(cv_wait)
 4cd:	b8 17 00 00 00       	mov    $0x17,%eax
 4d2:	cd 40                	int    $0x40
 4d4:	c3                   	ret    
 4d5:	66 90                	xchg   %ax,%ax
 4d7:	66 90                	xchg   %ax,%ax
 4d9:	66 90                	xchg   %ax,%ax
 4db:	66 90                	xchg   %ax,%ax
 4dd:	66 90                	xchg   %ax,%ax
 4df:	90                   	nop

000004e0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 4e0:	55                   	push   %ebp
 4e1:	89 e5                	mov    %esp,%ebp
 4e3:	57                   	push   %edi
 4e4:	56                   	push   %esi
 4e5:	53                   	push   %ebx
 4e6:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4e9:	85 d2                	test   %edx,%edx
{
 4eb:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
 4ee:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 4f0:	79 76                	jns    568 <printint+0x88>
 4f2:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 4f6:	74 70                	je     568 <printint+0x88>
    x = -xx;
 4f8:	f7 d8                	neg    %eax
    neg = 1;
 4fa:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 501:	31 f6                	xor    %esi,%esi
 503:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 506:	eb 0a                	jmp    512 <printint+0x32>
 508:	90                   	nop
 509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
 510:	89 fe                	mov    %edi,%esi
 512:	31 d2                	xor    %edx,%edx
 514:	8d 7e 01             	lea    0x1(%esi),%edi
 517:	f7 f1                	div    %ecx
 519:	0f b6 92 a0 09 00 00 	movzbl 0x9a0(%edx),%edx
  }while((x /= base) != 0);
 520:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 522:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 525:	75 e9                	jne    510 <printint+0x30>
  if(neg)
 527:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 52a:	85 c0                	test   %eax,%eax
 52c:	74 08                	je     536 <printint+0x56>
    buf[i++] = '-';
 52e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 533:	8d 7e 02             	lea    0x2(%esi),%edi
 536:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 53a:	8b 7d c0             	mov    -0x40(%ebp),%edi
 53d:	8d 76 00             	lea    0x0(%esi),%esi
 540:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
 543:	83 ec 04             	sub    $0x4,%esp
 546:	83 ee 01             	sub    $0x1,%esi
 549:	6a 01                	push   $0x1
 54b:	53                   	push   %ebx
 54c:	57                   	push   %edi
 54d:	88 45 d7             	mov    %al,-0x29(%ebp)
 550:	e8 f0 fe ff ff       	call   445 <write>

  while(--i >= 0)
 555:	83 c4 10             	add    $0x10,%esp
 558:	39 de                	cmp    %ebx,%esi
 55a:	75 e4                	jne    540 <printint+0x60>
    putc(fd, buf[i]);
}
 55c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 55f:	5b                   	pop    %ebx
 560:	5e                   	pop    %esi
 561:	5f                   	pop    %edi
 562:	5d                   	pop    %ebp
 563:	c3                   	ret    
 564:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 568:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 56f:	eb 90                	jmp    501 <printint+0x21>
 571:	eb 0d                	jmp    580 <printf>
 573:	90                   	nop
 574:	90                   	nop
 575:	90                   	nop
 576:	90                   	nop
 577:	90                   	nop
 578:	90                   	nop
 579:	90                   	nop
 57a:	90                   	nop
 57b:	90                   	nop
 57c:	90                   	nop
 57d:	90                   	nop
 57e:	90                   	nop
 57f:	90                   	nop

00000580 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 580:	55                   	push   %ebp
 581:	89 e5                	mov    %esp,%ebp
 583:	57                   	push   %edi
 584:	56                   	push   %esi
 585:	53                   	push   %ebx
 586:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 589:	8b 75 0c             	mov    0xc(%ebp),%esi
 58c:	0f b6 1e             	movzbl (%esi),%ebx
 58f:	84 db                	test   %bl,%bl
 591:	0f 84 b3 00 00 00    	je     64a <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
 597:	8d 45 10             	lea    0x10(%ebp),%eax
 59a:	83 c6 01             	add    $0x1,%esi
  state = 0;
 59d:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
 59f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 5a2:	eb 2f                	jmp    5d3 <printf+0x53>
 5a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 5a8:	83 f8 25             	cmp    $0x25,%eax
 5ab:	0f 84 a7 00 00 00    	je     658 <printf+0xd8>
  write(fd, &c, 1);
 5b1:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 5b4:	83 ec 04             	sub    $0x4,%esp
 5b7:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 5ba:	6a 01                	push   $0x1
 5bc:	50                   	push   %eax
 5bd:	ff 75 08             	pushl  0x8(%ebp)
 5c0:	e8 80 fe ff ff       	call   445 <write>
 5c5:	83 c4 10             	add    $0x10,%esp
 5c8:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 5cb:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 5cf:	84 db                	test   %bl,%bl
 5d1:	74 77                	je     64a <printf+0xca>
    if(state == 0){
 5d3:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 5d5:	0f be cb             	movsbl %bl,%ecx
 5d8:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 5db:	74 cb                	je     5a8 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5dd:	83 ff 25             	cmp    $0x25,%edi
 5e0:	75 e6                	jne    5c8 <printf+0x48>
      if(c == 'd'){
 5e2:	83 f8 64             	cmp    $0x64,%eax
 5e5:	0f 84 05 01 00 00    	je     6f0 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 5eb:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 5f1:	83 f9 70             	cmp    $0x70,%ecx
 5f4:	74 72                	je     668 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 5f6:	83 f8 73             	cmp    $0x73,%eax
 5f9:	0f 84 99 00 00 00    	je     698 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5ff:	83 f8 63             	cmp    $0x63,%eax
 602:	0f 84 08 01 00 00    	je     710 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 608:	83 f8 25             	cmp    $0x25,%eax
 60b:	0f 84 ef 00 00 00    	je     700 <printf+0x180>
  write(fd, &c, 1);
 611:	8d 45 e7             	lea    -0x19(%ebp),%eax
 614:	83 ec 04             	sub    $0x4,%esp
 617:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 61b:	6a 01                	push   $0x1
 61d:	50                   	push   %eax
 61e:	ff 75 08             	pushl  0x8(%ebp)
 621:	e8 1f fe ff ff       	call   445 <write>
 626:	83 c4 0c             	add    $0xc,%esp
 629:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 62c:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 62f:	6a 01                	push   $0x1
 631:	50                   	push   %eax
 632:	ff 75 08             	pushl  0x8(%ebp)
 635:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 638:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 63a:	e8 06 fe ff ff       	call   445 <write>
  for(i = 0; fmt[i]; i++){
 63f:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 643:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 646:	84 db                	test   %bl,%bl
 648:	75 89                	jne    5d3 <printf+0x53>
    }
  }
}
 64a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 64d:	5b                   	pop    %ebx
 64e:	5e                   	pop    %esi
 64f:	5f                   	pop    %edi
 650:	5d                   	pop    %ebp
 651:	c3                   	ret    
 652:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
 658:	bf 25 00 00 00       	mov    $0x25,%edi
 65d:	e9 66 ff ff ff       	jmp    5c8 <printf+0x48>
 662:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 668:	83 ec 0c             	sub    $0xc,%esp
 66b:	b9 10 00 00 00       	mov    $0x10,%ecx
 670:	6a 00                	push   $0x0
 672:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 675:	8b 45 08             	mov    0x8(%ebp),%eax
 678:	8b 17                	mov    (%edi),%edx
 67a:	e8 61 fe ff ff       	call   4e0 <printint>
        ap++;
 67f:	89 f8                	mov    %edi,%eax
 681:	83 c4 10             	add    $0x10,%esp
      state = 0;
 684:	31 ff                	xor    %edi,%edi
        ap++;
 686:	83 c0 04             	add    $0x4,%eax
 689:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 68c:	e9 37 ff ff ff       	jmp    5c8 <printf+0x48>
 691:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 698:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 69b:	8b 08                	mov    (%eax),%ecx
        ap++;
 69d:	83 c0 04             	add    $0x4,%eax
 6a0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 6a3:	85 c9                	test   %ecx,%ecx
 6a5:	0f 84 8e 00 00 00    	je     739 <printf+0x1b9>
        while(*s != 0){
 6ab:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
 6ae:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
 6b0:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
 6b2:	84 c0                	test   %al,%al
 6b4:	0f 84 0e ff ff ff    	je     5c8 <printf+0x48>
 6ba:	89 75 d0             	mov    %esi,-0x30(%ebp)
 6bd:	89 de                	mov    %ebx,%esi
 6bf:	8b 5d 08             	mov    0x8(%ebp),%ebx
 6c2:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 6c5:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 6c8:	83 ec 04             	sub    $0x4,%esp
          s++;
 6cb:	83 c6 01             	add    $0x1,%esi
 6ce:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 6d1:	6a 01                	push   $0x1
 6d3:	57                   	push   %edi
 6d4:	53                   	push   %ebx
 6d5:	e8 6b fd ff ff       	call   445 <write>
        while(*s != 0){
 6da:	0f b6 06             	movzbl (%esi),%eax
 6dd:	83 c4 10             	add    $0x10,%esp
 6e0:	84 c0                	test   %al,%al
 6e2:	75 e4                	jne    6c8 <printf+0x148>
 6e4:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 6e7:	31 ff                	xor    %edi,%edi
 6e9:	e9 da fe ff ff       	jmp    5c8 <printf+0x48>
 6ee:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 6f0:	83 ec 0c             	sub    $0xc,%esp
 6f3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 6f8:	6a 01                	push   $0x1
 6fa:	e9 73 ff ff ff       	jmp    672 <printf+0xf2>
 6ff:	90                   	nop
  write(fd, &c, 1);
 700:	83 ec 04             	sub    $0x4,%esp
 703:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 706:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 709:	6a 01                	push   $0x1
 70b:	e9 21 ff ff ff       	jmp    631 <printf+0xb1>
        putc(fd, *ap);
 710:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
 713:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 716:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 718:	6a 01                	push   $0x1
        ap++;
 71a:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
 71d:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 720:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 723:	50                   	push   %eax
 724:	ff 75 08             	pushl  0x8(%ebp)
 727:	e8 19 fd ff ff       	call   445 <write>
        ap++;
 72c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 72f:	83 c4 10             	add    $0x10,%esp
      state = 0;
 732:	31 ff                	xor    %edi,%edi
 734:	e9 8f fe ff ff       	jmp    5c8 <printf+0x48>
          s = "(null)";
 739:	bb 98 09 00 00       	mov    $0x998,%ebx
        while(*s != 0){
 73e:	b8 28 00 00 00       	mov    $0x28,%eax
 743:	e9 72 ff ff ff       	jmp    6ba <printf+0x13a>
 748:	66 90                	xchg   %ax,%ax
 74a:	66 90                	xchg   %ax,%ax
 74c:	66 90                	xchg   %ax,%ax
 74e:	66 90                	xchg   %ax,%ax

00000750 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 750:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 751:	a1 b0 0c 00 00       	mov    0xcb0,%eax
{
 756:	89 e5                	mov    %esp,%ebp
 758:	57                   	push   %edi
 759:	56                   	push   %esi
 75a:	53                   	push   %ebx
 75b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 75e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 761:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 768:	39 c8                	cmp    %ecx,%eax
 76a:	8b 10                	mov    (%eax),%edx
 76c:	73 32                	jae    7a0 <free+0x50>
 76e:	39 d1                	cmp    %edx,%ecx
 770:	72 04                	jb     776 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 772:	39 d0                	cmp    %edx,%eax
 774:	72 32                	jb     7a8 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 776:	8b 73 fc             	mov    -0x4(%ebx),%esi
 779:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 77c:	39 fa                	cmp    %edi,%edx
 77e:	74 30                	je     7b0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 780:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 783:	8b 50 04             	mov    0x4(%eax),%edx
 786:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 789:	39 f1                	cmp    %esi,%ecx
 78b:	74 3a                	je     7c7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 78d:	89 08                	mov    %ecx,(%eax)
  freep = p;
 78f:	a3 b0 0c 00 00       	mov    %eax,0xcb0
}
 794:	5b                   	pop    %ebx
 795:	5e                   	pop    %esi
 796:	5f                   	pop    %edi
 797:	5d                   	pop    %ebp
 798:	c3                   	ret    
 799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7a0:	39 d0                	cmp    %edx,%eax
 7a2:	72 04                	jb     7a8 <free+0x58>
 7a4:	39 d1                	cmp    %edx,%ecx
 7a6:	72 ce                	jb     776 <free+0x26>
{
 7a8:	89 d0                	mov    %edx,%eax
 7aa:	eb bc                	jmp    768 <free+0x18>
 7ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 7b0:	03 72 04             	add    0x4(%edx),%esi
 7b3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 7b6:	8b 10                	mov    (%eax),%edx
 7b8:	8b 12                	mov    (%edx),%edx
 7ba:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 7bd:	8b 50 04             	mov    0x4(%eax),%edx
 7c0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 7c3:	39 f1                	cmp    %esi,%ecx
 7c5:	75 c6                	jne    78d <free+0x3d>
    p->s.size += bp->s.size;
 7c7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 7ca:	a3 b0 0c 00 00       	mov    %eax,0xcb0
    p->s.size += bp->s.size;
 7cf:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7d2:	8b 53 f8             	mov    -0x8(%ebx),%edx
 7d5:	89 10                	mov    %edx,(%eax)
}
 7d7:	5b                   	pop    %ebx
 7d8:	5e                   	pop    %esi
 7d9:	5f                   	pop    %edi
 7da:	5d                   	pop    %ebp
 7db:	c3                   	ret    
 7dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000007e0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7e0:	55                   	push   %ebp
 7e1:	89 e5                	mov    %esp,%ebp
 7e3:	57                   	push   %edi
 7e4:	56                   	push   %esi
 7e5:	53                   	push   %ebx
 7e6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7e9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 7ec:	8b 15 b0 0c 00 00    	mov    0xcb0,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7f2:	8d 78 07             	lea    0x7(%eax),%edi
 7f5:	c1 ef 03             	shr    $0x3,%edi
 7f8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 7fb:	85 d2                	test   %edx,%edx
 7fd:	0f 84 9d 00 00 00    	je     8a0 <malloc+0xc0>
 803:	8b 02                	mov    (%edx),%eax
 805:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 808:	39 cf                	cmp    %ecx,%edi
 80a:	76 6c                	jbe    878 <malloc+0x98>
 80c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 812:	bb 00 10 00 00       	mov    $0x1000,%ebx
 817:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 81a:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 821:	eb 0e                	jmp    831 <malloc+0x51>
 823:	90                   	nop
 824:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 828:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 82a:	8b 48 04             	mov    0x4(%eax),%ecx
 82d:	39 f9                	cmp    %edi,%ecx
 82f:	73 47                	jae    878 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 831:	39 05 b0 0c 00 00    	cmp    %eax,0xcb0
 837:	89 c2                	mov    %eax,%edx
 839:	75 ed                	jne    828 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 83b:	83 ec 0c             	sub    $0xc,%esp
 83e:	56                   	push   %esi
 83f:	e8 69 fc ff ff       	call   4ad <sbrk>
  if(p == (char*)-1)
 844:	83 c4 10             	add    $0x10,%esp
 847:	83 f8 ff             	cmp    $0xffffffff,%eax
 84a:	74 1c                	je     868 <malloc+0x88>
  hp->s.size = nu;
 84c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 84f:	83 ec 0c             	sub    $0xc,%esp
 852:	83 c0 08             	add    $0x8,%eax
 855:	50                   	push   %eax
 856:	e8 f5 fe ff ff       	call   750 <free>
  return freep;
 85b:	8b 15 b0 0c 00 00    	mov    0xcb0,%edx
      if((p = morecore(nunits)) == 0)
 861:	83 c4 10             	add    $0x10,%esp
 864:	85 d2                	test   %edx,%edx
 866:	75 c0                	jne    828 <malloc+0x48>
        return 0;
  }
}
 868:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 86b:	31 c0                	xor    %eax,%eax
}
 86d:	5b                   	pop    %ebx
 86e:	5e                   	pop    %esi
 86f:	5f                   	pop    %edi
 870:	5d                   	pop    %ebp
 871:	c3                   	ret    
 872:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 878:	39 cf                	cmp    %ecx,%edi
 87a:	74 54                	je     8d0 <malloc+0xf0>
        p->s.size -= nunits;
 87c:	29 f9                	sub    %edi,%ecx
 87e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 881:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 884:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 887:	89 15 b0 0c 00 00    	mov    %edx,0xcb0
}
 88d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 890:	83 c0 08             	add    $0x8,%eax
}
 893:	5b                   	pop    %ebx
 894:	5e                   	pop    %esi
 895:	5f                   	pop    %edi
 896:	5d                   	pop    %ebp
 897:	c3                   	ret    
 898:	90                   	nop
 899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
 8a0:	c7 05 b0 0c 00 00 b4 	movl   $0xcb4,0xcb0
 8a7:	0c 00 00 
 8aa:	c7 05 b4 0c 00 00 b4 	movl   $0xcb4,0xcb4
 8b1:	0c 00 00 
    base.s.size = 0;
 8b4:	b8 b4 0c 00 00       	mov    $0xcb4,%eax
 8b9:	c7 05 b8 0c 00 00 00 	movl   $0x0,0xcb8
 8c0:	00 00 00 
 8c3:	e9 44 ff ff ff       	jmp    80c <malloc+0x2c>
 8c8:	90                   	nop
 8c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 8d0:	8b 08                	mov    (%eax),%ecx
 8d2:	89 0a                	mov    %ecx,(%edx)
 8d4:	eb b1                	jmp    887 <malloc+0xa7>
