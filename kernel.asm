
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:
8010000c:	0f 20 e0             	mov    %cr4,%eax
8010000f:	83 c8 10             	or     $0x10,%eax
80100012:	0f 22 e0             	mov    %eax,%cr4
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
8010001a:	0f 22 d8             	mov    %eax,%cr3
8010001d:	0f 20 c0             	mov    %cr0,%eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
80100025:	0f 22 c0             	mov    %eax,%cr0
80100028:	bc d0 d5 10 80       	mov    $0x8010d5d0,%esp
8010002d:	b8 60 30 10 80       	mov    $0x80103060,%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 14 d6 10 80       	mov    $0x8010d614,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 20 82 10 80       	push   $0x80108220
80100051:	68 e0 d5 10 80       	push   $0x8010d5e0
80100056:	e8 05 49 00 00       	call   80104960 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 2c 1d 11 80 dc 	movl   $0x80111cdc,0x80111d2c
80100062:	1c 11 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 30 1d 11 80 dc 	movl   $0x80111cdc,0x80111d30
8010006c:	1c 11 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba dc 1c 11 80       	mov    $0x80111cdc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 dc 1c 11 80 	movl   $0x80111cdc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 27 82 10 80       	push   $0x80108227
80100097:	50                   	push   %eax
80100098:	e8 73 47 00 00       	call   80104810 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 30 1d 11 80       	mov    0x80111d30,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 30 1d 11 80    	mov    %ebx,0x80111d30
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d dc 1c 11 80       	cmp    $0x80111cdc,%eax
801000bb:	72 c3                	jb     80100080 <binit+0x40>
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 e0 d5 10 80       	push   $0x8010d5e0
801000e4:	e8 b7 49 00 00       	call   80104aa0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 30 1d 11 80    	mov    0x80111d30,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb dc 1c 11 80    	cmp    $0x80111cdc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb dc 1c 11 80    	cmp    $0x80111cdc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 2c 1d 11 80    	mov    0x80111d2c,%ebx
80100126:	81 fb dc 1c 11 80    	cmp    $0x80111cdc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb dc 1c 11 80    	cmp    $0x80111cdc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 e0 d5 10 80       	push   $0x8010d5e0
80100162:	e8 f9 49 00 00       	call   80104b60 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 de 46 00 00       	call   80104850 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 5d 21 00 00       	call   801022e0 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 2e 82 10 80       	push   $0x8010822e
80100198:	e8 f3 01 00 00       	call   80100390 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 5d 47 00 00       	call   80104910 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
  iderw(b);
801001c4:	e9 17 21 00 00       	jmp    801022e0 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 3f 82 10 80       	push   $0x8010823f
801001d1:	e8 ba 01 00 00       	call   80100390 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 1c 47 00 00       	call   80104910 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 ac 46 00 00       	call   801048b0 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 e0 d5 10 80 	movl   $0x8010d5e0,(%esp)
8010020b:	e8 90 48 00 00       	call   80104aa0 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 30 1d 11 80       	mov    0x80111d30,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 dc 1c 11 80 	movl   $0x80111cdc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 30 1d 11 80       	mov    0x80111d30,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 30 1d 11 80    	mov    %ebx,0x80111d30
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 e0 d5 10 80 	movl   $0x8010d5e0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 ff 48 00 00       	jmp    80104b60 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 46 82 10 80       	push   $0x80108246
80100269:	e8 22 01 00 00       	call   80100390 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 9b 16 00 00       	call   80101920 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
8010028c:	e8 0f 48 00 00       	call   80104aa0 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 c0 1f 11 80    	mov    0x80111fc0,%edx
801002a7:	39 15 c4 1f 11 80    	cmp    %edx,0x80111fc4
801002ad:	74 2c                	je     801002db <consoleread+0x6b>
801002af:	eb 5f                	jmp    80100310 <consoleread+0xa0>
801002b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b8:	83 ec 08             	sub    $0x8,%esp
801002bb:	68 20 c5 10 80       	push   $0x8010c520
801002c0:	68 c0 1f 11 80       	push   $0x80111fc0
801002c5:	e8 06 3d 00 00       	call   80103fd0 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 c0 1f 11 80    	mov    0x80111fc0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 c4 1f 11 80    	cmp    0x80111fc4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 e0 36 00 00       	call   801039c0 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 c5 10 80       	push   $0x8010c520
801002ef:	e8 6c 48 00 00       	call   80104b60 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 44 15 00 00       	call   80101840 <ilock>
        return -1;
801002fc:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100302:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100307:	5b                   	pop    %ebx
80100308:	5e                   	pop    %esi
80100309:	5f                   	pop    %edi
8010030a:	5d                   	pop    %ebp
8010030b:	c3                   	ret    
8010030c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100310:	8d 42 01             	lea    0x1(%edx),%eax
80100313:	a3 c0 1f 11 80       	mov    %eax,0x80111fc0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 40 1f 11 80 	movsbl -0x7feee0c0(%eax),%eax
    if(c == C('D')){  // EOF
80100324:	83 f8 04             	cmp    $0x4,%eax
80100327:	74 3f                	je     80100368 <consoleread+0xf8>
    *dst++ = c;
80100329:	83 c6 01             	add    $0x1,%esi
    --n;
8010032c:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
8010032f:	83 f8 0a             	cmp    $0xa,%eax
    *dst++ = c;
80100332:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n')
80100335:	74 43                	je     8010037a <consoleread+0x10a>
  while(n > 0){
80100337:	85 db                	test   %ebx,%ebx
80100339:	0f 85 62 ff ff ff    	jne    801002a1 <consoleread+0x31>
8010033f:	8b 45 10             	mov    0x10(%ebp),%eax
  release(&cons.lock);
80100342:	83 ec 0c             	sub    $0xc,%esp
80100345:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100348:	68 20 c5 10 80       	push   $0x8010c520
8010034d:	e8 0e 48 00 00       	call   80104b60 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 e6 14 00 00       	call   80101840 <ilock>
  return target - n;
8010035a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010035d:	83 c4 10             	add    $0x10,%esp
}
80100360:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100363:	5b                   	pop    %ebx
80100364:	5e                   	pop    %esi
80100365:	5f                   	pop    %edi
80100366:	5d                   	pop    %ebp
80100367:	c3                   	ret    
80100368:	8b 45 10             	mov    0x10(%ebp),%eax
8010036b:	29 d8                	sub    %ebx,%eax
      if(n < target){
8010036d:	3b 5d 10             	cmp    0x10(%ebp),%ebx
80100370:	73 d0                	jae    80100342 <consoleread+0xd2>
        input.r--;
80100372:	89 15 c0 1f 11 80    	mov    %edx,0x80111fc0
80100378:	eb c8                	jmp    80100342 <consoleread+0xd2>
8010037a:	8b 45 10             	mov    0x10(%ebp),%eax
8010037d:	29 d8                	sub    %ebx,%eax
8010037f:	eb c1                	jmp    80100342 <consoleread+0xd2>
80100381:	eb 0d                	jmp    80100390 <panic>
80100383:	90                   	nop
80100384:	90                   	nop
80100385:	90                   	nop
80100386:	90                   	nop
80100387:	90                   	nop
80100388:	90                   	nop
80100389:	90                   	nop
8010038a:	90                   	nop
8010038b:	90                   	nop
8010038c:	90                   	nop
8010038d:	90                   	nop
8010038e:	90                   	nop
8010038f:	90                   	nop

80100390 <panic>:
{
80100390:	55                   	push   %ebp
80100391:	89 e5                	mov    %esp,%ebp
80100393:	56                   	push   %esi
80100394:	53                   	push   %ebx
80100395:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100398:	fa                   	cli    
  cons.locking = 0;
80100399:	c7 05 54 c5 10 80 00 	movl   $0x0,0x8010c554
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 42 25 00 00       	call   801028f0 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 4d 82 10 80       	push   $0x8010824d
801003b7:	e8 34 03 00 00       	call   801006f0 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 2b 03 00 00       	call   801006f0 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 f9 88 10 80 	movl   $0x801088f9,(%esp)
801003cc:	e8 1f 03 00 00       	call   801006f0 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 a3 45 00 00       	call   80104980 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 61 82 10 80       	push   $0x80108261
801003ed:	e8 fe 02 00 00       	call   801006f0 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 58 c5 10 80 01 	movl   $0x1,0x8010c558
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 15 58 c5 10 80    	mov    0x8010c558,%edx
80100416:	85 d2                	test   %edx,%edx
80100418:	74 06                	je     80100420 <consputc+0x10>
8010041a:	fa                   	cli    
8010041b:	eb fe                	jmp    8010041b <consputc+0xb>
8010041d:	8d 76 00             	lea    0x0(%esi),%esi
{
80100420:	55                   	push   %ebp
80100421:	89 e5                	mov    %esp,%ebp
80100423:	57                   	push   %edi
80100424:	56                   	push   %esi
80100425:	53                   	push   %ebx
80100426:	89 c6                	mov    %eax,%esi
80100428:	83 ec 0c             	sub    $0xc,%esp
  if(c == BACKSPACE){
8010042b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100430:	0f 84 eb 00 00 00    	je     80100521 <consputc+0x111>
  } else if(c != UP && c != DOWN && c != LEFT && c != RIGHT){
80100436:	8d 80 1e ff ff ff    	lea    -0xe2(%eax),%eax
8010043c:	83 f8 03             	cmp    $0x3,%eax
8010043f:	0f 87 ad 01 00 00    	ja     801005f2 <consputc+0x1e2>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100445:	bb d4 03 00 00       	mov    $0x3d4,%ebx
8010044a:	b8 0e 00 00 00       	mov    $0xe,%eax
8010044f:	89 da                	mov    %ebx,%edx
80100451:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100452:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100457:	89 ca                	mov    %ecx,%edx
80100459:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
8010045a:	0f b6 f8             	movzbl %al,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010045d:	89 da                	mov    %ebx,%edx
8010045f:	b8 0f 00 00 00       	mov    $0xf,%eax
80100464:	c1 e7 08             	shl    $0x8,%edi
80100467:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100468:	89 ca                	mov    %ecx,%edx
8010046a:	ec                   	in     (%dx),%al
8010046b:	0f b6 d8             	movzbl %al,%ebx
  pos |= inb(CRTPORT+1);
8010046e:	09 fb                	or     %edi,%ebx
  if(c == '\n')
80100470:	83 fe 0a             	cmp    $0xa,%esi
80100473:	0f 84 66 01 00 00    	je     801005df <consputc+0x1cf>
  else if(c == BACKSPACE) {
80100479:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010047f:	0f 84 25 01 00 00    	je     801005aa <consputc+0x19a>
  } else if(c == LEFT){
80100485:	81 fe e4 00 00 00    	cmp    $0xe4,%esi
8010048b:	0f 84 09 01 00 00    	je     8010059a <consputc+0x18a>
  } else if(c == RIGHT){
80100491:	81 fe e5 00 00 00    	cmp    $0xe5,%esi
80100497:	0f 84 ae 00 00 00    	je     8010054b <consputc+0x13b>
  } else if(c == DOWN){
8010049d:	8d 86 1e ff ff ff    	lea    -0xe2(%esi),%eax
801004a3:	83 f8 01             	cmp    $0x1,%eax
801004a6:	76 36                	jbe    801004de <consputc+0xce>
    memmove(crt + pos + 1, crt + pos, sizeof(crt[0])*(24*80 - pos));
801004a8:	b8 80 07 00 00       	mov    $0x780,%eax
801004ad:	8d 3c 1b             	lea    (%ebx,%ebx,1),%edi
801004b0:	51                   	push   %ecx
801004b1:	29 d8                	sub    %ebx,%eax
    crt[pos++] = (c & 0xff) | 0x0700;  // black on white
801004b3:	83 c3 01             	add    $0x1,%ebx
    memmove(crt + pos + 1, crt + pos, sizeof(crt[0])*(24*80 - pos));
801004b6:	01 c0                	add    %eax,%eax
801004b8:	8d 97 00 80 0b 80    	lea    -0x7ff48000(%edi),%edx
801004be:	50                   	push   %eax
801004bf:	8d 87 02 80 0b 80    	lea    -0x7ff47ffe(%edi),%eax
801004c5:	52                   	push   %edx
801004c6:	50                   	push   %eax
801004c7:	e8 a4 49 00 00       	call   80104e70 <memmove>
    crt[pos++] = (c & 0xff) | 0x0700;  // black on white
801004cc:	89 f0                	mov    %esi,%eax
801004ce:	83 c4 10             	add    $0x10,%esp
801004d1:	0f b6 c0             	movzbl %al,%eax
801004d4:	80 cc 07             	or     $0x7,%ah
801004d7:	66 89 87 00 80 0b 80 	mov    %ax,-0x7ff48000(%edi)
  if(pos < 0 || pos > 25*80)
801004de:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
801004e4:	0f 8f a3 00 00 00    	jg     8010058d <consputc+0x17d>
  if((pos/80) >= 24){  // Scroll up.
801004ea:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801004f0:	7f 5e                	jg     80100550 <consputc+0x140>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004f2:	be d4 03 00 00       	mov    $0x3d4,%esi
801004f7:	b8 0e 00 00 00       	mov    $0xe,%eax
801004fc:	89 f2                	mov    %esi,%edx
801004fe:	ee                   	out    %al,(%dx)
801004ff:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
  outb(CRTPORT+1, pos>>8);
80100504:	89 d8                	mov    %ebx,%eax
80100506:	c1 f8 08             	sar    $0x8,%eax
80100509:	89 ca                	mov    %ecx,%edx
8010050b:	ee                   	out    %al,(%dx)
8010050c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100511:	89 f2                	mov    %esi,%edx
80100513:	ee                   	out    %al,(%dx)
80100514:	89 d8                	mov    %ebx,%eax
80100516:	89 ca                	mov    %ecx,%edx
80100518:	ee                   	out    %al,(%dx)
}
80100519:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010051c:	5b                   	pop    %ebx
8010051d:	5e                   	pop    %esi
8010051e:	5f                   	pop    %edi
8010051f:	5d                   	pop    %ebp
80100520:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100521:	83 ec 0c             	sub    $0xc,%esp
80100524:	6a 08                	push   $0x8
80100526:	e8 05 69 00 00       	call   80106e30 <uartputc>
8010052b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100532:	e8 f9 68 00 00       	call   80106e30 <uartputc>
80100537:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010053e:	e8 ed 68 00 00       	call   80106e30 <uartputc>
80100543:	83 c4 10             	add    $0x10,%esp
80100546:	e9 fa fe ff ff       	jmp    80100445 <consputc+0x35>
      /*if (pos < maximum_pos)*/ ++pos;
8010054b:	83 c3 01             	add    $0x1,%ebx
8010054e:	eb 8e                	jmp    801004de <consputc+0xce>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100550:	50                   	push   %eax
80100551:	68 60 0e 00 00       	push   $0xe60
    pos -= 80;
80100556:	83 eb 50             	sub    $0x50,%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100559:	68 a0 80 0b 80       	push   $0x800b80a0
8010055e:	68 00 80 0b 80       	push   $0x800b8000
80100563:	e8 08 49 00 00       	call   80104e70 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100568:	b8 80 07 00 00       	mov    $0x780,%eax
8010056d:	83 c4 0c             	add    $0xc,%esp
80100570:	29 d8                	sub    %ebx,%eax
80100572:	01 c0                	add    %eax,%eax
80100574:	50                   	push   %eax
80100575:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
80100578:	6a 00                	push   $0x0
8010057a:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
8010057f:	50                   	push   %eax
80100580:	e8 3b 48 00 00       	call   80104dc0 <memset>
80100585:	83 c4 10             	add    $0x10,%esp
80100588:	e9 65 ff ff ff       	jmp    801004f2 <consputc+0xe2>
    panic("pos under/overflow");
8010058d:	83 ec 0c             	sub    $0xc,%esp
80100590:	68 65 82 10 80       	push   $0x80108265
80100595:	e8 f6 fd ff ff       	call   80100390 <panic>
      if (pos > 0)
8010059a:	85 db                	test   %ebx,%ebx
8010059c:	0f 84 50 ff ff ff    	je     801004f2 <consputc+0xe2>
	--pos;
801005a2:	83 eb 01             	sub    $0x1,%ebx
801005a5:	e9 34 ff ff ff       	jmp    801004de <consputc+0xce>
      if (pos > 0){
801005aa:	85 db                	test   %ebx,%ebx
801005ac:	0f 84 40 ff ff ff    	je     801004f2 <consputc+0xe2>
 	--pos;
801005b2:	83 eb 01             	sub    $0x1,%ebx
	memmove(crt + pos, crt + pos + 1, sizeof(crt[0])*(24*80 - pos));
801005b5:	ba 80 07 00 00       	mov    $0x780,%edx
801005ba:	56                   	push   %esi
801005bb:	8d 43 01             	lea    0x1(%ebx),%eax
801005be:	29 da                	sub    %ebx,%edx
801005c0:	01 d2                	add    %edx,%edx
801005c2:	01 c0                	add    %eax,%eax
801005c4:	52                   	push   %edx
801005c5:	8d 90 00 80 0b 80    	lea    -0x7ff48000(%eax),%edx
801005cb:	2d 02 80 f4 7f       	sub    $0x7ff48002,%eax
801005d0:	52                   	push   %edx
801005d1:	50                   	push   %eax
801005d2:	e8 99 48 00 00       	call   80104e70 <memmove>
801005d7:	83 c4 10             	add    $0x10,%esp
801005da:	e9 ff fe ff ff       	jmp    801004de <consputc+0xce>
    pos += BUFF_SIZE - pos % BUFF_SIZE;
801005df:	89 d8                	mov    %ebx,%eax
801005e1:	b9 50 00 00 00       	mov    $0x50,%ecx
801005e6:	99                   	cltd   
801005e7:	f7 f9                	idiv   %ecx
801005e9:	29 d1                	sub    %edx,%ecx
801005eb:	01 cb                	add    %ecx,%ebx
801005ed:	e9 ec fe ff ff       	jmp    801004de <consputc+0xce>
    uartputc(c);
801005f2:	83 ec 0c             	sub    $0xc,%esp
801005f5:	56                   	push   %esi
801005f6:	e8 35 68 00 00       	call   80106e30 <uartputc>
801005fb:	83 c4 10             	add    $0x10,%esp
801005fe:	e9 42 fe ff ff       	jmp    80100445 <consputc+0x35>
80100603:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100610 <printint>:
{
80100610:	55                   	push   %ebp
80100611:	89 e5                	mov    %esp,%ebp
80100613:	57                   	push   %edi
80100614:	56                   	push   %esi
80100615:	53                   	push   %ebx
80100616:	89 d3                	mov    %edx,%ebx
80100618:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010061b:	85 c9                	test   %ecx,%ecx
{
8010061d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
80100620:	74 04                	je     80100626 <printint+0x16>
80100622:	85 c0                	test   %eax,%eax
80100624:	78 5a                	js     80100680 <printint+0x70>
    x = xx;
80100626:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  i = 0;
8010062d:	31 c9                	xor    %ecx,%ecx
8010062f:	8d 75 d7             	lea    -0x29(%ebp),%esi
80100632:	eb 06                	jmp    8010063a <printint+0x2a>
80100634:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf[i++] = digits[x % base];
80100638:	89 f9                	mov    %edi,%ecx
8010063a:	31 d2                	xor    %edx,%edx
8010063c:	8d 79 01             	lea    0x1(%ecx),%edi
8010063f:	f7 f3                	div    %ebx
80100641:	0f b6 92 90 82 10 80 	movzbl -0x7fef7d70(%edx),%edx
  }while((x /= base) != 0);
80100648:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
8010064a:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
8010064d:	75 e9                	jne    80100638 <printint+0x28>
  if(sign)
8010064f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100652:	85 c0                	test   %eax,%eax
80100654:	74 08                	je     8010065e <printint+0x4e>
    buf[i++] = '-';
80100656:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
8010065b:	8d 79 02             	lea    0x2(%ecx),%edi
8010065e:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
80100662:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i]);
80100668:	0f be 03             	movsbl (%ebx),%eax
8010066b:	83 eb 01             	sub    $0x1,%ebx
8010066e:	e8 9d fd ff ff       	call   80100410 <consputc>
  while(--i >= 0)
80100673:	39 f3                	cmp    %esi,%ebx
80100675:	75 f1                	jne    80100668 <printint+0x58>
}
80100677:	83 c4 2c             	add    $0x2c,%esp
8010067a:	5b                   	pop    %ebx
8010067b:	5e                   	pop    %esi
8010067c:	5f                   	pop    %edi
8010067d:	5d                   	pop    %ebp
8010067e:	c3                   	ret    
8010067f:	90                   	nop
    x = -xx;
80100680:	f7 d8                	neg    %eax
80100682:	eb a9                	jmp    8010062d <printint+0x1d>
80100684:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010068a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100690 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100690:	55                   	push   %ebp
80100691:	89 e5                	mov    %esp,%ebp
80100693:	57                   	push   %edi
80100694:	56                   	push   %esi
80100695:	53                   	push   %ebx
80100696:	83 ec 18             	sub    $0x18,%esp
80100699:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010069c:	ff 75 08             	pushl  0x8(%ebp)
8010069f:	e8 7c 12 00 00       	call   80101920 <iunlock>
  acquire(&cons.lock);
801006a4:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
801006ab:	e8 f0 43 00 00       	call   80104aa0 <acquire>
  for(i = 0; i < n; i++)
801006b0:	83 c4 10             	add    $0x10,%esp
801006b3:	85 f6                	test   %esi,%esi
801006b5:	7e 18                	jle    801006cf <consolewrite+0x3f>
801006b7:	8b 7d 0c             	mov    0xc(%ebp),%edi
801006ba:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
801006bd:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
801006c0:	0f b6 07             	movzbl (%edi),%eax
801006c3:	83 c7 01             	add    $0x1,%edi
801006c6:	e8 45 fd ff ff       	call   80100410 <consputc>
  for(i = 0; i < n; i++)
801006cb:	39 fb                	cmp    %edi,%ebx
801006cd:	75 f1                	jne    801006c0 <consolewrite+0x30>
  release(&cons.lock);
801006cf:	83 ec 0c             	sub    $0xc,%esp
801006d2:	68 20 c5 10 80       	push   $0x8010c520
801006d7:	e8 84 44 00 00       	call   80104b60 <release>
  ilock(ip);
801006dc:	58                   	pop    %eax
801006dd:	ff 75 08             	pushl  0x8(%ebp)
801006e0:	e8 5b 11 00 00       	call   80101840 <ilock>

  return n;
}
801006e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801006e8:	89 f0                	mov    %esi,%eax
801006ea:	5b                   	pop    %ebx
801006eb:	5e                   	pop    %esi
801006ec:	5f                   	pop    %edi
801006ed:	5d                   	pop    %ebp
801006ee:	c3                   	ret    
801006ef:	90                   	nop

801006f0 <cprintf>:
{
801006f0:	55                   	push   %ebp
801006f1:	89 e5                	mov    %esp,%ebp
801006f3:	57                   	push   %edi
801006f4:	56                   	push   %esi
801006f5:	53                   	push   %ebx
801006f6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006f9:	a1 54 c5 10 80       	mov    0x8010c554,%eax
  if(locking)
801006fe:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100700:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(locking)
80100703:	0f 85 6f 01 00 00    	jne    80100878 <cprintf+0x188>
  if (fmt == 0)
80100709:	8b 45 08             	mov    0x8(%ebp),%eax
8010070c:	85 c0                	test   %eax,%eax
8010070e:	89 c7                	mov    %eax,%edi
80100710:	0f 84 77 01 00 00    	je     8010088d <cprintf+0x19d>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100716:	0f b6 00             	movzbl (%eax),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100719:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010071c:	31 db                	xor    %ebx,%ebx
  argp = (uint*)(void*)(&fmt + 1);
8010071e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100721:	85 c0                	test   %eax,%eax
80100723:	75 56                	jne    8010077b <cprintf+0x8b>
80100725:	eb 79                	jmp    801007a0 <cprintf+0xb0>
80100727:	89 f6                	mov    %esi,%esi
80100729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[++i] & 0xff;
80100730:	0f b6 16             	movzbl (%esi),%edx
    if(c == 0)
80100733:	85 d2                	test   %edx,%edx
80100735:	74 69                	je     801007a0 <cprintf+0xb0>
80100737:	83 c3 02             	add    $0x2,%ebx
    switch(c){
8010073a:	83 fa 70             	cmp    $0x70,%edx
8010073d:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
80100740:	0f 84 84 00 00 00    	je     801007ca <cprintf+0xda>
80100746:	7f 78                	jg     801007c0 <cprintf+0xd0>
80100748:	83 fa 25             	cmp    $0x25,%edx
8010074b:	0f 84 ff 00 00 00    	je     80100850 <cprintf+0x160>
80100751:	83 fa 64             	cmp    $0x64,%edx
80100754:	0f 85 8e 00 00 00    	jne    801007e8 <cprintf+0xf8>
      printint(*argp++, 10, 1);
8010075a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010075d:	ba 0a 00 00 00       	mov    $0xa,%edx
80100762:	8d 48 04             	lea    0x4(%eax),%ecx
80100765:	8b 00                	mov    (%eax),%eax
80100767:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010076a:	b9 01 00 00 00       	mov    $0x1,%ecx
8010076f:	e8 9c fe ff ff       	call   80100610 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100774:	0f b6 06             	movzbl (%esi),%eax
80100777:	85 c0                	test   %eax,%eax
80100779:	74 25                	je     801007a0 <cprintf+0xb0>
8010077b:	8d 53 01             	lea    0x1(%ebx),%edx
    if(c != '%'){
8010077e:	83 f8 25             	cmp    $0x25,%eax
80100781:	8d 34 17             	lea    (%edi,%edx,1),%esi
80100784:	74 aa                	je     80100730 <cprintf+0x40>
80100786:	89 55 e0             	mov    %edx,-0x20(%ebp)
      consputc(c);
80100789:	e8 82 fc ff ff       	call   80100410 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010078e:	0f b6 06             	movzbl (%esi),%eax
      continue;
80100791:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100794:	89 d3                	mov    %edx,%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100796:	85 c0                	test   %eax,%eax
80100798:	75 e1                	jne    8010077b <cprintf+0x8b>
8010079a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(locking)
801007a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
801007a3:	85 c0                	test   %eax,%eax
801007a5:	74 10                	je     801007b7 <cprintf+0xc7>
    release(&cons.lock);
801007a7:	83 ec 0c             	sub    $0xc,%esp
801007aa:	68 20 c5 10 80       	push   $0x8010c520
801007af:	e8 ac 43 00 00       	call   80104b60 <release>
801007b4:	83 c4 10             	add    $0x10,%esp
}
801007b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801007ba:	5b                   	pop    %ebx
801007bb:	5e                   	pop    %esi
801007bc:	5f                   	pop    %edi
801007bd:	5d                   	pop    %ebp
801007be:	c3                   	ret    
801007bf:	90                   	nop
    switch(c){
801007c0:	83 fa 73             	cmp    $0x73,%edx
801007c3:	74 43                	je     80100808 <cprintf+0x118>
801007c5:	83 fa 78             	cmp    $0x78,%edx
801007c8:	75 1e                	jne    801007e8 <cprintf+0xf8>
      printint(*argp++, 16, 0);
801007ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801007cd:	ba 10 00 00 00       	mov    $0x10,%edx
801007d2:	8d 48 04             	lea    0x4(%eax),%ecx
801007d5:	8b 00                	mov    (%eax),%eax
801007d7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801007da:	31 c9                	xor    %ecx,%ecx
801007dc:	e8 2f fe ff ff       	call   80100610 <printint>
      break;
801007e1:	eb 91                	jmp    80100774 <cprintf+0x84>
801007e3:	90                   	nop
801007e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
801007e8:	b8 25 00 00 00       	mov    $0x25,%eax
801007ed:	89 55 e0             	mov    %edx,-0x20(%ebp)
801007f0:	e8 1b fc ff ff       	call   80100410 <consputc>
      consputc(c);
801007f5:	8b 55 e0             	mov    -0x20(%ebp),%edx
801007f8:	89 d0                	mov    %edx,%eax
801007fa:	e8 11 fc ff ff       	call   80100410 <consputc>
      break;
801007ff:	e9 70 ff ff ff       	jmp    80100774 <cprintf+0x84>
80100804:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((s = (char*)*argp++) == 0)
80100808:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010080b:	8b 10                	mov    (%eax),%edx
8010080d:	8d 48 04             	lea    0x4(%eax),%ecx
80100810:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100813:	85 d2                	test   %edx,%edx
80100815:	74 49                	je     80100860 <cprintf+0x170>
      for(; *s; s++)
80100817:	0f be 02             	movsbl (%edx),%eax
      if((s = (char*)*argp++) == 0)
8010081a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      for(; *s; s++)
8010081d:	84 c0                	test   %al,%al
8010081f:	0f 84 4f ff ff ff    	je     80100774 <cprintf+0x84>
80100825:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100828:	89 d3                	mov    %edx,%ebx
8010082a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100830:	83 c3 01             	add    $0x1,%ebx
        consputc(*s);
80100833:	e8 d8 fb ff ff       	call   80100410 <consputc>
      for(; *s; s++)
80100838:	0f be 03             	movsbl (%ebx),%eax
8010083b:	84 c0                	test   %al,%al
8010083d:	75 f1                	jne    80100830 <cprintf+0x140>
      if((s = (char*)*argp++) == 0)
8010083f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100842:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80100845:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100848:	e9 27 ff ff ff       	jmp    80100774 <cprintf+0x84>
8010084d:	8d 76 00             	lea    0x0(%esi),%esi
      consputc('%');
80100850:	b8 25 00 00 00       	mov    $0x25,%eax
80100855:	e8 b6 fb ff ff       	call   80100410 <consputc>
      break;
8010085a:	e9 15 ff ff ff       	jmp    80100774 <cprintf+0x84>
8010085f:	90                   	nop
        s = "(null)";
80100860:	ba 78 82 10 80       	mov    $0x80108278,%edx
      for(; *s; s++)
80100865:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100868:	b8 28 00 00 00       	mov    $0x28,%eax
8010086d:	89 d3                	mov    %edx,%ebx
8010086f:	eb bf                	jmp    80100830 <cprintf+0x140>
80100871:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
80100878:	83 ec 0c             	sub    $0xc,%esp
8010087b:	68 20 c5 10 80       	push   $0x8010c520
80100880:	e8 1b 42 00 00       	call   80104aa0 <acquire>
80100885:	83 c4 10             	add    $0x10,%esp
80100888:	e9 7c fe ff ff       	jmp    80100709 <cprintf+0x19>
    panic("null fmt");
8010088d:	83 ec 0c             	sub    $0xc,%esp
80100890:	68 7f 82 10 80       	push   $0x8010827f
80100895:	e8 f6 fa ff ff       	call   80100390 <panic>
8010089a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801008a0 <consoleintr>:
{
801008a0:	55                   	push   %ebp
801008a1:	89 e5                	mov    %esp,%ebp
801008a3:	57                   	push   %edi
801008a4:	56                   	push   %esi
801008a5:	53                   	push   %ebx
  int c, doprocdump = 0;
801008a6:	31 ff                	xor    %edi,%edi
{
801008a8:	83 ec 18             	sub    $0x18,%esp
801008ab:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&cons.lock);
801008ae:	68 20 c5 10 80       	push   $0x8010c520
801008b3:	e8 e8 41 00 00       	call   80104aa0 <acquire>
  while((c = getc()) >= 0){
801008b8:	83 c4 10             	add    $0x10,%esp
801008bb:	90                   	nop
801008bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801008c0:	ff d6                	call   *%esi
801008c2:	85 c0                	test   %eax,%eax
801008c4:	89 c3                	mov    %eax,%ebx
801008c6:	78 58                	js     80100920 <consoleintr+0x80>
    switch(c){
801008c8:	83 fb 7f             	cmp    $0x7f,%ebx
801008cb:	0f 84 af 01 00 00    	je     80100a80 <consoleintr+0x1e0>
801008d1:	7e 6d                	jle    80100940 <consoleintr+0xa0>
801008d3:	81 fb e3 00 00 00    	cmp    $0xe3,%ebx
801008d9:	0f 84 61 01 00 00    	je     80100a40 <consoleintr+0x1a0>
801008df:	0f 8e 2b 01 00 00    	jle    80100a10 <consoleintr+0x170>
801008e5:	81 fb e4 00 00 00    	cmp    $0xe4,%ebx
801008eb:	0f 84 5f 01 00 00    	je     80100a50 <consoleintr+0x1b0>
801008f1:	81 fb e5 00 00 00    	cmp    $0xe5,%ebx
801008f7:	75 62                	jne    8010095b <consoleintr+0xbb>
      if(input.e < input.max){
801008f9:	a1 c8 1f 11 80       	mov    0x80111fc8,%eax
801008fe:	3b 05 cc 1f 11 80    	cmp    0x80111fcc,%eax
80100904:	73 ba                	jae    801008c0 <consoleintr+0x20>
	      input.e++;
80100906:	83 c0 01             	add    $0x1,%eax
80100909:	a3 c8 1f 11 80       	mov    %eax,0x80111fc8
        consputc(c);
8010090e:	b8 e5 00 00 00       	mov    $0xe5,%eax
80100913:	e8 f8 fa ff ff       	call   80100410 <consputc>
  while((c = getc()) >= 0){
80100918:	ff d6                	call   *%esi
8010091a:	85 c0                	test   %eax,%eax
8010091c:	89 c3                	mov    %eax,%ebx
8010091e:	79 a8                	jns    801008c8 <consoleintr+0x28>
  release(&cons.lock);
80100920:	83 ec 0c             	sub    $0xc,%esp
80100923:	68 20 c5 10 80       	push   $0x8010c520
80100928:	e8 33 42 00 00       	call   80104b60 <release>
  if(doprocdump) {
8010092d:	83 c4 10             	add    $0x10,%esp
80100930:	85 ff                	test   %edi,%edi
80100932:	0f 85 f8 01 00 00    	jne    80100b30 <consoleintr+0x290>
}
80100938:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010093b:	5b                   	pop    %ebx
8010093c:	5e                   	pop    %esi
8010093d:	5f                   	pop    %edi
8010093e:	5d                   	pop    %ebp
8010093f:	c3                   	ret    
    switch(c){
80100940:	83 fb 10             	cmp    $0x10,%ebx
80100943:	0f 84 e7 00 00 00    	je     80100a30 <consoleintr+0x190>
80100949:	83 fb 15             	cmp    $0x15,%ebx
8010094c:	0f 84 86 01 00 00    	je     80100ad8 <consoleintr+0x238>
80100952:	83 fb 08             	cmp    $0x8,%ebx
80100955:	0f 84 25 01 00 00    	je     80100a80 <consoleintr+0x1e0>
      if(c != 0 && input.max < INPUT_BUF){
8010095b:	85 db                	test   %ebx,%ebx
8010095d:	0f 84 5d ff ff ff    	je     801008c0 <consoleintr+0x20>
80100963:	a1 cc 1f 11 80       	mov    0x80111fcc,%eax
80100968:	83 f8 7f             	cmp    $0x7f,%eax
8010096b:	0f 87 4f ff ff ff    	ja     801008c0 <consoleintr+0x20>
	if(c != '\n'){
80100971:	83 fb 0a             	cmp    $0xa,%ebx
80100974:	0f 84 c6 01 00 00    	je     80100b40 <consoleintr+0x2a0>
8010097a:	83 fb 0d             	cmp    $0xd,%ebx
8010097d:	0f 84 bd 01 00 00    	je     80100b40 <consoleintr+0x2a0>
	  memmove(input.buf + input.e + 1, input.buf + input.e, input.max - input.e);	
80100983:	8b 15 c8 1f 11 80    	mov    0x80111fc8,%edx
80100989:	83 ec 04             	sub    $0x4,%esp
8010098c:	29 d0                	sub    %edx,%eax
8010098e:	50                   	push   %eax
8010098f:	8d 82 40 1f 11 80    	lea    -0x7feee0c0(%edx),%eax
80100995:	81 c2 41 1f 11 80    	add    $0x80111f41,%edx
8010099b:	50                   	push   %eax
8010099c:	52                   	push   %edx
8010099d:	e8 ce 44 00 00       	call   80104e70 <memmove>
	  input.buf[input.e++ % INPUT_BUF] = c;
801009a2:	a1 c8 1f 11 80       	mov    0x80111fc8,%eax
	  input.max++;
801009a7:	83 05 cc 1f 11 80 01 	addl   $0x1,0x80111fcc
	  input.buf[input.e++ % INPUT_BUF] = c;
801009ae:	8d 50 01             	lea    0x1(%eax),%edx
801009b1:	83 e0 7f             	and    $0x7f,%eax
801009b4:	88 98 40 1f 11 80    	mov    %bl,-0x7feee0c0(%eax)
	  consputc(c);
801009ba:	89 d8                	mov    %ebx,%eax
	  input.buf[input.e++ % INPUT_BUF] = c;
801009bc:	89 15 c8 1f 11 80    	mov    %edx,0x80111fc8
	  consputc(c);
801009c2:	e8 49 fa ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.max == input.r + INPUT_BUF){
801009c7:	83 c4 10             	add    $0x10,%esp
801009ca:	83 fb 0a             	cmp    $0xa,%ebx
801009cd:	0f 84 87 01 00 00    	je     80100b5a <consoleintr+0x2ba>
801009d3:	83 fb 04             	cmp    $0x4,%ebx
801009d6:	0f 84 7e 01 00 00    	je     80100b5a <consoleintr+0x2ba>
801009dc:	a1 c0 1f 11 80       	mov    0x80111fc0,%eax
801009e1:	83 e8 80             	sub    $0xffffff80,%eax
801009e4:	39 05 cc 1f 11 80    	cmp    %eax,0x80111fcc
801009ea:	0f 85 d0 fe ff ff    	jne    801008c0 <consoleintr+0x20>
          wakeup(&input.r);
801009f0:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.max;
801009f3:	a3 c4 1f 11 80       	mov    %eax,0x80111fc4
	  input.e = input.max;
801009f8:	a3 c8 1f 11 80       	mov    %eax,0x80111fc8
          wakeup(&input.r);
801009fd:	68 c0 1f 11 80       	push   $0x80111fc0
80100a02:	e8 89 37 00 00       	call   80104190 <wakeup>
80100a07:	83 c4 10             	add    $0x10,%esp
80100a0a:	e9 b1 fe ff ff       	jmp    801008c0 <consoleintr+0x20>
80100a0f:	90                   	nop
    switch(c){
80100a10:	81 fb e2 00 00 00    	cmp    $0xe2,%ebx
80100a16:	0f 85 3f ff ff ff    	jne    8010095b <consoleintr+0xbb>
      consputc(c);
80100a1c:	b8 e2 00 00 00       	mov    $0xe2,%eax
80100a21:	e8 ea f9 ff ff       	call   80100410 <consputc>
      break;
80100a26:	e9 95 fe ff ff       	jmp    801008c0 <consoleintr+0x20>
80100a2b:	90                   	nop
80100a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100a30:	bf 01 00 00 00       	mov    $0x1,%edi
80100a35:	e9 86 fe ff ff       	jmp    801008c0 <consoleintr+0x20>
80100a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      consputc(c);
80100a40:	b8 e3 00 00 00       	mov    $0xe3,%eax
80100a45:	e8 c6 f9 ff ff       	call   80100410 <consputc>
      break;
80100a4a:	e9 71 fe ff ff       	jmp    801008c0 <consoleintr+0x20>
80100a4f:	90                   	nop
      if(input.e != input.w){
80100a50:	a1 c8 1f 11 80       	mov    0x80111fc8,%eax
80100a55:	3b 05 c4 1f 11 80    	cmp    0x80111fc4,%eax
80100a5b:	0f 84 5f fe ff ff    	je     801008c0 <consoleintr+0x20>
	      input.e--;
80100a61:	83 e8 01             	sub    $0x1,%eax
80100a64:	a3 c8 1f 11 80       	mov    %eax,0x80111fc8
        consputc(c);
80100a69:	b8 e4 00 00 00       	mov    $0xe4,%eax
80100a6e:	e8 9d f9 ff ff       	call   80100410 <consputc>
80100a73:	e9 48 fe ff ff       	jmp    801008c0 <consoleintr+0x20>
80100a78:	90                   	nop
80100a79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(input.e != input.w){
80100a80:	a1 c8 1f 11 80       	mov    0x80111fc8,%eax
80100a85:	3b 05 c4 1f 11 80    	cmp    0x80111fc4,%eax
80100a8b:	0f 84 2f fe ff ff    	je     801008c0 <consoleintr+0x20>
        input.max--;
80100a91:	8b 0d cc 1f 11 80    	mov    0x80111fcc,%ecx
        memmove(input.buf + input.e, input.buf + input.e + 1, input.max - input.e); // TODO: check indices
80100a97:	83 ec 04             	sub    $0x4,%esp
        input.max--;
80100a9a:	8d 51 ff             	lea    -0x1(%ecx),%edx
	      input.e--;
80100a9d:	8d 48 ff             	lea    -0x1(%eax),%ecx
        memmove(input.buf + input.e, input.buf + input.e + 1, input.max - input.e); // TODO: check indices
80100aa0:	05 40 1f 11 80       	add    $0x80111f40,%eax
        input.max--;
80100aa5:	89 15 cc 1f 11 80    	mov    %edx,0x80111fcc
	      input.e--;
80100aab:	89 0d c8 1f 11 80    	mov    %ecx,0x80111fc8
        memmove(input.buf + input.e, input.buf + input.e + 1, input.max - input.e); // TODO: check indices
80100ab1:	29 ca                	sub    %ecx,%edx
80100ab3:	81 c1 40 1f 11 80    	add    $0x80111f40,%ecx
80100ab9:	52                   	push   %edx
80100aba:	50                   	push   %eax
80100abb:	51                   	push   %ecx
80100abc:	e8 af 43 00 00       	call   80104e70 <memmove>
        consputc(BACKSPACE);
80100ac1:	b8 00 01 00 00       	mov    $0x100,%eax
80100ac6:	e8 45 f9 ff ff       	call   80100410 <consputc>
80100acb:	83 c4 10             	add    $0x10,%esp
80100ace:	e9 ed fd ff ff       	jmp    801008c0 <consoleintr+0x20>
80100ad3:	90                   	nop
80100ad4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      while(input.max != input.w &&
80100ad8:	a1 cc 1f 11 80       	mov    0x80111fcc,%eax
80100add:	39 05 c4 1f 11 80    	cmp    %eax,0x80111fc4
80100ae3:	75 32                	jne    80100b17 <consoleintr+0x277>
80100ae5:	e9 d6 fd ff ff       	jmp    801008c0 <consoleintr+0x20>
80100aea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.max--;
80100af0:	a3 cc 1f 11 80       	mov    %eax,0x80111fcc
        consputc(BACKSPACE);
80100af5:	b8 00 01 00 00       	mov    $0x100,%eax
	      input.e--;
80100afa:	83 2d c8 1f 11 80 01 	subl   $0x1,0x80111fc8
        consputc(BACKSPACE);
80100b01:	e8 0a f9 ff ff       	call   80100410 <consputc>
      while(input.max != input.w &&
80100b06:	a1 cc 1f 11 80       	mov    0x80111fcc,%eax
80100b0b:	3b 05 c4 1f 11 80    	cmp    0x80111fc4,%eax
80100b11:	0f 84 a9 fd ff ff    	je     801008c0 <consoleintr+0x20>
            input.buf[(input.max-1) % INPUT_BUF] != '\n'){
80100b17:	83 e8 01             	sub    $0x1,%eax
80100b1a:	89 c2                	mov    %eax,%edx
80100b1c:	83 e2 7f             	and    $0x7f,%edx
      while(input.max != input.w &&
80100b1f:	80 ba 40 1f 11 80 0a 	cmpb   $0xa,-0x7feee0c0(%edx)
80100b26:	75 c8                	jne    80100af0 <consoleintr+0x250>
80100b28:	e9 93 fd ff ff       	jmp    801008c0 <consoleintr+0x20>
80100b2d:	8d 76 00             	lea    0x0(%esi),%esi
}
80100b30:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b33:	5b                   	pop    %ebx
80100b34:	5e                   	pop    %esi
80100b35:	5f                   	pop    %edi
80100b36:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100b37:	e9 f4 3b 00 00       	jmp    80104730 <procdump>
80100b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
          input.buf[input.max++ % INPUT_BUF] = c;
80100b40:	8d 50 01             	lea    0x1(%eax),%edx
80100b43:	c6 80 40 1f 11 80 0a 	movb   $0xa,-0x7feee0c0(%eax)
          consputc(c);
80100b4a:	b8 0a 00 00 00       	mov    $0xa,%eax
          input.buf[input.max++ % INPUT_BUF] = c;
80100b4f:	89 15 cc 1f 11 80    	mov    %edx,0x80111fcc
          consputc(c);
80100b55:	e8 b6 f8 ff ff       	call   80100410 <consputc>
80100b5a:	a1 cc 1f 11 80       	mov    0x80111fcc,%eax
80100b5f:	e9 8c fe ff ff       	jmp    801009f0 <consoleintr+0x150>
80100b64:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100b6a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100b70 <consoleinit>:

void
consoleinit(void)
{
80100b70:	55                   	push   %ebp
80100b71:	89 e5                	mov    %esp,%ebp
80100b73:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100b76:	68 88 82 10 80       	push   $0x80108288
80100b7b:	68 20 c5 10 80       	push   $0x8010c520
80100b80:	e8 db 3d 00 00       	call   80104960 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100b85:	58                   	pop    %eax
80100b86:	5a                   	pop    %edx
80100b87:	6a 00                	push   $0x0
80100b89:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100b8b:	c7 05 8c 29 11 80 90 	movl   $0x80100690,0x8011298c
80100b92:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100b95:	c7 05 88 29 11 80 70 	movl   $0x80100270,0x80112988
80100b9c:	02 10 80 
  cons.locking = 1;
80100b9f:	c7 05 54 c5 10 80 01 	movl   $0x1,0x8010c554
80100ba6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100ba9:	e8 e2 18 00 00       	call   80102490 <ioapicenable>
}
80100bae:	83 c4 10             	add    $0x10,%esp
80100bb1:	c9                   	leave  
80100bb2:	c3                   	ret    
80100bb3:	66 90                	xchg   %ax,%ax
80100bb5:	66 90                	xchg   %ax,%ax
80100bb7:	66 90                	xchg   %ax,%ax
80100bb9:	66 90                	xchg   %ax,%ax
80100bbb:	66 90                	xchg   %ax,%ax
80100bbd:	66 90                	xchg   %ax,%ax
80100bbf:	90                   	nop

80100bc0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100bc0:	55                   	push   %ebp
80100bc1:	89 e5                	mov    %esp,%ebp
80100bc3:	57                   	push   %edi
80100bc4:	56                   	push   %esi
80100bc5:	53                   	push   %ebx
80100bc6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100bcc:	e8 ef 2d 00 00       	call   801039c0 <myproc>
80100bd1:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100bd7:	e8 84 21 00 00       	call   80102d60 <begin_op>

  if((ip = namei(path)) == 0){
80100bdc:	83 ec 0c             	sub    $0xc,%esp
80100bdf:	ff 75 08             	pushl  0x8(%ebp)
80100be2:	e8 b9 14 00 00       	call   801020a0 <namei>
80100be7:	83 c4 10             	add    $0x10,%esp
80100bea:	85 c0                	test   %eax,%eax
80100bec:	0f 84 91 01 00 00    	je     80100d83 <exec+0x1c3>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100bf2:	83 ec 0c             	sub    $0xc,%esp
80100bf5:	89 c3                	mov    %eax,%ebx
80100bf7:	50                   	push   %eax
80100bf8:	e8 43 0c 00 00       	call   80101840 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100bfd:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100c03:	6a 34                	push   $0x34
80100c05:	6a 00                	push   $0x0
80100c07:	50                   	push   %eax
80100c08:	53                   	push   %ebx
80100c09:	e8 12 0f 00 00       	call   80101b20 <readi>
80100c0e:	83 c4 20             	add    $0x20,%esp
80100c11:	83 f8 34             	cmp    $0x34,%eax
80100c14:	74 22                	je     80100c38 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100c16:	83 ec 0c             	sub    $0xc,%esp
80100c19:	53                   	push   %ebx
80100c1a:	e8 b1 0e 00 00       	call   80101ad0 <iunlockput>
    end_op();
80100c1f:	e8 ac 21 00 00       	call   80102dd0 <end_op>
80100c24:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100c27:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100c2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100c2f:	5b                   	pop    %ebx
80100c30:	5e                   	pop    %esi
80100c31:	5f                   	pop    %edi
80100c32:	5d                   	pop    %ebp
80100c33:	c3                   	ret    
80100c34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100c38:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100c3f:	45 4c 46 
80100c42:	75 d2                	jne    80100c16 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100c44:	e8 37 73 00 00       	call   80107f80 <setupkvm>
80100c49:	85 c0                	test   %eax,%eax
80100c4b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100c51:	74 c3                	je     80100c16 <exec+0x56>
  sz = 0;
80100c53:	31 ff                	xor    %edi,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c55:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100c5c:	00 
80100c5d:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100c63:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100c69:	0f 84 8c 02 00 00    	je     80100efb <exec+0x33b>
80100c6f:	31 f6                	xor    %esi,%esi
80100c71:	eb 7f                	jmp    80100cf2 <exec+0x132>
80100c73:	90                   	nop
80100c74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100c78:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100c7f:	75 63                	jne    80100ce4 <exec+0x124>
    if(ph.memsz < ph.filesz)
80100c81:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100c87:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100c8d:	0f 82 86 00 00 00    	jb     80100d19 <exec+0x159>
80100c93:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100c99:	72 7e                	jb     80100d19 <exec+0x159>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100c9b:	83 ec 04             	sub    $0x4,%esp
80100c9e:	50                   	push   %eax
80100c9f:	57                   	push   %edi
80100ca0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100ca6:	e8 f5 70 00 00       	call   80107da0 <allocuvm>
80100cab:	83 c4 10             	add    $0x10,%esp
80100cae:	85 c0                	test   %eax,%eax
80100cb0:	89 c7                	mov    %eax,%edi
80100cb2:	74 65                	je     80100d19 <exec+0x159>
    if(ph.vaddr % PGSIZE != 0)
80100cb4:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100cba:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100cbf:	75 58                	jne    80100d19 <exec+0x159>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100cc1:	83 ec 0c             	sub    $0xc,%esp
80100cc4:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100cca:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100cd0:	53                   	push   %ebx
80100cd1:	50                   	push   %eax
80100cd2:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100cd8:	e8 03 70 00 00       	call   80107ce0 <loaduvm>
80100cdd:	83 c4 20             	add    $0x20,%esp
80100ce0:	85 c0                	test   %eax,%eax
80100ce2:	78 35                	js     80100d19 <exec+0x159>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100ce4:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100ceb:	83 c6 01             	add    $0x1,%esi
80100cee:	39 f0                	cmp    %esi,%eax
80100cf0:	7e 3d                	jle    80100d2f <exec+0x16f>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100cf2:	89 f0                	mov    %esi,%eax
80100cf4:	6a 20                	push   $0x20
80100cf6:	c1 e0 05             	shl    $0x5,%eax
80100cf9:	03 85 ec fe ff ff    	add    -0x114(%ebp),%eax
80100cff:	50                   	push   %eax
80100d00:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100d06:	50                   	push   %eax
80100d07:	53                   	push   %ebx
80100d08:	e8 13 0e 00 00       	call   80101b20 <readi>
80100d0d:	83 c4 10             	add    $0x10,%esp
80100d10:	83 f8 20             	cmp    $0x20,%eax
80100d13:	0f 84 5f ff ff ff    	je     80100c78 <exec+0xb8>
    freevm(pgdir);
80100d19:	83 ec 0c             	sub    $0xc,%esp
80100d1c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100d22:	e8 d9 71 00 00       	call   80107f00 <freevm>
80100d27:	83 c4 10             	add    $0x10,%esp
80100d2a:	e9 e7 fe ff ff       	jmp    80100c16 <exec+0x56>
80100d2f:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100d35:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100d3b:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100d41:	83 ec 0c             	sub    $0xc,%esp
80100d44:	53                   	push   %ebx
80100d45:	e8 86 0d 00 00       	call   80101ad0 <iunlockput>
  end_op();
80100d4a:	e8 81 20 00 00       	call   80102dd0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100d4f:	83 c4 0c             	add    $0xc,%esp
80100d52:	56                   	push   %esi
80100d53:	57                   	push   %edi
80100d54:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100d5a:	e8 41 70 00 00       	call   80107da0 <allocuvm>
80100d5f:	83 c4 10             	add    $0x10,%esp
80100d62:	85 c0                	test   %eax,%eax
80100d64:	89 c6                	mov    %eax,%esi
80100d66:	75 3a                	jne    80100da2 <exec+0x1e2>
    freevm(pgdir);
80100d68:	83 ec 0c             	sub    $0xc,%esp
80100d6b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100d71:	e8 8a 71 00 00       	call   80107f00 <freevm>
80100d76:	83 c4 10             	add    $0x10,%esp
  return -1;
80100d79:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d7e:	e9 a9 fe ff ff       	jmp    80100c2c <exec+0x6c>
    end_op();
80100d83:	e8 48 20 00 00       	call   80102dd0 <end_op>
    cprintf("exec: fail\n");
80100d88:	83 ec 0c             	sub    $0xc,%esp
80100d8b:	68 a1 82 10 80       	push   $0x801082a1
80100d90:	e8 5b f9 ff ff       	call   801006f0 <cprintf>
    return -1;
80100d95:	83 c4 10             	add    $0x10,%esp
80100d98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d9d:	e9 8a fe ff ff       	jmp    80100c2c <exec+0x6c>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100da2:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100da8:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100dab:	31 ff                	xor    %edi,%edi
80100dad:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100daf:	50                   	push   %eax
80100db0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100db6:	e8 65 72 00 00       	call   80108020 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100dbb:	8b 45 0c             	mov    0xc(%ebp),%eax
80100dbe:	83 c4 10             	add    $0x10,%esp
80100dc1:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100dc7:	8b 00                	mov    (%eax),%eax
80100dc9:	85 c0                	test   %eax,%eax
80100dcb:	74 70                	je     80100e3d <exec+0x27d>
80100dcd:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100dd3:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100dd9:	eb 0a                	jmp    80100de5 <exec+0x225>
80100ddb:	90                   	nop
80100ddc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(argc >= MAXARG)
80100de0:	83 ff 20             	cmp    $0x20,%edi
80100de3:	74 83                	je     80100d68 <exec+0x1a8>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100de5:	83 ec 0c             	sub    $0xc,%esp
80100de8:	50                   	push   %eax
80100de9:	e8 f2 41 00 00       	call   80104fe0 <strlen>
80100dee:	f7 d0                	not    %eax
80100df0:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100df2:	8b 45 0c             	mov    0xc(%ebp),%eax
80100df5:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100df6:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100df9:	ff 34 b8             	pushl  (%eax,%edi,4)
80100dfc:	e8 df 41 00 00       	call   80104fe0 <strlen>
80100e01:	83 c0 01             	add    $0x1,%eax
80100e04:	50                   	push   %eax
80100e05:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e08:	ff 34 b8             	pushl  (%eax,%edi,4)
80100e0b:	53                   	push   %ebx
80100e0c:	56                   	push   %esi
80100e0d:	e8 6e 73 00 00       	call   80108180 <copyout>
80100e12:	83 c4 20             	add    $0x20,%esp
80100e15:	85 c0                	test   %eax,%eax
80100e17:	0f 88 4b ff ff ff    	js     80100d68 <exec+0x1a8>
  for(argc = 0; argv[argc]; argc++) {
80100e1d:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100e20:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100e27:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100e2a:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100e30:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100e33:	85 c0                	test   %eax,%eax
80100e35:	75 a9                	jne    80100de0 <exec+0x220>
80100e37:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e3d:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100e44:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100e46:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100e4d:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100e51:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100e58:	ff ff ff 
  ustack[1] = argc;
80100e5b:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e61:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100e63:	83 c0 0c             	add    $0xc,%eax
80100e66:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100e68:	50                   	push   %eax
80100e69:	52                   	push   %edx
80100e6a:	53                   	push   %ebx
80100e6b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e71:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100e77:	e8 04 73 00 00       	call   80108180 <copyout>
80100e7c:	83 c4 10             	add    $0x10,%esp
80100e7f:	85 c0                	test   %eax,%eax
80100e81:	0f 88 e1 fe ff ff    	js     80100d68 <exec+0x1a8>
  for(last=s=path; *s; s++)
80100e87:	8b 45 08             	mov    0x8(%ebp),%eax
80100e8a:	0f b6 00             	movzbl (%eax),%eax
80100e8d:	84 c0                	test   %al,%al
80100e8f:	74 17                	je     80100ea8 <exec+0x2e8>
80100e91:	8b 55 08             	mov    0x8(%ebp),%edx
80100e94:	89 d1                	mov    %edx,%ecx
80100e96:	83 c1 01             	add    $0x1,%ecx
80100e99:	3c 2f                	cmp    $0x2f,%al
80100e9b:	0f b6 01             	movzbl (%ecx),%eax
80100e9e:	0f 44 d1             	cmove  %ecx,%edx
80100ea1:	84 c0                	test   %al,%al
80100ea3:	75 f1                	jne    80100e96 <exec+0x2d6>
80100ea5:	89 55 08             	mov    %edx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100ea8:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100eae:	50                   	push   %eax
80100eaf:	6a 10                	push   $0x10
80100eb1:	ff 75 08             	pushl  0x8(%ebp)
80100eb4:	89 f8                	mov    %edi,%eax
80100eb6:	83 c0 6c             	add    $0x6c,%eax
80100eb9:	50                   	push   %eax
80100eba:	e8 e1 40 00 00       	call   80104fa0 <safestrcpy>
  curproc->pgdir = pgdir;
80100ebf:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  oldpgdir = curproc->pgdir;
80100ec5:	89 f9                	mov    %edi,%ecx
80100ec7:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->tf->eip = elf.entry;  // main
80100eca:	8b 41 18             	mov    0x18(%ecx),%eax
  curproc->sz = sz;
80100ecd:	89 31                	mov    %esi,(%ecx)
  curproc->pgdir = pgdir;
80100ecf:	89 51 04             	mov    %edx,0x4(%ecx)
  curproc->tf->eip = elf.entry;  // main
80100ed2:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100ed8:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100edb:	8b 41 18             	mov    0x18(%ecx),%eax
80100ede:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100ee1:	89 0c 24             	mov    %ecx,(%esp)
80100ee4:	e8 67 6c 00 00       	call   80107b50 <switchuvm>
  freevm(oldpgdir);
80100ee9:	89 3c 24             	mov    %edi,(%esp)
80100eec:	e8 0f 70 00 00       	call   80107f00 <freevm>
  return 0;
80100ef1:	83 c4 10             	add    $0x10,%esp
80100ef4:	31 c0                	xor    %eax,%eax
80100ef6:	e9 31 fd ff ff       	jmp    80100c2c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100efb:	be 00 20 00 00       	mov    $0x2000,%esi
80100f00:	e9 3c fe ff ff       	jmp    80100d41 <exec+0x181>
80100f05:	66 90                	xchg   %ax,%ax
80100f07:	66 90                	xchg   %ax,%ax
80100f09:	66 90                	xchg   %ax,%ax
80100f0b:	66 90                	xchg   %ax,%ax
80100f0d:	66 90                	xchg   %ax,%ax
80100f0f:	90                   	nop

80100f10 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f10:	55                   	push   %ebp
80100f11:	89 e5                	mov    %esp,%ebp
80100f13:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100f16:	68 ad 82 10 80       	push   $0x801082ad
80100f1b:	68 e0 1f 11 80       	push   $0x80111fe0
80100f20:	e8 3b 3a 00 00       	call   80104960 <initlock>
}
80100f25:	83 c4 10             	add    $0x10,%esp
80100f28:	c9                   	leave  
80100f29:	c3                   	ret    
80100f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100f30 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f30:	55                   	push   %ebp
80100f31:	89 e5                	mov    %esp,%ebp
80100f33:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f34:	bb 14 20 11 80       	mov    $0x80112014,%ebx
{
80100f39:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100f3c:	68 e0 1f 11 80       	push   $0x80111fe0
80100f41:	e8 5a 3b 00 00       	call   80104aa0 <acquire>
80100f46:	83 c4 10             	add    $0x10,%esp
80100f49:	eb 10                	jmp    80100f5b <filealloc+0x2b>
80100f4b:	90                   	nop
80100f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f50:	83 c3 18             	add    $0x18,%ebx
80100f53:	81 fb 74 29 11 80    	cmp    $0x80112974,%ebx
80100f59:	73 25                	jae    80100f80 <filealloc+0x50>
    if(f->ref == 0){
80100f5b:	8b 43 04             	mov    0x4(%ebx),%eax
80100f5e:	85 c0                	test   %eax,%eax
80100f60:	75 ee                	jne    80100f50 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100f62:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100f65:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100f6c:	68 e0 1f 11 80       	push   $0x80111fe0
80100f71:	e8 ea 3b 00 00       	call   80104b60 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100f76:	89 d8                	mov    %ebx,%eax
      return f;
80100f78:	83 c4 10             	add    $0x10,%esp
}
80100f7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f7e:	c9                   	leave  
80100f7f:	c3                   	ret    
  release(&ftable.lock);
80100f80:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100f83:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100f85:	68 e0 1f 11 80       	push   $0x80111fe0
80100f8a:	e8 d1 3b 00 00       	call   80104b60 <release>
}
80100f8f:	89 d8                	mov    %ebx,%eax
  return 0;
80100f91:	83 c4 10             	add    $0x10,%esp
}
80100f94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f97:	c9                   	leave  
80100f98:	c3                   	ret    
80100f99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100fa0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100fa0:	55                   	push   %ebp
80100fa1:	89 e5                	mov    %esp,%ebp
80100fa3:	53                   	push   %ebx
80100fa4:	83 ec 10             	sub    $0x10,%esp
80100fa7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100faa:	68 e0 1f 11 80       	push   $0x80111fe0
80100faf:	e8 ec 3a 00 00       	call   80104aa0 <acquire>
  if(f->ref < 1)
80100fb4:	8b 43 04             	mov    0x4(%ebx),%eax
80100fb7:	83 c4 10             	add    $0x10,%esp
80100fba:	85 c0                	test   %eax,%eax
80100fbc:	7e 1a                	jle    80100fd8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100fbe:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100fc1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100fc4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100fc7:	68 e0 1f 11 80       	push   $0x80111fe0
80100fcc:	e8 8f 3b 00 00       	call   80104b60 <release>
  return f;
}
80100fd1:	89 d8                	mov    %ebx,%eax
80100fd3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100fd6:	c9                   	leave  
80100fd7:	c3                   	ret    
    panic("filedup");
80100fd8:	83 ec 0c             	sub    $0xc,%esp
80100fdb:	68 b4 82 10 80       	push   $0x801082b4
80100fe0:	e8 ab f3 ff ff       	call   80100390 <panic>
80100fe5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100ff0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ff0:	55                   	push   %ebp
80100ff1:	89 e5                	mov    %esp,%ebp
80100ff3:	57                   	push   %edi
80100ff4:	56                   	push   %esi
80100ff5:	53                   	push   %ebx
80100ff6:	83 ec 28             	sub    $0x28,%esp
80100ff9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100ffc:	68 e0 1f 11 80       	push   $0x80111fe0
80101001:	e8 9a 3a 00 00       	call   80104aa0 <acquire>
  if(f->ref < 1)
80101006:	8b 43 04             	mov    0x4(%ebx),%eax
80101009:	83 c4 10             	add    $0x10,%esp
8010100c:	85 c0                	test   %eax,%eax
8010100e:	0f 8e 9b 00 00 00    	jle    801010af <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80101014:	83 e8 01             	sub    $0x1,%eax
80101017:	85 c0                	test   %eax,%eax
80101019:	89 43 04             	mov    %eax,0x4(%ebx)
8010101c:	74 1a                	je     80101038 <fileclose+0x48>
    release(&ftable.lock);
8010101e:	c7 45 08 e0 1f 11 80 	movl   $0x80111fe0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80101025:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101028:	5b                   	pop    %ebx
80101029:	5e                   	pop    %esi
8010102a:	5f                   	pop    %edi
8010102b:	5d                   	pop    %ebp
    release(&ftable.lock);
8010102c:	e9 2f 3b 00 00       	jmp    80104b60 <release>
80101031:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80101038:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
8010103c:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
8010103e:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80101041:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80101044:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
8010104a:	88 45 e7             	mov    %al,-0x19(%ebp)
8010104d:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80101050:	68 e0 1f 11 80       	push   $0x80111fe0
  ff = *f;
80101055:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80101058:	e8 03 3b 00 00       	call   80104b60 <release>
  if(ff.type == FD_PIPE)
8010105d:	83 c4 10             	add    $0x10,%esp
80101060:	83 ff 01             	cmp    $0x1,%edi
80101063:	74 13                	je     80101078 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80101065:	83 ff 02             	cmp    $0x2,%edi
80101068:	74 26                	je     80101090 <fileclose+0xa0>
}
8010106a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010106d:	5b                   	pop    %ebx
8010106e:	5e                   	pop    %esi
8010106f:	5f                   	pop    %edi
80101070:	5d                   	pop    %ebp
80101071:	c3                   	ret    
80101072:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80101078:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
8010107c:	83 ec 08             	sub    $0x8,%esp
8010107f:	53                   	push   %ebx
80101080:	56                   	push   %esi
80101081:	e8 8a 24 00 00       	call   80103510 <pipeclose>
80101086:	83 c4 10             	add    $0x10,%esp
80101089:	eb df                	jmp    8010106a <fileclose+0x7a>
8010108b:	90                   	nop
8010108c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80101090:	e8 cb 1c 00 00       	call   80102d60 <begin_op>
    iput(ff.ip);
80101095:	83 ec 0c             	sub    $0xc,%esp
80101098:	ff 75 e0             	pushl  -0x20(%ebp)
8010109b:	e8 d0 08 00 00       	call   80101970 <iput>
    end_op();
801010a0:	83 c4 10             	add    $0x10,%esp
}
801010a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010a6:	5b                   	pop    %ebx
801010a7:	5e                   	pop    %esi
801010a8:	5f                   	pop    %edi
801010a9:	5d                   	pop    %ebp
    end_op();
801010aa:	e9 21 1d 00 00       	jmp    80102dd0 <end_op>
    panic("fileclose");
801010af:	83 ec 0c             	sub    $0xc,%esp
801010b2:	68 bc 82 10 80       	push   $0x801082bc
801010b7:	e8 d4 f2 ff ff       	call   80100390 <panic>
801010bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801010c0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801010c0:	55                   	push   %ebp
801010c1:	89 e5                	mov    %esp,%ebp
801010c3:	53                   	push   %ebx
801010c4:	83 ec 04             	sub    $0x4,%esp
801010c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
801010ca:	83 3b 02             	cmpl   $0x2,(%ebx)
801010cd:	75 31                	jne    80101100 <filestat+0x40>
    ilock(f->ip);
801010cf:	83 ec 0c             	sub    $0xc,%esp
801010d2:	ff 73 10             	pushl  0x10(%ebx)
801010d5:	e8 66 07 00 00       	call   80101840 <ilock>
    stati(f->ip, st);
801010da:	58                   	pop    %eax
801010db:	5a                   	pop    %edx
801010dc:	ff 75 0c             	pushl  0xc(%ebp)
801010df:	ff 73 10             	pushl  0x10(%ebx)
801010e2:	e8 09 0a 00 00       	call   80101af0 <stati>
    iunlock(f->ip);
801010e7:	59                   	pop    %ecx
801010e8:	ff 73 10             	pushl  0x10(%ebx)
801010eb:	e8 30 08 00 00       	call   80101920 <iunlock>
    return 0;
801010f0:	83 c4 10             	add    $0x10,%esp
801010f3:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
801010f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801010f8:	c9                   	leave  
801010f9:	c3                   	ret    
801010fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80101100:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101105:	eb ee                	jmp    801010f5 <filestat+0x35>
80101107:	89 f6                	mov    %esi,%esi
80101109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101110 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101110:	55                   	push   %ebp
80101111:	89 e5                	mov    %esp,%ebp
80101113:	57                   	push   %edi
80101114:	56                   	push   %esi
80101115:	53                   	push   %ebx
80101116:	83 ec 0c             	sub    $0xc,%esp
80101119:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010111c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010111f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101122:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101126:	74 60                	je     80101188 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101128:	8b 03                	mov    (%ebx),%eax
8010112a:	83 f8 01             	cmp    $0x1,%eax
8010112d:	74 41                	je     80101170 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010112f:	83 f8 02             	cmp    $0x2,%eax
80101132:	75 5b                	jne    8010118f <fileread+0x7f>
    ilock(f->ip);
80101134:	83 ec 0c             	sub    $0xc,%esp
80101137:	ff 73 10             	pushl  0x10(%ebx)
8010113a:	e8 01 07 00 00       	call   80101840 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010113f:	57                   	push   %edi
80101140:	ff 73 14             	pushl  0x14(%ebx)
80101143:	56                   	push   %esi
80101144:	ff 73 10             	pushl  0x10(%ebx)
80101147:	e8 d4 09 00 00       	call   80101b20 <readi>
8010114c:	83 c4 20             	add    $0x20,%esp
8010114f:	85 c0                	test   %eax,%eax
80101151:	89 c6                	mov    %eax,%esi
80101153:	7e 03                	jle    80101158 <fileread+0x48>
      f->off += r;
80101155:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101158:	83 ec 0c             	sub    $0xc,%esp
8010115b:	ff 73 10             	pushl  0x10(%ebx)
8010115e:	e8 bd 07 00 00       	call   80101920 <iunlock>
    return r;
80101163:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101166:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101169:	89 f0                	mov    %esi,%eax
8010116b:	5b                   	pop    %ebx
8010116c:	5e                   	pop    %esi
8010116d:	5f                   	pop    %edi
8010116e:	5d                   	pop    %ebp
8010116f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101170:	8b 43 0c             	mov    0xc(%ebx),%eax
80101173:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101176:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101179:	5b                   	pop    %ebx
8010117a:	5e                   	pop    %esi
8010117b:	5f                   	pop    %edi
8010117c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010117d:	e9 3e 25 00 00       	jmp    801036c0 <piperead>
80101182:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101188:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010118d:	eb d7                	jmp    80101166 <fileread+0x56>
  panic("fileread");
8010118f:	83 ec 0c             	sub    $0xc,%esp
80101192:	68 c6 82 10 80       	push   $0x801082c6
80101197:	e8 f4 f1 ff ff       	call   80100390 <panic>
8010119c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801011a0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801011a0:	55                   	push   %ebp
801011a1:	89 e5                	mov    %esp,%ebp
801011a3:	57                   	push   %edi
801011a4:	56                   	push   %esi
801011a5:	53                   	push   %ebx
801011a6:	83 ec 1c             	sub    $0x1c,%esp
801011a9:	8b 75 08             	mov    0x8(%ebp),%esi
801011ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
801011af:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
801011b3:	89 45 dc             	mov    %eax,-0x24(%ebp)
801011b6:	8b 45 10             	mov    0x10(%ebp),%eax
801011b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801011bc:	0f 84 aa 00 00 00    	je     8010126c <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
801011c2:	8b 06                	mov    (%esi),%eax
801011c4:	83 f8 01             	cmp    $0x1,%eax
801011c7:	0f 84 c3 00 00 00    	je     80101290 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801011cd:	83 f8 02             	cmp    $0x2,%eax
801011d0:	0f 85 d9 00 00 00    	jne    801012af <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801011d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801011d9:	31 ff                	xor    %edi,%edi
    while(i < n){
801011db:	85 c0                	test   %eax,%eax
801011dd:	7f 34                	jg     80101213 <filewrite+0x73>
801011df:	e9 9c 00 00 00       	jmp    80101280 <filewrite+0xe0>
801011e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801011e8:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
801011eb:	83 ec 0c             	sub    $0xc,%esp
801011ee:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
801011f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801011f4:	e8 27 07 00 00       	call   80101920 <iunlock>
      end_op();
801011f9:	e8 d2 1b 00 00       	call   80102dd0 <end_op>
801011fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101201:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101204:	39 c3                	cmp    %eax,%ebx
80101206:	0f 85 96 00 00 00    	jne    801012a2 <filewrite+0x102>
        panic("short filewrite");
      i += r;
8010120c:	01 df                	add    %ebx,%edi
    while(i < n){
8010120e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101211:	7e 6d                	jle    80101280 <filewrite+0xe0>
      int n1 = n - i;
80101213:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101216:	b8 00 06 00 00       	mov    $0x600,%eax
8010121b:	29 fb                	sub    %edi,%ebx
8010121d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101223:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101226:	e8 35 1b 00 00       	call   80102d60 <begin_op>
      ilock(f->ip);
8010122b:	83 ec 0c             	sub    $0xc,%esp
8010122e:	ff 76 10             	pushl  0x10(%esi)
80101231:	e8 0a 06 00 00       	call   80101840 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101236:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101239:	53                   	push   %ebx
8010123a:	ff 76 14             	pushl  0x14(%esi)
8010123d:	01 f8                	add    %edi,%eax
8010123f:	50                   	push   %eax
80101240:	ff 76 10             	pushl  0x10(%esi)
80101243:	e8 d8 09 00 00       	call   80101c20 <writei>
80101248:	83 c4 20             	add    $0x20,%esp
8010124b:	85 c0                	test   %eax,%eax
8010124d:	7f 99                	jg     801011e8 <filewrite+0x48>
      iunlock(f->ip);
8010124f:	83 ec 0c             	sub    $0xc,%esp
80101252:	ff 76 10             	pushl  0x10(%esi)
80101255:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101258:	e8 c3 06 00 00       	call   80101920 <iunlock>
      end_op();
8010125d:	e8 6e 1b 00 00       	call   80102dd0 <end_op>
      if(r < 0)
80101262:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101265:	83 c4 10             	add    $0x10,%esp
80101268:	85 c0                	test   %eax,%eax
8010126a:	74 98                	je     80101204 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
8010126c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010126f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
80101274:	89 f8                	mov    %edi,%eax
80101276:	5b                   	pop    %ebx
80101277:	5e                   	pop    %esi
80101278:	5f                   	pop    %edi
80101279:	5d                   	pop    %ebp
8010127a:	c3                   	ret    
8010127b:	90                   	nop
8010127c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
80101280:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101283:	75 e7                	jne    8010126c <filewrite+0xcc>
}
80101285:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101288:	89 f8                	mov    %edi,%eax
8010128a:	5b                   	pop    %ebx
8010128b:	5e                   	pop    %esi
8010128c:	5f                   	pop    %edi
8010128d:	5d                   	pop    %ebp
8010128e:	c3                   	ret    
8010128f:	90                   	nop
    return pipewrite(f->pipe, addr, n);
80101290:	8b 46 0c             	mov    0xc(%esi),%eax
80101293:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101296:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101299:	5b                   	pop    %ebx
8010129a:	5e                   	pop    %esi
8010129b:	5f                   	pop    %edi
8010129c:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
8010129d:	e9 0e 23 00 00       	jmp    801035b0 <pipewrite>
        panic("short filewrite");
801012a2:	83 ec 0c             	sub    $0xc,%esp
801012a5:	68 cf 82 10 80       	push   $0x801082cf
801012aa:	e8 e1 f0 ff ff       	call   80100390 <panic>
  panic("filewrite");
801012af:	83 ec 0c             	sub    $0xc,%esp
801012b2:	68 d5 82 10 80       	push   $0x801082d5
801012b7:	e8 d4 f0 ff ff       	call   80100390 <panic>
801012bc:	66 90                	xchg   %ax,%ax
801012be:	66 90                	xchg   %ax,%ax

801012c0 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801012c0:	55                   	push   %ebp
801012c1:	89 e5                	mov    %esp,%ebp
801012c3:	57                   	push   %edi
801012c4:	56                   	push   %esi
801012c5:	53                   	push   %ebx
801012c6:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801012c9:	8b 0d e0 29 11 80    	mov    0x801129e0,%ecx
{
801012cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801012d2:	85 c9                	test   %ecx,%ecx
801012d4:	0f 84 87 00 00 00    	je     80101361 <balloc+0xa1>
801012da:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801012e1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801012e4:	83 ec 08             	sub    $0x8,%esp
801012e7:	89 f0                	mov    %esi,%eax
801012e9:	c1 f8 0c             	sar    $0xc,%eax
801012ec:	03 05 f8 29 11 80    	add    0x801129f8,%eax
801012f2:	50                   	push   %eax
801012f3:	ff 75 d8             	pushl  -0x28(%ebp)
801012f6:	e8 d5 ed ff ff       	call   801000d0 <bread>
801012fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012fe:	a1 e0 29 11 80       	mov    0x801129e0,%eax
80101303:	83 c4 10             	add    $0x10,%esp
80101306:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101309:	31 c0                	xor    %eax,%eax
8010130b:	eb 2f                	jmp    8010133c <balloc+0x7c>
8010130d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101310:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101312:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
80101315:	bb 01 00 00 00       	mov    $0x1,%ebx
8010131a:	83 e1 07             	and    $0x7,%ecx
8010131d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010131f:	89 c1                	mov    %eax,%ecx
80101321:	c1 f9 03             	sar    $0x3,%ecx
80101324:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101329:	85 df                	test   %ebx,%edi
8010132b:	89 fa                	mov    %edi,%edx
8010132d:	74 41                	je     80101370 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010132f:	83 c0 01             	add    $0x1,%eax
80101332:	83 c6 01             	add    $0x1,%esi
80101335:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010133a:	74 05                	je     80101341 <balloc+0x81>
8010133c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010133f:	77 cf                	ja     80101310 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101341:	83 ec 0c             	sub    $0xc,%esp
80101344:	ff 75 e4             	pushl  -0x1c(%ebp)
80101347:	e8 94 ee ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010134c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101353:	83 c4 10             	add    $0x10,%esp
80101356:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101359:	39 05 e0 29 11 80    	cmp    %eax,0x801129e0
8010135f:	77 80                	ja     801012e1 <balloc+0x21>
  }
  panic("balloc: out of blocks");
80101361:	83 ec 0c             	sub    $0xc,%esp
80101364:	68 df 82 10 80       	push   $0x801082df
80101369:	e8 22 f0 ff ff       	call   80100390 <panic>
8010136e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101370:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101373:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101376:	09 da                	or     %ebx,%edx
80101378:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010137c:	57                   	push   %edi
8010137d:	e8 ae 1b 00 00       	call   80102f30 <log_write>
        brelse(bp);
80101382:	89 3c 24             	mov    %edi,(%esp)
80101385:	e8 56 ee ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
8010138a:	58                   	pop    %eax
8010138b:	5a                   	pop    %edx
8010138c:	56                   	push   %esi
8010138d:	ff 75 d8             	pushl  -0x28(%ebp)
80101390:	e8 3b ed ff ff       	call   801000d0 <bread>
80101395:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101397:	8d 40 5c             	lea    0x5c(%eax),%eax
8010139a:	83 c4 0c             	add    $0xc,%esp
8010139d:	68 00 02 00 00       	push   $0x200
801013a2:	6a 00                	push   $0x0
801013a4:	50                   	push   %eax
801013a5:	e8 16 3a 00 00       	call   80104dc0 <memset>
  log_write(bp);
801013aa:	89 1c 24             	mov    %ebx,(%esp)
801013ad:	e8 7e 1b 00 00       	call   80102f30 <log_write>
  brelse(bp);
801013b2:	89 1c 24             	mov    %ebx,(%esp)
801013b5:	e8 26 ee ff ff       	call   801001e0 <brelse>
}
801013ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013bd:	89 f0                	mov    %esi,%eax
801013bf:	5b                   	pop    %ebx
801013c0:	5e                   	pop    %esi
801013c1:	5f                   	pop    %edi
801013c2:	5d                   	pop    %ebp
801013c3:	c3                   	ret    
801013c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801013ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801013d0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801013d0:	55                   	push   %ebp
801013d1:	89 e5                	mov    %esp,%ebp
801013d3:	57                   	push   %edi
801013d4:	56                   	push   %esi
801013d5:	53                   	push   %ebx
801013d6:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801013d8:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013da:	bb 34 2a 11 80       	mov    $0x80112a34,%ebx
{
801013df:	83 ec 28             	sub    $0x28,%esp
801013e2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801013e5:	68 00 2a 11 80       	push   $0x80112a00
801013ea:	e8 b1 36 00 00       	call   80104aa0 <acquire>
801013ef:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013f2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801013f5:	eb 17                	jmp    8010140e <iget+0x3e>
801013f7:	89 f6                	mov    %esi,%esi
801013f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101400:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101406:	81 fb 54 46 11 80    	cmp    $0x80114654,%ebx
8010140c:	73 22                	jae    80101430 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010140e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101411:	85 c9                	test   %ecx,%ecx
80101413:	7e 04                	jle    80101419 <iget+0x49>
80101415:	39 3b                	cmp    %edi,(%ebx)
80101417:	74 4f                	je     80101468 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101419:	85 f6                	test   %esi,%esi
8010141b:	75 e3                	jne    80101400 <iget+0x30>
8010141d:	85 c9                	test   %ecx,%ecx
8010141f:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101422:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101428:	81 fb 54 46 11 80    	cmp    $0x80114654,%ebx
8010142e:	72 de                	jb     8010140e <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101430:	85 f6                	test   %esi,%esi
80101432:	74 5b                	je     8010148f <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101434:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
80101437:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101439:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010143c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101443:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010144a:	68 00 2a 11 80       	push   $0x80112a00
8010144f:	e8 0c 37 00 00       	call   80104b60 <release>

  return ip;
80101454:	83 c4 10             	add    $0x10,%esp
}
80101457:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010145a:	89 f0                	mov    %esi,%eax
8010145c:	5b                   	pop    %ebx
8010145d:	5e                   	pop    %esi
8010145e:	5f                   	pop    %edi
8010145f:	5d                   	pop    %ebp
80101460:	c3                   	ret    
80101461:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101468:	39 53 04             	cmp    %edx,0x4(%ebx)
8010146b:	75 ac                	jne    80101419 <iget+0x49>
      release(&icache.lock);
8010146d:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101470:	83 c1 01             	add    $0x1,%ecx
      return ip;
80101473:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
80101475:	68 00 2a 11 80       	push   $0x80112a00
      ip->ref++;
8010147a:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
8010147d:	e8 de 36 00 00       	call   80104b60 <release>
      return ip;
80101482:	83 c4 10             	add    $0x10,%esp
}
80101485:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101488:	89 f0                	mov    %esi,%eax
8010148a:	5b                   	pop    %ebx
8010148b:	5e                   	pop    %esi
8010148c:	5f                   	pop    %edi
8010148d:	5d                   	pop    %ebp
8010148e:	c3                   	ret    
    panic("iget: no inodes");
8010148f:	83 ec 0c             	sub    $0xc,%esp
80101492:	68 f5 82 10 80       	push   $0x801082f5
80101497:	e8 f4 ee ff ff       	call   80100390 <panic>
8010149c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801014a0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801014a0:	55                   	push   %ebp
801014a1:	89 e5                	mov    %esp,%ebp
801014a3:	57                   	push   %edi
801014a4:	56                   	push   %esi
801014a5:	53                   	push   %ebx
801014a6:	89 c6                	mov    %eax,%esi
801014a8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801014ab:	83 fa 0b             	cmp    $0xb,%edx
801014ae:	77 18                	ja     801014c8 <bmap+0x28>
801014b0:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
801014b3:	8b 5f 5c             	mov    0x5c(%edi),%ebx
801014b6:	85 db                	test   %ebx,%ebx
801014b8:	74 76                	je     80101530 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801014ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014bd:	89 d8                	mov    %ebx,%eax
801014bf:	5b                   	pop    %ebx
801014c0:	5e                   	pop    %esi
801014c1:	5f                   	pop    %edi
801014c2:	5d                   	pop    %ebp
801014c3:	c3                   	ret    
801014c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
801014c8:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
801014cb:	83 fb 7f             	cmp    $0x7f,%ebx
801014ce:	0f 87 90 00 00 00    	ja     80101564 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
801014d4:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
801014da:	8b 00                	mov    (%eax),%eax
801014dc:	85 d2                	test   %edx,%edx
801014de:	74 70                	je     80101550 <bmap+0xb0>
    bp = bread(ip->dev, addr);
801014e0:	83 ec 08             	sub    $0x8,%esp
801014e3:	52                   	push   %edx
801014e4:	50                   	push   %eax
801014e5:	e8 e6 eb ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
801014ea:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
801014ee:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
801014f1:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801014f3:	8b 1a                	mov    (%edx),%ebx
801014f5:	85 db                	test   %ebx,%ebx
801014f7:	75 1d                	jne    80101516 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
801014f9:	8b 06                	mov    (%esi),%eax
801014fb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801014fe:	e8 bd fd ff ff       	call   801012c0 <balloc>
80101503:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101506:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101509:	89 c3                	mov    %eax,%ebx
8010150b:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010150d:	57                   	push   %edi
8010150e:	e8 1d 1a 00 00       	call   80102f30 <log_write>
80101513:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101516:	83 ec 0c             	sub    $0xc,%esp
80101519:	57                   	push   %edi
8010151a:	e8 c1 ec ff ff       	call   801001e0 <brelse>
8010151f:	83 c4 10             	add    $0x10,%esp
}
80101522:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101525:	89 d8                	mov    %ebx,%eax
80101527:	5b                   	pop    %ebx
80101528:	5e                   	pop    %esi
80101529:	5f                   	pop    %edi
8010152a:	5d                   	pop    %ebp
8010152b:	c3                   	ret    
8010152c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
80101530:	8b 00                	mov    (%eax),%eax
80101532:	e8 89 fd ff ff       	call   801012c0 <balloc>
80101537:	89 47 5c             	mov    %eax,0x5c(%edi)
}
8010153a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
8010153d:	89 c3                	mov    %eax,%ebx
}
8010153f:	89 d8                	mov    %ebx,%eax
80101541:	5b                   	pop    %ebx
80101542:	5e                   	pop    %esi
80101543:	5f                   	pop    %edi
80101544:	5d                   	pop    %ebp
80101545:	c3                   	ret    
80101546:	8d 76 00             	lea    0x0(%esi),%esi
80101549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101550:	e8 6b fd ff ff       	call   801012c0 <balloc>
80101555:	89 c2                	mov    %eax,%edx
80101557:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010155d:	8b 06                	mov    (%esi),%eax
8010155f:	e9 7c ff ff ff       	jmp    801014e0 <bmap+0x40>
  panic("bmap: out of range");
80101564:	83 ec 0c             	sub    $0xc,%esp
80101567:	68 05 83 10 80       	push   $0x80108305
8010156c:	e8 1f ee ff ff       	call   80100390 <panic>
80101571:	eb 0d                	jmp    80101580 <readsb>
80101573:	90                   	nop
80101574:	90                   	nop
80101575:	90                   	nop
80101576:	90                   	nop
80101577:	90                   	nop
80101578:	90                   	nop
80101579:	90                   	nop
8010157a:	90                   	nop
8010157b:	90                   	nop
8010157c:	90                   	nop
8010157d:	90                   	nop
8010157e:	90                   	nop
8010157f:	90                   	nop

80101580 <readsb>:
{
80101580:	55                   	push   %ebp
80101581:	89 e5                	mov    %esp,%ebp
80101583:	56                   	push   %esi
80101584:	53                   	push   %ebx
80101585:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101588:	83 ec 08             	sub    $0x8,%esp
8010158b:	6a 01                	push   $0x1
8010158d:	ff 75 08             	pushl  0x8(%ebp)
80101590:	e8 3b eb ff ff       	call   801000d0 <bread>
80101595:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101597:	8d 40 5c             	lea    0x5c(%eax),%eax
8010159a:	83 c4 0c             	add    $0xc,%esp
8010159d:	6a 1c                	push   $0x1c
8010159f:	50                   	push   %eax
801015a0:	56                   	push   %esi
801015a1:	e8 ca 38 00 00       	call   80104e70 <memmove>
  brelse(bp);
801015a6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801015a9:	83 c4 10             	add    $0x10,%esp
}
801015ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
801015af:	5b                   	pop    %ebx
801015b0:	5e                   	pop    %esi
801015b1:	5d                   	pop    %ebp
  brelse(bp);
801015b2:	e9 29 ec ff ff       	jmp    801001e0 <brelse>
801015b7:	89 f6                	mov    %esi,%esi
801015b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801015c0 <bfree>:
{
801015c0:	55                   	push   %ebp
801015c1:	89 e5                	mov    %esp,%ebp
801015c3:	56                   	push   %esi
801015c4:	53                   	push   %ebx
801015c5:	89 d3                	mov    %edx,%ebx
801015c7:	89 c6                	mov    %eax,%esi
  readsb(dev, &sb);
801015c9:	83 ec 08             	sub    $0x8,%esp
801015cc:	68 e0 29 11 80       	push   $0x801129e0
801015d1:	50                   	push   %eax
801015d2:	e8 a9 ff ff ff       	call   80101580 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
801015d7:	58                   	pop    %eax
801015d8:	5a                   	pop    %edx
801015d9:	89 da                	mov    %ebx,%edx
801015db:	c1 ea 0c             	shr    $0xc,%edx
801015de:	03 15 f8 29 11 80    	add    0x801129f8,%edx
801015e4:	52                   	push   %edx
801015e5:	56                   	push   %esi
801015e6:	e8 e5 ea ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
801015eb:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801015ed:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
801015f0:	ba 01 00 00 00       	mov    $0x1,%edx
801015f5:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801015f8:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801015fe:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101601:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101603:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101608:	85 d1                	test   %edx,%ecx
8010160a:	74 25                	je     80101631 <bfree+0x71>
  bp->data[bi/8] &= ~m;
8010160c:	f7 d2                	not    %edx
8010160e:	89 c6                	mov    %eax,%esi
  log_write(bp);
80101610:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101613:	21 ca                	and    %ecx,%edx
80101615:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101619:	56                   	push   %esi
8010161a:	e8 11 19 00 00       	call   80102f30 <log_write>
  brelse(bp);
8010161f:	89 34 24             	mov    %esi,(%esp)
80101622:	e8 b9 eb ff ff       	call   801001e0 <brelse>
}
80101627:	83 c4 10             	add    $0x10,%esp
8010162a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010162d:	5b                   	pop    %ebx
8010162e:	5e                   	pop    %esi
8010162f:	5d                   	pop    %ebp
80101630:	c3                   	ret    
    panic("freeing free block");
80101631:	83 ec 0c             	sub    $0xc,%esp
80101634:	68 18 83 10 80       	push   $0x80108318
80101639:	e8 52 ed ff ff       	call   80100390 <panic>
8010163e:	66 90                	xchg   %ax,%ax

80101640 <iinit>:
{
80101640:	55                   	push   %ebp
80101641:	89 e5                	mov    %esp,%ebp
80101643:	53                   	push   %ebx
80101644:	bb 40 2a 11 80       	mov    $0x80112a40,%ebx
80101649:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010164c:	68 2b 83 10 80       	push   $0x8010832b
80101651:	68 00 2a 11 80       	push   $0x80112a00
80101656:	e8 05 33 00 00       	call   80104960 <initlock>
8010165b:	83 c4 10             	add    $0x10,%esp
8010165e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101660:	83 ec 08             	sub    $0x8,%esp
80101663:	68 32 83 10 80       	push   $0x80108332
80101668:	53                   	push   %ebx
80101669:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010166f:	e8 9c 31 00 00       	call   80104810 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101674:	83 c4 10             	add    $0x10,%esp
80101677:	81 fb 60 46 11 80    	cmp    $0x80114660,%ebx
8010167d:	75 e1                	jne    80101660 <iinit+0x20>
  readsb(dev, &sb);
8010167f:	83 ec 08             	sub    $0x8,%esp
80101682:	68 e0 29 11 80       	push   $0x801129e0
80101687:	ff 75 08             	pushl  0x8(%ebp)
8010168a:	e8 f1 fe ff ff       	call   80101580 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010168f:	ff 35 f8 29 11 80    	pushl  0x801129f8
80101695:	ff 35 f4 29 11 80    	pushl  0x801129f4
8010169b:	ff 35 f0 29 11 80    	pushl  0x801129f0
801016a1:	ff 35 ec 29 11 80    	pushl  0x801129ec
801016a7:	ff 35 e8 29 11 80    	pushl  0x801129e8
801016ad:	ff 35 e4 29 11 80    	pushl  0x801129e4
801016b3:	ff 35 e0 29 11 80    	pushl  0x801129e0
801016b9:	68 98 83 10 80       	push   $0x80108398
801016be:	e8 2d f0 ff ff       	call   801006f0 <cprintf>
}
801016c3:	83 c4 30             	add    $0x30,%esp
801016c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801016c9:	c9                   	leave  
801016ca:	c3                   	ret    
801016cb:	90                   	nop
801016cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801016d0 <ialloc>:
{
801016d0:	55                   	push   %ebp
801016d1:	89 e5                	mov    %esp,%ebp
801016d3:	57                   	push   %edi
801016d4:	56                   	push   %esi
801016d5:	53                   	push   %ebx
801016d6:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801016d9:	83 3d e8 29 11 80 01 	cmpl   $0x1,0x801129e8
{
801016e0:	8b 45 0c             	mov    0xc(%ebp),%eax
801016e3:	8b 75 08             	mov    0x8(%ebp),%esi
801016e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801016e9:	0f 86 91 00 00 00    	jbe    80101780 <ialloc+0xb0>
801016ef:	bb 01 00 00 00       	mov    $0x1,%ebx
801016f4:	eb 21                	jmp    80101717 <ialloc+0x47>
801016f6:	8d 76 00             	lea    0x0(%esi),%esi
801016f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101700:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101703:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101706:	57                   	push   %edi
80101707:	e8 d4 ea ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010170c:	83 c4 10             	add    $0x10,%esp
8010170f:	39 1d e8 29 11 80    	cmp    %ebx,0x801129e8
80101715:	76 69                	jbe    80101780 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101717:	89 d8                	mov    %ebx,%eax
80101719:	83 ec 08             	sub    $0x8,%esp
8010171c:	c1 e8 03             	shr    $0x3,%eax
8010171f:	03 05 f4 29 11 80    	add    0x801129f4,%eax
80101725:	50                   	push   %eax
80101726:	56                   	push   %esi
80101727:	e8 a4 e9 ff ff       	call   801000d0 <bread>
8010172c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010172e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101730:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
80101733:	83 e0 07             	and    $0x7,%eax
80101736:	c1 e0 06             	shl    $0x6,%eax
80101739:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010173d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101741:	75 bd                	jne    80101700 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101743:	83 ec 04             	sub    $0x4,%esp
80101746:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101749:	6a 40                	push   $0x40
8010174b:	6a 00                	push   $0x0
8010174d:	51                   	push   %ecx
8010174e:	e8 6d 36 00 00       	call   80104dc0 <memset>
      dip->type = type;
80101753:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101757:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010175a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010175d:	89 3c 24             	mov    %edi,(%esp)
80101760:	e8 cb 17 00 00       	call   80102f30 <log_write>
      brelse(bp);
80101765:	89 3c 24             	mov    %edi,(%esp)
80101768:	e8 73 ea ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
8010176d:	83 c4 10             	add    $0x10,%esp
}
80101770:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101773:	89 da                	mov    %ebx,%edx
80101775:	89 f0                	mov    %esi,%eax
}
80101777:	5b                   	pop    %ebx
80101778:	5e                   	pop    %esi
80101779:	5f                   	pop    %edi
8010177a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010177b:	e9 50 fc ff ff       	jmp    801013d0 <iget>
  panic("ialloc: no inodes");
80101780:	83 ec 0c             	sub    $0xc,%esp
80101783:	68 38 83 10 80       	push   $0x80108338
80101788:	e8 03 ec ff ff       	call   80100390 <panic>
8010178d:	8d 76 00             	lea    0x0(%esi),%esi

80101790 <iupdate>:
{
80101790:	55                   	push   %ebp
80101791:	89 e5                	mov    %esp,%ebp
80101793:	56                   	push   %esi
80101794:	53                   	push   %ebx
80101795:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101798:	83 ec 08             	sub    $0x8,%esp
8010179b:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010179e:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017a1:	c1 e8 03             	shr    $0x3,%eax
801017a4:	03 05 f4 29 11 80    	add    0x801129f4,%eax
801017aa:	50                   	push   %eax
801017ab:	ff 73 a4             	pushl  -0x5c(%ebx)
801017ae:	e8 1d e9 ff ff       	call   801000d0 <bread>
801017b3:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801017b5:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
801017b8:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801017bc:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801017bf:	83 e0 07             	and    $0x7,%eax
801017c2:	c1 e0 06             	shl    $0x6,%eax
801017c5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801017c9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801017cc:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801017d0:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801017d3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801017d7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801017db:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801017df:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801017e3:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801017e7:	8b 53 fc             	mov    -0x4(%ebx),%edx
801017ea:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801017ed:	6a 34                	push   $0x34
801017ef:	53                   	push   %ebx
801017f0:	50                   	push   %eax
801017f1:	e8 7a 36 00 00       	call   80104e70 <memmove>
  log_write(bp);
801017f6:	89 34 24             	mov    %esi,(%esp)
801017f9:	e8 32 17 00 00       	call   80102f30 <log_write>
  brelse(bp);
801017fe:	89 75 08             	mov    %esi,0x8(%ebp)
80101801:	83 c4 10             	add    $0x10,%esp
}
80101804:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101807:	5b                   	pop    %ebx
80101808:	5e                   	pop    %esi
80101809:	5d                   	pop    %ebp
  brelse(bp);
8010180a:	e9 d1 e9 ff ff       	jmp    801001e0 <brelse>
8010180f:	90                   	nop

80101810 <idup>:
{
80101810:	55                   	push   %ebp
80101811:	89 e5                	mov    %esp,%ebp
80101813:	53                   	push   %ebx
80101814:	83 ec 10             	sub    $0x10,%esp
80101817:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010181a:	68 00 2a 11 80       	push   $0x80112a00
8010181f:	e8 7c 32 00 00       	call   80104aa0 <acquire>
  ip->ref++;
80101824:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101828:	c7 04 24 00 2a 11 80 	movl   $0x80112a00,(%esp)
8010182f:	e8 2c 33 00 00       	call   80104b60 <release>
}
80101834:	89 d8                	mov    %ebx,%eax
80101836:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101839:	c9                   	leave  
8010183a:	c3                   	ret    
8010183b:	90                   	nop
8010183c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101840 <ilock>:
{
80101840:	55                   	push   %ebp
80101841:	89 e5                	mov    %esp,%ebp
80101843:	56                   	push   %esi
80101844:	53                   	push   %ebx
80101845:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101848:	85 db                	test   %ebx,%ebx
8010184a:	0f 84 b7 00 00 00    	je     80101907 <ilock+0xc7>
80101850:	8b 53 08             	mov    0x8(%ebx),%edx
80101853:	85 d2                	test   %edx,%edx
80101855:	0f 8e ac 00 00 00    	jle    80101907 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010185b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010185e:	83 ec 0c             	sub    $0xc,%esp
80101861:	50                   	push   %eax
80101862:	e8 e9 2f 00 00       	call   80104850 <acquiresleep>
  if(ip->valid == 0){
80101867:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010186a:	83 c4 10             	add    $0x10,%esp
8010186d:	85 c0                	test   %eax,%eax
8010186f:	74 0f                	je     80101880 <ilock+0x40>
}
80101871:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101874:	5b                   	pop    %ebx
80101875:	5e                   	pop    %esi
80101876:	5d                   	pop    %ebp
80101877:	c3                   	ret    
80101878:	90                   	nop
80101879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101880:	8b 43 04             	mov    0x4(%ebx),%eax
80101883:	83 ec 08             	sub    $0x8,%esp
80101886:	c1 e8 03             	shr    $0x3,%eax
80101889:	03 05 f4 29 11 80    	add    0x801129f4,%eax
8010188f:	50                   	push   %eax
80101890:	ff 33                	pushl  (%ebx)
80101892:	e8 39 e8 ff ff       	call   801000d0 <bread>
80101897:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101899:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010189c:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010189f:	83 e0 07             	and    $0x7,%eax
801018a2:	c1 e0 06             	shl    $0x6,%eax
801018a5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801018a9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801018ac:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801018af:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801018b3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801018b7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801018bb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801018bf:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801018c3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801018c7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801018cb:	8b 50 fc             	mov    -0x4(%eax),%edx
801018ce:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801018d1:	6a 34                	push   $0x34
801018d3:	50                   	push   %eax
801018d4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801018d7:	50                   	push   %eax
801018d8:	e8 93 35 00 00       	call   80104e70 <memmove>
    brelse(bp);
801018dd:	89 34 24             	mov    %esi,(%esp)
801018e0:	e8 fb e8 ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
801018e5:	83 c4 10             	add    $0x10,%esp
801018e8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
801018ed:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
801018f4:	0f 85 77 ff ff ff    	jne    80101871 <ilock+0x31>
      panic("ilock: no type");
801018fa:	83 ec 0c             	sub    $0xc,%esp
801018fd:	68 50 83 10 80       	push   $0x80108350
80101902:	e8 89 ea ff ff       	call   80100390 <panic>
    panic("ilock");
80101907:	83 ec 0c             	sub    $0xc,%esp
8010190a:	68 4a 83 10 80       	push   $0x8010834a
8010190f:	e8 7c ea ff ff       	call   80100390 <panic>
80101914:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010191a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101920 <iunlock>:
{
80101920:	55                   	push   %ebp
80101921:	89 e5                	mov    %esp,%ebp
80101923:	56                   	push   %esi
80101924:	53                   	push   %ebx
80101925:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101928:	85 db                	test   %ebx,%ebx
8010192a:	74 28                	je     80101954 <iunlock+0x34>
8010192c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010192f:	83 ec 0c             	sub    $0xc,%esp
80101932:	56                   	push   %esi
80101933:	e8 d8 2f 00 00       	call   80104910 <holdingsleep>
80101938:	83 c4 10             	add    $0x10,%esp
8010193b:	85 c0                	test   %eax,%eax
8010193d:	74 15                	je     80101954 <iunlock+0x34>
8010193f:	8b 43 08             	mov    0x8(%ebx),%eax
80101942:	85 c0                	test   %eax,%eax
80101944:	7e 0e                	jle    80101954 <iunlock+0x34>
  releasesleep(&ip->lock);
80101946:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101949:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010194c:	5b                   	pop    %ebx
8010194d:	5e                   	pop    %esi
8010194e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010194f:	e9 5c 2f 00 00       	jmp    801048b0 <releasesleep>
    panic("iunlock");
80101954:	83 ec 0c             	sub    $0xc,%esp
80101957:	68 5f 83 10 80       	push   $0x8010835f
8010195c:	e8 2f ea ff ff       	call   80100390 <panic>
80101961:	eb 0d                	jmp    80101970 <iput>
80101963:	90                   	nop
80101964:	90                   	nop
80101965:	90                   	nop
80101966:	90                   	nop
80101967:	90                   	nop
80101968:	90                   	nop
80101969:	90                   	nop
8010196a:	90                   	nop
8010196b:	90                   	nop
8010196c:	90                   	nop
8010196d:	90                   	nop
8010196e:	90                   	nop
8010196f:	90                   	nop

80101970 <iput>:
{
80101970:	55                   	push   %ebp
80101971:	89 e5                	mov    %esp,%ebp
80101973:	57                   	push   %edi
80101974:	56                   	push   %esi
80101975:	53                   	push   %ebx
80101976:	83 ec 28             	sub    $0x28,%esp
80101979:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
8010197c:	8d 7b 0c             	lea    0xc(%ebx),%edi
8010197f:	57                   	push   %edi
80101980:	e8 cb 2e 00 00       	call   80104850 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101985:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101988:	83 c4 10             	add    $0x10,%esp
8010198b:	85 d2                	test   %edx,%edx
8010198d:	74 07                	je     80101996 <iput+0x26>
8010198f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101994:	74 32                	je     801019c8 <iput+0x58>
  releasesleep(&ip->lock);
80101996:	83 ec 0c             	sub    $0xc,%esp
80101999:	57                   	push   %edi
8010199a:	e8 11 2f 00 00       	call   801048b0 <releasesleep>
  acquire(&icache.lock);
8010199f:	c7 04 24 00 2a 11 80 	movl   $0x80112a00,(%esp)
801019a6:	e8 f5 30 00 00       	call   80104aa0 <acquire>
  ip->ref--;
801019ab:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801019af:	83 c4 10             	add    $0x10,%esp
801019b2:	c7 45 08 00 2a 11 80 	movl   $0x80112a00,0x8(%ebp)
}
801019b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019bc:	5b                   	pop    %ebx
801019bd:	5e                   	pop    %esi
801019be:	5f                   	pop    %edi
801019bf:	5d                   	pop    %ebp
  release(&icache.lock);
801019c0:	e9 9b 31 00 00       	jmp    80104b60 <release>
801019c5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
801019c8:	83 ec 0c             	sub    $0xc,%esp
801019cb:	68 00 2a 11 80       	push   $0x80112a00
801019d0:	e8 cb 30 00 00       	call   80104aa0 <acquire>
    int r = ip->ref;
801019d5:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
801019d8:	c7 04 24 00 2a 11 80 	movl   $0x80112a00,(%esp)
801019df:	e8 7c 31 00 00       	call   80104b60 <release>
    if(r == 1){
801019e4:	83 c4 10             	add    $0x10,%esp
801019e7:	83 fe 01             	cmp    $0x1,%esi
801019ea:	75 aa                	jne    80101996 <iput+0x26>
801019ec:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
801019f2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801019f5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801019f8:	89 cf                	mov    %ecx,%edi
801019fa:	eb 0b                	jmp    80101a07 <iput+0x97>
801019fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a00:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101a03:	39 fe                	cmp    %edi,%esi
80101a05:	74 19                	je     80101a20 <iput+0xb0>
    if(ip->addrs[i]){
80101a07:	8b 16                	mov    (%esi),%edx
80101a09:	85 d2                	test   %edx,%edx
80101a0b:	74 f3                	je     80101a00 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80101a0d:	8b 03                	mov    (%ebx),%eax
80101a0f:	e8 ac fb ff ff       	call   801015c0 <bfree>
      ip->addrs[i] = 0;
80101a14:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101a1a:	eb e4                	jmp    80101a00 <iput+0x90>
80101a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101a20:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101a26:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101a29:	85 c0                	test   %eax,%eax
80101a2b:	75 33                	jne    80101a60 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101a2d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101a30:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101a37:	53                   	push   %ebx
80101a38:	e8 53 fd ff ff       	call   80101790 <iupdate>
      ip->type = 0;
80101a3d:	31 c0                	xor    %eax,%eax
80101a3f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101a43:	89 1c 24             	mov    %ebx,(%esp)
80101a46:	e8 45 fd ff ff       	call   80101790 <iupdate>
      ip->valid = 0;
80101a4b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101a52:	83 c4 10             	add    $0x10,%esp
80101a55:	e9 3c ff ff ff       	jmp    80101996 <iput+0x26>
80101a5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101a60:	83 ec 08             	sub    $0x8,%esp
80101a63:	50                   	push   %eax
80101a64:	ff 33                	pushl  (%ebx)
80101a66:	e8 65 e6 ff ff       	call   801000d0 <bread>
80101a6b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101a71:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101a74:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101a77:	8d 70 5c             	lea    0x5c(%eax),%esi
80101a7a:	83 c4 10             	add    $0x10,%esp
80101a7d:	89 cf                	mov    %ecx,%edi
80101a7f:	eb 0e                	jmp    80101a8f <iput+0x11f>
80101a81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a88:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
80101a8b:	39 fe                	cmp    %edi,%esi
80101a8d:	74 0f                	je     80101a9e <iput+0x12e>
      if(a[j])
80101a8f:	8b 16                	mov    (%esi),%edx
80101a91:	85 d2                	test   %edx,%edx
80101a93:	74 f3                	je     80101a88 <iput+0x118>
        bfree(ip->dev, a[j]);
80101a95:	8b 03                	mov    (%ebx),%eax
80101a97:	e8 24 fb ff ff       	call   801015c0 <bfree>
80101a9c:	eb ea                	jmp    80101a88 <iput+0x118>
    brelse(bp);
80101a9e:	83 ec 0c             	sub    $0xc,%esp
80101aa1:	ff 75 e4             	pushl  -0x1c(%ebp)
80101aa4:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101aa7:	e8 34 e7 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101aac:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101ab2:	8b 03                	mov    (%ebx),%eax
80101ab4:	e8 07 fb ff ff       	call   801015c0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101ab9:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101ac0:	00 00 00 
80101ac3:	83 c4 10             	add    $0x10,%esp
80101ac6:	e9 62 ff ff ff       	jmp    80101a2d <iput+0xbd>
80101acb:	90                   	nop
80101acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101ad0 <iunlockput>:
{
80101ad0:	55                   	push   %ebp
80101ad1:	89 e5                	mov    %esp,%ebp
80101ad3:	53                   	push   %ebx
80101ad4:	83 ec 10             	sub    $0x10,%esp
80101ad7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101ada:	53                   	push   %ebx
80101adb:	e8 40 fe ff ff       	call   80101920 <iunlock>
  iput(ip);
80101ae0:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101ae3:	83 c4 10             	add    $0x10,%esp
}
80101ae6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101ae9:	c9                   	leave  
  iput(ip);
80101aea:	e9 81 fe ff ff       	jmp    80101970 <iput>
80101aef:	90                   	nop

80101af0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101af0:	55                   	push   %ebp
80101af1:	89 e5                	mov    %esp,%ebp
80101af3:	8b 55 08             	mov    0x8(%ebp),%edx
80101af6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101af9:	8b 0a                	mov    (%edx),%ecx
80101afb:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101afe:	8b 4a 04             	mov    0x4(%edx),%ecx
80101b01:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101b04:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101b08:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101b0b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101b0f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101b13:	8b 52 58             	mov    0x58(%edx),%edx
80101b16:	89 50 10             	mov    %edx,0x10(%eax)
}
80101b19:	5d                   	pop    %ebp
80101b1a:	c3                   	ret    
80101b1b:	90                   	nop
80101b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101b20 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101b20:	55                   	push   %ebp
80101b21:	89 e5                	mov    %esp,%ebp
80101b23:	57                   	push   %edi
80101b24:	56                   	push   %esi
80101b25:	53                   	push   %ebx
80101b26:	83 ec 1c             	sub    $0x1c,%esp
80101b29:	8b 45 08             	mov    0x8(%ebp),%eax
80101b2c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b2f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b32:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101b37:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101b3a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b3d:	8b 75 10             	mov    0x10(%ebp),%esi
80101b40:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101b43:	0f 84 a7 00 00 00    	je     80101bf0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101b49:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b4c:	8b 40 58             	mov    0x58(%eax),%eax
80101b4f:	39 c6                	cmp    %eax,%esi
80101b51:	0f 87 ba 00 00 00    	ja     80101c11 <readi+0xf1>
80101b57:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101b5a:	89 f9                	mov    %edi,%ecx
80101b5c:	01 f1                	add    %esi,%ecx
80101b5e:	0f 82 ad 00 00 00    	jb     80101c11 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101b64:	89 c2                	mov    %eax,%edx
80101b66:	29 f2                	sub    %esi,%edx
80101b68:	39 c8                	cmp    %ecx,%eax
80101b6a:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b6d:	31 ff                	xor    %edi,%edi
80101b6f:	85 d2                	test   %edx,%edx
    n = ip->size - off;
80101b71:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b74:	74 6c                	je     80101be2 <readi+0xc2>
80101b76:	8d 76 00             	lea    0x0(%esi),%esi
80101b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b80:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101b83:	89 f2                	mov    %esi,%edx
80101b85:	c1 ea 09             	shr    $0x9,%edx
80101b88:	89 d8                	mov    %ebx,%eax
80101b8a:	e8 11 f9 ff ff       	call   801014a0 <bmap>
80101b8f:	83 ec 08             	sub    $0x8,%esp
80101b92:	50                   	push   %eax
80101b93:	ff 33                	pushl  (%ebx)
80101b95:	e8 36 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b9a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b9d:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b9f:	89 f0                	mov    %esi,%eax
80101ba1:	25 ff 01 00 00       	and    $0x1ff,%eax
80101ba6:	b9 00 02 00 00       	mov    $0x200,%ecx
80101bab:	83 c4 0c             	add    $0xc,%esp
80101bae:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101bb0:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101bb4:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101bb7:	29 fb                	sub    %edi,%ebx
80101bb9:	39 d9                	cmp    %ebx,%ecx
80101bbb:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101bbe:	53                   	push   %ebx
80101bbf:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101bc0:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101bc2:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101bc5:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101bc7:	e8 a4 32 00 00       	call   80104e70 <memmove>
    brelse(bp);
80101bcc:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101bcf:	89 14 24             	mov    %edx,(%esp)
80101bd2:	e8 09 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101bd7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101bda:	83 c4 10             	add    $0x10,%esp
80101bdd:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101be0:	77 9e                	ja     80101b80 <readi+0x60>
  }
  return n;
80101be2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101be5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101be8:	5b                   	pop    %ebx
80101be9:	5e                   	pop    %esi
80101bea:	5f                   	pop    %edi
80101beb:	5d                   	pop    %ebp
80101bec:	c3                   	ret    
80101bed:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101bf0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101bf4:	66 83 f8 09          	cmp    $0x9,%ax
80101bf8:	77 17                	ja     80101c11 <readi+0xf1>
80101bfa:	8b 04 c5 80 29 11 80 	mov    -0x7feed680(,%eax,8),%eax
80101c01:	85 c0                	test   %eax,%eax
80101c03:	74 0c                	je     80101c11 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101c05:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101c08:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c0b:	5b                   	pop    %ebx
80101c0c:	5e                   	pop    %esi
80101c0d:	5f                   	pop    %edi
80101c0e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101c0f:	ff e0                	jmp    *%eax
      return -1;
80101c11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c16:	eb cd                	jmp    80101be5 <readi+0xc5>
80101c18:	90                   	nop
80101c19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101c20 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101c20:	55                   	push   %ebp
80101c21:	89 e5                	mov    %esp,%ebp
80101c23:	57                   	push   %edi
80101c24:	56                   	push   %esi
80101c25:	53                   	push   %ebx
80101c26:	83 ec 1c             	sub    $0x1c,%esp
80101c29:	8b 45 08             	mov    0x8(%ebp),%eax
80101c2c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101c2f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101c32:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101c37:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101c3a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101c3d:	8b 75 10             	mov    0x10(%ebp),%esi
80101c40:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101c43:	0f 84 b7 00 00 00    	je     80101d00 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101c49:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c4c:	39 70 58             	cmp    %esi,0x58(%eax)
80101c4f:	0f 82 eb 00 00 00    	jb     80101d40 <writei+0x120>
80101c55:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101c58:	31 d2                	xor    %edx,%edx
80101c5a:	89 f8                	mov    %edi,%eax
80101c5c:	01 f0                	add    %esi,%eax
80101c5e:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101c61:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101c66:	0f 87 d4 00 00 00    	ja     80101d40 <writei+0x120>
80101c6c:	85 d2                	test   %edx,%edx
80101c6e:	0f 85 cc 00 00 00    	jne    80101d40 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c74:	85 ff                	test   %edi,%edi
80101c76:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101c7d:	74 72                	je     80101cf1 <writei+0xd1>
80101c7f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c80:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101c83:	89 f2                	mov    %esi,%edx
80101c85:	c1 ea 09             	shr    $0x9,%edx
80101c88:	89 f8                	mov    %edi,%eax
80101c8a:	e8 11 f8 ff ff       	call   801014a0 <bmap>
80101c8f:	83 ec 08             	sub    $0x8,%esp
80101c92:	50                   	push   %eax
80101c93:	ff 37                	pushl  (%edi)
80101c95:	e8 36 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c9a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c9d:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ca0:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101ca2:	89 f0                	mov    %esi,%eax
80101ca4:	b9 00 02 00 00       	mov    $0x200,%ecx
80101ca9:	83 c4 0c             	add    $0xc,%esp
80101cac:	25 ff 01 00 00       	and    $0x1ff,%eax
80101cb1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101cb3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101cb7:	39 d9                	cmp    %ebx,%ecx
80101cb9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101cbc:	53                   	push   %ebx
80101cbd:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101cc0:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101cc2:	50                   	push   %eax
80101cc3:	e8 a8 31 00 00       	call   80104e70 <memmove>
    log_write(bp);
80101cc8:	89 3c 24             	mov    %edi,(%esp)
80101ccb:	e8 60 12 00 00       	call   80102f30 <log_write>
    brelse(bp);
80101cd0:	89 3c 24             	mov    %edi,(%esp)
80101cd3:	e8 08 e5 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101cd8:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101cdb:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101cde:	83 c4 10             	add    $0x10,%esp
80101ce1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101ce4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101ce7:	77 97                	ja     80101c80 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101ce9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101cec:	3b 70 58             	cmp    0x58(%eax),%esi
80101cef:	77 37                	ja     80101d28 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101cf1:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101cf4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cf7:	5b                   	pop    %ebx
80101cf8:	5e                   	pop    %esi
80101cf9:	5f                   	pop    %edi
80101cfa:	5d                   	pop    %ebp
80101cfb:	c3                   	ret    
80101cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101d00:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101d04:	66 83 f8 09          	cmp    $0x9,%ax
80101d08:	77 36                	ja     80101d40 <writei+0x120>
80101d0a:	8b 04 c5 84 29 11 80 	mov    -0x7feed67c(,%eax,8),%eax
80101d11:	85 c0                	test   %eax,%eax
80101d13:	74 2b                	je     80101d40 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101d15:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101d18:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d1b:	5b                   	pop    %ebx
80101d1c:	5e                   	pop    %esi
80101d1d:	5f                   	pop    %edi
80101d1e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101d1f:	ff e0                	jmp    *%eax
80101d21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101d28:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101d2b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101d2e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101d31:	50                   	push   %eax
80101d32:	e8 59 fa ff ff       	call   80101790 <iupdate>
80101d37:	83 c4 10             	add    $0x10,%esp
80101d3a:	eb b5                	jmp    80101cf1 <writei+0xd1>
80101d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101d40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101d45:	eb ad                	jmp    80101cf4 <writei+0xd4>
80101d47:	89 f6                	mov    %esi,%esi
80101d49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101d50 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101d50:	55                   	push   %ebp
80101d51:	89 e5                	mov    %esp,%ebp
80101d53:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101d56:	6a 0e                	push   $0xe
80101d58:	ff 75 0c             	pushl  0xc(%ebp)
80101d5b:	ff 75 08             	pushl  0x8(%ebp)
80101d5e:	e8 7d 31 00 00       	call   80104ee0 <strncmp>
}
80101d63:	c9                   	leave  
80101d64:	c3                   	ret    
80101d65:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101d70 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101d70:	55                   	push   %ebp
80101d71:	89 e5                	mov    %esp,%ebp
80101d73:	57                   	push   %edi
80101d74:	56                   	push   %esi
80101d75:	53                   	push   %ebx
80101d76:	83 ec 1c             	sub    $0x1c,%esp
80101d79:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101d7c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101d81:	0f 85 85 00 00 00    	jne    80101e0c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101d87:	8b 53 58             	mov    0x58(%ebx),%edx
80101d8a:	31 ff                	xor    %edi,%edi
80101d8c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101d8f:	85 d2                	test   %edx,%edx
80101d91:	74 3e                	je     80101dd1 <dirlookup+0x61>
80101d93:	90                   	nop
80101d94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d98:	6a 10                	push   $0x10
80101d9a:	57                   	push   %edi
80101d9b:	56                   	push   %esi
80101d9c:	53                   	push   %ebx
80101d9d:	e8 7e fd ff ff       	call   80101b20 <readi>
80101da2:	83 c4 10             	add    $0x10,%esp
80101da5:	83 f8 10             	cmp    $0x10,%eax
80101da8:	75 55                	jne    80101dff <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101daa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101daf:	74 18                	je     80101dc9 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101db1:	8d 45 da             	lea    -0x26(%ebp),%eax
80101db4:	83 ec 04             	sub    $0x4,%esp
80101db7:	6a 0e                	push   $0xe
80101db9:	50                   	push   %eax
80101dba:	ff 75 0c             	pushl  0xc(%ebp)
80101dbd:	e8 1e 31 00 00       	call   80104ee0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101dc2:	83 c4 10             	add    $0x10,%esp
80101dc5:	85 c0                	test   %eax,%eax
80101dc7:	74 17                	je     80101de0 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101dc9:	83 c7 10             	add    $0x10,%edi
80101dcc:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101dcf:	72 c7                	jb     80101d98 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101dd1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101dd4:	31 c0                	xor    %eax,%eax
}
80101dd6:	5b                   	pop    %ebx
80101dd7:	5e                   	pop    %esi
80101dd8:	5f                   	pop    %edi
80101dd9:	5d                   	pop    %ebp
80101dda:	c3                   	ret    
80101ddb:	90                   	nop
80101ddc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101de0:	8b 45 10             	mov    0x10(%ebp),%eax
80101de3:	85 c0                	test   %eax,%eax
80101de5:	74 05                	je     80101dec <dirlookup+0x7c>
        *poff = off;
80101de7:	8b 45 10             	mov    0x10(%ebp),%eax
80101dea:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101dec:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101df0:	8b 03                	mov    (%ebx),%eax
80101df2:	e8 d9 f5 ff ff       	call   801013d0 <iget>
}
80101df7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dfa:	5b                   	pop    %ebx
80101dfb:	5e                   	pop    %esi
80101dfc:	5f                   	pop    %edi
80101dfd:	5d                   	pop    %ebp
80101dfe:	c3                   	ret    
      panic("dirlookup read");
80101dff:	83 ec 0c             	sub    $0xc,%esp
80101e02:	68 79 83 10 80       	push   $0x80108379
80101e07:	e8 84 e5 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101e0c:	83 ec 0c             	sub    $0xc,%esp
80101e0f:	68 67 83 10 80       	push   $0x80108367
80101e14:	e8 77 e5 ff ff       	call   80100390 <panic>
80101e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101e20 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101e20:	55                   	push   %ebp
80101e21:	89 e5                	mov    %esp,%ebp
80101e23:	57                   	push   %edi
80101e24:	56                   	push   %esi
80101e25:	53                   	push   %ebx
80101e26:	89 cf                	mov    %ecx,%edi
80101e28:	89 c3                	mov    %eax,%ebx
80101e2a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101e2d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101e30:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101e33:	0f 84 67 01 00 00    	je     80101fa0 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101e39:	e8 82 1b 00 00       	call   801039c0 <myproc>
  acquire(&icache.lock);
80101e3e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101e41:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101e44:	68 00 2a 11 80       	push   $0x80112a00
80101e49:	e8 52 2c 00 00       	call   80104aa0 <acquire>
  ip->ref++;
80101e4e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101e52:	c7 04 24 00 2a 11 80 	movl   $0x80112a00,(%esp)
80101e59:	e8 02 2d 00 00       	call   80104b60 <release>
80101e5e:	83 c4 10             	add    $0x10,%esp
80101e61:	eb 08                	jmp    80101e6b <namex+0x4b>
80101e63:	90                   	nop
80101e64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e68:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e6b:	0f b6 03             	movzbl (%ebx),%eax
80101e6e:	3c 2f                	cmp    $0x2f,%al
80101e70:	74 f6                	je     80101e68 <namex+0x48>
  if(*path == 0)
80101e72:	84 c0                	test   %al,%al
80101e74:	0f 84 ee 00 00 00    	je     80101f68 <namex+0x148>
  while(*path != '/' && *path != 0)
80101e7a:	0f b6 03             	movzbl (%ebx),%eax
80101e7d:	3c 2f                	cmp    $0x2f,%al
80101e7f:	0f 84 b3 00 00 00    	je     80101f38 <namex+0x118>
80101e85:	84 c0                	test   %al,%al
80101e87:	89 da                	mov    %ebx,%edx
80101e89:	75 09                	jne    80101e94 <namex+0x74>
80101e8b:	e9 a8 00 00 00       	jmp    80101f38 <namex+0x118>
80101e90:	84 c0                	test   %al,%al
80101e92:	74 0a                	je     80101e9e <namex+0x7e>
    path++;
80101e94:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101e97:	0f b6 02             	movzbl (%edx),%eax
80101e9a:	3c 2f                	cmp    $0x2f,%al
80101e9c:	75 f2                	jne    80101e90 <namex+0x70>
80101e9e:	89 d1                	mov    %edx,%ecx
80101ea0:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101ea2:	83 f9 0d             	cmp    $0xd,%ecx
80101ea5:	0f 8e 91 00 00 00    	jle    80101f3c <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101eab:	83 ec 04             	sub    $0x4,%esp
80101eae:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101eb1:	6a 0e                	push   $0xe
80101eb3:	53                   	push   %ebx
80101eb4:	57                   	push   %edi
80101eb5:	e8 b6 2f 00 00       	call   80104e70 <memmove>
    path++;
80101eba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101ebd:	83 c4 10             	add    $0x10,%esp
    path++;
80101ec0:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101ec2:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101ec5:	75 11                	jne    80101ed8 <namex+0xb8>
80101ec7:	89 f6                	mov    %esi,%esi
80101ec9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101ed0:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101ed3:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101ed6:	74 f8                	je     80101ed0 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101ed8:	83 ec 0c             	sub    $0xc,%esp
80101edb:	56                   	push   %esi
80101edc:	e8 5f f9 ff ff       	call   80101840 <ilock>
    if(ip->type != T_DIR){
80101ee1:	83 c4 10             	add    $0x10,%esp
80101ee4:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101ee9:	0f 85 91 00 00 00    	jne    80101f80 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101eef:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101ef2:	85 d2                	test   %edx,%edx
80101ef4:	74 09                	je     80101eff <namex+0xdf>
80101ef6:	80 3b 00             	cmpb   $0x0,(%ebx)
80101ef9:	0f 84 b7 00 00 00    	je     80101fb6 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101eff:	83 ec 04             	sub    $0x4,%esp
80101f02:	6a 00                	push   $0x0
80101f04:	57                   	push   %edi
80101f05:	56                   	push   %esi
80101f06:	e8 65 fe ff ff       	call   80101d70 <dirlookup>
80101f0b:	83 c4 10             	add    $0x10,%esp
80101f0e:	85 c0                	test   %eax,%eax
80101f10:	74 6e                	je     80101f80 <namex+0x160>
  iunlock(ip);
80101f12:	83 ec 0c             	sub    $0xc,%esp
80101f15:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101f18:	56                   	push   %esi
80101f19:	e8 02 fa ff ff       	call   80101920 <iunlock>
  iput(ip);
80101f1e:	89 34 24             	mov    %esi,(%esp)
80101f21:	e8 4a fa ff ff       	call   80101970 <iput>
80101f26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101f29:	83 c4 10             	add    $0x10,%esp
80101f2c:	89 c6                	mov    %eax,%esi
80101f2e:	e9 38 ff ff ff       	jmp    80101e6b <namex+0x4b>
80101f33:	90                   	nop
80101f34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80101f38:	89 da                	mov    %ebx,%edx
80101f3a:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101f3c:	83 ec 04             	sub    $0x4,%esp
80101f3f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101f42:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101f45:	51                   	push   %ecx
80101f46:	53                   	push   %ebx
80101f47:	57                   	push   %edi
80101f48:	e8 23 2f 00 00       	call   80104e70 <memmove>
    name[len] = 0;
80101f4d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101f50:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101f53:	83 c4 10             	add    $0x10,%esp
80101f56:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101f5a:	89 d3                	mov    %edx,%ebx
80101f5c:	e9 61 ff ff ff       	jmp    80101ec2 <namex+0xa2>
80101f61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101f68:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101f6b:	85 c0                	test   %eax,%eax
80101f6d:	75 5d                	jne    80101fcc <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
80101f6f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f72:	89 f0                	mov    %esi,%eax
80101f74:	5b                   	pop    %ebx
80101f75:	5e                   	pop    %esi
80101f76:	5f                   	pop    %edi
80101f77:	5d                   	pop    %ebp
80101f78:	c3                   	ret    
80101f79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101f80:	83 ec 0c             	sub    $0xc,%esp
80101f83:	56                   	push   %esi
80101f84:	e8 97 f9 ff ff       	call   80101920 <iunlock>
  iput(ip);
80101f89:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f8c:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f8e:	e8 dd f9 ff ff       	call   80101970 <iput>
      return 0;
80101f93:	83 c4 10             	add    $0x10,%esp
}
80101f96:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f99:	89 f0                	mov    %esi,%eax
80101f9b:	5b                   	pop    %ebx
80101f9c:	5e                   	pop    %esi
80101f9d:	5f                   	pop    %edi
80101f9e:	5d                   	pop    %ebp
80101f9f:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101fa0:	ba 01 00 00 00       	mov    $0x1,%edx
80101fa5:	b8 01 00 00 00       	mov    $0x1,%eax
80101faa:	e8 21 f4 ff ff       	call   801013d0 <iget>
80101faf:	89 c6                	mov    %eax,%esi
80101fb1:	e9 b5 fe ff ff       	jmp    80101e6b <namex+0x4b>
      iunlock(ip);
80101fb6:	83 ec 0c             	sub    $0xc,%esp
80101fb9:	56                   	push   %esi
80101fba:	e8 61 f9 ff ff       	call   80101920 <iunlock>
      return ip;
80101fbf:	83 c4 10             	add    $0x10,%esp
}
80101fc2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fc5:	89 f0                	mov    %esi,%eax
80101fc7:	5b                   	pop    %ebx
80101fc8:	5e                   	pop    %esi
80101fc9:	5f                   	pop    %edi
80101fca:	5d                   	pop    %ebp
80101fcb:	c3                   	ret    
    iput(ip);
80101fcc:	83 ec 0c             	sub    $0xc,%esp
80101fcf:	56                   	push   %esi
    return 0;
80101fd0:	31 f6                	xor    %esi,%esi
    iput(ip);
80101fd2:	e8 99 f9 ff ff       	call   80101970 <iput>
    return 0;
80101fd7:	83 c4 10             	add    $0x10,%esp
80101fda:	eb 93                	jmp    80101f6f <namex+0x14f>
80101fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101fe0 <dirlink>:
{
80101fe0:	55                   	push   %ebp
80101fe1:	89 e5                	mov    %esp,%ebp
80101fe3:	57                   	push   %edi
80101fe4:	56                   	push   %esi
80101fe5:	53                   	push   %ebx
80101fe6:	83 ec 20             	sub    $0x20,%esp
80101fe9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101fec:	6a 00                	push   $0x0
80101fee:	ff 75 0c             	pushl  0xc(%ebp)
80101ff1:	53                   	push   %ebx
80101ff2:	e8 79 fd ff ff       	call   80101d70 <dirlookup>
80101ff7:	83 c4 10             	add    $0x10,%esp
80101ffa:	85 c0                	test   %eax,%eax
80101ffc:	75 67                	jne    80102065 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101ffe:	8b 7b 58             	mov    0x58(%ebx),%edi
80102001:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102004:	85 ff                	test   %edi,%edi
80102006:	74 29                	je     80102031 <dirlink+0x51>
80102008:	31 ff                	xor    %edi,%edi
8010200a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010200d:	eb 09                	jmp    80102018 <dirlink+0x38>
8010200f:	90                   	nop
80102010:	83 c7 10             	add    $0x10,%edi
80102013:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102016:	73 19                	jae    80102031 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102018:	6a 10                	push   $0x10
8010201a:	57                   	push   %edi
8010201b:	56                   	push   %esi
8010201c:	53                   	push   %ebx
8010201d:	e8 fe fa ff ff       	call   80101b20 <readi>
80102022:	83 c4 10             	add    $0x10,%esp
80102025:	83 f8 10             	cmp    $0x10,%eax
80102028:	75 4e                	jne    80102078 <dirlink+0x98>
    if(de.inum == 0)
8010202a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010202f:	75 df                	jne    80102010 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102031:	8d 45 da             	lea    -0x26(%ebp),%eax
80102034:	83 ec 04             	sub    $0x4,%esp
80102037:	6a 0e                	push   $0xe
80102039:	ff 75 0c             	pushl  0xc(%ebp)
8010203c:	50                   	push   %eax
8010203d:	e8 fe 2e 00 00       	call   80104f40 <strncpy>
  de.inum = inum;
80102042:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102045:	6a 10                	push   $0x10
80102047:	57                   	push   %edi
80102048:	56                   	push   %esi
80102049:	53                   	push   %ebx
  de.inum = inum;
8010204a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010204e:	e8 cd fb ff ff       	call   80101c20 <writei>
80102053:	83 c4 20             	add    $0x20,%esp
80102056:	83 f8 10             	cmp    $0x10,%eax
80102059:	75 2a                	jne    80102085 <dirlink+0xa5>
  return 0;
8010205b:	31 c0                	xor    %eax,%eax
}
8010205d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102060:	5b                   	pop    %ebx
80102061:	5e                   	pop    %esi
80102062:	5f                   	pop    %edi
80102063:	5d                   	pop    %ebp
80102064:	c3                   	ret    
    iput(ip);
80102065:	83 ec 0c             	sub    $0xc,%esp
80102068:	50                   	push   %eax
80102069:	e8 02 f9 ff ff       	call   80101970 <iput>
    return -1;
8010206e:	83 c4 10             	add    $0x10,%esp
80102071:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102076:	eb e5                	jmp    8010205d <dirlink+0x7d>
      panic("dirlink read");
80102078:	83 ec 0c             	sub    $0xc,%esp
8010207b:	68 88 83 10 80       	push   $0x80108388
80102080:	e8 0b e3 ff ff       	call   80100390 <panic>
    panic("dirlink");
80102085:	83 ec 0c             	sub    $0xc,%esp
80102088:	68 1a 8e 10 80       	push   $0x80108e1a
8010208d:	e8 fe e2 ff ff       	call   80100390 <panic>
80102092:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102099:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801020a0 <namei>:

struct inode*
namei(char *path)
{
801020a0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801020a1:	31 d2                	xor    %edx,%edx
{
801020a3:	89 e5                	mov    %esp,%ebp
801020a5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801020a8:	8b 45 08             	mov    0x8(%ebp),%eax
801020ab:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801020ae:	e8 6d fd ff ff       	call   80101e20 <namex>
}
801020b3:	c9                   	leave  
801020b4:	c3                   	ret    
801020b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801020b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801020c0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801020c0:	55                   	push   %ebp
  return namex(path, 1, name);
801020c1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801020c6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801020c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801020cb:	8b 45 08             	mov    0x8(%ebp),%eax
}
801020ce:	5d                   	pop    %ebp
  return namex(path, 1, name);
801020cf:	e9 4c fd ff ff       	jmp    80101e20 <namex>
801020d4:	66 90                	xchg   %ax,%ax
801020d6:	66 90                	xchg   %ax,%ax
801020d8:	66 90                	xchg   %ax,%ax
801020da:	66 90                	xchg   %ax,%ax
801020dc:	66 90                	xchg   %ax,%ax
801020de:	66 90                	xchg   %ax,%ax

801020e0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801020e0:	55                   	push   %ebp
801020e1:	89 e5                	mov    %esp,%ebp
801020e3:	57                   	push   %edi
801020e4:	56                   	push   %esi
801020e5:	53                   	push   %ebx
801020e6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801020e9:	85 c0                	test   %eax,%eax
801020eb:	0f 84 b4 00 00 00    	je     801021a5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801020f1:	8b 58 08             	mov    0x8(%eax),%ebx
801020f4:	89 c6                	mov    %eax,%esi
801020f6:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
801020fc:	0f 87 96 00 00 00    	ja     80102198 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102102:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102107:	89 f6                	mov    %esi,%esi
80102109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102110:	89 ca                	mov    %ecx,%edx
80102112:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102113:	83 e0 c0             	and    $0xffffffc0,%eax
80102116:	3c 40                	cmp    $0x40,%al
80102118:	75 f6                	jne    80102110 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010211a:	31 ff                	xor    %edi,%edi
8010211c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102121:	89 f8                	mov    %edi,%eax
80102123:	ee                   	out    %al,(%dx)
80102124:	b8 01 00 00 00       	mov    $0x1,%eax
80102129:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010212e:	ee                   	out    %al,(%dx)
8010212f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102134:	89 d8                	mov    %ebx,%eax
80102136:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102137:	89 d8                	mov    %ebx,%eax
80102139:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010213e:	c1 f8 08             	sar    $0x8,%eax
80102141:	ee                   	out    %al,(%dx)
80102142:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102147:	89 f8                	mov    %edi,%eax
80102149:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010214a:	0f b6 46 04          	movzbl 0x4(%esi),%eax
8010214e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102153:	c1 e0 04             	shl    $0x4,%eax
80102156:	83 e0 10             	and    $0x10,%eax
80102159:	83 c8 e0             	or     $0xffffffe0,%eax
8010215c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010215d:	f6 06 04             	testb  $0x4,(%esi)
80102160:	75 16                	jne    80102178 <idestart+0x98>
80102162:	b8 20 00 00 00       	mov    $0x20,%eax
80102167:	89 ca                	mov    %ecx,%edx
80102169:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010216a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010216d:	5b                   	pop    %ebx
8010216e:	5e                   	pop    %esi
8010216f:	5f                   	pop    %edi
80102170:	5d                   	pop    %ebp
80102171:	c3                   	ret    
80102172:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102178:	b8 30 00 00 00       	mov    $0x30,%eax
8010217d:	89 ca                	mov    %ecx,%edx
8010217f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102180:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102185:	83 c6 5c             	add    $0x5c,%esi
80102188:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010218d:	fc                   	cld    
8010218e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102190:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102193:	5b                   	pop    %ebx
80102194:	5e                   	pop    %esi
80102195:	5f                   	pop    %edi
80102196:	5d                   	pop    %ebp
80102197:	c3                   	ret    
    panic("incorrect blockno");
80102198:	83 ec 0c             	sub    $0xc,%esp
8010219b:	68 f4 83 10 80       	push   $0x801083f4
801021a0:	e8 eb e1 ff ff       	call   80100390 <panic>
    panic("idestart");
801021a5:	83 ec 0c             	sub    $0xc,%esp
801021a8:	68 eb 83 10 80       	push   $0x801083eb
801021ad:	e8 de e1 ff ff       	call   80100390 <panic>
801021b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801021c0 <ideinit>:
{
801021c0:	55                   	push   %ebp
801021c1:	89 e5                	mov    %esp,%ebp
801021c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021c6:	68 06 84 10 80       	push   $0x80108406
801021cb:	68 80 c5 10 80       	push   $0x8010c580
801021d0:	e8 8b 27 00 00       	call   80104960 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801021d5:	58                   	pop    %eax
801021d6:	a1 20 4d 11 80       	mov    0x80114d20,%eax
801021db:	5a                   	pop    %edx
801021dc:	83 e8 01             	sub    $0x1,%eax
801021df:	50                   	push   %eax
801021e0:	6a 0e                	push   $0xe
801021e2:	e8 a9 02 00 00       	call   80102490 <ioapicenable>
801021e7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021ea:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021ef:	90                   	nop
801021f0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021f1:	83 e0 c0             	and    $0xffffffc0,%eax
801021f4:	3c 40                	cmp    $0x40,%al
801021f6:	75 f8                	jne    801021f0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021f8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801021fd:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102202:	ee                   	out    %al,(%dx)
80102203:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102208:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010220d:	eb 06                	jmp    80102215 <ideinit+0x55>
8010220f:	90                   	nop
  for(i=0; i<1000; i++){
80102210:	83 e9 01             	sub    $0x1,%ecx
80102213:	74 0f                	je     80102224 <ideinit+0x64>
80102215:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102216:	84 c0                	test   %al,%al
80102218:	74 f6                	je     80102210 <ideinit+0x50>
      havedisk1 = 1;
8010221a:	c7 05 60 c5 10 80 01 	movl   $0x1,0x8010c560
80102221:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102224:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102229:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010222e:	ee                   	out    %al,(%dx)
}
8010222f:	c9                   	leave  
80102230:	c3                   	ret    
80102231:	eb 0d                	jmp    80102240 <ideintr>
80102233:	90                   	nop
80102234:	90                   	nop
80102235:	90                   	nop
80102236:	90                   	nop
80102237:	90                   	nop
80102238:	90                   	nop
80102239:	90                   	nop
8010223a:	90                   	nop
8010223b:	90                   	nop
8010223c:	90                   	nop
8010223d:	90                   	nop
8010223e:	90                   	nop
8010223f:	90                   	nop

80102240 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102240:	55                   	push   %ebp
80102241:	89 e5                	mov    %esp,%ebp
80102243:	57                   	push   %edi
80102244:	56                   	push   %esi
80102245:	53                   	push   %ebx
80102246:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102249:	68 80 c5 10 80       	push   $0x8010c580
8010224e:	e8 4d 28 00 00       	call   80104aa0 <acquire>

  if((b = idequeue) == 0){
80102253:	8b 1d 64 c5 10 80    	mov    0x8010c564,%ebx
80102259:	83 c4 10             	add    $0x10,%esp
8010225c:	85 db                	test   %ebx,%ebx
8010225e:	74 67                	je     801022c7 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102260:	8b 43 58             	mov    0x58(%ebx),%eax
80102263:	a3 64 c5 10 80       	mov    %eax,0x8010c564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102268:	8b 3b                	mov    (%ebx),%edi
8010226a:	f7 c7 04 00 00 00    	test   $0x4,%edi
80102270:	75 31                	jne    801022a3 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102272:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102277:	89 f6                	mov    %esi,%esi
80102279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102280:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102281:	89 c6                	mov    %eax,%esi
80102283:	83 e6 c0             	and    $0xffffffc0,%esi
80102286:	89 f1                	mov    %esi,%ecx
80102288:	80 f9 40             	cmp    $0x40,%cl
8010228b:	75 f3                	jne    80102280 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010228d:	a8 21                	test   $0x21,%al
8010228f:	75 12                	jne    801022a3 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
80102291:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102294:	b9 80 00 00 00       	mov    $0x80,%ecx
80102299:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010229e:	fc                   	cld    
8010229f:	f3 6d                	rep insl (%dx),%es:(%edi)
801022a1:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801022a3:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
801022a6:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801022a9:	89 f9                	mov    %edi,%ecx
801022ab:	83 c9 02             	or     $0x2,%ecx
801022ae:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
801022b0:	53                   	push   %ebx
801022b1:	e8 da 1e 00 00       	call   80104190 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801022b6:	a1 64 c5 10 80       	mov    0x8010c564,%eax
801022bb:	83 c4 10             	add    $0x10,%esp
801022be:	85 c0                	test   %eax,%eax
801022c0:	74 05                	je     801022c7 <ideintr+0x87>
    idestart(idequeue);
801022c2:	e8 19 fe ff ff       	call   801020e0 <idestart>
    release(&idelock);
801022c7:	83 ec 0c             	sub    $0xc,%esp
801022ca:	68 80 c5 10 80       	push   $0x8010c580
801022cf:	e8 8c 28 00 00       	call   80104b60 <release>

  release(&idelock);
}
801022d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022d7:	5b                   	pop    %ebx
801022d8:	5e                   	pop    %esi
801022d9:	5f                   	pop    %edi
801022da:	5d                   	pop    %ebp
801022db:	c3                   	ret    
801022dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801022e0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801022e0:	55                   	push   %ebp
801022e1:	89 e5                	mov    %esp,%ebp
801022e3:	53                   	push   %ebx
801022e4:	83 ec 10             	sub    $0x10,%esp
801022e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801022ea:	8d 43 0c             	lea    0xc(%ebx),%eax
801022ed:	50                   	push   %eax
801022ee:	e8 1d 26 00 00       	call   80104910 <holdingsleep>
801022f3:	83 c4 10             	add    $0x10,%esp
801022f6:	85 c0                	test   %eax,%eax
801022f8:	0f 84 c6 00 00 00    	je     801023c4 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801022fe:	8b 03                	mov    (%ebx),%eax
80102300:	83 e0 06             	and    $0x6,%eax
80102303:	83 f8 02             	cmp    $0x2,%eax
80102306:	0f 84 ab 00 00 00    	je     801023b7 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010230c:	8b 53 04             	mov    0x4(%ebx),%edx
8010230f:	85 d2                	test   %edx,%edx
80102311:	74 0d                	je     80102320 <iderw+0x40>
80102313:	a1 60 c5 10 80       	mov    0x8010c560,%eax
80102318:	85 c0                	test   %eax,%eax
8010231a:	0f 84 b1 00 00 00    	je     801023d1 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102320:	83 ec 0c             	sub    $0xc,%esp
80102323:	68 80 c5 10 80       	push   $0x8010c580
80102328:	e8 73 27 00 00       	call   80104aa0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010232d:	8b 15 64 c5 10 80    	mov    0x8010c564,%edx
80102333:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
80102336:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010233d:	85 d2                	test   %edx,%edx
8010233f:	75 09                	jne    8010234a <iderw+0x6a>
80102341:	eb 6d                	jmp    801023b0 <iderw+0xd0>
80102343:	90                   	nop
80102344:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102348:	89 c2                	mov    %eax,%edx
8010234a:	8b 42 58             	mov    0x58(%edx),%eax
8010234d:	85 c0                	test   %eax,%eax
8010234f:	75 f7                	jne    80102348 <iderw+0x68>
80102351:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102354:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102356:	39 1d 64 c5 10 80    	cmp    %ebx,0x8010c564
8010235c:	74 42                	je     801023a0 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010235e:	8b 03                	mov    (%ebx),%eax
80102360:	83 e0 06             	and    $0x6,%eax
80102363:	83 f8 02             	cmp    $0x2,%eax
80102366:	74 23                	je     8010238b <iderw+0xab>
80102368:	90                   	nop
80102369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102370:	83 ec 08             	sub    $0x8,%esp
80102373:	68 80 c5 10 80       	push   $0x8010c580
80102378:	53                   	push   %ebx
80102379:	e8 52 1c 00 00       	call   80103fd0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010237e:	8b 03                	mov    (%ebx),%eax
80102380:	83 c4 10             	add    $0x10,%esp
80102383:	83 e0 06             	and    $0x6,%eax
80102386:	83 f8 02             	cmp    $0x2,%eax
80102389:	75 e5                	jne    80102370 <iderw+0x90>
  }


  release(&idelock);
8010238b:	c7 45 08 80 c5 10 80 	movl   $0x8010c580,0x8(%ebp)
}
80102392:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102395:	c9                   	leave  
  release(&idelock);
80102396:	e9 c5 27 00 00       	jmp    80104b60 <release>
8010239b:	90                   	nop
8010239c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
801023a0:	89 d8                	mov    %ebx,%eax
801023a2:	e8 39 fd ff ff       	call   801020e0 <idestart>
801023a7:	eb b5                	jmp    8010235e <iderw+0x7e>
801023a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023b0:	ba 64 c5 10 80       	mov    $0x8010c564,%edx
801023b5:	eb 9d                	jmp    80102354 <iderw+0x74>
    panic("iderw: nothing to do");
801023b7:	83 ec 0c             	sub    $0xc,%esp
801023ba:	68 20 84 10 80       	push   $0x80108420
801023bf:	e8 cc df ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
801023c4:	83 ec 0c             	sub    $0xc,%esp
801023c7:	68 0a 84 10 80       	push   $0x8010840a
801023cc:	e8 bf df ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
801023d1:	83 ec 0c             	sub    $0xc,%esp
801023d4:	68 35 84 10 80       	push   $0x80108435
801023d9:	e8 b2 df ff ff       	call   80100390 <panic>
801023de:	66 90                	xchg   %ax,%ax

801023e0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801023e0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801023e1:	c7 05 54 46 11 80 00 	movl   $0xfec00000,0x80114654
801023e8:	00 c0 fe 
{
801023eb:	89 e5                	mov    %esp,%ebp
801023ed:	56                   	push   %esi
801023ee:	53                   	push   %ebx
  ioapic->reg = reg;
801023ef:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801023f6:	00 00 00 
  return ioapic->data;
801023f9:	a1 54 46 11 80       	mov    0x80114654,%eax
801023fe:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102401:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102407:	8b 0d 54 46 11 80    	mov    0x80114654,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010240d:	0f b6 15 80 47 11 80 	movzbl 0x80114780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102414:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
80102417:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010241a:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
8010241d:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102420:	39 c2                	cmp    %eax,%edx
80102422:	74 16                	je     8010243a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102424:	83 ec 0c             	sub    $0xc,%esp
80102427:	68 54 84 10 80       	push   $0x80108454
8010242c:	e8 bf e2 ff ff       	call   801006f0 <cprintf>
80102431:	8b 0d 54 46 11 80    	mov    0x80114654,%ecx
80102437:	83 c4 10             	add    $0x10,%esp
8010243a:	83 c3 21             	add    $0x21,%ebx
{
8010243d:	ba 10 00 00 00       	mov    $0x10,%edx
80102442:	b8 20 00 00 00       	mov    $0x20,%eax
80102447:	89 f6                	mov    %esi,%esi
80102449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
80102450:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102452:	8b 0d 54 46 11 80    	mov    0x80114654,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102458:	89 c6                	mov    %eax,%esi
8010245a:	81 ce 00 00 01 00    	or     $0x10000,%esi
80102460:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102463:	89 71 10             	mov    %esi,0x10(%ecx)
80102466:	8d 72 01             	lea    0x1(%edx),%esi
80102469:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
8010246c:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
8010246e:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
80102470:	8b 0d 54 46 11 80    	mov    0x80114654,%ecx
80102476:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010247d:	75 d1                	jne    80102450 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010247f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102482:	5b                   	pop    %ebx
80102483:	5e                   	pop    %esi
80102484:	5d                   	pop    %ebp
80102485:	c3                   	ret    
80102486:	8d 76 00             	lea    0x0(%esi),%esi
80102489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102490 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102490:	55                   	push   %ebp
  ioapic->reg = reg;
80102491:	8b 0d 54 46 11 80    	mov    0x80114654,%ecx
{
80102497:	89 e5                	mov    %esp,%ebp
80102499:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010249c:	8d 50 20             	lea    0x20(%eax),%edx
8010249f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801024a3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024a5:	8b 0d 54 46 11 80    	mov    0x80114654,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024ab:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801024ae:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801024b4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024b6:	a1 54 46 11 80       	mov    0x80114654,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024bb:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801024be:	89 50 10             	mov    %edx,0x10(%eax)
}
801024c1:	5d                   	pop    %ebp
801024c2:	c3                   	ret    
801024c3:	66 90                	xchg   %ax,%ax
801024c5:	66 90                	xchg   %ax,%ax
801024c7:	66 90                	xchg   %ax,%ax
801024c9:	66 90                	xchg   %ax,%ax
801024cb:	66 90                	xchg   %ax,%ax
801024cd:	66 90                	xchg   %ax,%ax
801024cf:	90                   	nop

801024d0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801024d0:	55                   	push   %ebp
801024d1:	89 e5                	mov    %esp,%ebp
801024d3:	53                   	push   %ebx
801024d4:	83 ec 04             	sub    $0x4,%esp
801024d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801024da:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801024e0:	75 70                	jne    80102552 <kfree+0x82>
801024e2:	81 fb e8 ed 12 80    	cmp    $0x8012ede8,%ebx
801024e8:	72 68                	jb     80102552 <kfree+0x82>
801024ea:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801024f0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801024f5:	77 5b                	ja     80102552 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801024f7:	83 ec 04             	sub    $0x4,%esp
801024fa:	68 00 10 00 00       	push   $0x1000
801024ff:	6a 01                	push   $0x1
80102501:	53                   	push   %ebx
80102502:	e8 b9 28 00 00       	call   80104dc0 <memset>

  if(kmem.use_lock)
80102507:	8b 15 94 46 11 80    	mov    0x80114694,%edx
8010250d:	83 c4 10             	add    $0x10,%esp
80102510:	85 d2                	test   %edx,%edx
80102512:	75 2c                	jne    80102540 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102514:	a1 98 46 11 80       	mov    0x80114698,%eax
80102519:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010251b:	a1 94 46 11 80       	mov    0x80114694,%eax
  kmem.freelist = r;
80102520:	89 1d 98 46 11 80    	mov    %ebx,0x80114698
  if(kmem.use_lock)
80102526:	85 c0                	test   %eax,%eax
80102528:	75 06                	jne    80102530 <kfree+0x60>
    release(&kmem.lock);
}
8010252a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010252d:	c9                   	leave  
8010252e:	c3                   	ret    
8010252f:	90                   	nop
    release(&kmem.lock);
80102530:	c7 45 08 60 46 11 80 	movl   $0x80114660,0x8(%ebp)
}
80102537:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010253a:	c9                   	leave  
    release(&kmem.lock);
8010253b:	e9 20 26 00 00       	jmp    80104b60 <release>
    acquire(&kmem.lock);
80102540:	83 ec 0c             	sub    $0xc,%esp
80102543:	68 60 46 11 80       	push   $0x80114660
80102548:	e8 53 25 00 00       	call   80104aa0 <acquire>
8010254d:	83 c4 10             	add    $0x10,%esp
80102550:	eb c2                	jmp    80102514 <kfree+0x44>
    panic("kfree");
80102552:	83 ec 0c             	sub    $0xc,%esp
80102555:	68 86 84 10 80       	push   $0x80108486
8010255a:	e8 31 de ff ff       	call   80100390 <panic>
8010255f:	90                   	nop

80102560 <freerange>:
{
80102560:	55                   	push   %ebp
80102561:	89 e5                	mov    %esp,%ebp
80102563:	56                   	push   %esi
80102564:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102565:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102568:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010256b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102571:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102577:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010257d:	39 de                	cmp    %ebx,%esi
8010257f:	72 23                	jb     801025a4 <freerange+0x44>
80102581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102588:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010258e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102591:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102597:	50                   	push   %eax
80102598:	e8 33 ff ff ff       	call   801024d0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010259d:	83 c4 10             	add    $0x10,%esp
801025a0:	39 f3                	cmp    %esi,%ebx
801025a2:	76 e4                	jbe    80102588 <freerange+0x28>
}
801025a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025a7:	5b                   	pop    %ebx
801025a8:	5e                   	pop    %esi
801025a9:	5d                   	pop    %ebp
801025aa:	c3                   	ret    
801025ab:	90                   	nop
801025ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801025b0 <kinit1>:
{
801025b0:	55                   	push   %ebp
801025b1:	89 e5                	mov    %esp,%ebp
801025b3:	56                   	push   %esi
801025b4:	53                   	push   %ebx
801025b5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801025b8:	83 ec 08             	sub    $0x8,%esp
801025bb:	68 8c 84 10 80       	push   $0x8010848c
801025c0:	68 60 46 11 80       	push   $0x80114660
801025c5:	e8 96 23 00 00       	call   80104960 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801025ca:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025cd:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
801025d0:	c7 05 94 46 11 80 00 	movl   $0x0,0x80114694
801025d7:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801025da:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025e0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025e6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025ec:	39 de                	cmp    %ebx,%esi
801025ee:	72 1c                	jb     8010260c <kinit1+0x5c>
    kfree(p);
801025f0:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801025f6:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025f9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025ff:	50                   	push   %eax
80102600:	e8 cb fe ff ff       	call   801024d0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102605:	83 c4 10             	add    $0x10,%esp
80102608:	39 de                	cmp    %ebx,%esi
8010260a:	73 e4                	jae    801025f0 <kinit1+0x40>
}
8010260c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010260f:	5b                   	pop    %ebx
80102610:	5e                   	pop    %esi
80102611:	5d                   	pop    %ebp
80102612:	c3                   	ret    
80102613:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102620 <kinit2>:
{
80102620:	55                   	push   %ebp
80102621:	89 e5                	mov    %esp,%ebp
80102623:	56                   	push   %esi
80102624:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102625:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102628:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010262b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102631:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102637:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010263d:	39 de                	cmp    %ebx,%esi
8010263f:	72 23                	jb     80102664 <kinit2+0x44>
80102641:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102648:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010264e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102651:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102657:	50                   	push   %eax
80102658:	e8 73 fe ff ff       	call   801024d0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010265d:	83 c4 10             	add    $0x10,%esp
80102660:	39 de                	cmp    %ebx,%esi
80102662:	73 e4                	jae    80102648 <kinit2+0x28>
  kmem.use_lock = 1;
80102664:	c7 05 94 46 11 80 01 	movl   $0x1,0x80114694
8010266b:	00 00 00 
}
8010266e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102671:	5b                   	pop    %ebx
80102672:	5e                   	pop    %esi
80102673:	5d                   	pop    %ebp
80102674:	c3                   	ret    
80102675:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102679:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102680 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102680:	a1 94 46 11 80       	mov    0x80114694,%eax
80102685:	85 c0                	test   %eax,%eax
80102687:	75 1f                	jne    801026a8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102689:	a1 98 46 11 80       	mov    0x80114698,%eax
  if(r)
8010268e:	85 c0                	test   %eax,%eax
80102690:	74 0e                	je     801026a0 <kalloc+0x20>
    kmem.freelist = r->next;
80102692:	8b 10                	mov    (%eax),%edx
80102694:	89 15 98 46 11 80    	mov    %edx,0x80114698
8010269a:	c3                   	ret    
8010269b:	90                   	nop
8010269c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
801026a0:	f3 c3                	repz ret 
801026a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
801026a8:	55                   	push   %ebp
801026a9:	89 e5                	mov    %esp,%ebp
801026ab:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801026ae:	68 60 46 11 80       	push   $0x80114660
801026b3:	e8 e8 23 00 00       	call   80104aa0 <acquire>
  r = kmem.freelist;
801026b8:	a1 98 46 11 80       	mov    0x80114698,%eax
  if(r)
801026bd:	83 c4 10             	add    $0x10,%esp
801026c0:	8b 15 94 46 11 80    	mov    0x80114694,%edx
801026c6:	85 c0                	test   %eax,%eax
801026c8:	74 08                	je     801026d2 <kalloc+0x52>
    kmem.freelist = r->next;
801026ca:	8b 08                	mov    (%eax),%ecx
801026cc:	89 0d 98 46 11 80    	mov    %ecx,0x80114698
  if(kmem.use_lock)
801026d2:	85 d2                	test   %edx,%edx
801026d4:	74 16                	je     801026ec <kalloc+0x6c>
    release(&kmem.lock);
801026d6:	83 ec 0c             	sub    $0xc,%esp
801026d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801026dc:	68 60 46 11 80       	push   $0x80114660
801026e1:	e8 7a 24 00 00       	call   80104b60 <release>
  return (char*)r;
801026e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801026e9:	83 c4 10             	add    $0x10,%esp
}
801026ec:	c9                   	leave  
801026ed:	c3                   	ret    
801026ee:	66 90                	xchg   %ax,%ax

801026f0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026f0:	ba 64 00 00 00       	mov    $0x64,%edx
801026f5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801026f6:	a8 01                	test   $0x1,%al
801026f8:	0f 84 c2 00 00 00    	je     801027c0 <kbdgetc+0xd0>
801026fe:	ba 60 00 00 00       	mov    $0x60,%edx
80102703:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102704:	0f b6 d0             	movzbl %al,%edx
80102707:	8b 0d b4 c5 10 80    	mov    0x8010c5b4,%ecx

  if(data == 0xE0){
8010270d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102713:	0f 84 7f 00 00 00    	je     80102798 <kbdgetc+0xa8>
{
80102719:	55                   	push   %ebp
8010271a:	89 e5                	mov    %esp,%ebp
8010271c:	53                   	push   %ebx
8010271d:	89 cb                	mov    %ecx,%ebx
8010271f:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102722:	84 c0                	test   %al,%al
80102724:	78 4a                	js     80102770 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102726:	85 db                	test   %ebx,%ebx
80102728:	74 09                	je     80102733 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010272a:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
8010272d:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102730:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102733:	0f b6 82 c0 85 10 80 	movzbl -0x7fef7a40(%edx),%eax
8010273a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
8010273c:	0f b6 82 c0 84 10 80 	movzbl -0x7fef7b40(%edx),%eax
80102743:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102745:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102747:	89 0d b4 c5 10 80    	mov    %ecx,0x8010c5b4
  c = charcode[shift & (CTL | SHIFT)][data];
8010274d:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102750:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102753:	8b 04 85 a0 84 10 80 	mov    -0x7fef7b60(,%eax,4),%eax
8010275a:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010275e:	74 31                	je     80102791 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
80102760:	8d 50 9f             	lea    -0x61(%eax),%edx
80102763:	83 fa 19             	cmp    $0x19,%edx
80102766:	77 40                	ja     801027a8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102768:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
8010276b:	5b                   	pop    %ebx
8010276c:	5d                   	pop    %ebp
8010276d:	c3                   	ret    
8010276e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102770:	83 e0 7f             	and    $0x7f,%eax
80102773:	85 db                	test   %ebx,%ebx
80102775:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102778:	0f b6 82 c0 85 10 80 	movzbl -0x7fef7a40(%edx),%eax
8010277f:	83 c8 40             	or     $0x40,%eax
80102782:	0f b6 c0             	movzbl %al,%eax
80102785:	f7 d0                	not    %eax
80102787:	21 c1                	and    %eax,%ecx
    return 0;
80102789:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010278b:	89 0d b4 c5 10 80    	mov    %ecx,0x8010c5b4
}
80102791:	5b                   	pop    %ebx
80102792:	5d                   	pop    %ebp
80102793:	c3                   	ret    
80102794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102798:	83 c9 40             	or     $0x40,%ecx
    return 0;
8010279b:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
8010279d:	89 0d b4 c5 10 80    	mov    %ecx,0x8010c5b4
    return 0;
801027a3:	c3                   	ret    
801027a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
801027a8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801027ab:	8d 50 20             	lea    0x20(%eax),%edx
}
801027ae:	5b                   	pop    %ebx
      c += 'a' - 'A';
801027af:	83 f9 1a             	cmp    $0x1a,%ecx
801027b2:	0f 42 c2             	cmovb  %edx,%eax
}
801027b5:	5d                   	pop    %ebp
801027b6:	c3                   	ret    
801027b7:	89 f6                	mov    %esi,%esi
801027b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801027c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801027c5:	c3                   	ret    
801027c6:	8d 76 00             	lea    0x0(%esi),%esi
801027c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027d0 <kbdintr>:

void
kbdintr(void)
{
801027d0:	55                   	push   %ebp
801027d1:	89 e5                	mov    %esp,%ebp
801027d3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801027d6:	68 f0 26 10 80       	push   $0x801026f0
801027db:	e8 c0 e0 ff ff       	call   801008a0 <consoleintr>
}
801027e0:	83 c4 10             	add    $0x10,%esp
801027e3:	c9                   	leave  
801027e4:	c3                   	ret    
801027e5:	66 90                	xchg   %ax,%ax
801027e7:	66 90                	xchg   %ax,%ax
801027e9:	66 90                	xchg   %ax,%ax
801027eb:	66 90                	xchg   %ax,%ax
801027ed:	66 90                	xchg   %ax,%ax
801027ef:	90                   	nop

801027f0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801027f0:	a1 9c 46 11 80       	mov    0x8011469c,%eax
{
801027f5:	55                   	push   %ebp
801027f6:	89 e5                	mov    %esp,%ebp
  if(!lapic)
801027f8:	85 c0                	test   %eax,%eax
801027fa:	0f 84 c8 00 00 00    	je     801028c8 <lapicinit+0xd8>
  lapic[index] = value;
80102800:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102807:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010280a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010280d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102814:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102817:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010281a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102821:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102824:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102827:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010282e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102831:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102834:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010283b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010283e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102841:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102848:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010284b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010284e:	8b 50 30             	mov    0x30(%eax),%edx
80102851:	c1 ea 10             	shr    $0x10,%edx
80102854:	80 fa 03             	cmp    $0x3,%dl
80102857:	77 77                	ja     801028d0 <lapicinit+0xe0>
  lapic[index] = value;
80102859:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102860:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102863:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102866:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010286d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102870:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102873:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010287a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010287d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102880:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102887:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010288a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010288d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102894:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102897:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010289a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801028a1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801028a4:	8b 50 20             	mov    0x20(%eax),%edx
801028a7:	89 f6                	mov    %esi,%esi
801028a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801028b0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801028b6:	80 e6 10             	and    $0x10,%dh
801028b9:	75 f5                	jne    801028b0 <lapicinit+0xc0>
  lapic[index] = value;
801028bb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801028c2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028c5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801028c8:	5d                   	pop    %ebp
801028c9:	c3                   	ret    
801028ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
801028d0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801028d7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028da:	8b 50 20             	mov    0x20(%eax),%edx
801028dd:	e9 77 ff ff ff       	jmp    80102859 <lapicinit+0x69>
801028e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801028f0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
801028f0:	8b 15 9c 46 11 80    	mov    0x8011469c,%edx
{
801028f6:	55                   	push   %ebp
801028f7:	31 c0                	xor    %eax,%eax
801028f9:	89 e5                	mov    %esp,%ebp
  if (!lapic)
801028fb:	85 d2                	test   %edx,%edx
801028fd:	74 06                	je     80102905 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
801028ff:	8b 42 20             	mov    0x20(%edx),%eax
80102902:	c1 e8 18             	shr    $0x18,%eax
}
80102905:	5d                   	pop    %ebp
80102906:	c3                   	ret    
80102907:	89 f6                	mov    %esi,%esi
80102909:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102910 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102910:	a1 9c 46 11 80       	mov    0x8011469c,%eax
{
80102915:	55                   	push   %ebp
80102916:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102918:	85 c0                	test   %eax,%eax
8010291a:	74 0d                	je     80102929 <lapiceoi+0x19>
  lapic[index] = value;
8010291c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102923:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102926:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102929:	5d                   	pop    %ebp
8010292a:	c3                   	ret    
8010292b:	90                   	nop
8010292c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102930 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102930:	55                   	push   %ebp
80102931:	89 e5                	mov    %esp,%ebp
}
80102933:	5d                   	pop    %ebp
80102934:	c3                   	ret    
80102935:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102939:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102940 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102940:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102941:	b8 0f 00 00 00       	mov    $0xf,%eax
80102946:	ba 70 00 00 00       	mov    $0x70,%edx
8010294b:	89 e5                	mov    %esp,%ebp
8010294d:	53                   	push   %ebx
8010294e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102951:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102954:	ee                   	out    %al,(%dx)
80102955:	b8 0a 00 00 00       	mov    $0xa,%eax
8010295a:	ba 71 00 00 00       	mov    $0x71,%edx
8010295f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102960:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102962:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102965:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010296b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010296d:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
80102970:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
80102973:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102975:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102978:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010297e:	a1 9c 46 11 80       	mov    0x8011469c,%eax
80102983:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102989:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010298c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102993:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102996:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102999:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801029a0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029a3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029a6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029ac:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029af:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029b5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029b8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029be:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029c1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029c7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
801029ca:	5b                   	pop    %ebx
801029cb:	5d                   	pop    %ebp
801029cc:	c3                   	ret    
801029cd:	8d 76 00             	lea    0x0(%esi),%esi

801029d0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801029d0:	55                   	push   %ebp
801029d1:	b8 0b 00 00 00       	mov    $0xb,%eax
801029d6:	ba 70 00 00 00       	mov    $0x70,%edx
801029db:	89 e5                	mov    %esp,%ebp
801029dd:	57                   	push   %edi
801029de:	56                   	push   %esi
801029df:	53                   	push   %ebx
801029e0:	83 ec 4c             	sub    $0x4c,%esp
801029e3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029e4:	ba 71 00 00 00       	mov    $0x71,%edx
801029e9:	ec                   	in     (%dx),%al
801029ea:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029ed:	bb 70 00 00 00       	mov    $0x70,%ebx
801029f2:	88 45 b3             	mov    %al,-0x4d(%ebp)
801029f5:	8d 76 00             	lea    0x0(%esi),%esi
801029f8:	31 c0                	xor    %eax,%eax
801029fa:	89 da                	mov    %ebx,%edx
801029fc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029fd:	b9 71 00 00 00       	mov    $0x71,%ecx
80102a02:	89 ca                	mov    %ecx,%edx
80102a04:	ec                   	in     (%dx),%al
80102a05:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a08:	89 da                	mov    %ebx,%edx
80102a0a:	b8 02 00 00 00       	mov    $0x2,%eax
80102a0f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a10:	89 ca                	mov    %ecx,%edx
80102a12:	ec                   	in     (%dx),%al
80102a13:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a16:	89 da                	mov    %ebx,%edx
80102a18:	b8 04 00 00 00       	mov    $0x4,%eax
80102a1d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a1e:	89 ca                	mov    %ecx,%edx
80102a20:	ec                   	in     (%dx),%al
80102a21:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a24:	89 da                	mov    %ebx,%edx
80102a26:	b8 07 00 00 00       	mov    $0x7,%eax
80102a2b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a2c:	89 ca                	mov    %ecx,%edx
80102a2e:	ec                   	in     (%dx),%al
80102a2f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a32:	89 da                	mov    %ebx,%edx
80102a34:	b8 08 00 00 00       	mov    $0x8,%eax
80102a39:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a3a:	89 ca                	mov    %ecx,%edx
80102a3c:	ec                   	in     (%dx),%al
80102a3d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a3f:	89 da                	mov    %ebx,%edx
80102a41:	b8 09 00 00 00       	mov    $0x9,%eax
80102a46:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a47:	89 ca                	mov    %ecx,%edx
80102a49:	ec                   	in     (%dx),%al
80102a4a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a4c:	89 da                	mov    %ebx,%edx
80102a4e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a53:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a54:	89 ca                	mov    %ecx,%edx
80102a56:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a57:	84 c0                	test   %al,%al
80102a59:	78 9d                	js     801029f8 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102a5b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a5f:	89 fa                	mov    %edi,%edx
80102a61:	0f b6 fa             	movzbl %dl,%edi
80102a64:	89 f2                	mov    %esi,%edx
80102a66:	0f b6 f2             	movzbl %dl,%esi
80102a69:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a6c:	89 da                	mov    %ebx,%edx
80102a6e:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102a71:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a74:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a78:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a7b:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102a7f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102a82:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102a86:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102a89:	31 c0                	xor    %eax,%eax
80102a8b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a8c:	89 ca                	mov    %ecx,%edx
80102a8e:	ec                   	in     (%dx),%al
80102a8f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a92:	89 da                	mov    %ebx,%edx
80102a94:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102a97:	b8 02 00 00 00       	mov    $0x2,%eax
80102a9c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a9d:	89 ca                	mov    %ecx,%edx
80102a9f:	ec                   	in     (%dx),%al
80102aa0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aa3:	89 da                	mov    %ebx,%edx
80102aa5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102aa8:	b8 04 00 00 00       	mov    $0x4,%eax
80102aad:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aae:	89 ca                	mov    %ecx,%edx
80102ab0:	ec                   	in     (%dx),%al
80102ab1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ab4:	89 da                	mov    %ebx,%edx
80102ab6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102ab9:	b8 07 00 00 00       	mov    $0x7,%eax
80102abe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102abf:	89 ca                	mov    %ecx,%edx
80102ac1:	ec                   	in     (%dx),%al
80102ac2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ac5:	89 da                	mov    %ebx,%edx
80102ac7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102aca:	b8 08 00 00 00       	mov    $0x8,%eax
80102acf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ad0:	89 ca                	mov    %ecx,%edx
80102ad2:	ec                   	in     (%dx),%al
80102ad3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ad6:	89 da                	mov    %ebx,%edx
80102ad8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102adb:	b8 09 00 00 00       	mov    $0x9,%eax
80102ae0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ae1:	89 ca                	mov    %ecx,%edx
80102ae3:	ec                   	in     (%dx),%al
80102ae4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ae7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102aea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102aed:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102af0:	6a 18                	push   $0x18
80102af2:	50                   	push   %eax
80102af3:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102af6:	50                   	push   %eax
80102af7:	e8 14 23 00 00       	call   80104e10 <memcmp>
80102afc:	83 c4 10             	add    $0x10,%esp
80102aff:	85 c0                	test   %eax,%eax
80102b01:	0f 85 f1 fe ff ff    	jne    801029f8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102b07:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102b0b:	75 78                	jne    80102b85 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102b0d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b10:	89 c2                	mov    %eax,%edx
80102b12:	83 e0 0f             	and    $0xf,%eax
80102b15:	c1 ea 04             	shr    $0x4,%edx
80102b18:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b1b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b1e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102b21:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b24:	89 c2                	mov    %eax,%edx
80102b26:	83 e0 0f             	and    $0xf,%eax
80102b29:	c1 ea 04             	shr    $0x4,%edx
80102b2c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b2f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b32:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b35:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b38:	89 c2                	mov    %eax,%edx
80102b3a:	83 e0 0f             	and    $0xf,%eax
80102b3d:	c1 ea 04             	shr    $0x4,%edx
80102b40:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b43:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b46:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b49:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b4c:	89 c2                	mov    %eax,%edx
80102b4e:	83 e0 0f             	and    $0xf,%eax
80102b51:	c1 ea 04             	shr    $0x4,%edx
80102b54:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b57:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b5a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b5d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b60:	89 c2                	mov    %eax,%edx
80102b62:	83 e0 0f             	and    $0xf,%eax
80102b65:	c1 ea 04             	shr    $0x4,%edx
80102b68:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b6b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b6e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b71:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b74:	89 c2                	mov    %eax,%edx
80102b76:	83 e0 0f             	and    $0xf,%eax
80102b79:	c1 ea 04             	shr    $0x4,%edx
80102b7c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b7f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b82:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102b85:	8b 75 08             	mov    0x8(%ebp),%esi
80102b88:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b8b:	89 06                	mov    %eax,(%esi)
80102b8d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b90:	89 46 04             	mov    %eax,0x4(%esi)
80102b93:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b96:	89 46 08             	mov    %eax,0x8(%esi)
80102b99:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b9c:	89 46 0c             	mov    %eax,0xc(%esi)
80102b9f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102ba2:	89 46 10             	mov    %eax,0x10(%esi)
80102ba5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102ba8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102bab:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102bb2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102bb5:	5b                   	pop    %ebx
80102bb6:	5e                   	pop    %esi
80102bb7:	5f                   	pop    %edi
80102bb8:	5d                   	pop    %ebp
80102bb9:	c3                   	ret    
80102bba:	66 90                	xchg   %ax,%ax
80102bbc:	66 90                	xchg   %ax,%ax
80102bbe:	66 90                	xchg   %ax,%ax

80102bc0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102bc0:	8b 0d e8 46 11 80    	mov    0x801146e8,%ecx
80102bc6:	85 c9                	test   %ecx,%ecx
80102bc8:	0f 8e 8a 00 00 00    	jle    80102c58 <install_trans+0x98>
{
80102bce:	55                   	push   %ebp
80102bcf:	89 e5                	mov    %esp,%ebp
80102bd1:	57                   	push   %edi
80102bd2:	56                   	push   %esi
80102bd3:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102bd4:	31 db                	xor    %ebx,%ebx
{
80102bd6:	83 ec 0c             	sub    $0xc,%esp
80102bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102be0:	a1 d4 46 11 80       	mov    0x801146d4,%eax
80102be5:	83 ec 08             	sub    $0x8,%esp
80102be8:	01 d8                	add    %ebx,%eax
80102bea:	83 c0 01             	add    $0x1,%eax
80102bed:	50                   	push   %eax
80102bee:	ff 35 e4 46 11 80    	pushl  0x801146e4
80102bf4:	e8 d7 d4 ff ff       	call   801000d0 <bread>
80102bf9:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bfb:	58                   	pop    %eax
80102bfc:	5a                   	pop    %edx
80102bfd:	ff 34 9d ec 46 11 80 	pushl  -0x7feeb914(,%ebx,4)
80102c04:	ff 35 e4 46 11 80    	pushl  0x801146e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102c0a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c0d:	e8 be d4 ff ff       	call   801000d0 <bread>
80102c12:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c14:	8d 47 5c             	lea    0x5c(%edi),%eax
80102c17:	83 c4 0c             	add    $0xc,%esp
80102c1a:	68 00 02 00 00       	push   $0x200
80102c1f:	50                   	push   %eax
80102c20:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c23:	50                   	push   %eax
80102c24:	e8 47 22 00 00       	call   80104e70 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c29:	89 34 24             	mov    %esi,(%esp)
80102c2c:	e8 6f d5 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102c31:	89 3c 24             	mov    %edi,(%esp)
80102c34:	e8 a7 d5 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102c39:	89 34 24             	mov    %esi,(%esp)
80102c3c:	e8 9f d5 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c41:	83 c4 10             	add    $0x10,%esp
80102c44:	39 1d e8 46 11 80    	cmp    %ebx,0x801146e8
80102c4a:	7f 94                	jg     80102be0 <install_trans+0x20>
  }
}
80102c4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c4f:	5b                   	pop    %ebx
80102c50:	5e                   	pop    %esi
80102c51:	5f                   	pop    %edi
80102c52:	5d                   	pop    %ebp
80102c53:	c3                   	ret    
80102c54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c58:	f3 c3                	repz ret 
80102c5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102c60 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c60:	55                   	push   %ebp
80102c61:	89 e5                	mov    %esp,%ebp
80102c63:	56                   	push   %esi
80102c64:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102c65:	83 ec 08             	sub    $0x8,%esp
80102c68:	ff 35 d4 46 11 80    	pushl  0x801146d4
80102c6e:	ff 35 e4 46 11 80    	pushl  0x801146e4
80102c74:	e8 57 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102c79:	8b 1d e8 46 11 80    	mov    0x801146e8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102c7f:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c82:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102c84:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102c86:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102c89:	7e 16                	jle    80102ca1 <write_head+0x41>
80102c8b:	c1 e3 02             	shl    $0x2,%ebx
80102c8e:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102c90:	8b 8a ec 46 11 80    	mov    -0x7feeb914(%edx),%ecx
80102c96:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102c9a:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102c9d:	39 da                	cmp    %ebx,%edx
80102c9f:	75 ef                	jne    80102c90 <write_head+0x30>
  }
  bwrite(buf);
80102ca1:	83 ec 0c             	sub    $0xc,%esp
80102ca4:	56                   	push   %esi
80102ca5:	e8 f6 d4 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102caa:	89 34 24             	mov    %esi,(%esp)
80102cad:	e8 2e d5 ff ff       	call   801001e0 <brelse>
}
80102cb2:	83 c4 10             	add    $0x10,%esp
80102cb5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102cb8:	5b                   	pop    %ebx
80102cb9:	5e                   	pop    %esi
80102cba:	5d                   	pop    %ebp
80102cbb:	c3                   	ret    
80102cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102cc0 <initlog>:
{
80102cc0:	55                   	push   %ebp
80102cc1:	89 e5                	mov    %esp,%ebp
80102cc3:	53                   	push   %ebx
80102cc4:	83 ec 2c             	sub    $0x2c,%esp
80102cc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102cca:	68 c0 86 10 80       	push   $0x801086c0
80102ccf:	68 a0 46 11 80       	push   $0x801146a0
80102cd4:	e8 87 1c 00 00       	call   80104960 <initlock>
  readsb(dev, &sb);
80102cd9:	58                   	pop    %eax
80102cda:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102cdd:	5a                   	pop    %edx
80102cde:	50                   	push   %eax
80102cdf:	53                   	push   %ebx
80102ce0:	e8 9b e8 ff ff       	call   80101580 <readsb>
  log.size = sb.nlog;
80102ce5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102ce8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102ceb:	59                   	pop    %ecx
  log.dev = dev;
80102cec:	89 1d e4 46 11 80    	mov    %ebx,0x801146e4
  log.size = sb.nlog;
80102cf2:	89 15 d8 46 11 80    	mov    %edx,0x801146d8
  log.start = sb.logstart;
80102cf8:	a3 d4 46 11 80       	mov    %eax,0x801146d4
  struct buf *buf = bread(log.dev, log.start);
80102cfd:	5a                   	pop    %edx
80102cfe:	50                   	push   %eax
80102cff:	53                   	push   %ebx
80102d00:	e8 cb d3 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102d05:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102d08:	83 c4 10             	add    $0x10,%esp
80102d0b:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102d0d:	89 1d e8 46 11 80    	mov    %ebx,0x801146e8
  for (i = 0; i < log.lh.n; i++) {
80102d13:	7e 1c                	jle    80102d31 <initlog+0x71>
80102d15:	c1 e3 02             	shl    $0x2,%ebx
80102d18:	31 d2                	xor    %edx,%edx
80102d1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102d20:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102d24:	83 c2 04             	add    $0x4,%edx
80102d27:	89 8a e8 46 11 80    	mov    %ecx,-0x7feeb918(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102d2d:	39 d3                	cmp    %edx,%ebx
80102d2f:	75 ef                	jne    80102d20 <initlog+0x60>
  brelse(buf);
80102d31:	83 ec 0c             	sub    $0xc,%esp
80102d34:	50                   	push   %eax
80102d35:	e8 a6 d4 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d3a:	e8 81 fe ff ff       	call   80102bc0 <install_trans>
  log.lh.n = 0;
80102d3f:	c7 05 e8 46 11 80 00 	movl   $0x0,0x801146e8
80102d46:	00 00 00 
  write_head(); // clear the log
80102d49:	e8 12 ff ff ff       	call   80102c60 <write_head>
}
80102d4e:	83 c4 10             	add    $0x10,%esp
80102d51:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d54:	c9                   	leave  
80102d55:	c3                   	ret    
80102d56:	8d 76 00             	lea    0x0(%esi),%esi
80102d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102d60 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d60:	55                   	push   %ebp
80102d61:	89 e5                	mov    %esp,%ebp
80102d63:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d66:	68 a0 46 11 80       	push   $0x801146a0
80102d6b:	e8 30 1d 00 00       	call   80104aa0 <acquire>
80102d70:	83 c4 10             	add    $0x10,%esp
80102d73:	eb 18                	jmp    80102d8d <begin_op+0x2d>
80102d75:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d78:	83 ec 08             	sub    $0x8,%esp
80102d7b:	68 a0 46 11 80       	push   $0x801146a0
80102d80:	68 a0 46 11 80       	push   $0x801146a0
80102d85:	e8 46 12 00 00       	call   80103fd0 <sleep>
80102d8a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102d8d:	a1 e0 46 11 80       	mov    0x801146e0,%eax
80102d92:	85 c0                	test   %eax,%eax
80102d94:	75 e2                	jne    80102d78 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102d96:	a1 dc 46 11 80       	mov    0x801146dc,%eax
80102d9b:	8b 15 e8 46 11 80    	mov    0x801146e8,%edx
80102da1:	83 c0 01             	add    $0x1,%eax
80102da4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102da7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102daa:	83 fa 1e             	cmp    $0x1e,%edx
80102dad:	7f c9                	jg     80102d78 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102daf:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102db2:	a3 dc 46 11 80       	mov    %eax,0x801146dc
      release(&log.lock);
80102db7:	68 a0 46 11 80       	push   $0x801146a0
80102dbc:	e8 9f 1d 00 00       	call   80104b60 <release>
      break;
    }
  }
}
80102dc1:	83 c4 10             	add    $0x10,%esp
80102dc4:	c9                   	leave  
80102dc5:	c3                   	ret    
80102dc6:	8d 76 00             	lea    0x0(%esi),%esi
80102dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102dd0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102dd0:	55                   	push   %ebp
80102dd1:	89 e5                	mov    %esp,%ebp
80102dd3:	57                   	push   %edi
80102dd4:	56                   	push   %esi
80102dd5:	53                   	push   %ebx
80102dd6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102dd9:	68 a0 46 11 80       	push   $0x801146a0
80102dde:	e8 bd 1c 00 00       	call   80104aa0 <acquire>
  log.outstanding -= 1;
80102de3:	a1 dc 46 11 80       	mov    0x801146dc,%eax
  if(log.committing)
80102de8:	8b 35 e0 46 11 80    	mov    0x801146e0,%esi
80102dee:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102df1:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102df4:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102df6:	89 1d dc 46 11 80    	mov    %ebx,0x801146dc
  if(log.committing)
80102dfc:	0f 85 1a 01 00 00    	jne    80102f1c <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80102e02:	85 db                	test   %ebx,%ebx
80102e04:	0f 85 ee 00 00 00    	jne    80102ef8 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102e0a:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
80102e0d:	c7 05 e0 46 11 80 01 	movl   $0x1,0x801146e0
80102e14:	00 00 00 
  release(&log.lock);
80102e17:	68 a0 46 11 80       	push   $0x801146a0
80102e1c:	e8 3f 1d 00 00       	call   80104b60 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e21:	8b 0d e8 46 11 80    	mov    0x801146e8,%ecx
80102e27:	83 c4 10             	add    $0x10,%esp
80102e2a:	85 c9                	test   %ecx,%ecx
80102e2c:	0f 8e 85 00 00 00    	jle    80102eb7 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e32:	a1 d4 46 11 80       	mov    0x801146d4,%eax
80102e37:	83 ec 08             	sub    $0x8,%esp
80102e3a:	01 d8                	add    %ebx,%eax
80102e3c:	83 c0 01             	add    $0x1,%eax
80102e3f:	50                   	push   %eax
80102e40:	ff 35 e4 46 11 80    	pushl  0x801146e4
80102e46:	e8 85 d2 ff ff       	call   801000d0 <bread>
80102e4b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e4d:	58                   	pop    %eax
80102e4e:	5a                   	pop    %edx
80102e4f:	ff 34 9d ec 46 11 80 	pushl  -0x7feeb914(,%ebx,4)
80102e56:	ff 35 e4 46 11 80    	pushl  0x801146e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102e5c:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e5f:	e8 6c d2 ff ff       	call   801000d0 <bread>
80102e64:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102e66:	8d 40 5c             	lea    0x5c(%eax),%eax
80102e69:	83 c4 0c             	add    $0xc,%esp
80102e6c:	68 00 02 00 00       	push   $0x200
80102e71:	50                   	push   %eax
80102e72:	8d 46 5c             	lea    0x5c(%esi),%eax
80102e75:	50                   	push   %eax
80102e76:	e8 f5 1f 00 00       	call   80104e70 <memmove>
    bwrite(to);  // write the log
80102e7b:	89 34 24             	mov    %esi,(%esp)
80102e7e:	e8 1d d3 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102e83:	89 3c 24             	mov    %edi,(%esp)
80102e86:	e8 55 d3 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102e8b:	89 34 24             	mov    %esi,(%esp)
80102e8e:	e8 4d d3 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102e93:	83 c4 10             	add    $0x10,%esp
80102e96:	3b 1d e8 46 11 80    	cmp    0x801146e8,%ebx
80102e9c:	7c 94                	jl     80102e32 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102e9e:	e8 bd fd ff ff       	call   80102c60 <write_head>
    install_trans(); // Now install writes to home locations
80102ea3:	e8 18 fd ff ff       	call   80102bc0 <install_trans>
    log.lh.n = 0;
80102ea8:	c7 05 e8 46 11 80 00 	movl   $0x0,0x801146e8
80102eaf:	00 00 00 
    write_head();    // Erase the transaction from the log
80102eb2:	e8 a9 fd ff ff       	call   80102c60 <write_head>
    acquire(&log.lock);
80102eb7:	83 ec 0c             	sub    $0xc,%esp
80102eba:	68 a0 46 11 80       	push   $0x801146a0
80102ebf:	e8 dc 1b 00 00       	call   80104aa0 <acquire>
    wakeup(&log);
80102ec4:	c7 04 24 a0 46 11 80 	movl   $0x801146a0,(%esp)
    log.committing = 0;
80102ecb:	c7 05 e0 46 11 80 00 	movl   $0x0,0x801146e0
80102ed2:	00 00 00 
    wakeup(&log);
80102ed5:	e8 b6 12 00 00       	call   80104190 <wakeup>
    release(&log.lock);
80102eda:	c7 04 24 a0 46 11 80 	movl   $0x801146a0,(%esp)
80102ee1:	e8 7a 1c 00 00       	call   80104b60 <release>
80102ee6:	83 c4 10             	add    $0x10,%esp
}
80102ee9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102eec:	5b                   	pop    %ebx
80102eed:	5e                   	pop    %esi
80102eee:	5f                   	pop    %edi
80102eef:	5d                   	pop    %ebp
80102ef0:	c3                   	ret    
80102ef1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80102ef8:	83 ec 0c             	sub    $0xc,%esp
80102efb:	68 a0 46 11 80       	push   $0x801146a0
80102f00:	e8 8b 12 00 00       	call   80104190 <wakeup>
  release(&log.lock);
80102f05:	c7 04 24 a0 46 11 80 	movl   $0x801146a0,(%esp)
80102f0c:	e8 4f 1c 00 00       	call   80104b60 <release>
80102f11:	83 c4 10             	add    $0x10,%esp
}
80102f14:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f17:	5b                   	pop    %ebx
80102f18:	5e                   	pop    %esi
80102f19:	5f                   	pop    %edi
80102f1a:	5d                   	pop    %ebp
80102f1b:	c3                   	ret    
    panic("log.committing");
80102f1c:	83 ec 0c             	sub    $0xc,%esp
80102f1f:	68 c4 86 10 80       	push   $0x801086c4
80102f24:	e8 67 d4 ff ff       	call   80100390 <panic>
80102f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102f30 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f30:	55                   	push   %ebp
80102f31:	89 e5                	mov    %esp,%ebp
80102f33:	53                   	push   %ebx
80102f34:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f37:	8b 15 e8 46 11 80    	mov    0x801146e8,%edx
{
80102f3d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f40:	83 fa 1d             	cmp    $0x1d,%edx
80102f43:	0f 8f 9d 00 00 00    	jg     80102fe6 <log_write+0xb6>
80102f49:	a1 d8 46 11 80       	mov    0x801146d8,%eax
80102f4e:	83 e8 01             	sub    $0x1,%eax
80102f51:	39 c2                	cmp    %eax,%edx
80102f53:	0f 8d 8d 00 00 00    	jge    80102fe6 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f59:	a1 dc 46 11 80       	mov    0x801146dc,%eax
80102f5e:	85 c0                	test   %eax,%eax
80102f60:	0f 8e 8d 00 00 00    	jle    80102ff3 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f66:	83 ec 0c             	sub    $0xc,%esp
80102f69:	68 a0 46 11 80       	push   $0x801146a0
80102f6e:	e8 2d 1b 00 00       	call   80104aa0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102f73:	8b 0d e8 46 11 80    	mov    0x801146e8,%ecx
80102f79:	83 c4 10             	add    $0x10,%esp
80102f7c:	83 f9 00             	cmp    $0x0,%ecx
80102f7f:	7e 57                	jle    80102fd8 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f81:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80102f84:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f86:	3b 15 ec 46 11 80    	cmp    0x801146ec,%edx
80102f8c:	75 0b                	jne    80102f99 <log_write+0x69>
80102f8e:	eb 38                	jmp    80102fc8 <log_write+0x98>
80102f90:	39 14 85 ec 46 11 80 	cmp    %edx,-0x7feeb914(,%eax,4)
80102f97:	74 2f                	je     80102fc8 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102f99:	83 c0 01             	add    $0x1,%eax
80102f9c:	39 c1                	cmp    %eax,%ecx
80102f9e:	75 f0                	jne    80102f90 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102fa0:	89 14 85 ec 46 11 80 	mov    %edx,-0x7feeb914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80102fa7:	83 c0 01             	add    $0x1,%eax
80102faa:	a3 e8 46 11 80       	mov    %eax,0x801146e8
  b->flags |= B_DIRTY; // prevent eviction
80102faf:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102fb2:	c7 45 08 a0 46 11 80 	movl   $0x801146a0,0x8(%ebp)
}
80102fb9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102fbc:	c9                   	leave  
  release(&log.lock);
80102fbd:	e9 9e 1b 00 00       	jmp    80104b60 <release>
80102fc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102fc8:	89 14 85 ec 46 11 80 	mov    %edx,-0x7feeb914(,%eax,4)
80102fcf:	eb de                	jmp    80102faf <log_write+0x7f>
80102fd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fd8:	8b 43 08             	mov    0x8(%ebx),%eax
80102fdb:	a3 ec 46 11 80       	mov    %eax,0x801146ec
  if (i == log.lh.n)
80102fe0:	75 cd                	jne    80102faf <log_write+0x7f>
80102fe2:	31 c0                	xor    %eax,%eax
80102fe4:	eb c1                	jmp    80102fa7 <log_write+0x77>
    panic("too big a transaction");
80102fe6:	83 ec 0c             	sub    $0xc,%esp
80102fe9:	68 d3 86 10 80       	push   $0x801086d3
80102fee:	e8 9d d3 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102ff3:	83 ec 0c             	sub    $0xc,%esp
80102ff6:	68 e9 86 10 80       	push   $0x801086e9
80102ffb:	e8 90 d3 ff ff       	call   80100390 <panic>

80103000 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103000:	55                   	push   %ebp
80103001:	89 e5                	mov    %esp,%ebp
80103003:	53                   	push   %ebx
80103004:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103007:	e8 94 09 00 00       	call   801039a0 <cpuid>
8010300c:	89 c3                	mov    %eax,%ebx
8010300e:	e8 8d 09 00 00       	call   801039a0 <cpuid>
80103013:	83 ec 04             	sub    $0x4,%esp
80103016:	53                   	push   %ebx
80103017:	50                   	push   %eax
80103018:	68 04 87 10 80       	push   $0x80108704
8010301d:	e8 ce d6 ff ff       	call   801006f0 <cprintf>
  idtinit();       // load idt register
80103022:	e8 19 3a 00 00       	call   80106a40 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103027:	e8 f4 08 00 00       	call   80103920 <mycpu>
8010302c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010302e:	b8 01 00 00 00       	mov    $0x1,%eax
80103033:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010303a:	e8 41 0c 00 00       	call   80103c80 <scheduler>
8010303f:	90                   	nop

80103040 <mpenter>:
{
80103040:	55                   	push   %ebp
80103041:	89 e5                	mov    %esp,%ebp
80103043:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103046:	e8 e5 4a 00 00       	call   80107b30 <switchkvm>
  seginit();
8010304b:	e8 50 4a 00 00       	call   80107aa0 <seginit>
  lapicinit();
80103050:	e8 9b f7 ff ff       	call   801027f0 <lapicinit>
  mpmain();
80103055:	e8 a6 ff ff ff       	call   80103000 <mpmain>
8010305a:	66 90                	xchg   %ax,%ax
8010305c:	66 90                	xchg   %ax,%ax
8010305e:	66 90                	xchg   %ax,%ax

80103060 <main>:
{
80103060:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103064:	83 e4 f0             	and    $0xfffffff0,%esp
80103067:	ff 71 fc             	pushl  -0x4(%ecx)
8010306a:	55                   	push   %ebp
8010306b:	89 e5                	mov    %esp,%ebp
8010306d:	53                   	push   %ebx
8010306e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010306f:	83 ec 08             	sub    $0x8,%esp
80103072:	68 00 00 40 80       	push   $0x80400000
80103077:	68 e8 ed 12 80       	push   $0x8012ede8
8010307c:	e8 2f f5 ff ff       	call   801025b0 <kinit1>
  kvmalloc();      // kernel page table
80103081:	e8 7a 4f 00 00       	call   80108000 <kvmalloc>
  mpinit();        // detect other processors
80103086:	e8 75 01 00 00       	call   80103200 <mpinit>
  lapicinit();     // interrupt controller
8010308b:	e8 60 f7 ff ff       	call   801027f0 <lapicinit>
  seginit();       // segment descriptors
80103090:	e8 0b 4a 00 00       	call   80107aa0 <seginit>
  picinit();       // disable pic
80103095:	e8 46 03 00 00       	call   801033e0 <picinit>
  ioapicinit();    // another interrupt controller
8010309a:	e8 41 f3 ff ff       	call   801023e0 <ioapicinit>
  consoleinit();   // console hardware
8010309f:	e8 cc da ff ff       	call   80100b70 <consoleinit>
  uartinit();      // serial port
801030a4:	e8 c7 3c 00 00       	call   80106d70 <uartinit>
  pinit();         // process table
801030a9:	e8 52 08 00 00       	call   80103900 <pinit>
  tvinit();        // trap vectors
801030ae:	e8 0d 39 00 00       	call   801069c0 <tvinit>
  binit();         // buffer cache
801030b3:	e8 88 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
801030b8:	e8 53 de ff ff       	call   80100f10 <fileinit>
  ideinit();       // disk 
801030bd:	e8 fe f0 ff ff       	call   801021c0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801030c2:	83 c4 0c             	add    $0xc,%esp
801030c5:	68 8a 00 00 00       	push   $0x8a
801030ca:	68 8c c4 10 80       	push   $0x8010c48c
801030cf:	68 00 70 00 80       	push   $0x80007000
801030d4:	e8 97 1d 00 00       	call   80104e70 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801030d9:	69 05 20 4d 11 80 b0 	imul   $0xb0,0x80114d20,%eax
801030e0:	00 00 00 
801030e3:	83 c4 10             	add    $0x10,%esp
801030e6:	05 a0 47 11 80       	add    $0x801147a0,%eax
801030eb:	3d a0 47 11 80       	cmp    $0x801147a0,%eax
801030f0:	76 71                	jbe    80103163 <main+0x103>
801030f2:	bb a0 47 11 80       	mov    $0x801147a0,%ebx
801030f7:	89 f6                	mov    %esi,%esi
801030f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
80103100:	e8 1b 08 00 00       	call   80103920 <mycpu>
80103105:	39 d8                	cmp    %ebx,%eax
80103107:	74 41                	je     8010314a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103109:	e8 72 f5 ff ff       	call   80102680 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
8010310e:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
80103113:	c7 05 f8 6f 00 80 40 	movl   $0x80103040,0x80006ff8
8010311a:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
8010311d:	c7 05 f4 6f 00 80 00 	movl   $0x10b000,0x80006ff4
80103124:	b0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80103127:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
8010312c:	0f b6 03             	movzbl (%ebx),%eax
8010312f:	83 ec 08             	sub    $0x8,%esp
80103132:	68 00 70 00 00       	push   $0x7000
80103137:	50                   	push   %eax
80103138:	e8 03 f8 ff ff       	call   80102940 <lapicstartap>
8010313d:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103140:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103146:	85 c0                	test   %eax,%eax
80103148:	74 f6                	je     80103140 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
8010314a:	69 05 20 4d 11 80 b0 	imul   $0xb0,0x80114d20,%eax
80103151:	00 00 00 
80103154:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
8010315a:	05 a0 47 11 80       	add    $0x801147a0,%eax
8010315f:	39 c3                	cmp    %eax,%ebx
80103161:	72 9d                	jb     80103100 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103163:	83 ec 08             	sub    $0x8,%esp
80103166:	68 00 00 00 8e       	push   $0x8e000000
8010316b:	68 00 00 40 80       	push   $0x80400000
80103170:	e8 ab f4 ff ff       	call   80102620 <kinit2>
  userinit();      // first user process
80103175:	e8 76 08 00 00       	call   801039f0 <userinit>
  mpmain();        // finish this processor's setup
8010317a:	e8 81 fe ff ff       	call   80103000 <mpmain>
8010317f:	90                   	nop

80103180 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103180:	55                   	push   %ebp
80103181:	89 e5                	mov    %esp,%ebp
80103183:	57                   	push   %edi
80103184:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103185:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010318b:	53                   	push   %ebx
  e = addr+len;
8010318c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010318f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103192:	39 de                	cmp    %ebx,%esi
80103194:	72 10                	jb     801031a6 <mpsearch1+0x26>
80103196:	eb 50                	jmp    801031e8 <mpsearch1+0x68>
80103198:	90                   	nop
80103199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031a0:	39 fb                	cmp    %edi,%ebx
801031a2:	89 fe                	mov    %edi,%esi
801031a4:	76 42                	jbe    801031e8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031a6:	83 ec 04             	sub    $0x4,%esp
801031a9:	8d 7e 10             	lea    0x10(%esi),%edi
801031ac:	6a 04                	push   $0x4
801031ae:	68 18 87 10 80       	push   $0x80108718
801031b3:	56                   	push   %esi
801031b4:	e8 57 1c 00 00       	call   80104e10 <memcmp>
801031b9:	83 c4 10             	add    $0x10,%esp
801031bc:	85 c0                	test   %eax,%eax
801031be:	75 e0                	jne    801031a0 <mpsearch1+0x20>
801031c0:	89 f1                	mov    %esi,%ecx
801031c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801031c8:	0f b6 11             	movzbl (%ecx),%edx
801031cb:	83 c1 01             	add    $0x1,%ecx
801031ce:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
801031d0:	39 f9                	cmp    %edi,%ecx
801031d2:	75 f4                	jne    801031c8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031d4:	84 c0                	test   %al,%al
801031d6:	75 c8                	jne    801031a0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801031d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031db:	89 f0                	mov    %esi,%eax
801031dd:	5b                   	pop    %ebx
801031de:	5e                   	pop    %esi
801031df:	5f                   	pop    %edi
801031e0:	5d                   	pop    %ebp
801031e1:	c3                   	ret    
801031e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801031e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801031eb:	31 f6                	xor    %esi,%esi
}
801031ed:	89 f0                	mov    %esi,%eax
801031ef:	5b                   	pop    %ebx
801031f0:	5e                   	pop    %esi
801031f1:	5f                   	pop    %edi
801031f2:	5d                   	pop    %ebp
801031f3:	c3                   	ret    
801031f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801031fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103200 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103200:	55                   	push   %ebp
80103201:	89 e5                	mov    %esp,%ebp
80103203:	57                   	push   %edi
80103204:	56                   	push   %esi
80103205:	53                   	push   %ebx
80103206:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103209:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103210:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103217:	c1 e0 08             	shl    $0x8,%eax
8010321a:	09 d0                	or     %edx,%eax
8010321c:	c1 e0 04             	shl    $0x4,%eax
8010321f:	85 c0                	test   %eax,%eax
80103221:	75 1b                	jne    8010323e <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103223:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010322a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103231:	c1 e0 08             	shl    $0x8,%eax
80103234:	09 d0                	or     %edx,%eax
80103236:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103239:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010323e:	ba 00 04 00 00       	mov    $0x400,%edx
80103243:	e8 38 ff ff ff       	call   80103180 <mpsearch1>
80103248:	85 c0                	test   %eax,%eax
8010324a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010324d:	0f 84 3d 01 00 00    	je     80103390 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103253:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103256:	8b 58 04             	mov    0x4(%eax),%ebx
80103259:	85 db                	test   %ebx,%ebx
8010325b:	0f 84 4f 01 00 00    	je     801033b0 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103261:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103267:	83 ec 04             	sub    $0x4,%esp
8010326a:	6a 04                	push   $0x4
8010326c:	68 35 87 10 80       	push   $0x80108735
80103271:	56                   	push   %esi
80103272:	e8 99 1b 00 00       	call   80104e10 <memcmp>
80103277:	83 c4 10             	add    $0x10,%esp
8010327a:	85 c0                	test   %eax,%eax
8010327c:	0f 85 2e 01 00 00    	jne    801033b0 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
80103282:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103289:	3c 01                	cmp    $0x1,%al
8010328b:	0f 95 c2             	setne  %dl
8010328e:	3c 04                	cmp    $0x4,%al
80103290:	0f 95 c0             	setne  %al
80103293:	20 c2                	and    %al,%dl
80103295:	0f 85 15 01 00 00    	jne    801033b0 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
8010329b:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
801032a2:	66 85 ff             	test   %di,%di
801032a5:	74 1a                	je     801032c1 <mpinit+0xc1>
801032a7:	89 f0                	mov    %esi,%eax
801032a9:	01 f7                	add    %esi,%edi
  sum = 0;
801032ab:	31 d2                	xor    %edx,%edx
801032ad:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801032b0:	0f b6 08             	movzbl (%eax),%ecx
801032b3:	83 c0 01             	add    $0x1,%eax
801032b6:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801032b8:	39 c7                	cmp    %eax,%edi
801032ba:	75 f4                	jne    801032b0 <mpinit+0xb0>
801032bc:	84 d2                	test   %dl,%dl
801032be:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
801032c1:	85 f6                	test   %esi,%esi
801032c3:	0f 84 e7 00 00 00    	je     801033b0 <mpinit+0x1b0>
801032c9:	84 d2                	test   %dl,%dl
801032cb:	0f 85 df 00 00 00    	jne    801033b0 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801032d1:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801032d7:	a3 9c 46 11 80       	mov    %eax,0x8011469c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032dc:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
801032e3:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
801032e9:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032ee:	01 d6                	add    %edx,%esi
801032f0:	39 c6                	cmp    %eax,%esi
801032f2:	76 23                	jbe    80103317 <mpinit+0x117>
    switch(*p){
801032f4:	0f b6 10             	movzbl (%eax),%edx
801032f7:	80 fa 04             	cmp    $0x4,%dl
801032fa:	0f 87 ca 00 00 00    	ja     801033ca <mpinit+0x1ca>
80103300:	ff 24 95 5c 87 10 80 	jmp    *-0x7fef78a4(,%edx,4)
80103307:	89 f6                	mov    %esi,%esi
80103309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103310:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103313:	39 c6                	cmp    %eax,%esi
80103315:	77 dd                	ja     801032f4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103317:	85 db                	test   %ebx,%ebx
80103319:	0f 84 9e 00 00 00    	je     801033bd <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010331f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103322:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103326:	74 15                	je     8010333d <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103328:	b8 70 00 00 00       	mov    $0x70,%eax
8010332d:	ba 22 00 00 00       	mov    $0x22,%edx
80103332:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103333:	ba 23 00 00 00       	mov    $0x23,%edx
80103338:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103339:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010333c:	ee                   	out    %al,(%dx)
  }
}
8010333d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103340:	5b                   	pop    %ebx
80103341:	5e                   	pop    %esi
80103342:	5f                   	pop    %edi
80103343:	5d                   	pop    %ebp
80103344:	c3                   	ret    
80103345:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
80103348:	8b 0d 20 4d 11 80    	mov    0x80114d20,%ecx
8010334e:	83 f9 07             	cmp    $0x7,%ecx
80103351:	7f 19                	jg     8010336c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103353:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103357:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010335d:	83 c1 01             	add    $0x1,%ecx
80103360:	89 0d 20 4d 11 80    	mov    %ecx,0x80114d20
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103366:	88 97 a0 47 11 80    	mov    %dl,-0x7feeb860(%edi)
      p += sizeof(struct mpproc);
8010336c:	83 c0 14             	add    $0x14,%eax
      continue;
8010336f:	e9 7c ff ff ff       	jmp    801032f0 <mpinit+0xf0>
80103374:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103378:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010337c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010337f:	88 15 80 47 11 80    	mov    %dl,0x80114780
      continue;
80103385:	e9 66 ff ff ff       	jmp    801032f0 <mpinit+0xf0>
8010338a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
80103390:	ba 00 00 01 00       	mov    $0x10000,%edx
80103395:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010339a:	e8 e1 fd ff ff       	call   80103180 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010339f:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
801033a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801033a4:	0f 85 a9 fe ff ff    	jne    80103253 <mpinit+0x53>
801033aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
801033b0:	83 ec 0c             	sub    $0xc,%esp
801033b3:	68 1d 87 10 80       	push   $0x8010871d
801033b8:	e8 d3 cf ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
801033bd:	83 ec 0c             	sub    $0xc,%esp
801033c0:	68 3c 87 10 80       	push   $0x8010873c
801033c5:	e8 c6 cf ff ff       	call   80100390 <panic>
      ismp = 0;
801033ca:	31 db                	xor    %ebx,%ebx
801033cc:	e9 26 ff ff ff       	jmp    801032f7 <mpinit+0xf7>
801033d1:	66 90                	xchg   %ax,%ax
801033d3:	66 90                	xchg   %ax,%ax
801033d5:	66 90                	xchg   %ax,%ax
801033d7:	66 90                	xchg   %ax,%ax
801033d9:	66 90                	xchg   %ax,%ax
801033db:	66 90                	xchg   %ax,%ax
801033dd:	66 90                	xchg   %ax,%ax
801033df:	90                   	nop

801033e0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801033e0:	55                   	push   %ebp
801033e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801033e6:	ba 21 00 00 00       	mov    $0x21,%edx
801033eb:	89 e5                	mov    %esp,%ebp
801033ed:	ee                   	out    %al,(%dx)
801033ee:	ba a1 00 00 00       	mov    $0xa1,%edx
801033f3:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801033f4:	5d                   	pop    %ebp
801033f5:	c3                   	ret    
801033f6:	66 90                	xchg   %ax,%ax
801033f8:	66 90                	xchg   %ax,%ax
801033fa:	66 90                	xchg   %ax,%ax
801033fc:	66 90                	xchg   %ax,%ax
801033fe:	66 90                	xchg   %ax,%ax

80103400 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103400:	55                   	push   %ebp
80103401:	89 e5                	mov    %esp,%ebp
80103403:	57                   	push   %edi
80103404:	56                   	push   %esi
80103405:	53                   	push   %ebx
80103406:	83 ec 0c             	sub    $0xc,%esp
80103409:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010340c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010340f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103415:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010341b:	e8 10 db ff ff       	call   80100f30 <filealloc>
80103420:	85 c0                	test   %eax,%eax
80103422:	89 03                	mov    %eax,(%ebx)
80103424:	74 22                	je     80103448 <pipealloc+0x48>
80103426:	e8 05 db ff ff       	call   80100f30 <filealloc>
8010342b:	85 c0                	test   %eax,%eax
8010342d:	89 06                	mov    %eax,(%esi)
8010342f:	74 3f                	je     80103470 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103431:	e8 4a f2 ff ff       	call   80102680 <kalloc>
80103436:	85 c0                	test   %eax,%eax
80103438:	89 c7                	mov    %eax,%edi
8010343a:	75 54                	jne    80103490 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
8010343c:	8b 03                	mov    (%ebx),%eax
8010343e:	85 c0                	test   %eax,%eax
80103440:	75 34                	jne    80103476 <pipealloc+0x76>
80103442:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
80103448:	8b 06                	mov    (%esi),%eax
8010344a:	85 c0                	test   %eax,%eax
8010344c:	74 0c                	je     8010345a <pipealloc+0x5a>
    fileclose(*f1);
8010344e:	83 ec 0c             	sub    $0xc,%esp
80103451:	50                   	push   %eax
80103452:	e8 99 db ff ff       	call   80100ff0 <fileclose>
80103457:	83 c4 10             	add    $0x10,%esp
  return -1;
}
8010345a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010345d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103462:	5b                   	pop    %ebx
80103463:	5e                   	pop    %esi
80103464:	5f                   	pop    %edi
80103465:	5d                   	pop    %ebp
80103466:	c3                   	ret    
80103467:	89 f6                	mov    %esi,%esi
80103469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
80103470:	8b 03                	mov    (%ebx),%eax
80103472:	85 c0                	test   %eax,%eax
80103474:	74 e4                	je     8010345a <pipealloc+0x5a>
    fileclose(*f0);
80103476:	83 ec 0c             	sub    $0xc,%esp
80103479:	50                   	push   %eax
8010347a:	e8 71 db ff ff       	call   80100ff0 <fileclose>
  if(*f1)
8010347f:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
80103481:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103484:	85 c0                	test   %eax,%eax
80103486:	75 c6                	jne    8010344e <pipealloc+0x4e>
80103488:	eb d0                	jmp    8010345a <pipealloc+0x5a>
8010348a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
80103490:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
80103493:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010349a:	00 00 00 
  p->writeopen = 1;
8010349d:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801034a4:	00 00 00 
  p->nwrite = 0;
801034a7:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801034ae:	00 00 00 
  p->nread = 0;
801034b1:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801034b8:	00 00 00 
  initlock(&p->lock, "pipe");
801034bb:	68 49 8b 10 80       	push   $0x80108b49
801034c0:	50                   	push   %eax
801034c1:	e8 9a 14 00 00       	call   80104960 <initlock>
  (*f0)->type = FD_PIPE;
801034c6:	8b 03                	mov    (%ebx),%eax
  return 0;
801034c8:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801034cb:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801034d1:	8b 03                	mov    (%ebx),%eax
801034d3:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801034d7:	8b 03                	mov    (%ebx),%eax
801034d9:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801034dd:	8b 03                	mov    (%ebx),%eax
801034df:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801034e2:	8b 06                	mov    (%esi),%eax
801034e4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801034ea:	8b 06                	mov    (%esi),%eax
801034ec:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801034f0:	8b 06                	mov    (%esi),%eax
801034f2:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801034f6:	8b 06                	mov    (%esi),%eax
801034f8:	89 78 0c             	mov    %edi,0xc(%eax)
}
801034fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801034fe:	31 c0                	xor    %eax,%eax
}
80103500:	5b                   	pop    %ebx
80103501:	5e                   	pop    %esi
80103502:	5f                   	pop    %edi
80103503:	5d                   	pop    %ebp
80103504:	c3                   	ret    
80103505:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103510 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103510:	55                   	push   %ebp
80103511:	89 e5                	mov    %esp,%ebp
80103513:	56                   	push   %esi
80103514:	53                   	push   %ebx
80103515:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103518:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010351b:	83 ec 0c             	sub    $0xc,%esp
8010351e:	53                   	push   %ebx
8010351f:	e8 7c 15 00 00       	call   80104aa0 <acquire>
  if(writable){
80103524:	83 c4 10             	add    $0x10,%esp
80103527:	85 f6                	test   %esi,%esi
80103529:	74 45                	je     80103570 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010352b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103531:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
80103534:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010353b:	00 00 00 
    wakeup(&p->nread);
8010353e:	50                   	push   %eax
8010353f:	e8 4c 0c 00 00       	call   80104190 <wakeup>
80103544:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103547:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010354d:	85 d2                	test   %edx,%edx
8010354f:	75 0a                	jne    8010355b <pipeclose+0x4b>
80103551:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103557:	85 c0                	test   %eax,%eax
80103559:	74 35                	je     80103590 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010355b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010355e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103561:	5b                   	pop    %ebx
80103562:	5e                   	pop    %esi
80103563:	5d                   	pop    %ebp
    release(&p->lock);
80103564:	e9 f7 15 00 00       	jmp    80104b60 <release>
80103569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103570:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103576:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
80103579:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103580:	00 00 00 
    wakeup(&p->nwrite);
80103583:	50                   	push   %eax
80103584:	e8 07 0c 00 00       	call   80104190 <wakeup>
80103589:	83 c4 10             	add    $0x10,%esp
8010358c:	eb b9                	jmp    80103547 <pipeclose+0x37>
8010358e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103590:	83 ec 0c             	sub    $0xc,%esp
80103593:	53                   	push   %ebx
80103594:	e8 c7 15 00 00       	call   80104b60 <release>
    kfree((char*)p);
80103599:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010359c:	83 c4 10             	add    $0x10,%esp
}
8010359f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035a2:	5b                   	pop    %ebx
801035a3:	5e                   	pop    %esi
801035a4:	5d                   	pop    %ebp
    kfree((char*)p);
801035a5:	e9 26 ef ff ff       	jmp    801024d0 <kfree>
801035aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801035b0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801035b0:	55                   	push   %ebp
801035b1:	89 e5                	mov    %esp,%ebp
801035b3:	57                   	push   %edi
801035b4:	56                   	push   %esi
801035b5:	53                   	push   %ebx
801035b6:	83 ec 28             	sub    $0x28,%esp
801035b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801035bc:	53                   	push   %ebx
801035bd:	e8 de 14 00 00       	call   80104aa0 <acquire>
  for(i = 0; i < n; i++){
801035c2:	8b 45 10             	mov    0x10(%ebp),%eax
801035c5:	83 c4 10             	add    $0x10,%esp
801035c8:	85 c0                	test   %eax,%eax
801035ca:	0f 8e c9 00 00 00    	jle    80103699 <pipewrite+0xe9>
801035d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801035d3:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801035d9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801035df:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801035e2:	03 4d 10             	add    0x10(%ebp),%ecx
801035e5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035e8:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
801035ee:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
801035f4:	39 d0                	cmp    %edx,%eax
801035f6:	75 71                	jne    80103669 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
801035f8:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801035fe:	85 c0                	test   %eax,%eax
80103600:	74 4e                	je     80103650 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103602:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103608:	eb 3a                	jmp    80103644 <pipewrite+0x94>
8010360a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103610:	83 ec 0c             	sub    $0xc,%esp
80103613:	57                   	push   %edi
80103614:	e8 77 0b 00 00       	call   80104190 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103619:	5a                   	pop    %edx
8010361a:	59                   	pop    %ecx
8010361b:	53                   	push   %ebx
8010361c:	56                   	push   %esi
8010361d:	e8 ae 09 00 00       	call   80103fd0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103622:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103628:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010362e:	83 c4 10             	add    $0x10,%esp
80103631:	05 00 02 00 00       	add    $0x200,%eax
80103636:	39 c2                	cmp    %eax,%edx
80103638:	75 36                	jne    80103670 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
8010363a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103640:	85 c0                	test   %eax,%eax
80103642:	74 0c                	je     80103650 <pipewrite+0xa0>
80103644:	e8 77 03 00 00       	call   801039c0 <myproc>
80103649:	8b 40 24             	mov    0x24(%eax),%eax
8010364c:	85 c0                	test   %eax,%eax
8010364e:	74 c0                	je     80103610 <pipewrite+0x60>
        release(&p->lock);
80103650:	83 ec 0c             	sub    $0xc,%esp
80103653:	53                   	push   %ebx
80103654:	e8 07 15 00 00       	call   80104b60 <release>
        return -1;
80103659:	83 c4 10             	add    $0x10,%esp
8010365c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103661:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103664:	5b                   	pop    %ebx
80103665:	5e                   	pop    %esi
80103666:	5f                   	pop    %edi
80103667:	5d                   	pop    %ebp
80103668:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103669:	89 c2                	mov    %eax,%edx
8010366b:	90                   	nop
8010366c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103670:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103673:	8d 42 01             	lea    0x1(%edx),%eax
80103676:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
8010367c:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103682:	83 c6 01             	add    $0x1,%esi
80103685:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
80103689:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010368c:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010368f:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103693:	0f 85 4f ff ff ff    	jne    801035e8 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103699:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010369f:	83 ec 0c             	sub    $0xc,%esp
801036a2:	50                   	push   %eax
801036a3:	e8 e8 0a 00 00       	call   80104190 <wakeup>
  release(&p->lock);
801036a8:	89 1c 24             	mov    %ebx,(%esp)
801036ab:	e8 b0 14 00 00       	call   80104b60 <release>
  return n;
801036b0:	83 c4 10             	add    $0x10,%esp
801036b3:	8b 45 10             	mov    0x10(%ebp),%eax
801036b6:	eb a9                	jmp    80103661 <pipewrite+0xb1>
801036b8:	90                   	nop
801036b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801036c0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801036c0:	55                   	push   %ebp
801036c1:	89 e5                	mov    %esp,%ebp
801036c3:	57                   	push   %edi
801036c4:	56                   	push   %esi
801036c5:	53                   	push   %ebx
801036c6:	83 ec 18             	sub    $0x18,%esp
801036c9:	8b 75 08             	mov    0x8(%ebp),%esi
801036cc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801036cf:	56                   	push   %esi
801036d0:	e8 cb 13 00 00       	call   80104aa0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036d5:	83 c4 10             	add    $0x10,%esp
801036d8:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801036de:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801036e4:	75 6a                	jne    80103750 <piperead+0x90>
801036e6:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
801036ec:	85 db                	test   %ebx,%ebx
801036ee:	0f 84 c4 00 00 00    	je     801037b8 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801036f4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801036fa:	eb 2d                	jmp    80103729 <piperead+0x69>
801036fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103700:	83 ec 08             	sub    $0x8,%esp
80103703:	56                   	push   %esi
80103704:	53                   	push   %ebx
80103705:	e8 c6 08 00 00       	call   80103fd0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010370a:	83 c4 10             	add    $0x10,%esp
8010370d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103713:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103719:	75 35                	jne    80103750 <piperead+0x90>
8010371b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103721:	85 d2                	test   %edx,%edx
80103723:	0f 84 8f 00 00 00    	je     801037b8 <piperead+0xf8>
    if(myproc()->killed){
80103729:	e8 92 02 00 00       	call   801039c0 <myproc>
8010372e:	8b 48 24             	mov    0x24(%eax),%ecx
80103731:	85 c9                	test   %ecx,%ecx
80103733:	74 cb                	je     80103700 <piperead+0x40>
      release(&p->lock);
80103735:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103738:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
8010373d:	56                   	push   %esi
8010373e:	e8 1d 14 00 00       	call   80104b60 <release>
      return -1;
80103743:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103746:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103749:	89 d8                	mov    %ebx,%eax
8010374b:	5b                   	pop    %ebx
8010374c:	5e                   	pop    %esi
8010374d:	5f                   	pop    %edi
8010374e:	5d                   	pop    %ebp
8010374f:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103750:	8b 45 10             	mov    0x10(%ebp),%eax
80103753:	85 c0                	test   %eax,%eax
80103755:	7e 61                	jle    801037b8 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103757:	31 db                	xor    %ebx,%ebx
80103759:	eb 13                	jmp    8010376e <piperead+0xae>
8010375b:	90                   	nop
8010375c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103760:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103766:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
8010376c:	74 1f                	je     8010378d <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
8010376e:	8d 41 01             	lea    0x1(%ecx),%eax
80103771:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80103777:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
8010377d:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103782:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103785:	83 c3 01             	add    $0x1,%ebx
80103788:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010378b:	75 d3                	jne    80103760 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010378d:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103793:	83 ec 0c             	sub    $0xc,%esp
80103796:	50                   	push   %eax
80103797:	e8 f4 09 00 00       	call   80104190 <wakeup>
  release(&p->lock);
8010379c:	89 34 24             	mov    %esi,(%esp)
8010379f:	e8 bc 13 00 00       	call   80104b60 <release>
  return i;
801037a4:	83 c4 10             	add    $0x10,%esp
}
801037a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037aa:	89 d8                	mov    %ebx,%eax
801037ac:	5b                   	pop    %ebx
801037ad:	5e                   	pop    %esi
801037ae:	5f                   	pop    %edi
801037af:	5d                   	pop    %ebp
801037b0:	c3                   	ret    
801037b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801037b8:	31 db                	xor    %ebx,%ebx
801037ba:	eb d1                	jmp    8010378d <piperead+0xcd>
801037bc:	66 90                	xchg   %ax,%ax
801037be:	66 90                	xchg   %ax,%ax

801037c0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801037c0:	55                   	push   %ebp
801037c1:	89 e5                	mov    %esp,%ebp
801037c3:	53                   	push   %ebx
  char *sp;
  int i;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037c4:	bb 74 4d 11 80       	mov    $0x80114d74,%ebx
{
801037c9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801037cc:	68 40 4d 11 80       	push   $0x80114d40
801037d1:	e8 ca 12 00 00       	call   80104aa0 <acquire>
801037d6:	83 c4 10             	add    $0x10,%esp
801037d9:	eb 17                	jmp    801037f2 <allocproc+0x32>
801037db:	90                   	nop
801037dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037e0:	81 c3 60 06 00 00    	add    $0x660,%ebx
801037e6:	81 fb 74 e5 12 80    	cmp    $0x8012e574,%ebx
801037ec:	0f 83 90 00 00 00    	jae    80103882 <allocproc+0xc2>
    if(p->state == UNUSED)
801037f2:	8b 43 0c             	mov    0xc(%ebx),%eax
801037f5:	85 c0                	test   %eax,%eax
801037f7:	75 e7                	jne    801037e0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801037f9:	a1 04 c0 10 80       	mov    0x8010c004,%eax
  p->state = EMBRYO;
801037fe:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103805:	8d 50 01             	lea    0x1(%eax),%edx
80103808:	89 43 10             	mov    %eax,0x10(%ebx)
8010380b:	8d 43 7c             	lea    0x7c(%ebx),%eax
8010380e:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
80103814:	8d 93 60 06 00 00    	lea    0x660(%ebx),%edx
8010381a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for (i = 0; i < 29; ++i)
  {
    p->syscalls[i].count = 0;
80103820:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103826:	83 c0 34             	add    $0x34,%eax
  for (i = 0; i < 29; ++i)
80103829:	39 c2                	cmp    %eax,%edx
8010382b:	75 f3                	jne    80103820 <allocproc+0x60>
  }

  release(&ptable.lock);
8010382d:	83 ec 0c             	sub    $0xc,%esp
80103830:	68 40 4d 11 80       	push   $0x80114d40
80103835:	e8 26 13 00 00       	call   80104b60 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010383a:	e8 41 ee ff ff       	call   80102680 <kalloc>
8010383f:	83 c4 10             	add    $0x10,%esp
80103842:	85 c0                	test   %eax,%eax
80103844:	89 43 08             	mov    %eax,0x8(%ebx)
80103847:	74 52                	je     8010389b <allocproc+0xdb>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103849:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010384f:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103852:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103857:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
8010385a:	c7 40 14 a7 69 10 80 	movl   $0x801069a7,0x14(%eax)
  p->context = (struct context*)sp;
80103861:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103864:	6a 14                	push   $0x14
80103866:	6a 00                	push   $0x0
80103868:	50                   	push   %eax
80103869:	e8 52 15 00 00       	call   80104dc0 <memset>
  p->context->eip = (uint)forkret;
8010386e:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103871:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103874:	c7 40 10 b0 38 10 80 	movl   $0x801038b0,0x10(%eax)
}
8010387b:	89 d8                	mov    %ebx,%eax
8010387d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103880:	c9                   	leave  
80103881:	c3                   	ret    
  release(&ptable.lock);
80103882:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103885:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103887:	68 40 4d 11 80       	push   $0x80114d40
8010388c:	e8 cf 12 00 00       	call   80104b60 <release>
}
80103891:	89 d8                	mov    %ebx,%eax
  return 0;
80103893:	83 c4 10             	add    $0x10,%esp
}
80103896:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103899:	c9                   	leave  
8010389a:	c3                   	ret    
    p->state = UNUSED;
8010389b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801038a2:	31 db                	xor    %ebx,%ebx
801038a4:	eb d5                	jmp    8010387b <allocproc+0xbb>
801038a6:	8d 76 00             	lea    0x0(%esi),%esi
801038a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801038b0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801038b0:	55                   	push   %ebp
801038b1:	89 e5                	mov    %esp,%ebp
801038b3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801038b6:	68 40 4d 11 80       	push   $0x80114d40
801038bb:	e8 a0 12 00 00       	call   80104b60 <release>

  if (first) {
801038c0:	a1 00 c0 10 80       	mov    0x8010c000,%eax
801038c5:	83 c4 10             	add    $0x10,%esp
801038c8:	85 c0                	test   %eax,%eax
801038ca:	75 04                	jne    801038d0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801038cc:	c9                   	leave  
801038cd:	c3                   	ret    
801038ce:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
801038d0:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
801038d3:	c7 05 00 c0 10 80 00 	movl   $0x0,0x8010c000
801038da:	00 00 00 
    iinit(ROOTDEV);
801038dd:	6a 01                	push   $0x1
801038df:	e8 5c dd ff ff       	call   80101640 <iinit>
    initlog(ROOTDEV);
801038e4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801038eb:	e8 d0 f3 ff ff       	call   80102cc0 <initlog>
801038f0:	83 c4 10             	add    $0x10,%esp
}
801038f3:	c9                   	leave  
801038f4:	c3                   	ret    
801038f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801038f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103900 <pinit>:
{
80103900:	55                   	push   %ebp
80103901:	89 e5                	mov    %esp,%ebp
80103903:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103906:	68 70 87 10 80       	push   $0x80108770
8010390b:	68 40 4d 11 80       	push   $0x80114d40
80103910:	e8 4b 10 00 00       	call   80104960 <initlock>
}
80103915:	83 c4 10             	add    $0x10,%esp
80103918:	c9                   	leave  
80103919:	c3                   	ret    
8010391a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103920 <mycpu>:
{
80103920:	55                   	push   %ebp
80103921:	89 e5                	mov    %esp,%ebp
80103923:	56                   	push   %esi
80103924:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103925:	9c                   	pushf  
80103926:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103927:	f6 c4 02             	test   $0x2,%ah
8010392a:	75 5e                	jne    8010398a <mycpu+0x6a>
  apicid = lapicid();
8010392c:	e8 bf ef ff ff       	call   801028f0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103931:	8b 35 20 4d 11 80    	mov    0x80114d20,%esi
80103937:	85 f6                	test   %esi,%esi
80103939:	7e 42                	jle    8010397d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
8010393b:	0f b6 15 a0 47 11 80 	movzbl 0x801147a0,%edx
80103942:	39 d0                	cmp    %edx,%eax
80103944:	74 30                	je     80103976 <mycpu+0x56>
80103946:	b9 50 48 11 80       	mov    $0x80114850,%ecx
  for (i = 0; i < ncpu; ++i) {
8010394b:	31 d2                	xor    %edx,%edx
8010394d:	8d 76 00             	lea    0x0(%esi),%esi
80103950:	83 c2 01             	add    $0x1,%edx
80103953:	39 f2                	cmp    %esi,%edx
80103955:	74 26                	je     8010397d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103957:	0f b6 19             	movzbl (%ecx),%ebx
8010395a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103960:	39 c3                	cmp    %eax,%ebx
80103962:	75 ec                	jne    80103950 <mycpu+0x30>
80103964:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
8010396a:	05 a0 47 11 80       	add    $0x801147a0,%eax
}
8010396f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103972:	5b                   	pop    %ebx
80103973:	5e                   	pop    %esi
80103974:	5d                   	pop    %ebp
80103975:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103976:	b8 a0 47 11 80       	mov    $0x801147a0,%eax
      return &cpus[i];
8010397b:	eb f2                	jmp    8010396f <mycpu+0x4f>
  panic("unknown apicid\n");
8010397d:	83 ec 0c             	sub    $0xc,%esp
80103980:	68 77 87 10 80       	push   $0x80108777
80103985:	e8 06 ca ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
8010398a:	83 ec 0c             	sub    $0xc,%esp
8010398d:	68 3c 89 10 80       	push   $0x8010893c
80103992:	e8 f9 c9 ff ff       	call   80100390 <panic>
80103997:	89 f6                	mov    %esi,%esi
80103999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801039a0 <cpuid>:
cpuid() {
801039a0:	55                   	push   %ebp
801039a1:	89 e5                	mov    %esp,%ebp
801039a3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801039a6:	e8 75 ff ff ff       	call   80103920 <mycpu>
801039ab:	2d a0 47 11 80       	sub    $0x801147a0,%eax
}
801039b0:	c9                   	leave  
  return mycpu()-cpus;
801039b1:	c1 f8 04             	sar    $0x4,%eax
801039b4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801039ba:	c3                   	ret    
801039bb:	90                   	nop
801039bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801039c0 <myproc>:
myproc(void) {
801039c0:	55                   	push   %ebp
801039c1:	89 e5                	mov    %esp,%ebp
801039c3:	53                   	push   %ebx
801039c4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801039c7:	e8 04 10 00 00       	call   801049d0 <pushcli>
  c = mycpu();
801039cc:	e8 4f ff ff ff       	call   80103920 <mycpu>
  p = c->proc;
801039d1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801039d7:	e8 34 10 00 00       	call   80104a10 <popcli>
}
801039dc:	83 c4 04             	add    $0x4,%esp
801039df:	89 d8                	mov    %ebx,%eax
801039e1:	5b                   	pop    %ebx
801039e2:	5d                   	pop    %ebp
801039e3:	c3                   	ret    
801039e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801039ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801039f0 <userinit>:
{
801039f0:	55                   	push   %ebp
801039f1:	89 e5                	mov    %esp,%ebp
801039f3:	53                   	push   %ebx
801039f4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801039f7:	e8 c4 fd ff ff       	call   801037c0 <allocproc>
801039fc:	89 c3                	mov    %eax,%ebx
  initproc = p;
801039fe:	a3 b8 c5 10 80       	mov    %eax,0x8010c5b8
  if((p->pgdir = setupkvm()) == 0)
80103a03:	e8 78 45 00 00       	call   80107f80 <setupkvm>
80103a08:	85 c0                	test   %eax,%eax
80103a0a:	89 43 04             	mov    %eax,0x4(%ebx)
80103a0d:	0f 84 bd 00 00 00    	je     80103ad0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103a13:	83 ec 04             	sub    $0x4,%esp
80103a16:	68 2c 00 00 00       	push   $0x2c
80103a1b:	68 60 c4 10 80       	push   $0x8010c460
80103a20:	50                   	push   %eax
80103a21:	e8 3a 42 00 00       	call   80107c60 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103a26:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103a29:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103a2f:	6a 4c                	push   $0x4c
80103a31:	6a 00                	push   $0x0
80103a33:	ff 73 18             	pushl  0x18(%ebx)
80103a36:	e8 85 13 00 00       	call   80104dc0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a3b:	8b 43 18             	mov    0x18(%ebx),%eax
80103a3e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a43:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a48:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a4b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a4f:	8b 43 18             	mov    0x18(%ebx),%eax
80103a52:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103a56:	8b 43 18             	mov    0x18(%ebx),%eax
80103a59:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a5d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103a61:	8b 43 18             	mov    0x18(%ebx),%eax
80103a64:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a68:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103a6c:	8b 43 18             	mov    0x18(%ebx),%eax
80103a6f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103a76:	8b 43 18             	mov    0x18(%ebx),%eax
80103a79:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103a80:	8b 43 18             	mov    0x18(%ebx),%eax
80103a83:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a8a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103a8d:	6a 10                	push   $0x10
80103a8f:	68 a0 87 10 80       	push   $0x801087a0
80103a94:	50                   	push   %eax
80103a95:	e8 06 15 00 00       	call   80104fa0 <safestrcpy>
  p->cwd = namei("/");
80103a9a:	c7 04 24 a9 87 10 80 	movl   $0x801087a9,(%esp)
80103aa1:	e8 fa e5 ff ff       	call   801020a0 <namei>
80103aa6:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103aa9:	c7 04 24 40 4d 11 80 	movl   $0x80114d40,(%esp)
80103ab0:	e8 eb 0f 00 00       	call   80104aa0 <acquire>
  p->state = RUNNABLE;
80103ab5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103abc:	c7 04 24 40 4d 11 80 	movl   $0x80114d40,(%esp)
80103ac3:	e8 98 10 00 00       	call   80104b60 <release>
}
80103ac8:	83 c4 10             	add    $0x10,%esp
80103acb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ace:	c9                   	leave  
80103acf:	c3                   	ret    
    panic("userinit: out of memory?");
80103ad0:	83 ec 0c             	sub    $0xc,%esp
80103ad3:	68 87 87 10 80       	push   $0x80108787
80103ad8:	e8 b3 c8 ff ff       	call   80100390 <panic>
80103add:	8d 76 00             	lea    0x0(%esi),%esi

80103ae0 <growproc>:
{
80103ae0:	55                   	push   %ebp
80103ae1:	89 e5                	mov    %esp,%ebp
80103ae3:	56                   	push   %esi
80103ae4:	53                   	push   %ebx
80103ae5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103ae8:	e8 e3 0e 00 00       	call   801049d0 <pushcli>
  c = mycpu();
80103aed:	e8 2e fe ff ff       	call   80103920 <mycpu>
  p = c->proc;
80103af2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103af8:	e8 13 0f 00 00       	call   80104a10 <popcli>
  if(n > 0){
80103afd:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80103b00:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103b02:	7f 1c                	jg     80103b20 <growproc+0x40>
  } else if(n < 0){
80103b04:	75 3a                	jne    80103b40 <growproc+0x60>
  switchuvm(curproc);
80103b06:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103b09:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103b0b:	53                   	push   %ebx
80103b0c:	e8 3f 40 00 00       	call   80107b50 <switchuvm>
  return 0;
80103b11:	83 c4 10             	add    $0x10,%esp
80103b14:	31 c0                	xor    %eax,%eax
}
80103b16:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b19:	5b                   	pop    %ebx
80103b1a:	5e                   	pop    %esi
80103b1b:	5d                   	pop    %ebp
80103b1c:	c3                   	ret    
80103b1d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b20:	83 ec 04             	sub    $0x4,%esp
80103b23:	01 c6                	add    %eax,%esi
80103b25:	56                   	push   %esi
80103b26:	50                   	push   %eax
80103b27:	ff 73 04             	pushl  0x4(%ebx)
80103b2a:	e8 71 42 00 00       	call   80107da0 <allocuvm>
80103b2f:	83 c4 10             	add    $0x10,%esp
80103b32:	85 c0                	test   %eax,%eax
80103b34:	75 d0                	jne    80103b06 <growproc+0x26>
      return -1;
80103b36:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b3b:	eb d9                	jmp    80103b16 <growproc+0x36>
80103b3d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b40:	83 ec 04             	sub    $0x4,%esp
80103b43:	01 c6                	add    %eax,%esi
80103b45:	56                   	push   %esi
80103b46:	50                   	push   %eax
80103b47:	ff 73 04             	pushl  0x4(%ebx)
80103b4a:	e8 81 43 00 00       	call   80107ed0 <deallocuvm>
80103b4f:	83 c4 10             	add    $0x10,%esp
80103b52:	85 c0                	test   %eax,%eax
80103b54:	75 b0                	jne    80103b06 <growproc+0x26>
80103b56:	eb de                	jmp    80103b36 <growproc+0x56>
80103b58:	90                   	nop
80103b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103b60 <fork>:
{
80103b60:	55                   	push   %ebp
80103b61:	89 e5                	mov    %esp,%ebp
80103b63:	57                   	push   %edi
80103b64:	56                   	push   %esi
80103b65:	53                   	push   %ebx
80103b66:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103b69:	e8 62 0e 00 00       	call   801049d0 <pushcli>
  c = mycpu();
80103b6e:	e8 ad fd ff ff       	call   80103920 <mycpu>
  p = c->proc;
80103b73:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b79:	e8 92 0e 00 00       	call   80104a10 <popcli>
  if((np = allocproc()) == 0){
80103b7e:	e8 3d fc ff ff       	call   801037c0 <allocproc>
80103b83:	85 c0                	test   %eax,%eax
80103b85:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103b88:	0f 84 b7 00 00 00    	je     80103c45 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103b8e:	83 ec 08             	sub    $0x8,%esp
80103b91:	ff 33                	pushl  (%ebx)
80103b93:	ff 73 04             	pushl  0x4(%ebx)
80103b96:	89 c7                	mov    %eax,%edi
80103b98:	e8 b3 44 00 00       	call   80108050 <copyuvm>
80103b9d:	83 c4 10             	add    $0x10,%esp
80103ba0:	85 c0                	test   %eax,%eax
80103ba2:	89 47 04             	mov    %eax,0x4(%edi)
80103ba5:	0f 84 a1 00 00 00    	je     80103c4c <fork+0xec>
  np->sz = curproc->sz;
80103bab:	8b 03                	mov    (%ebx),%eax
80103bad:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103bb0:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103bb2:	89 59 14             	mov    %ebx,0x14(%ecx)
80103bb5:	89 c8                	mov    %ecx,%eax
  *np->tf = *curproc->tf;
80103bb7:	8b 79 18             	mov    0x18(%ecx),%edi
80103bba:	8b 73 18             	mov    0x18(%ebx),%esi
80103bbd:	b9 13 00 00 00       	mov    $0x13,%ecx
80103bc2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103bc4:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103bc6:	8b 40 18             	mov    0x18(%eax),%eax
80103bc9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103bd0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103bd4:	85 c0                	test   %eax,%eax
80103bd6:	74 13                	je     80103beb <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103bd8:	83 ec 0c             	sub    $0xc,%esp
80103bdb:	50                   	push   %eax
80103bdc:	e8 bf d3 ff ff       	call   80100fa0 <filedup>
80103be1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103be4:	83 c4 10             	add    $0x10,%esp
80103be7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103beb:	83 c6 01             	add    $0x1,%esi
80103bee:	83 fe 10             	cmp    $0x10,%esi
80103bf1:	75 dd                	jne    80103bd0 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103bf3:	83 ec 0c             	sub    $0xc,%esp
80103bf6:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bf9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103bfc:	e8 0f dc ff ff       	call   80101810 <idup>
80103c01:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c04:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103c07:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c0a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103c0d:	6a 10                	push   $0x10
80103c0f:	53                   	push   %ebx
80103c10:	50                   	push   %eax
80103c11:	e8 8a 13 00 00       	call   80104fa0 <safestrcpy>
  pid = np->pid;
80103c16:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103c19:	c7 04 24 40 4d 11 80 	movl   $0x80114d40,(%esp)
80103c20:	e8 7b 0e 00 00       	call   80104aa0 <acquire>
  np->state = RUNNABLE;
80103c25:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103c2c:	c7 04 24 40 4d 11 80 	movl   $0x80114d40,(%esp)
80103c33:	e8 28 0f 00 00       	call   80104b60 <release>
  return pid;
80103c38:	83 c4 10             	add    $0x10,%esp
}
80103c3b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c3e:	89 d8                	mov    %ebx,%eax
80103c40:	5b                   	pop    %ebx
80103c41:	5e                   	pop    %esi
80103c42:	5f                   	pop    %edi
80103c43:	5d                   	pop    %ebp
80103c44:	c3                   	ret    
    return -1;
80103c45:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c4a:	eb ef                	jmp    80103c3b <fork+0xdb>
    kfree(np->kstack);
80103c4c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103c4f:	83 ec 0c             	sub    $0xc,%esp
80103c52:	ff 73 08             	pushl  0x8(%ebx)
80103c55:	e8 76 e8 ff ff       	call   801024d0 <kfree>
    np->kstack = 0;
80103c5a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103c61:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103c68:	83 c4 10             	add    $0x10,%esp
80103c6b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c70:	eb c9                	jmp    80103c3b <fork+0xdb>
80103c72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103c80 <scheduler>:
{
80103c80:	55                   	push   %ebp
80103c81:	89 e5                	mov    %esp,%ebp
80103c83:	57                   	push   %edi
80103c84:	56                   	push   %esi
80103c85:	53                   	push   %ebx
80103c86:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103c89:	e8 92 fc ff ff       	call   80103920 <mycpu>
80103c8e:	8d 78 04             	lea    0x4(%eax),%edi
80103c91:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103c93:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103c9a:	00 00 00 
80103c9d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103ca0:	fb                   	sti    
    acquire(&ptable.lock);
80103ca1:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ca4:	bb 74 4d 11 80       	mov    $0x80114d74,%ebx
    acquire(&ptable.lock);
80103ca9:	68 40 4d 11 80       	push   $0x80114d40
80103cae:	e8 ed 0d 00 00       	call   80104aa0 <acquire>
80103cb3:	83 c4 10             	add    $0x10,%esp
80103cb6:	8d 76 00             	lea    0x0(%esi),%esi
80103cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(p->state != RUNNABLE)
80103cc0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103cc4:	75 33                	jne    80103cf9 <scheduler+0x79>
      switchuvm(p);
80103cc6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103cc9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103ccf:	53                   	push   %ebx
80103cd0:	e8 7b 3e 00 00       	call   80107b50 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103cd5:	58                   	pop    %eax
80103cd6:	5a                   	pop    %edx
80103cd7:	ff 73 1c             	pushl  0x1c(%ebx)
80103cda:	57                   	push   %edi
      p->state = RUNNING;
80103cdb:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103ce2:	e8 14 13 00 00       	call   80104ffb <swtch>
      switchkvm();
80103ce7:	e8 44 3e 00 00       	call   80107b30 <switchkvm>
      c->proc = 0;
80103cec:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103cf3:	00 00 00 
80103cf6:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cf9:	81 c3 60 06 00 00    	add    $0x660,%ebx
80103cff:	81 fb 74 e5 12 80    	cmp    $0x8012e574,%ebx
80103d05:	72 b9                	jb     80103cc0 <scheduler+0x40>
    release(&ptable.lock);
80103d07:	83 ec 0c             	sub    $0xc,%esp
80103d0a:	68 40 4d 11 80       	push   $0x80114d40
80103d0f:	e8 4c 0e 00 00       	call   80104b60 <release>
    sti();
80103d14:	83 c4 10             	add    $0x10,%esp
80103d17:	eb 87                	jmp    80103ca0 <scheduler+0x20>
80103d19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103d20 <sched>:
{
80103d20:	55                   	push   %ebp
80103d21:	89 e5                	mov    %esp,%ebp
80103d23:	56                   	push   %esi
80103d24:	53                   	push   %ebx
  pushcli();
80103d25:	e8 a6 0c 00 00       	call   801049d0 <pushcli>
  c = mycpu();
80103d2a:	e8 f1 fb ff ff       	call   80103920 <mycpu>
  p = c->proc;
80103d2f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d35:	e8 d6 0c 00 00       	call   80104a10 <popcli>
  if(!holding(&ptable.lock))
80103d3a:	83 ec 0c             	sub    $0xc,%esp
80103d3d:	68 40 4d 11 80       	push   $0x80114d40
80103d42:	e8 29 0d 00 00       	call   80104a70 <holding>
80103d47:	83 c4 10             	add    $0x10,%esp
80103d4a:	85 c0                	test   %eax,%eax
80103d4c:	74 4f                	je     80103d9d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103d4e:	e8 cd fb ff ff       	call   80103920 <mycpu>
80103d53:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103d5a:	75 68                	jne    80103dc4 <sched+0xa4>
  if(p->state == RUNNING)
80103d5c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103d60:	74 55                	je     80103db7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103d62:	9c                   	pushf  
80103d63:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103d64:	f6 c4 02             	test   $0x2,%ah
80103d67:	75 41                	jne    80103daa <sched+0x8a>
  intena = mycpu()->intena;
80103d69:	e8 b2 fb ff ff       	call   80103920 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103d6e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103d71:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103d77:	e8 a4 fb ff ff       	call   80103920 <mycpu>
80103d7c:	83 ec 08             	sub    $0x8,%esp
80103d7f:	ff 70 04             	pushl  0x4(%eax)
80103d82:	53                   	push   %ebx
80103d83:	e8 73 12 00 00       	call   80104ffb <swtch>
  mycpu()->intena = intena;
80103d88:	e8 93 fb ff ff       	call   80103920 <mycpu>
}
80103d8d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103d90:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103d96:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d99:	5b                   	pop    %ebx
80103d9a:	5e                   	pop    %esi
80103d9b:	5d                   	pop    %ebp
80103d9c:	c3                   	ret    
    panic("sched ptable.lock");
80103d9d:	83 ec 0c             	sub    $0xc,%esp
80103da0:	68 ab 87 10 80       	push   $0x801087ab
80103da5:	e8 e6 c5 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103daa:	83 ec 0c             	sub    $0xc,%esp
80103dad:	68 d7 87 10 80       	push   $0x801087d7
80103db2:	e8 d9 c5 ff ff       	call   80100390 <panic>
    panic("sched running");
80103db7:	83 ec 0c             	sub    $0xc,%esp
80103dba:	68 c9 87 10 80       	push   $0x801087c9
80103dbf:	e8 cc c5 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103dc4:	83 ec 0c             	sub    $0xc,%esp
80103dc7:	68 bd 87 10 80       	push   $0x801087bd
80103dcc:	e8 bf c5 ff ff       	call   80100390 <panic>
80103dd1:	eb 0d                	jmp    80103de0 <exit>
80103dd3:	90                   	nop
80103dd4:	90                   	nop
80103dd5:	90                   	nop
80103dd6:	90                   	nop
80103dd7:	90                   	nop
80103dd8:	90                   	nop
80103dd9:	90                   	nop
80103dda:	90                   	nop
80103ddb:	90                   	nop
80103ddc:	90                   	nop
80103ddd:	90                   	nop
80103dde:	90                   	nop
80103ddf:	90                   	nop

80103de0 <exit>:
{
80103de0:	55                   	push   %ebp
80103de1:	89 e5                	mov    %esp,%ebp
80103de3:	57                   	push   %edi
80103de4:	56                   	push   %esi
80103de5:	53                   	push   %ebx
80103de6:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103de9:	e8 e2 0b 00 00       	call   801049d0 <pushcli>
  c = mycpu();
80103dee:	e8 2d fb ff ff       	call   80103920 <mycpu>
  p = c->proc;
80103df3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103df9:	e8 12 0c 00 00       	call   80104a10 <popcli>
  if(curproc == initproc)
80103dfe:	39 35 b8 c5 10 80    	cmp    %esi,0x8010c5b8
80103e04:	8d 5e 28             	lea    0x28(%esi),%ebx
80103e07:	8d 7e 68             	lea    0x68(%esi),%edi
80103e0a:	0f 84 f1 00 00 00    	je     80103f01 <exit+0x121>
    if(curproc->ofile[fd]){
80103e10:	8b 03                	mov    (%ebx),%eax
80103e12:	85 c0                	test   %eax,%eax
80103e14:	74 12                	je     80103e28 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103e16:	83 ec 0c             	sub    $0xc,%esp
80103e19:	50                   	push   %eax
80103e1a:	e8 d1 d1 ff ff       	call   80100ff0 <fileclose>
      curproc->ofile[fd] = 0;
80103e1f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103e25:	83 c4 10             	add    $0x10,%esp
80103e28:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
80103e2b:	39 fb                	cmp    %edi,%ebx
80103e2d:	75 e1                	jne    80103e10 <exit+0x30>
  begin_op();
80103e2f:	e8 2c ef ff ff       	call   80102d60 <begin_op>
  iput(curproc->cwd);
80103e34:	83 ec 0c             	sub    $0xc,%esp
80103e37:	ff 76 68             	pushl  0x68(%esi)
80103e3a:	e8 31 db ff ff       	call   80101970 <iput>
  end_op();
80103e3f:	e8 8c ef ff ff       	call   80102dd0 <end_op>
  curproc->cwd = 0;
80103e44:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80103e4b:	c7 04 24 40 4d 11 80 	movl   $0x80114d40,(%esp)
80103e52:	e8 49 0c 00 00       	call   80104aa0 <acquire>
  wakeup1(curproc->parent);
80103e57:	8b 56 14             	mov    0x14(%esi),%edx
80103e5a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e5d:	b8 74 4d 11 80       	mov    $0x80114d74,%eax
80103e62:	eb 10                	jmp    80103e74 <exit+0x94>
80103e64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e68:	05 60 06 00 00       	add    $0x660,%eax
80103e6d:	3d 74 e5 12 80       	cmp    $0x8012e574,%eax
80103e72:	73 1e                	jae    80103e92 <exit+0xb2>
    if(p->state == SLEEPING && p->chan == chan)
80103e74:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e78:	75 ee                	jne    80103e68 <exit+0x88>
80103e7a:	3b 50 20             	cmp    0x20(%eax),%edx
80103e7d:	75 e9                	jne    80103e68 <exit+0x88>
      p->state = RUNNABLE;
80103e7f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e86:	05 60 06 00 00       	add    $0x660,%eax
80103e8b:	3d 74 e5 12 80       	cmp    $0x8012e574,%eax
80103e90:	72 e2                	jb     80103e74 <exit+0x94>
      p->parent = initproc;
80103e92:	8b 0d b8 c5 10 80    	mov    0x8010c5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e98:	ba 74 4d 11 80       	mov    $0x80114d74,%edx
80103e9d:	eb 0f                	jmp    80103eae <exit+0xce>
80103e9f:	90                   	nop
80103ea0:	81 c2 60 06 00 00    	add    $0x660,%edx
80103ea6:	81 fa 74 e5 12 80    	cmp    $0x8012e574,%edx
80103eac:	73 3a                	jae    80103ee8 <exit+0x108>
    if(p->parent == curproc){
80103eae:	39 72 14             	cmp    %esi,0x14(%edx)
80103eb1:	75 ed                	jne    80103ea0 <exit+0xc0>
      if(p->state == ZOMBIE)
80103eb3:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103eb7:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103eba:	75 e4                	jne    80103ea0 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ebc:	b8 74 4d 11 80       	mov    $0x80114d74,%eax
80103ec1:	eb 11                	jmp    80103ed4 <exit+0xf4>
80103ec3:	90                   	nop
80103ec4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ec8:	05 60 06 00 00       	add    $0x660,%eax
80103ecd:	3d 74 e5 12 80       	cmp    $0x8012e574,%eax
80103ed2:	73 cc                	jae    80103ea0 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103ed4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103ed8:	75 ee                	jne    80103ec8 <exit+0xe8>
80103eda:	3b 48 20             	cmp    0x20(%eax),%ecx
80103edd:	75 e9                	jne    80103ec8 <exit+0xe8>
      p->state = RUNNABLE;
80103edf:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103ee6:	eb e0                	jmp    80103ec8 <exit+0xe8>
  curproc->state = ZOMBIE;
80103ee8:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103eef:	e8 2c fe ff ff       	call   80103d20 <sched>
  panic("zombie exit");
80103ef4:	83 ec 0c             	sub    $0xc,%esp
80103ef7:	68 f8 87 10 80       	push   $0x801087f8
80103efc:	e8 8f c4 ff ff       	call   80100390 <panic>
    panic("init exiting");
80103f01:	83 ec 0c             	sub    $0xc,%esp
80103f04:	68 eb 87 10 80       	push   $0x801087eb
80103f09:	e8 82 c4 ff ff       	call   80100390 <panic>
80103f0e:	66 90                	xchg   %ax,%ax

80103f10 <yield>:
{
80103f10:	55                   	push   %ebp
80103f11:	89 e5                	mov    %esp,%ebp
80103f13:	53                   	push   %ebx
80103f14:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103f17:	68 40 4d 11 80       	push   $0x80114d40
80103f1c:	e8 7f 0b 00 00       	call   80104aa0 <acquire>
  pushcli();
80103f21:	e8 aa 0a 00 00       	call   801049d0 <pushcli>
  c = mycpu();
80103f26:	e8 f5 f9 ff ff       	call   80103920 <mycpu>
  p = c->proc;
80103f2b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f31:	e8 da 0a 00 00       	call   80104a10 <popcli>
  myproc()->state = RUNNABLE;
80103f36:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80103f3d:	e8 de fd ff ff       	call   80103d20 <sched>
  release(&ptable.lock);
80103f42:	c7 04 24 40 4d 11 80 	movl   $0x80114d40,(%esp)
80103f49:	e8 12 0c 00 00       	call   80104b60 <release>
}
80103f4e:	83 c4 10             	add    $0x10,%esp
80103f51:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f54:	c9                   	leave  
80103f55:	c3                   	ret    
80103f56:	8d 76 00             	lea    0x0(%esi),%esi
80103f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f60 <sleep_without_spin>:
{
80103f60:	55                   	push   %ebp
80103f61:	89 e5                	mov    %esp,%ebp
80103f63:	56                   	push   %esi
80103f64:	53                   	push   %ebx
80103f65:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103f68:	e8 63 0a 00 00       	call   801049d0 <pushcli>
  c = mycpu();
80103f6d:	e8 ae f9 ff ff       	call   80103920 <mycpu>
  p = c->proc;
80103f72:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f78:	e8 93 0a 00 00       	call   80104a10 <popcli>
  if(p == 0)
80103f7d:	85 db                	test   %ebx,%ebx
80103f7f:	74 38                	je     80103fb9 <sleep_without_spin+0x59>
  acquire(&ptable.lock);  //DOC: sleeplock1
80103f81:	83 ec 0c             	sub    $0xc,%esp
80103f84:	68 40 4d 11 80       	push   $0x80114d40
80103f89:	e8 12 0b 00 00       	call   80104aa0 <acquire>
  p->chan = chan;
80103f8e:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80103f91:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103f98:	e8 83 fd ff ff       	call   80103d20 <sched>
  p->chan = 0;
80103f9d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  release(&ptable.lock);
80103fa4:	83 c4 10             	add    $0x10,%esp
80103fa7:	c7 45 08 40 4d 11 80 	movl   $0x80114d40,0x8(%ebp)
}
80103fae:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103fb1:	5b                   	pop    %ebx
80103fb2:	5e                   	pop    %esi
80103fb3:	5d                   	pop    %ebp
  release(&ptable.lock);
80103fb4:	e9 a7 0b 00 00       	jmp    80104b60 <release>
    panic("sleep");
80103fb9:	83 ec 0c             	sub    $0xc,%esp
80103fbc:	68 9d 8b 10 80       	push   $0x80108b9d
80103fc1:	e8 ca c3 ff ff       	call   80100390 <panic>
80103fc6:	8d 76 00             	lea    0x0(%esi),%esi
80103fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103fd0 <sleep>:
{
80103fd0:	55                   	push   %ebp
80103fd1:	89 e5                	mov    %esp,%ebp
80103fd3:	57                   	push   %edi
80103fd4:	56                   	push   %esi
80103fd5:	53                   	push   %ebx
80103fd6:	83 ec 0c             	sub    $0xc,%esp
80103fd9:	8b 7d 08             	mov    0x8(%ebp),%edi
80103fdc:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80103fdf:	e8 ec 09 00 00       	call   801049d0 <pushcli>
  c = mycpu();
80103fe4:	e8 37 f9 ff ff       	call   80103920 <mycpu>
  p = c->proc;
80103fe9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103fef:	e8 1c 0a 00 00       	call   80104a10 <popcli>
  if(p == 0)
80103ff4:	85 db                	test   %ebx,%ebx
80103ff6:	0f 84 87 00 00 00    	je     80104083 <sleep+0xb3>
  if(lk == 0)
80103ffc:	85 f6                	test   %esi,%esi
80103ffe:	74 76                	je     80104076 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104000:	81 fe 40 4d 11 80    	cmp    $0x80114d40,%esi
80104006:	74 50                	je     80104058 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104008:	83 ec 0c             	sub    $0xc,%esp
8010400b:	68 40 4d 11 80       	push   $0x80114d40
80104010:	e8 8b 0a 00 00       	call   80104aa0 <acquire>
    release(lk);
80104015:	89 34 24             	mov    %esi,(%esp)
80104018:	e8 43 0b 00 00       	call   80104b60 <release>
  p->chan = chan;
8010401d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104020:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104027:	e8 f4 fc ff ff       	call   80103d20 <sched>
  p->chan = 0;
8010402c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104033:	c7 04 24 40 4d 11 80 	movl   $0x80114d40,(%esp)
8010403a:	e8 21 0b 00 00       	call   80104b60 <release>
    acquire(lk);
8010403f:	89 75 08             	mov    %esi,0x8(%ebp)
80104042:	83 c4 10             	add    $0x10,%esp
}
80104045:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104048:	5b                   	pop    %ebx
80104049:	5e                   	pop    %esi
8010404a:	5f                   	pop    %edi
8010404b:	5d                   	pop    %ebp
    acquire(lk);
8010404c:	e9 4f 0a 00 00       	jmp    80104aa0 <acquire>
80104051:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104058:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010405b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104062:	e8 b9 fc ff ff       	call   80103d20 <sched>
  p->chan = 0;
80104067:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010406e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104071:	5b                   	pop    %ebx
80104072:	5e                   	pop    %esi
80104073:	5f                   	pop    %edi
80104074:	5d                   	pop    %ebp
80104075:	c3                   	ret    
    panic("sleep without lk");
80104076:	83 ec 0c             	sub    $0xc,%esp
80104079:	68 04 88 10 80       	push   $0x80108804
8010407e:	e8 0d c3 ff ff       	call   80100390 <panic>
    panic("sleep");
80104083:	83 ec 0c             	sub    $0xc,%esp
80104086:	68 9d 8b 10 80       	push   $0x80108b9d
8010408b:	e8 00 c3 ff ff       	call   80100390 <panic>

80104090 <wait>:
{
80104090:	55                   	push   %ebp
80104091:	89 e5                	mov    %esp,%ebp
80104093:	56                   	push   %esi
80104094:	53                   	push   %ebx
  pushcli();
80104095:	e8 36 09 00 00       	call   801049d0 <pushcli>
  c = mycpu();
8010409a:	e8 81 f8 ff ff       	call   80103920 <mycpu>
  p = c->proc;
8010409f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801040a5:	e8 66 09 00 00       	call   80104a10 <popcli>
  acquire(&ptable.lock);
801040aa:	83 ec 0c             	sub    $0xc,%esp
801040ad:	68 40 4d 11 80       	push   $0x80114d40
801040b2:	e8 e9 09 00 00       	call   80104aa0 <acquire>
801040b7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801040ba:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040bc:	bb 74 4d 11 80       	mov    $0x80114d74,%ebx
801040c1:	eb 13                	jmp    801040d6 <wait+0x46>
801040c3:	90                   	nop
801040c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040c8:	81 c3 60 06 00 00    	add    $0x660,%ebx
801040ce:	81 fb 74 e5 12 80    	cmp    $0x8012e574,%ebx
801040d4:	73 1e                	jae    801040f4 <wait+0x64>
      if(p->parent != curproc)
801040d6:	39 73 14             	cmp    %esi,0x14(%ebx)
801040d9:	75 ed                	jne    801040c8 <wait+0x38>
      if(p->state == ZOMBIE){
801040db:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801040df:	74 37                	je     80104118 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040e1:	81 c3 60 06 00 00    	add    $0x660,%ebx
      havekids = 1;
801040e7:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040ec:	81 fb 74 e5 12 80    	cmp    $0x8012e574,%ebx
801040f2:	72 e2                	jb     801040d6 <wait+0x46>
    if(!havekids || curproc->killed){
801040f4:	85 c0                	test   %eax,%eax
801040f6:	74 76                	je     8010416e <wait+0xde>
801040f8:	8b 46 24             	mov    0x24(%esi),%eax
801040fb:	85 c0                	test   %eax,%eax
801040fd:	75 6f                	jne    8010416e <wait+0xde>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801040ff:	83 ec 08             	sub    $0x8,%esp
80104102:	68 40 4d 11 80       	push   $0x80114d40
80104107:	56                   	push   %esi
80104108:	e8 c3 fe ff ff       	call   80103fd0 <sleep>
    havekids = 0;
8010410d:	83 c4 10             	add    $0x10,%esp
80104110:	eb a8                	jmp    801040ba <wait+0x2a>
80104112:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104118:	83 ec 0c             	sub    $0xc,%esp
8010411b:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
8010411e:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104121:	e8 aa e3 ff ff       	call   801024d0 <kfree>
        freevm(p->pgdir);
80104126:	5a                   	pop    %edx
80104127:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
8010412a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104131:	e8 ca 3d 00 00       	call   80107f00 <freevm>
        release(&ptable.lock);
80104136:	c7 04 24 40 4d 11 80 	movl   $0x80114d40,(%esp)
        p->pid = 0;
8010413d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104144:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010414b:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
8010414f:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104156:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010415d:	e8 fe 09 00 00       	call   80104b60 <release>
        return pid;
80104162:	83 c4 10             	add    $0x10,%esp
}
80104165:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104168:	89 f0                	mov    %esi,%eax
8010416a:	5b                   	pop    %ebx
8010416b:	5e                   	pop    %esi
8010416c:	5d                   	pop    %ebp
8010416d:	c3                   	ret    
      release(&ptable.lock);
8010416e:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104171:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104176:	68 40 4d 11 80       	push   $0x80114d40
8010417b:	e8 e0 09 00 00       	call   80104b60 <release>
      return -1;
80104180:	83 c4 10             	add    $0x10,%esp
80104183:	eb e0                	jmp    80104165 <wait+0xd5>
80104185:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104190 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104190:	55                   	push   %ebp
80104191:	89 e5                	mov    %esp,%ebp
80104193:	53                   	push   %ebx
80104194:	83 ec 10             	sub    $0x10,%esp
80104197:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010419a:	68 40 4d 11 80       	push   $0x80114d40
8010419f:	e8 fc 08 00 00       	call   80104aa0 <acquire>
801041a4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041a7:	b8 74 4d 11 80       	mov    $0x80114d74,%eax
801041ac:	eb 0e                	jmp    801041bc <wakeup+0x2c>
801041ae:	66 90                	xchg   %ax,%ax
801041b0:	05 60 06 00 00       	add    $0x660,%eax
801041b5:	3d 74 e5 12 80       	cmp    $0x8012e574,%eax
801041ba:	73 1e                	jae    801041da <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
801041bc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801041c0:	75 ee                	jne    801041b0 <wakeup+0x20>
801041c2:	3b 58 20             	cmp    0x20(%eax),%ebx
801041c5:	75 e9                	jne    801041b0 <wakeup+0x20>
      p->state = RUNNABLE;
801041c7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041ce:	05 60 06 00 00       	add    $0x660,%eax
801041d3:	3d 74 e5 12 80       	cmp    $0x8012e574,%eax
801041d8:	72 e2                	jb     801041bc <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
801041da:	c7 45 08 40 4d 11 80 	movl   $0x80114d40,0x8(%ebp)
}
801041e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041e4:	c9                   	leave  
  release(&ptable.lock);
801041e5:	e9 76 09 00 00       	jmp    80104b60 <release>
801041ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801041f0 <invocation_log>:

int
invocation_log(int pid)
{
801041f0:	55                   	push   %ebp
801041f1:	89 e5                	mov    %esp,%ebp
801041f3:	57                   	push   %edi
801041f4:	56                   	push   %esi
801041f5:	53                   	push   %ebx
  struct proc *p;
  int i, status = -1;
801041f6:	be ff ff ff ff       	mov    $0xffffffff,%esi
{
801041fb:	83 ec 38             	sub    $0x38,%esp

  acquire(&ptable.lock);
801041fe:	68 40 4d 11 80       	push   $0x80114d40
80104203:	e8 98 08 00 00       	call   80104aa0 <acquire>
80104208:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010420b:	c7 45 e0 74 4d 11 80 	movl   $0x80114d74,-0x20(%ebp)
80104212:	89 f0                	mov    %esi,%eax
80104214:	eb 20                	jmp    80104236 <invocation_log+0x46>
80104216:	8d 76 00             	lea    0x0(%esi),%esi
80104219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104220:	81 45 e0 60 06 00 00 	addl   $0x660,-0x20(%ebp)
80104227:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010422a:	81 fa 74 e5 12 80    	cmp    $0x8012e574,%edx
80104230:	0f 83 51 03 00 00    	jae    80104587 <invocation_log+0x397>
  {
    if(p->pid == pid){
80104236:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80104239:	8b 55 08             	mov    0x8(%ebp),%edx
8010423c:	39 51 10             	cmp    %edx,0x10(%ecx)
8010423f:	75 df                	jne    80104220 <invocation_log+0x30>
80104241:	81 c1 88 00 00 00    	add    $0x88,%ecx
80104247:	31 f6                	xor    %esi,%esi
80104249:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010424c:	eb 0e                	jmp    8010425c <invocation_log+0x6c>
8010424e:	66 90                	xchg   %ax,%ax
80104250:	8b 75 dc             	mov    -0x24(%ebp),%esi
80104253:	83 45 e4 34          	addl   $0x34,-0x1c(%ebp)
      for (i = 0; i < 29; ++i)
80104257:	83 fe 1d             	cmp    $0x1d,%esi
8010425a:	74 c4                	je     80104220 <invocation_log+0x30>
      {
        if (p->syscalls[i].count > 0)
8010425c:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010425f:	8b 51 f4             	mov    -0xc(%ecx),%edx
80104262:	8d 4e 01             	lea    0x1(%esi),%ecx
80104265:	89 4d dc             	mov    %ecx,-0x24(%ebp)
80104268:	85 d2                	test   %edx,%edx
8010426a:	74 e4                	je     80104250 <invocation_log+0x60>
        {
          struct date* d = p->syscalls[i].datelist;
8010426c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
          struct syscallarg* a = p->syscalls[i].arglist;
8010426f:	8b 78 20             	mov    0x20(%eax),%edi
          struct date* d = p->syscalls[i].datelist;
80104272:	8b 58 f8             	mov    -0x8(%eax),%ebx
          for (; d != 0 && a != 0; d = d->next)
80104275:	85 ff                	test   %edi,%edi
80104277:	0f 84 ab 01 00 00    	je     80104428 <invocation_log+0x238>
8010427d:	85 db                	test   %ebx,%ebx
8010427f:	0f 84 a3 01 00 00    	je     80104428 <invocation_log+0x238>
          {
            cprintf("%d syscall : ID :%d NAME:%s DATE: %d:%d:%d %d-%d-%d\n",p->syscalls[i].count, i+1,
              p->syscalls[i].name, d->date.hour, d->date.minute, d->date.second, d->date.year,
              d->date.month, d->date.day);
            if (i == 0 || i == 1 || i == 2 || i == 13 || i == 10 || i == 27 || i == 28)
80104285:	89 f1                	mov    %esi,%ecx
80104287:	b8 07 24 00 18       	mov    $0x18002407,%eax
8010428c:	d3 e8                	shr    %cl,%eax
8010428e:	b9 01 00 00 00       	mov    $0x1,%ecx
80104293:	f7 d0                	not    %eax
80104295:	83 e0 01             	and    $0x1,%eax
80104298:	83 fe 1c             	cmp    $0x1c,%esi
8010429b:	0f 47 c1             	cmova  %ecx,%eax
              cprintf("%d %s  (%s)\n",p->pid, p->syscalls[i].name, a->type[0]); 
            if (i == 21 || i == 22 || i == 24 || i == 5 || i == 11 || i == 12 || i == 9 || i == 20)
8010429e:	89 f1                	mov    %esi,%ecx
801042a0:	88 45 db             	mov    %al,-0x25(%ebp)
801042a3:	b8 20 1a 70 01       	mov    $0x1701a20,%eax
801042a8:	d3 e8                	shr    %cl,%eax
801042aa:	b9 01 00 00 00       	mov    $0x1,%ecx
801042af:	f7 d0                	not    %eax
801042b1:	83 e0 01             	and    $0x1,%eax
801042b4:	83 fe 18             	cmp    $0x18,%esi
801042b7:	0f 47 c1             	cmova  %ecx,%eax
801042ba:	88 45 da             	mov    %al,-0x26(%ebp)
                a->type[2],a->int_argv[1]);
            if (i == 6)
                cprintf("%d %s  (%s 0x%p, %s 0x%p)\n",p->pid, p->syscalls[i].name, a->type[0], a->str_argv[0], a->type[1], a->ptr_argv[0]);
            if (i == 14)
                cprintf("%d %s  (%s %s, %s %d)\n",p->pid, p->syscalls[i].name, a->type[0], a->str_argv[0], a->type[1], a->int_argv[0]);
            if (i == 17 || i == 19 || i == 8)
801042bd:	89 f0                	mov    %esi,%eax
801042bf:	83 e0 fd             	and    $0xfffffffd,%eax
801042c2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801042c5:	eb 4c                	jmp    80104313 <invocation_log+0x123>
801042c7:	89 f6                	mov    %esi,%esi
801042c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801042d0:	83 fe 08             	cmp    $0x8,%esi
801042d3:	0f 84 e5 00 00 00    	je     801043be <invocation_log+0x1ce>
                cprintf("%d %s  (%s %s)\n",p->pid, p->syscalls[i].name, a->type[0], a->str_argv[0]);
            if (i == 18)
801042d9:	83 fe 12             	cmp    $0x12,%esi
801042dc:	0f 84 05 01 00 00    	je     801043e7 <invocation_log+0x1f7>
                cprintf("%d %s  (%s %s, %s %s)\n",p->pid, p->syscalls[i].name, a->type[0], a->str_argv[0], a->type[1], a->str_argv[1]);
            if (i == 7)
801042e2:	83 fe 07             	cmp    $0x7,%esi
801042e5:	0f 84 d6 01 00 00    	je     801044c1 <invocation_log+0x2d1>
                cprintf("%d %s  (%s %d, %s 0x%p)\n",p->pid, p->syscalls[i].name, a->type[0], a->int_argv[0], a->type[1], a->st);
            if (i == 16)
801042eb:	83 fe 10             	cmp    $0x10,%esi
801042ee:	0f 84 5a 02 00 00    	je     8010454e <invocation_log+0x35e>
          for (; d != 0 && a != 0; d = d->next)
801042f4:	8b 5b 1c             	mov    0x1c(%ebx),%ebx
                cprintf("%d %s  (%s %s, %s %d, %s %d)\n",p->pid, p->syscalls[i].name, a->type[0], a->str_argv[0], a->type[1], a->int_argv[0],
                  a->type[2], a->int_argv[1]);

            a = a->next;
801042f7:	8b bf 58 01 00 00    	mov    0x158(%edi),%edi
          for (; d != 0 && a != 0; d = d->next)
801042fd:	85 db                	test   %ebx,%ebx
801042ff:	0f 84 23 01 00 00    	je     80104428 <invocation_log+0x238>
80104305:	85 ff                	test   %edi,%edi
80104307:	0f 84 1b 01 00 00    	je     80104428 <invocation_log+0x238>
8010430d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104310:	8b 50 f4             	mov    -0xc(%eax),%edx
            cprintf("%d syscall : ID :%d NAME:%s DATE: %d:%d:%d %d-%d-%d\n",p->syscalls[i].count, i+1,
80104313:	83 ec 08             	sub    $0x8,%esp
80104316:	ff 73 0c             	pushl  0xc(%ebx)
80104319:	ff 73 10             	pushl  0x10(%ebx)
8010431c:	ff 73 14             	pushl  0x14(%ebx)
8010431f:	ff 33                	pushl  (%ebx)
80104321:	ff 73 04             	pushl  0x4(%ebx)
80104324:	ff 73 08             	pushl  0x8(%ebx)
80104327:	ff 75 e4             	pushl  -0x1c(%ebp)
8010432a:	ff 75 dc             	pushl  -0x24(%ebp)
8010432d:	52                   	push   %edx
8010432e:	68 64 89 10 80       	push   $0x80108964
80104333:	e8 b8 c3 ff ff       	call   801006f0 <cprintf>
            if (i == 0 || i == 1 || i == 2 || i == 13 || i == 10 || i == 27 || i == 28)
80104338:	83 c4 30             	add    $0x30,%esp
8010433b:	80 7d db 00          	cmpb   $0x0,-0x25(%ebp)
8010433f:	75 17                	jne    80104358 <invocation_log+0x168>
              cprintf("%d %s  (%s)\n",p->pid, p->syscalls[i].name, a->type[0]); 
80104341:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104344:	57                   	push   %edi
80104345:	ff 75 e4             	pushl  -0x1c(%ebp)
80104348:	ff 70 10             	pushl  0x10(%eax)
8010434b:	68 15 88 10 80       	push   $0x80108815
80104350:	e8 9b c3 ff ff       	call   801006f0 <cprintf>
80104355:	83 c4 10             	add    $0x10,%esp
            if (i == 21 || i == 22 || i == 24 || i == 5 || i == 11 || i == 12 || i == 9 || i == 20)
80104358:	80 7d da 00          	cmpb   $0x0,-0x26(%ebp)
8010435c:	75 20                	jne    8010437e <invocation_log+0x18e>
              cprintf("%d %s  (%s %d)\n",p->pid, p->syscalls[i].name, a->type[0], a->int_argv[0]);
8010435e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104361:	83 ec 0c             	sub    $0xc,%esp
80104364:	ff b7 f0 00 00 00    	pushl  0xf0(%edi)
8010436a:	57                   	push   %edi
8010436b:	ff 75 e4             	pushl  -0x1c(%ebp)
8010436e:	ff 70 10             	pushl  0x10(%eax)
80104371:	68 22 88 10 80       	push   $0x80108822
80104376:	e8 75 c3 ff ff       	call   801006f0 <cprintf>
8010437b:	83 c4 20             	add    $0x20,%esp
            if (i == 23)
8010437e:	83 fe 17             	cmp    $0x17,%esi
80104381:	0f 84 98 01 00 00    	je     8010451f <invocation_log+0x32f>
            if (i == 3)
80104387:	83 fe 03             	cmp    $0x3,%esi
8010438a:	0f 84 0c 01 00 00    	je     8010449c <invocation_log+0x2ac>
            if (i == 4 || i == 15)
80104390:	83 fe 04             	cmp    $0x4,%esi
80104393:	0f 84 97 00 00 00    	je     80104430 <invocation_log+0x240>
80104399:	83 fe 0f             	cmp    $0xf,%esi
8010439c:	0f 84 8e 00 00 00    	je     80104430 <invocation_log+0x240>
            if (i == 6)
801043a2:	83 fe 06             	cmp    $0x6,%esi
801043a5:	0f 84 c2 00 00 00    	je     8010446d <invocation_log+0x27d>
            if (i == 14)
801043ab:	83 fe 0e             	cmp    $0xe,%esi
801043ae:	0f 84 3c 01 00 00    	je     801044f0 <invocation_log+0x300>
            if (i == 17 || i == 19 || i == 8)
801043b4:	83 7d d4 11          	cmpl   $0x11,-0x2c(%ebp)
801043b8:	0f 85 12 ff ff ff    	jne    801042d0 <invocation_log+0xe0>
                cprintf("%d %s  (%s %s)\n",p->pid, p->syscalls[i].name, a->type[0], a->str_argv[0]);
801043be:	8b 45 e0             	mov    -0x20(%ebp),%eax
801043c1:	83 ec 0c             	sub    $0xc,%esp
801043c4:	ff b7 14 01 00 00    	pushl  0x114(%edi)
801043ca:	57                   	push   %edi
801043cb:	ff 75 e4             	pushl  -0x1c(%ebp)
801043ce:	ff 70 10             	pushl  0x10(%eax)
801043d1:	68 8d 88 10 80       	push   $0x8010888d
801043d6:	e8 15 c3 ff ff       	call   801006f0 <cprintf>
801043db:	83 c4 20             	add    $0x20,%esp
            if (i == 18)
801043de:	83 fe 12             	cmp    $0x12,%esi
801043e1:	0f 85 fb fe ff ff    	jne    801042e2 <invocation_log+0xf2>
                cprintf("%d %s  (%s %s, %s %s)\n",p->pid, p->syscalls[i].name, a->type[0], a->str_argv[0], a->type[1], a->str_argv[1]);
801043e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801043ea:	8d 57 1e             	lea    0x1e(%edi),%edx
801043ed:	83 ec 04             	sub    $0x4,%esp
801043f0:	ff b7 18 01 00 00    	pushl  0x118(%edi)
801043f6:	52                   	push   %edx
801043f7:	ff b7 14 01 00 00    	pushl  0x114(%edi)
801043fd:	57                   	push   %edi
801043fe:	ff 75 e4             	pushl  -0x1c(%ebp)
80104401:	ff 70 10             	pushl  0x10(%eax)
80104404:	68 9d 88 10 80       	push   $0x8010889d
80104409:	e8 e2 c2 ff ff       	call   801006f0 <cprintf>
          for (; d != 0 && a != 0; d = d->next)
8010440e:	8b 5b 1c             	mov    0x1c(%ebx),%ebx
                cprintf("%d %s  (%s %s, %s %s)\n",p->pid, p->syscalls[i].name, a->type[0], a->str_argv[0], a->type[1], a->str_argv[1]);
80104411:	83 c4 20             	add    $0x20,%esp
            a = a->next;
80104414:	8b bf 58 01 00 00    	mov    0x158(%edi),%edi
          for (; d != 0 && a != 0; d = d->next)
8010441a:	85 db                	test   %ebx,%ebx
8010441c:	0f 85 e3 fe ff ff    	jne    80104305 <invocation_log+0x115>
80104422:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
          }
          status = 0;
80104428:	31 c0                	xor    %eax,%eax
8010442a:	e9 21 fe ff ff       	jmp    80104250 <invocation_log+0x60>
8010442f:	90                   	nop
                a->type[2],a->int_argv[1]);
80104430:	8d 57 3c             	lea    0x3c(%edi),%edx
              cprintf("%d %s  (%s %d, %s 0x%p, %s %d)\n",p->pid, p->syscalls[i].name,
80104433:	83 ec 0c             	sub    $0xc,%esp
80104436:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104439:	ff b7 f4 00 00 00    	pushl  0xf4(%edi)
8010443f:	52                   	push   %edx
                a->type[0],a->int_argv[0],a->type[1],a->str_argv[0],
80104440:	8d 57 1e             	lea    0x1e(%edi),%edx
              cprintf("%d %s  (%s %d, %s 0x%p, %s %d)\n",p->pid, p->syscalls[i].name,
80104443:	ff b7 14 01 00 00    	pushl  0x114(%edi)
80104449:	52                   	push   %edx
8010444a:	ff b7 f0 00 00 00    	pushl  0xf0(%edi)
80104450:	57                   	push   %edi
80104451:	ff 75 e4             	pushl  -0x1c(%ebp)
80104454:	ff 70 10             	pushl  0x10(%eax)
80104457:	68 9c 89 10 80       	push   $0x8010899c
8010445c:	e8 8f c2 ff ff       	call   801006f0 <cprintf>
80104461:	83 c4 30             	add    $0x30,%esp
            if (i == 6)
80104464:	83 fe 06             	cmp    $0x6,%esi
80104467:	0f 85 3e ff ff ff    	jne    801043ab <invocation_log+0x1bb>
                cprintf("%d %s  (%s 0x%p, %s 0x%p)\n",p->pid, p->syscalls[i].name, a->type[0], a->str_argv[0], a->type[1], a->ptr_argv[0]);
8010446d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104470:	8d 57 1e             	lea    0x1e(%edi),%edx
80104473:	83 ec 04             	sub    $0x4,%esp
80104476:	ff b7 34 01 00 00    	pushl  0x134(%edi)
8010447c:	52                   	push   %edx
8010447d:	ff b7 14 01 00 00    	pushl  0x114(%edi)
80104483:	57                   	push   %edi
80104484:	ff 75 e4             	pushl  -0x1c(%ebp)
80104487:	ff 70 10             	pushl  0x10(%eax)
8010448a:	68 5b 88 10 80       	push   $0x8010885b
8010448f:	e8 5c c2 ff ff       	call   801006f0 <cprintf>
80104494:	83 c4 20             	add    $0x20,%esp
80104497:	e9 58 fe ff ff       	jmp    801042f4 <invocation_log+0x104>
              cprintf("%d %s  (%s 0x%p)\n",p->pid, p->syscalls[i].name, a->type[0], a->intptr_argv);
8010449c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010449f:	83 ec 0c             	sub    $0xc,%esp
801044a2:	ff b7 10 01 00 00    	pushl  0x110(%edi)
801044a8:	57                   	push   %edi
801044a9:	ff 75 e4             	pushl  -0x1c(%ebp)
801044ac:	ff 70 10             	pushl  0x10(%eax)
801044af:	68 49 88 10 80       	push   $0x80108849
801044b4:	e8 37 c2 ff ff       	call   801006f0 <cprintf>
801044b9:	83 c4 20             	add    $0x20,%esp
801044bc:	e9 33 fe ff ff       	jmp    801042f4 <invocation_log+0x104>
                cprintf("%d %s  (%s %d, %s 0x%p)\n",p->pid, p->syscalls[i].name, a->type[0], a->int_argv[0], a->type[1], a->st);
801044c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
801044c4:	8d 57 1e             	lea    0x1e(%edi),%edx
801044c7:	83 ec 04             	sub    $0x4,%esp
801044ca:	ff b7 54 01 00 00    	pushl  0x154(%edi)
801044d0:	52                   	push   %edx
801044d1:	ff b7 f0 00 00 00    	pushl  0xf0(%edi)
801044d7:	57                   	push   %edi
801044d8:	ff 75 e4             	pushl  -0x1c(%ebp)
801044db:	ff 70 10             	pushl  0x10(%eax)
801044de:	68 b4 88 10 80       	push   $0x801088b4
801044e3:	e8 08 c2 ff ff       	call   801006f0 <cprintf>
801044e8:	83 c4 20             	add    $0x20,%esp
801044eb:	e9 04 fe ff ff       	jmp    801042f4 <invocation_log+0x104>
                cprintf("%d %s  (%s %s, %s %d)\n",p->pid, p->syscalls[i].name, a->type[0], a->str_argv[0], a->type[1], a->int_argv[0]);
801044f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801044f3:	8d 57 1e             	lea    0x1e(%edi),%edx
801044f6:	83 ec 04             	sub    $0x4,%esp
801044f9:	ff b7 f0 00 00 00    	pushl  0xf0(%edi)
801044ff:	52                   	push   %edx
80104500:	ff b7 14 01 00 00    	pushl  0x114(%edi)
80104506:	57                   	push   %edi
80104507:	ff 75 e4             	pushl  -0x1c(%ebp)
8010450a:	ff 70 10             	pushl  0x10(%eax)
8010450d:	68 76 88 10 80       	push   $0x80108876
80104512:	e8 d9 c1 ff ff       	call   801006f0 <cprintf>
80104517:	83 c4 20             	add    $0x20,%esp
8010451a:	e9 d5 fd ff ff       	jmp    801042f4 <invocation_log+0x104>
              cprintf("%d %s  (%s %d, %s %d)\n",p->pid, p->syscalls[i].name,
8010451f:	8b 45 e0             	mov    -0x20(%ebp),%eax
                a->type[1],a->int_argv[1]);
80104522:	8d 57 1e             	lea    0x1e(%edi),%edx
              cprintf("%d %s  (%s %d, %s %d)\n",p->pid, p->syscalls[i].name,
80104525:	83 ec 04             	sub    $0x4,%esp
80104528:	ff b7 f4 00 00 00    	pushl  0xf4(%edi)
8010452e:	52                   	push   %edx
8010452f:	ff b7 f0 00 00 00    	pushl  0xf0(%edi)
80104535:	57                   	push   %edi
80104536:	ff 75 e4             	pushl  -0x1c(%ebp)
80104539:	ff 70 10             	pushl  0x10(%eax)
8010453c:	68 32 88 10 80       	push   $0x80108832
80104541:	e8 aa c1 ff ff       	call   801006f0 <cprintf>
80104546:	83 c4 20             	add    $0x20,%esp
80104549:	e9 66 fe ff ff       	jmp    801043b4 <invocation_log+0x1c4>
                  a->type[2], a->int_argv[1]);
8010454e:	8d 57 3c             	lea    0x3c(%edi),%edx
                cprintf("%d %s  (%s %s, %s %d, %s %d)\n",p->pid, p->syscalls[i].name, a->type[0], a->str_argv[0], a->type[1], a->int_argv[0],
80104551:	83 ec 0c             	sub    $0xc,%esp
80104554:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104557:	ff b7 f4 00 00 00    	pushl  0xf4(%edi)
8010455d:	52                   	push   %edx
8010455e:	8d 57 1e             	lea    0x1e(%edi),%edx
80104561:	ff b7 f0 00 00 00    	pushl  0xf0(%edi)
80104567:	52                   	push   %edx
80104568:	ff b7 14 01 00 00    	pushl  0x114(%edi)
8010456e:	57                   	push   %edi
8010456f:	ff 75 e4             	pushl  -0x1c(%ebp)
80104572:	ff 70 10             	pushl  0x10(%eax)
80104575:	68 cd 88 10 80       	push   $0x801088cd
8010457a:	e8 71 c1 ff ff       	call   801006f0 <cprintf>
8010457f:	83 c4 30             	add    $0x30,%esp
80104582:	e9 6d fd ff ff       	jmp    801042f4 <invocation_log+0x104>
        } 
      }
    }
  }

  release(&ptable.lock);
80104587:	83 ec 0c             	sub    $0xc,%esp
8010458a:	89 c6                	mov    %eax,%esi
8010458c:	68 40 4d 11 80       	push   $0x80114d40
80104591:	e8 ca 05 00 00       	call   80104b60 <release>

  if (status == -1)
80104596:	83 c4 10             	add    $0x10,%esp
80104599:	83 fe ff             	cmp    $0xffffffff,%esi
8010459c:	74 0a                	je     801045a8 <invocation_log+0x3b8>
    cprintf("pid not found!\n");

  return status;
}
8010459e:	8d 65 f4             	lea    -0xc(%ebp),%esp
801045a1:	89 f0                	mov    %esi,%eax
801045a3:	5b                   	pop    %ebx
801045a4:	5e                   	pop    %esi
801045a5:	5f                   	pop    %edi
801045a6:	5d                   	pop    %ebp
801045a7:	c3                   	ret    
    cprintf("pid not found!\n");
801045a8:	83 ec 0c             	sub    $0xc,%esp
801045ab:	68 eb 88 10 80       	push   $0x801088eb
801045b0:	e8 3b c1 ff ff       	call   801006f0 <cprintf>
801045b5:	83 c4 10             	add    $0x10,%esp
}
801045b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801045bb:	89 f0                	mov    %esi,%eax
801045bd:	5b                   	pop    %ebx
801045be:	5e                   	pop    %esi
801045bf:	5f                   	pop    %edi
801045c0:	5d                   	pop    %ebp
801045c1:	c3                   	ret    
801045c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045d0 <get_syscall_count>:

int
get_syscall_count(int pid, int sysnum)
{
801045d0:	55                   	push   %ebp
801045d1:	89 e5                	mov    %esp,%ebp
801045d3:	56                   	push   %esi
801045d4:	53                   	push   %ebx
801045d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;
  int count = 0, status = -1;
801045d8:	31 f6                	xor    %esi,%esi

  acquire(&ptable.lock);
801045da:	83 ec 0c             	sub    $0xc,%esp
801045dd:	68 40 4d 11 80       	push   $0x80114d40
801045e2:	e8 b9 04 00 00       	call   80104aa0 <acquire>
801045e7:	6b 4d 0c 34          	imul   $0x34,0xc(%ebp),%ecx
801045eb:	83 c4 10             	add    $0x10,%esp
  int count = 0, status = -1;
801045ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801045f3:	ba 74 4d 11 80       	mov    $0x80114d74,%edx
801045f8:	90                   	nop
801045f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  {
     if (p->pid == pid)
80104600:	39 5a 10             	cmp    %ebx,0x10(%edx)
80104603:	75 06                	jne    8010460b <get_syscall_count+0x3b>
     {
       count = p->syscalls[sysnum-1].count;
80104605:	8b 74 0a 48          	mov    0x48(%edx,%ecx,1),%esi
       status = 0;
80104609:	31 c0                	xor    %eax,%eax
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010460b:	81 c2 60 06 00 00    	add    $0x660,%edx
80104611:	81 fa 74 e5 12 80    	cmp    $0x8012e574,%edx
80104617:	72 e7                	jb     80104600 <get_syscall_count+0x30>
     }
  }

  if(status == -1)
80104619:	83 f8 ff             	cmp    $0xffffffff,%eax
8010461c:	74 19                	je     80104637 <get_syscall_count+0x67>
  {
    cprintf("pid not found!\n");
    release(&ptable.lock);
    return -1;
  }
  release(&ptable.lock);
8010461e:	83 ec 0c             	sub    $0xc,%esp
80104621:	68 40 4d 11 80       	push   $0x80114d40
80104626:	e8 35 05 00 00       	call   80104b60 <release>
  return count;
8010462b:	83 c4 10             	add    $0x10,%esp
}
8010462e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104631:	89 f0                	mov    %esi,%eax
80104633:	5b                   	pop    %ebx
80104634:	5e                   	pop    %esi
80104635:	5d                   	pop    %ebp
80104636:	c3                   	ret    
    cprintf("pid not found!\n");
80104637:	83 ec 0c             	sub    $0xc,%esp
    return -1;
8010463a:	be ff ff ff ff       	mov    $0xffffffff,%esi
    cprintf("pid not found!\n");
8010463f:	68 eb 88 10 80       	push   $0x801088eb
80104644:	e8 a7 c0 ff ff       	call   801006f0 <cprintf>
    release(&ptable.lock);
80104649:	c7 04 24 40 4d 11 80 	movl   $0x80114d40,(%esp)
80104650:	e8 0b 05 00 00       	call   80104b60 <release>
    return -1;
80104655:	83 c4 10             	add    $0x10,%esp
80104658:	eb d4                	jmp    8010462e <get_syscall_count+0x5e>
8010465a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104660 <log_syscalls>:

void 
log_syscalls(struct node* first_proc)
{
80104660:	55                   	push   %ebp
80104661:	89 e5                	mov    %esp,%ebp
80104663:	53                   	push   %ebx
80104664:	83 ec 04             	sub    $0x4,%esp
80104667:	8b 5d 08             	mov    0x8(%ebp),%ebx
  for(struct node* n = first_proc; n != 0; n = n->next){
8010466a:	85 db                	test   %ebx,%ebx
8010466c:	74 2f                	je     8010469d <log_syscalls+0x3d>
8010466e:	66 90                	xchg   %ax,%ax
    cprintf("Syscall name: %s @ DATE: %d:%d:%d %d-%d-%d by Process: %d\n", n -> name, n->date.hour, n->date.minute, n->date.second, n->date.year,
80104670:	83 ec 0c             	sub    $0xc,%esp
80104673:	ff 73 38             	pushl  0x38(%ebx)
80104676:	ff 73 2c             	pushl  0x2c(%ebx)
80104679:	ff 73 30             	pushl  0x30(%ebx)
8010467c:	ff 73 34             	pushl  0x34(%ebx)
8010467f:	ff 73 20             	pushl  0x20(%ebx)
80104682:	ff 73 24             	pushl  0x24(%ebx)
80104685:	ff 73 28             	pushl  0x28(%ebx)
80104688:	53                   	push   %ebx
80104689:	68 bc 89 10 80       	push   $0x801089bc
8010468e:	e8 5d c0 ff ff       	call   801006f0 <cprintf>
  for(struct node* n = first_proc; n != 0; n = n->next){
80104693:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104696:	83 c4 30             	add    $0x30,%esp
80104699:	85 db                	test   %ebx,%ebx
8010469b:	75 d3                	jne    80104670 <log_syscalls+0x10>
      n->date.month, n->date.day, n -> pid);
  }
}
8010469d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046a0:	c9                   	leave  
801046a1:	c3                   	ret    
801046a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801046b0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801046b0:	55                   	push   %ebp
801046b1:	89 e5                	mov    %esp,%ebp
801046b3:	53                   	push   %ebx
801046b4:	83 ec 10             	sub    $0x10,%esp
801046b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801046ba:	68 40 4d 11 80       	push   $0x80114d40
801046bf:	e8 dc 03 00 00       	call   80104aa0 <acquire>
801046c4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046c7:	b8 74 4d 11 80       	mov    $0x80114d74,%eax
801046cc:	eb 0e                	jmp    801046dc <kill+0x2c>
801046ce:	66 90                	xchg   %ax,%ax
801046d0:	05 60 06 00 00       	add    $0x660,%eax
801046d5:	3d 74 e5 12 80       	cmp    $0x8012e574,%eax
801046da:	73 34                	jae    80104710 <kill+0x60>
    if(p->pid == pid){
801046dc:	39 58 10             	cmp    %ebx,0x10(%eax)
801046df:	75 ef                	jne    801046d0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801046e1:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801046e5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801046ec:	75 07                	jne    801046f5 <kill+0x45>
        p->state = RUNNABLE;
801046ee:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801046f5:	83 ec 0c             	sub    $0xc,%esp
801046f8:	68 40 4d 11 80       	push   $0x80114d40
801046fd:	e8 5e 04 00 00       	call   80104b60 <release>
      return 0;
80104702:	83 c4 10             	add    $0x10,%esp
80104705:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104707:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010470a:	c9                   	leave  
8010470b:	c3                   	ret    
8010470c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104710:	83 ec 0c             	sub    $0xc,%esp
80104713:	68 40 4d 11 80       	push   $0x80114d40
80104718:	e8 43 04 00 00       	call   80104b60 <release>
  return -1;
8010471d:	83 c4 10             	add    $0x10,%esp
80104720:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104725:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104728:	c9                   	leave  
80104729:	c3                   	ret    
8010472a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104730 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104730:	55                   	push   %ebp
80104731:	89 e5                	mov    %esp,%ebp
80104733:	57                   	push   %edi
80104734:	56                   	push   %esi
80104735:	53                   	push   %ebx
  struct proc *p;
  char *state;
  uint pc[10];
  int count=0;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104736:	bf 74 4d 11 80       	mov    $0x80114d74,%edi
  int count=0;
8010473b:	31 db                	xor    %ebx,%ebx
{
8010473d:	83 ec 3c             	sub    $0x3c,%esp
    if(p->state == UNUSED)
80104740:	8b 47 0c             	mov    0xc(%edi),%eax
80104743:	85 c0                	test   %eax,%eax
80104745:	74 61                	je     801047a8 <procdump+0x78>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104747:	83 f8 05             	cmp    $0x5,%eax
      state = states[p->state];
    else
      state = "???";
8010474a:	b9 fb 88 10 80       	mov    $0x801088fb,%ecx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010474f:	77 11                	ja     80104762 <procdump+0x32>
80104751:	8b 0c 85 f8 89 10 80 	mov    -0x7fef7608(,%eax,4),%ecx
      state = "???";
80104758:	b8 fb 88 10 80       	mov    $0x801088fb,%eax
8010475d:	85 c9                	test   %ecx,%ecx
8010475f:	0f 44 c8             	cmove  %eax,%ecx
80104762:	8d 47 7c             	lea    0x7c(%edi),%eax
80104765:	8d 97 5c 05 00 00    	lea    0x55c(%edi),%edx
8010476b:	90                   	nop
8010476c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(i=0;i<24;i++)
      count += p->syscalls[i].count;
80104770:	03 18                	add    (%eax),%ebx
80104772:	83 c0 34             	add    $0x34,%eax
    for(i=0;i<24;i++)
80104775:	39 d0                	cmp    %edx,%eax
80104777:	75 f7                	jne    80104770 <procdump+0x40>
    cprintf("%d %s %s count:%d", p->pid, state, p->name,count);
80104779:	8d 47 6c             	lea    0x6c(%edi),%eax
8010477c:	83 ec 0c             	sub    $0xc,%esp
8010477f:	53                   	push   %ebx
80104780:	50                   	push   %eax
80104781:	51                   	push   %ecx
80104782:	ff 77 10             	pushl  0x10(%edi)
80104785:	68 ff 88 10 80       	push   $0x801088ff
8010478a:	e8 61 bf ff ff       	call   801006f0 <cprintf>
    if(p->state == SLEEPING){
8010478f:	83 c4 20             	add    $0x20,%esp
80104792:	83 7f 0c 02          	cmpl   $0x2,0xc(%edi)
80104796:	74 26                	je     801047be <procdump+0x8e>
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104798:	83 ec 0c             	sub    $0xc,%esp
8010479b:	68 f9 88 10 80       	push   $0x801088f9
801047a0:	e8 4b bf ff ff       	call   801006f0 <cprintf>
801047a5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047a8:	81 c7 60 06 00 00    	add    $0x660,%edi
801047ae:	81 ff 74 e5 12 80    	cmp    $0x8012e574,%edi
801047b4:	72 8a                	jb     80104740 <procdump+0x10>
  }
}
801047b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801047b9:	5b                   	pop    %ebx
801047ba:	5e                   	pop    %esi
801047bb:	5f                   	pop    %edi
801047bc:	5d                   	pop    %ebp
801047bd:	c3                   	ret    
      getcallerpcs((uint*)p->context->ebp+2, pc);
801047be:	8d 45 c0             	lea    -0x40(%ebp),%eax
801047c1:	83 ec 08             	sub    $0x8,%esp
801047c4:	8d 75 c0             	lea    -0x40(%ebp),%esi
801047c7:	50                   	push   %eax
801047c8:	8b 47 1c             	mov    0x1c(%edi),%eax
801047cb:	8b 40 0c             	mov    0xc(%eax),%eax
801047ce:	83 c0 08             	add    $0x8,%eax
801047d1:	50                   	push   %eax
801047d2:	e8 a9 01 00 00       	call   80104980 <getcallerpcs>
801047d7:	83 c4 10             	add    $0x10,%esp
801047da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
801047e0:	8b 06                	mov    (%esi),%eax
801047e2:	85 c0                	test   %eax,%eax
801047e4:	74 b2                	je     80104798 <procdump+0x68>
        cprintf(" %p", pc[i]);
801047e6:	83 ec 08             	sub    $0x8,%esp
801047e9:	83 c6 04             	add    $0x4,%esi
801047ec:	50                   	push   %eax
801047ed:	68 61 82 10 80       	push   $0x80108261
801047f2:	e8 f9 be ff ff       	call   801006f0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801047f7:	8d 45 e8             	lea    -0x18(%ebp),%eax
801047fa:	83 c4 10             	add    $0x10,%esp
801047fd:	39 c6                	cmp    %eax,%esi
801047ff:	75 df                	jne    801047e0 <procdump+0xb0>
80104801:	eb 95                	jmp    80104798 <procdump+0x68>
80104803:	66 90                	xchg   %ax,%ax
80104805:	66 90                	xchg   %ax,%ax
80104807:	66 90                	xchg   %ax,%ax
80104809:	66 90                	xchg   %ax,%ax
8010480b:	66 90                	xchg   %ax,%ax
8010480d:	66 90                	xchg   %ax,%ax
8010480f:	90                   	nop

80104810 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104810:	55                   	push   %ebp
80104811:	89 e5                	mov    %esp,%ebp
80104813:	53                   	push   %ebx
80104814:	83 ec 0c             	sub    $0xc,%esp
80104817:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010481a:	68 10 8a 10 80       	push   $0x80108a10
8010481f:	8d 43 04             	lea    0x4(%ebx),%eax
80104822:	50                   	push   %eax
80104823:	e8 38 01 00 00       	call   80104960 <initlock>
  lk->name = name;
80104828:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010482b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104831:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104834:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010483b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010483e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104841:	c9                   	leave  
80104842:	c3                   	ret    
80104843:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104850 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104850:	55                   	push   %ebp
80104851:	89 e5                	mov    %esp,%ebp
80104853:	56                   	push   %esi
80104854:	53                   	push   %ebx
80104855:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104858:	83 ec 0c             	sub    $0xc,%esp
8010485b:	8d 73 04             	lea    0x4(%ebx),%esi
8010485e:	56                   	push   %esi
8010485f:	e8 3c 02 00 00       	call   80104aa0 <acquire>
  while (lk->locked) {
80104864:	8b 13                	mov    (%ebx),%edx
80104866:	83 c4 10             	add    $0x10,%esp
80104869:	85 d2                	test   %edx,%edx
8010486b:	74 16                	je     80104883 <acquiresleep+0x33>
8010486d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104870:	83 ec 08             	sub    $0x8,%esp
80104873:	56                   	push   %esi
80104874:	53                   	push   %ebx
80104875:	e8 56 f7 ff ff       	call   80103fd0 <sleep>
  while (lk->locked) {
8010487a:	8b 03                	mov    (%ebx),%eax
8010487c:	83 c4 10             	add    $0x10,%esp
8010487f:	85 c0                	test   %eax,%eax
80104881:	75 ed                	jne    80104870 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104883:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104889:	e8 32 f1 ff ff       	call   801039c0 <myproc>
8010488e:	8b 40 10             	mov    0x10(%eax),%eax
80104891:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104894:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104897:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010489a:	5b                   	pop    %ebx
8010489b:	5e                   	pop    %esi
8010489c:	5d                   	pop    %ebp
  release(&lk->lk);
8010489d:	e9 be 02 00 00       	jmp    80104b60 <release>
801048a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801048b0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801048b0:	55                   	push   %ebp
801048b1:	89 e5                	mov    %esp,%ebp
801048b3:	57                   	push   %edi
801048b4:	56                   	push   %esi
801048b5:	53                   	push   %ebx
801048b6:	83 ec 18             	sub    $0x18,%esp
801048b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801048bc:	8d 73 04             	lea    0x4(%ebx),%esi
801048bf:	56                   	push   %esi
801048c0:	e8 db 01 00 00       	call   80104aa0 <acquire>
  if (lk->locked && (lk->pid == myproc()->pid)){
801048c5:	8b 03                	mov    (%ebx),%eax
801048c7:	83 c4 10             	add    $0x10,%esp
801048ca:	85 c0                	test   %eax,%eax
801048cc:	75 12                	jne    801048e0 <releasesleep+0x30>
    lk->locked = 0;
    lk->pid = 0;
    wakeup(lk);
  }
  release(&lk->lk);
801048ce:	89 75 08             	mov    %esi,0x8(%ebp)
}
801048d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801048d4:	5b                   	pop    %ebx
801048d5:	5e                   	pop    %esi
801048d6:	5f                   	pop    %edi
801048d7:	5d                   	pop    %ebp
  release(&lk->lk);
801048d8:	e9 83 02 00 00       	jmp    80104b60 <release>
801048dd:	8d 76 00             	lea    0x0(%esi),%esi
  if (lk->locked && (lk->pid == myproc()->pid)){
801048e0:	8b 7b 3c             	mov    0x3c(%ebx),%edi
801048e3:	e8 d8 f0 ff ff       	call   801039c0 <myproc>
801048e8:	3b 78 10             	cmp    0x10(%eax),%edi
801048eb:	75 e1                	jne    801048ce <releasesleep+0x1e>
    wakeup(lk);
801048ed:	83 ec 0c             	sub    $0xc,%esp
    lk->locked = 0;
801048f0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
    lk->pid = 0;
801048f6:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
    wakeup(lk);
801048fd:	53                   	push   %ebx
801048fe:	e8 8d f8 ff ff       	call   80104190 <wakeup>
80104903:	83 c4 10             	add    $0x10,%esp
80104906:	eb c6                	jmp    801048ce <releasesleep+0x1e>
80104908:	90                   	nop
80104909:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104910 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104910:	55                   	push   %ebp
80104911:	89 e5                	mov    %esp,%ebp
80104913:	57                   	push   %edi
80104914:	56                   	push   %esi
80104915:	53                   	push   %ebx
80104916:	31 ff                	xor    %edi,%edi
80104918:	83 ec 18             	sub    $0x18,%esp
8010491b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010491e:	8d 73 04             	lea    0x4(%ebx),%esi
80104921:	56                   	push   %esi
80104922:	e8 79 01 00 00       	call   80104aa0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104927:	8b 03                	mov    (%ebx),%eax
80104929:	83 c4 10             	add    $0x10,%esp
8010492c:	85 c0                	test   %eax,%eax
8010492e:	74 13                	je     80104943 <holdingsleep+0x33>
80104930:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104933:	e8 88 f0 ff ff       	call   801039c0 <myproc>
80104938:	39 58 10             	cmp    %ebx,0x10(%eax)
8010493b:	0f 94 c0             	sete   %al
8010493e:	0f b6 c0             	movzbl %al,%eax
80104941:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104943:	83 ec 0c             	sub    $0xc,%esp
80104946:	56                   	push   %esi
80104947:	e8 14 02 00 00       	call   80104b60 <release>
  return r;
}
8010494c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010494f:	89 f8                	mov    %edi,%eax
80104951:	5b                   	pop    %ebx
80104952:	5e                   	pop    %esi
80104953:	5f                   	pop    %edi
80104954:	5d                   	pop    %ebp
80104955:	c3                   	ret    
80104956:	66 90                	xchg   %ax,%ax
80104958:	66 90                	xchg   %ax,%ax
8010495a:	66 90                	xchg   %ax,%ax
8010495c:	66 90                	xchg   %ax,%ax
8010495e:	66 90                	xchg   %ax,%ax

80104960 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104960:	55                   	push   %ebp
80104961:	89 e5                	mov    %esp,%ebp
80104963:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104966:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104969:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010496f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104972:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104979:	5d                   	pop    %ebp
8010497a:	c3                   	ret    
8010497b:	90                   	nop
8010497c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104980 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104980:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104981:	31 d2                	xor    %edx,%edx
{
80104983:	89 e5                	mov    %esp,%ebp
80104985:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104986:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104989:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010498c:	83 e8 08             	sub    $0x8,%eax
8010498f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104990:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104996:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010499c:	77 1a                	ja     801049b8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010499e:	8b 58 04             	mov    0x4(%eax),%ebx
801049a1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801049a4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801049a7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801049a9:	83 fa 0a             	cmp    $0xa,%edx
801049ac:	75 e2                	jne    80104990 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801049ae:	5b                   	pop    %ebx
801049af:	5d                   	pop    %ebp
801049b0:	c3                   	ret    
801049b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049b8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801049bb:	83 c1 28             	add    $0x28,%ecx
801049be:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801049c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801049c6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
801049c9:	39 c1                	cmp    %eax,%ecx
801049cb:	75 f3                	jne    801049c0 <getcallerpcs+0x40>
}
801049cd:	5b                   	pop    %ebx
801049ce:	5d                   	pop    %ebp
801049cf:	c3                   	ret    

801049d0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801049d0:	55                   	push   %ebp
801049d1:	89 e5                	mov    %esp,%ebp
801049d3:	53                   	push   %ebx
801049d4:	83 ec 04             	sub    $0x4,%esp
801049d7:	9c                   	pushf  
801049d8:	5b                   	pop    %ebx
  asm volatile("cli");
801049d9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801049da:	e8 41 ef ff ff       	call   80103920 <mycpu>
801049df:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801049e5:	85 c0                	test   %eax,%eax
801049e7:	75 11                	jne    801049fa <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
801049e9:	81 e3 00 02 00 00    	and    $0x200,%ebx
801049ef:	e8 2c ef ff ff       	call   80103920 <mycpu>
801049f4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
801049fa:	e8 21 ef ff ff       	call   80103920 <mycpu>
801049ff:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104a06:	83 c4 04             	add    $0x4,%esp
80104a09:	5b                   	pop    %ebx
80104a0a:	5d                   	pop    %ebp
80104a0b:	c3                   	ret    
80104a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104a10 <popcli>:

void
popcli(void)
{
80104a10:	55                   	push   %ebp
80104a11:	89 e5                	mov    %esp,%ebp
80104a13:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104a16:	9c                   	pushf  
80104a17:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104a18:	f6 c4 02             	test   $0x2,%ah
80104a1b:	75 35                	jne    80104a52 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104a1d:	e8 fe ee ff ff       	call   80103920 <mycpu>
80104a22:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104a29:	78 34                	js     80104a5f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104a2b:	e8 f0 ee ff ff       	call   80103920 <mycpu>
80104a30:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104a36:	85 d2                	test   %edx,%edx
80104a38:	74 06                	je     80104a40 <popcli+0x30>
    sti();
}
80104a3a:	c9                   	leave  
80104a3b:	c3                   	ret    
80104a3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104a40:	e8 db ee ff ff       	call   80103920 <mycpu>
80104a45:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104a4b:	85 c0                	test   %eax,%eax
80104a4d:	74 eb                	je     80104a3a <popcli+0x2a>
  asm volatile("sti");
80104a4f:	fb                   	sti    
}
80104a50:	c9                   	leave  
80104a51:	c3                   	ret    
    panic("popcli - interruptible");
80104a52:	83 ec 0c             	sub    $0xc,%esp
80104a55:	68 1b 8a 10 80       	push   $0x80108a1b
80104a5a:	e8 31 b9 ff ff       	call   80100390 <panic>
    panic("popcli");
80104a5f:	83 ec 0c             	sub    $0xc,%esp
80104a62:	68 32 8a 10 80       	push   $0x80108a32
80104a67:	e8 24 b9 ff ff       	call   80100390 <panic>
80104a6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104a70 <holding>:
{
80104a70:	55                   	push   %ebp
80104a71:	89 e5                	mov    %esp,%ebp
80104a73:	56                   	push   %esi
80104a74:	53                   	push   %ebx
80104a75:	8b 75 08             	mov    0x8(%ebp),%esi
80104a78:	31 db                	xor    %ebx,%ebx
  pushcli();
80104a7a:	e8 51 ff ff ff       	call   801049d0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104a7f:	8b 06                	mov    (%esi),%eax
80104a81:	85 c0                	test   %eax,%eax
80104a83:	74 10                	je     80104a95 <holding+0x25>
80104a85:	8b 5e 08             	mov    0x8(%esi),%ebx
80104a88:	e8 93 ee ff ff       	call   80103920 <mycpu>
80104a8d:	39 c3                	cmp    %eax,%ebx
80104a8f:	0f 94 c3             	sete   %bl
80104a92:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104a95:	e8 76 ff ff ff       	call   80104a10 <popcli>
}
80104a9a:	89 d8                	mov    %ebx,%eax
80104a9c:	5b                   	pop    %ebx
80104a9d:	5e                   	pop    %esi
80104a9e:	5d                   	pop    %ebp
80104a9f:	c3                   	ret    

80104aa0 <acquire>:
{
80104aa0:	55                   	push   %ebp
80104aa1:	89 e5                	mov    %esp,%ebp
80104aa3:	56                   	push   %esi
80104aa4:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104aa5:	e8 26 ff ff ff       	call   801049d0 <pushcli>
  if(holding(lk))
80104aaa:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104aad:	83 ec 0c             	sub    $0xc,%esp
80104ab0:	53                   	push   %ebx
80104ab1:	e8 ba ff ff ff       	call   80104a70 <holding>
80104ab6:	83 c4 10             	add    $0x10,%esp
80104ab9:	85 c0                	test   %eax,%eax
80104abb:	0f 85 83 00 00 00    	jne    80104b44 <acquire+0xa4>
80104ac1:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104ac3:	ba 01 00 00 00       	mov    $0x1,%edx
80104ac8:	eb 09                	jmp    80104ad3 <acquire+0x33>
80104aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ad0:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104ad3:	89 d0                	mov    %edx,%eax
80104ad5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104ad8:	85 c0                	test   %eax,%eax
80104ada:	75 f4                	jne    80104ad0 <acquire+0x30>
  __sync_synchronize();
80104adc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104ae1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104ae4:	e8 37 ee ff ff       	call   80103920 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104ae9:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
80104aec:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104aef:	89 e8                	mov    %ebp,%eax
80104af1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104af8:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80104afe:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80104b04:	77 1a                	ja     80104b20 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104b06:	8b 48 04             	mov    0x4(%eax),%ecx
80104b09:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
80104b0c:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104b0f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104b11:	83 fe 0a             	cmp    $0xa,%esi
80104b14:	75 e2                	jne    80104af8 <acquire+0x58>
}
80104b16:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b19:	5b                   	pop    %ebx
80104b1a:	5e                   	pop    %esi
80104b1b:	5d                   	pop    %ebp
80104b1c:	c3                   	ret    
80104b1d:	8d 76 00             	lea    0x0(%esi),%esi
80104b20:	8d 04 b2             	lea    (%edx,%esi,4),%eax
80104b23:	83 c2 28             	add    $0x28,%edx
80104b26:	8d 76 00             	lea    0x0(%esi),%esi
80104b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80104b30:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104b36:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104b39:	39 d0                	cmp    %edx,%eax
80104b3b:	75 f3                	jne    80104b30 <acquire+0x90>
}
80104b3d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b40:	5b                   	pop    %ebx
80104b41:	5e                   	pop    %esi
80104b42:	5d                   	pop    %ebp
80104b43:	c3                   	ret    
    panic("acquire");
80104b44:	83 ec 0c             	sub    $0xc,%esp
80104b47:	68 39 8a 10 80       	push   $0x80108a39
80104b4c:	e8 3f b8 ff ff       	call   80100390 <panic>
80104b51:	eb 0d                	jmp    80104b60 <release>
80104b53:	90                   	nop
80104b54:	90                   	nop
80104b55:	90                   	nop
80104b56:	90                   	nop
80104b57:	90                   	nop
80104b58:	90                   	nop
80104b59:	90                   	nop
80104b5a:	90                   	nop
80104b5b:	90                   	nop
80104b5c:	90                   	nop
80104b5d:	90                   	nop
80104b5e:	90                   	nop
80104b5f:	90                   	nop

80104b60 <release>:
{
80104b60:	55                   	push   %ebp
80104b61:	89 e5                	mov    %esp,%ebp
80104b63:	53                   	push   %ebx
80104b64:	83 ec 10             	sub    $0x10,%esp
80104b67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104b6a:	53                   	push   %ebx
80104b6b:	e8 00 ff ff ff       	call   80104a70 <holding>
80104b70:	83 c4 10             	add    $0x10,%esp
80104b73:	85 c0                	test   %eax,%eax
80104b75:	74 22                	je     80104b99 <release+0x39>
  lk->pcs[0] = 0;
80104b77:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104b7e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104b85:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104b8a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104b90:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b93:	c9                   	leave  
  popcli();
80104b94:	e9 77 fe ff ff       	jmp    80104a10 <popcli>
    panic("release");
80104b99:	83 ec 0c             	sub    $0xc,%esp
80104b9c:	68 41 8a 10 80       	push   $0x80108a41
80104ba1:	e8 ea b7 ff ff       	call   80100390 <panic>
80104ba6:	66 90                	xchg   %ax,%ax
80104ba8:	66 90                	xchg   %ax,%ax
80104baa:	66 90                	xchg   %ax,%ax
80104bac:	66 90                	xchg   %ax,%ax
80104bae:	66 90                	xchg   %ax,%ax

80104bb0 <init_ticket_lock>:
#include "mmu.h"
#include "proc.h"
#include "spinlock.h"
#include "ticket_lock.h"

void init_ticket_lock(struct ticket_lock* lk, char* name) {
80104bb0:	55                   	push   %ebp
80104bb1:	89 e5                	mov    %esp,%ebp
80104bb3:	8b 45 08             	mov    0x8(%ebp),%eax
	lk->name = name;
80104bb6:	8b 55 0c             	mov    0xc(%ebp),%edx
	lk->pid = 0;
80104bb9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	lk->name = name;
80104bc0:	89 50 0c             	mov    %edx,0xc(%eax)
	lk->ticket = 0;
80104bc3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	lk->turn = 0;
80104bc9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
}
80104bd0:	5d                   	pop    %ebp
80104bd1:	c3                   	ret    
80104bd2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104be0 <ticket_acquire>:

void ticket_acquire(struct ticket_lock* lk) {
80104be0:	55                   	push   %ebp
80104be1:	89 e5                	mov    %esp,%ebp
80104be3:	56                   	push   %esi
//  return val;
//}

static inline int fetch_and_add(int* variable, int value)
  {
      __asm__ volatile("lock; xaddl %0, %1"
80104be4:	be 01 00 00 00       	mov    $0x1,%esi
80104be9:	53                   	push   %ebx
80104bea:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104bed:	f0 0f c1 33          	lock xadd %esi,(%ebx)
	uint me = fetch_and_add(&lk->ticket, 1);
	//cprintf("after inc %d %d\n", me, lk->ticket);
	while(lk->turn != me){
80104bf1:	3b 73 04             	cmp    0x4(%ebx),%esi
80104bf4:	74 1b                	je     80104c11 <ticket_acquire+0x31>
80104bf6:	8d 76 00             	lea    0x0(%esi),%esi
80104bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
		sleep_without_spin(lk);
80104c00:	83 ec 0c             	sub    $0xc,%esp
80104c03:	53                   	push   %ebx
80104c04:	e8 57 f3 ff ff       	call   80103f60 <sleep_without_spin>
	while(lk->turn != me){
80104c09:	83 c4 10             	add    $0x10,%esp
80104c0c:	39 73 04             	cmp    %esi,0x4(%ebx)
80104c0f:	75 ef                	jne    80104c00 <ticket_acquire+0x20>
	}
	lk->pid = myproc()->pid;
80104c11:	e8 aa ed ff ff       	call   801039c0 <myproc>
80104c16:	8b 40 10             	mov    0x10(%eax),%eax
80104c19:	89 43 08             	mov    %eax,0x8(%ebx)
}
80104c1c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c1f:	5b                   	pop    %ebx
80104c20:	5e                   	pop    %esi
80104c21:	5d                   	pop    %ebp
80104c22:	c3                   	ret    
80104c23:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c30 <ticket_release>:

void ticket_release(struct ticket_lock* lk) {
80104c30:	55                   	push   %ebp
80104c31:	89 e5                	mov    %esp,%ebp
80104c33:	56                   	push   %esi
80104c34:	53                   	push   %ebx
80104c35:	8b 5d 08             	mov    0x8(%ebp),%ebx
	
	if (lk->pid == myproc()->pid)
80104c38:	8b 73 08             	mov    0x8(%ebx),%esi
80104c3b:	e8 80 ed ff ff       	call   801039c0 <myproc>
80104c40:	3b 70 10             	cmp    0x10(%eax),%esi
80104c43:	74 0b                	je     80104c50 <ticket_release+0x20>
	{
		lk->pid = 0;
		fetch_and_add(&lk->turn, 1);
		wakeup(lk);
	}
}
80104c45:	5b                   	pop    %ebx
80104c46:	5e                   	pop    %esi
80104c47:	5d                   	pop    %ebp
80104c48:	c3                   	ret    
80104c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		lk->pid = 0;
80104c50:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
80104c57:	b8 01 00 00 00       	mov    $0x1,%eax
80104c5c:	f0 0f c1 43 04       	lock xadd %eax,0x4(%ebx)
		wakeup(lk);
80104c61:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80104c64:	5b                   	pop    %ebx
80104c65:	5e                   	pop    %esi
80104c66:	5d                   	pop    %ebp
		wakeup(lk);
80104c67:	e9 24 f5 ff ff       	jmp    80104190 <wakeup>
80104c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104c70 <ticket_holding>:

int ticket_holding(struct ticket_lock* lk) {
80104c70:	55                   	push   %ebp
80104c71:	31 c0                	xor    %eax,%eax
80104c73:	89 e5                	mov    %esp,%ebp
80104c75:	53                   	push   %ebx
80104c76:	83 ec 04             	sub    $0x4,%esp
80104c79:	8b 55 08             	mov    0x8(%ebp),%edx
	return (lk->ticket != lk->turn) && (lk->pid == myproc()->pid);
80104c7c:	8b 4a 04             	mov    0x4(%edx),%ecx
80104c7f:	39 0a                	cmp    %ecx,(%edx)
80104c81:	74 11                	je     80104c94 <ticket_holding+0x24>
80104c83:	8b 5a 08             	mov    0x8(%edx),%ebx
80104c86:	e8 35 ed ff ff       	call   801039c0 <myproc>
80104c8b:	39 58 10             	cmp    %ebx,0x10(%eax)
80104c8e:	0f 94 c0             	sete   %al
80104c91:	0f b6 c0             	movzbl %al,%eax
}
80104c94:	83 c4 04             	add    $0x4,%esp
80104c97:	5b                   	pop    %ebx
80104c98:	5d                   	pop    %ebp
80104c99:	c3                   	ret    
80104c9a:	66 90                	xchg   %ax,%ax
80104c9c:	66 90                	xchg   %ax,%ax
80104c9e:	66 90                	xchg   %ax,%ax

80104ca0 <sem_init>:
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "semaphore.h"

void sem_init(struct semaphore * s, uint i) {
80104ca0:	55                   	push   %ebp
80104ca1:	89 e5                	mov    %esp,%ebp
80104ca3:	53                   	push   %ebx
80104ca4:	83 ec 0c             	sub    $0xc,%esp
80104ca7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int j;
  s->val = i;
80104caa:	8b 45 0c             	mov    0xc(%ebp),%eax
80104cad:	89 03                	mov    %eax,(%ebx)
  //cprintf("%s sem_init: val = %d\n", name, s->val);
  initlock(&s->lock, (char*)s);
80104caf:	8d 43 04             	lea    0x4(%ebx),%eax
80104cb2:	53                   	push   %ebx
80104cb3:	50                   	push   %eax
80104cb4:	e8 a7 fc ff ff       	call   80104960 <initlock>
80104cb9:	8d 43 38             	lea    0x38(%ebx),%eax
80104cbc:	8d 93 38 01 00 00    	lea    0x138(%ebx),%edx
80104cc2:	83 c4 10             	add    $0x10,%esp
80104cc5:	8d 76 00             	lea    0x0(%esi),%esi
  for (j = 0; j < NPROC; j++)
    s->thread[j] = 0;
80104cc8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104cce:	83 c0 04             	add    $0x4,%eax
  for (j = 0; j < NPROC; j++)
80104cd1:	39 d0                	cmp    %edx,%eax
80104cd3:	75 f3                	jne    80104cc8 <sem_init+0x28>
  s->next = s->end = 0;
80104cd5:	c7 83 3c 01 00 00 00 	movl   $0x0,0x13c(%ebx)
80104cdc:	00 00 00 
80104cdf:	c7 83 38 01 00 00 00 	movl   $0x0,0x138(%ebx)
80104ce6:	00 00 00 
}
80104ce9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104cec:	c9                   	leave  
80104ced:	c3                   	ret    
80104cee:	66 90                	xchg   %ax,%ax

80104cf0 <sem_wait>:

void sem_wait(struct semaphore * s) {
80104cf0:	55                   	push   %ebp
80104cf1:	89 e5                	mov    %esp,%ebp
80104cf3:	57                   	push   %edi
80104cf4:	56                   	push   %esi
80104cf5:	53                   	push   %ebx
80104cf6:	83 ec 18             	sub    $0x18,%esp
80104cf9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&s->lock);
80104cfc:	8d 5e 04             	lea    0x4(%esi),%ebx
80104cff:	53                   	push   %ebx
80104d00:	e8 9b fd ff ff       	call   80104aa0 <acquire>
  //s->thread[s->end] = proc;
  //s->end = (s->end + 1) % NPROC;
  while (s->val == 0) {
80104d05:	8b 06                	mov    (%esi),%eax
80104d07:	83 c4 10             	add    $0x10,%esp
80104d0a:	85 c0                	test   %eax,%eax
80104d0c:	75 3b                	jne    80104d49 <sem_wait+0x59>
80104d0e:	66 90                	xchg   %ax,%ax
    s->thread[s->end] = myproc();
80104d10:	8b be 3c 01 00 00    	mov    0x13c(%esi),%edi
80104d16:	e8 a5 ec ff ff       	call   801039c0 <myproc>
80104d1b:	89 44 be 38          	mov    %eax,0x38(%esi,%edi,4)
    s->end = (s->end + 1) % NPROC;
80104d1f:	8b 86 3c 01 00 00    	mov    0x13c(%esi),%eax
80104d25:	83 c0 01             	add    $0x1,%eax
80104d28:	83 e0 3f             	and    $0x3f,%eax
80104d2b:	89 86 3c 01 00 00    	mov    %eax,0x13c(%esi)
    sleep(myproc(), &s->lock);
80104d31:	e8 8a ec ff ff       	call   801039c0 <myproc>
80104d36:	83 ec 08             	sub    $0x8,%esp
80104d39:	53                   	push   %ebx
80104d3a:	50                   	push   %eax
80104d3b:	e8 90 f2 ff ff       	call   80103fd0 <sleep>
  while (s->val == 0) {
80104d40:	8b 06                	mov    (%esi),%eax
80104d42:	83 c4 10             	add    $0x10,%esp
80104d45:	85 c0                	test   %eax,%eax
80104d47:	74 c7                	je     80104d10 <sem_wait+0x20>
  }
  s->val = s->val - 1;
80104d49:	83 e8 01             	sub    $0x1,%eax
80104d4c:	89 06                	mov    %eax,(%esi)
  //cprintf("%s sem_wait: val = %d\n", s->name, s->val);
  release(&s->lock);
80104d4e:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80104d51:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d54:	5b                   	pop    %ebx
80104d55:	5e                   	pop    %esi
80104d56:	5f                   	pop    %edi
80104d57:	5d                   	pop    %ebp
  release(&s->lock);
80104d58:	e9 03 fe ff ff       	jmp    80104b60 <release>
80104d5d:	8d 76 00             	lea    0x0(%esi),%esi

80104d60 <sem_signal>:

void sem_signal(struct semaphore * s) {
80104d60:	55                   	push   %ebp
80104d61:	89 e5                	mov    %esp,%ebp
80104d63:	56                   	push   %esi
80104d64:	53                   	push   %ebx
80104d65:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&s->lock);
80104d68:	83 ec 0c             	sub    $0xc,%esp
80104d6b:	8d 73 04             	lea    0x4(%ebx),%esi
80104d6e:	56                   	push   %esi
80104d6f:	e8 2c fd ff ff       	call   80104aa0 <acquire>
  s->val = s->val + 1;
  //cprintf("%s sem_signal: val = %d\n", s->name, s->val);
  if (s->thread[s->next]) {
80104d74:	8b 83 38 01 00 00    	mov    0x138(%ebx),%eax
  s->val = s->val + 1;
80104d7a:	83 03 01             	addl   $0x1,(%ebx)
  if (s->thread[s->next]) {
80104d7d:	83 c4 10             	add    $0x10,%esp
80104d80:	8b 44 83 38          	mov    0x38(%ebx,%eax,4),%eax
80104d84:	85 c0                	test   %eax,%eax
80104d86:	74 26                	je     80104dae <sem_signal+0x4e>
    wakeup(s->thread[s->next]);
80104d88:	83 ec 0c             	sub    $0xc,%esp
80104d8b:	50                   	push   %eax
80104d8c:	e8 ff f3 ff ff       	call   80104190 <wakeup>
    s->thread[s->next] = 0;
80104d91:	8b 83 38 01 00 00    	mov    0x138(%ebx),%eax
    s->next = (s->next + 1) % NPROC;
80104d97:	83 c4 10             	add    $0x10,%esp
    s->thread[s->next] = 0;
80104d9a:	c7 44 83 38 00 00 00 	movl   $0x0,0x38(%ebx,%eax,4)
80104da1:	00 
    s->next = (s->next + 1) % NPROC;
80104da2:	83 c0 01             	add    $0x1,%eax
80104da5:	83 e0 3f             	and    $0x3f,%eax
80104da8:	89 83 38 01 00 00    	mov    %eax,0x138(%ebx)
  }
  release(&s->lock);
80104dae:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104db1:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104db4:	5b                   	pop    %ebx
80104db5:	5e                   	pop    %esi
80104db6:	5d                   	pop    %ebp
  release(&s->lock);
80104db7:	e9 a4 fd ff ff       	jmp    80104b60 <release>
80104dbc:	66 90                	xchg   %ax,%ax
80104dbe:	66 90                	xchg   %ax,%ax

80104dc0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104dc0:	55                   	push   %ebp
80104dc1:	89 e5                	mov    %esp,%ebp
80104dc3:	57                   	push   %edi
80104dc4:	53                   	push   %ebx
80104dc5:	8b 55 08             	mov    0x8(%ebp),%edx
80104dc8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104dcb:	f6 c2 03             	test   $0x3,%dl
80104dce:	75 05                	jne    80104dd5 <memset+0x15>
80104dd0:	f6 c1 03             	test   $0x3,%cl
80104dd3:	74 13                	je     80104de8 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104dd5:	89 d7                	mov    %edx,%edi
80104dd7:	8b 45 0c             	mov    0xc(%ebp),%eax
80104dda:	fc                   	cld    
80104ddb:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104ddd:	5b                   	pop    %ebx
80104dde:	89 d0                	mov    %edx,%eax
80104de0:	5f                   	pop    %edi
80104de1:	5d                   	pop    %ebp
80104de2:	c3                   	ret    
80104de3:	90                   	nop
80104de4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104de8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104dec:	c1 e9 02             	shr    $0x2,%ecx
80104def:	89 f8                	mov    %edi,%eax
80104df1:	89 fb                	mov    %edi,%ebx
80104df3:	c1 e0 18             	shl    $0x18,%eax
80104df6:	c1 e3 10             	shl    $0x10,%ebx
80104df9:	09 d8                	or     %ebx,%eax
80104dfb:	09 f8                	or     %edi,%eax
80104dfd:	c1 e7 08             	shl    $0x8,%edi
80104e00:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104e02:	89 d7                	mov    %edx,%edi
80104e04:	fc                   	cld    
80104e05:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104e07:	5b                   	pop    %ebx
80104e08:	89 d0                	mov    %edx,%eax
80104e0a:	5f                   	pop    %edi
80104e0b:	5d                   	pop    %ebp
80104e0c:	c3                   	ret    
80104e0d:	8d 76 00             	lea    0x0(%esi),%esi

80104e10 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104e10:	55                   	push   %ebp
80104e11:	89 e5                	mov    %esp,%ebp
80104e13:	57                   	push   %edi
80104e14:	56                   	push   %esi
80104e15:	53                   	push   %ebx
80104e16:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104e19:	8b 75 08             	mov    0x8(%ebp),%esi
80104e1c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104e1f:	85 db                	test   %ebx,%ebx
80104e21:	74 29                	je     80104e4c <memcmp+0x3c>
    if(*s1 != *s2)
80104e23:	0f b6 16             	movzbl (%esi),%edx
80104e26:	0f b6 0f             	movzbl (%edi),%ecx
80104e29:	38 d1                	cmp    %dl,%cl
80104e2b:	75 2b                	jne    80104e58 <memcmp+0x48>
80104e2d:	b8 01 00 00 00       	mov    $0x1,%eax
80104e32:	eb 14                	jmp    80104e48 <memcmp+0x38>
80104e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e38:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80104e3c:	83 c0 01             	add    $0x1,%eax
80104e3f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104e44:	38 ca                	cmp    %cl,%dl
80104e46:	75 10                	jne    80104e58 <memcmp+0x48>
  while(n-- > 0){
80104e48:	39 d8                	cmp    %ebx,%eax
80104e4a:	75 ec                	jne    80104e38 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104e4c:	5b                   	pop    %ebx
  return 0;
80104e4d:	31 c0                	xor    %eax,%eax
}
80104e4f:	5e                   	pop    %esi
80104e50:	5f                   	pop    %edi
80104e51:	5d                   	pop    %ebp
80104e52:	c3                   	ret    
80104e53:	90                   	nop
80104e54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104e58:	0f b6 c2             	movzbl %dl,%eax
}
80104e5b:	5b                   	pop    %ebx
      return *s1 - *s2;
80104e5c:	29 c8                	sub    %ecx,%eax
}
80104e5e:	5e                   	pop    %esi
80104e5f:	5f                   	pop    %edi
80104e60:	5d                   	pop    %ebp
80104e61:	c3                   	ret    
80104e62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e70 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104e70:	55                   	push   %ebp
80104e71:	89 e5                	mov    %esp,%ebp
80104e73:	56                   	push   %esi
80104e74:	53                   	push   %ebx
80104e75:	8b 45 08             	mov    0x8(%ebp),%eax
80104e78:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104e7b:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104e7e:	39 c3                	cmp    %eax,%ebx
80104e80:	73 26                	jae    80104ea8 <memmove+0x38>
80104e82:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104e85:	39 c8                	cmp    %ecx,%eax
80104e87:	73 1f                	jae    80104ea8 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104e89:	85 f6                	test   %esi,%esi
80104e8b:	8d 56 ff             	lea    -0x1(%esi),%edx
80104e8e:	74 0f                	je     80104e9f <memmove+0x2f>
      *--d = *--s;
80104e90:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104e94:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104e97:	83 ea 01             	sub    $0x1,%edx
80104e9a:	83 fa ff             	cmp    $0xffffffff,%edx
80104e9d:	75 f1                	jne    80104e90 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104e9f:	5b                   	pop    %ebx
80104ea0:	5e                   	pop    %esi
80104ea1:	5d                   	pop    %ebp
80104ea2:	c3                   	ret    
80104ea3:	90                   	nop
80104ea4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104ea8:	31 d2                	xor    %edx,%edx
80104eaa:	85 f6                	test   %esi,%esi
80104eac:	74 f1                	je     80104e9f <memmove+0x2f>
80104eae:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104eb0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104eb4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104eb7:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
80104eba:	39 d6                	cmp    %edx,%esi
80104ebc:	75 f2                	jne    80104eb0 <memmove+0x40>
}
80104ebe:	5b                   	pop    %ebx
80104ebf:	5e                   	pop    %esi
80104ec0:	5d                   	pop    %ebp
80104ec1:	c3                   	ret    
80104ec2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ec9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ed0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104ed0:	55                   	push   %ebp
80104ed1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104ed3:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104ed4:	eb 9a                	jmp    80104e70 <memmove>
80104ed6:	8d 76 00             	lea    0x0(%esi),%esi
80104ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ee0 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104ee0:	55                   	push   %ebp
80104ee1:	89 e5                	mov    %esp,%ebp
80104ee3:	57                   	push   %edi
80104ee4:	56                   	push   %esi
80104ee5:	8b 7d 10             	mov    0x10(%ebp),%edi
80104ee8:	53                   	push   %ebx
80104ee9:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104eec:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104eef:	85 ff                	test   %edi,%edi
80104ef1:	74 2f                	je     80104f22 <strncmp+0x42>
80104ef3:	0f b6 01             	movzbl (%ecx),%eax
80104ef6:	0f b6 1e             	movzbl (%esi),%ebx
80104ef9:	84 c0                	test   %al,%al
80104efb:	74 37                	je     80104f34 <strncmp+0x54>
80104efd:	38 c3                	cmp    %al,%bl
80104eff:	75 33                	jne    80104f34 <strncmp+0x54>
80104f01:	01 f7                	add    %esi,%edi
80104f03:	eb 13                	jmp    80104f18 <strncmp+0x38>
80104f05:	8d 76 00             	lea    0x0(%esi),%esi
80104f08:	0f b6 01             	movzbl (%ecx),%eax
80104f0b:	84 c0                	test   %al,%al
80104f0d:	74 21                	je     80104f30 <strncmp+0x50>
80104f0f:	0f b6 1a             	movzbl (%edx),%ebx
80104f12:	89 d6                	mov    %edx,%esi
80104f14:	38 d8                	cmp    %bl,%al
80104f16:	75 1c                	jne    80104f34 <strncmp+0x54>
    n--, p++, q++;
80104f18:	8d 56 01             	lea    0x1(%esi),%edx
80104f1b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104f1e:	39 fa                	cmp    %edi,%edx
80104f20:	75 e6                	jne    80104f08 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104f22:	5b                   	pop    %ebx
    return 0;
80104f23:	31 c0                	xor    %eax,%eax
}
80104f25:	5e                   	pop    %esi
80104f26:	5f                   	pop    %edi
80104f27:	5d                   	pop    %ebp
80104f28:	c3                   	ret    
80104f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f30:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104f34:	29 d8                	sub    %ebx,%eax
}
80104f36:	5b                   	pop    %ebx
80104f37:	5e                   	pop    %esi
80104f38:	5f                   	pop    %edi
80104f39:	5d                   	pop    %ebp
80104f3a:	c3                   	ret    
80104f3b:	90                   	nop
80104f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104f40 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104f40:	55                   	push   %ebp
80104f41:	89 e5                	mov    %esp,%ebp
80104f43:	56                   	push   %esi
80104f44:	53                   	push   %ebx
80104f45:	8b 45 08             	mov    0x8(%ebp),%eax
80104f48:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104f4b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104f4e:	89 c2                	mov    %eax,%edx
80104f50:	eb 19                	jmp    80104f6b <strncpy+0x2b>
80104f52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104f58:	83 c3 01             	add    $0x1,%ebx
80104f5b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104f5f:	83 c2 01             	add    $0x1,%edx
80104f62:	84 c9                	test   %cl,%cl
80104f64:	88 4a ff             	mov    %cl,-0x1(%edx)
80104f67:	74 09                	je     80104f72 <strncpy+0x32>
80104f69:	89 f1                	mov    %esi,%ecx
80104f6b:	85 c9                	test   %ecx,%ecx
80104f6d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104f70:	7f e6                	jg     80104f58 <strncpy+0x18>
    ;
  while(n-- > 0)
80104f72:	31 c9                	xor    %ecx,%ecx
80104f74:	85 f6                	test   %esi,%esi
80104f76:	7e 17                	jle    80104f8f <strncpy+0x4f>
80104f78:	90                   	nop
80104f79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104f80:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104f84:	89 f3                	mov    %esi,%ebx
80104f86:	83 c1 01             	add    $0x1,%ecx
80104f89:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80104f8b:	85 db                	test   %ebx,%ebx
80104f8d:	7f f1                	jg     80104f80 <strncpy+0x40>
  return os;
}
80104f8f:	5b                   	pop    %ebx
80104f90:	5e                   	pop    %esi
80104f91:	5d                   	pop    %ebp
80104f92:	c3                   	ret    
80104f93:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104fa0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104fa0:	55                   	push   %ebp
80104fa1:	89 e5                	mov    %esp,%ebp
80104fa3:	56                   	push   %esi
80104fa4:	53                   	push   %ebx
80104fa5:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104fa8:	8b 45 08             	mov    0x8(%ebp),%eax
80104fab:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104fae:	85 c9                	test   %ecx,%ecx
80104fb0:	7e 26                	jle    80104fd8 <safestrcpy+0x38>
80104fb2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104fb6:	89 c1                	mov    %eax,%ecx
80104fb8:	eb 17                	jmp    80104fd1 <safestrcpy+0x31>
80104fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104fc0:	83 c2 01             	add    $0x1,%edx
80104fc3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104fc7:	83 c1 01             	add    $0x1,%ecx
80104fca:	84 db                	test   %bl,%bl
80104fcc:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104fcf:	74 04                	je     80104fd5 <safestrcpy+0x35>
80104fd1:	39 f2                	cmp    %esi,%edx
80104fd3:	75 eb                	jne    80104fc0 <safestrcpy+0x20>
    ;
  *s = 0;
80104fd5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104fd8:	5b                   	pop    %ebx
80104fd9:	5e                   	pop    %esi
80104fda:	5d                   	pop    %ebp
80104fdb:	c3                   	ret    
80104fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104fe0 <strlen>:

int
strlen(const char *s)
{
80104fe0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104fe1:	31 c0                	xor    %eax,%eax
{
80104fe3:	89 e5                	mov    %esp,%ebp
80104fe5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104fe8:	80 3a 00             	cmpb   $0x0,(%edx)
80104feb:	74 0c                	je     80104ff9 <strlen+0x19>
80104fed:	8d 76 00             	lea    0x0(%esi),%esi
80104ff0:	83 c0 01             	add    $0x1,%eax
80104ff3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104ff7:	75 f7                	jne    80104ff0 <strlen+0x10>
    ;
  return n;
}
80104ff9:	5d                   	pop    %ebp
80104ffa:	c3                   	ret    

80104ffb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104ffb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104fff:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80105003:	55                   	push   %ebp
  pushl %ebx
80105004:	53                   	push   %ebx
  pushl %esi
80105005:	56                   	push   %esi
  pushl %edi
80105006:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105007:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105009:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010500b:	5f                   	pop    %edi
  popl %esi
8010500c:	5e                   	pop    %esi
  popl %ebx
8010500d:	5b                   	pop    %ebx
  popl %ebp
8010500e:	5d                   	pop    %ebp
  ret
8010500f:	c3                   	ret    

80105010 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105010:	55                   	push   %ebp
80105011:	89 e5                	mov    %esp,%ebp
80105013:	53                   	push   %ebx
80105014:	83 ec 04             	sub    $0x4,%esp
80105017:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010501a:	e8 a1 e9 ff ff       	call   801039c0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010501f:	8b 00                	mov    (%eax),%eax
80105021:	39 d8                	cmp    %ebx,%eax
80105023:	76 1b                	jbe    80105040 <fetchint+0x30>
80105025:	8d 53 04             	lea    0x4(%ebx),%edx
80105028:	39 d0                	cmp    %edx,%eax
8010502a:	72 14                	jb     80105040 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010502c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010502f:	8b 13                	mov    (%ebx),%edx
80105031:	89 10                	mov    %edx,(%eax)
  return 0;
80105033:	31 c0                	xor    %eax,%eax
}
80105035:	83 c4 04             	add    $0x4,%esp
80105038:	5b                   	pop    %ebx
80105039:	5d                   	pop    %ebp
8010503a:	c3                   	ret    
8010503b:	90                   	nop
8010503c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105040:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105045:	eb ee                	jmp    80105035 <fetchint+0x25>
80105047:	89 f6                	mov    %esi,%esi
80105049:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105050 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105050:	55                   	push   %ebp
80105051:	89 e5                	mov    %esp,%ebp
80105053:	53                   	push   %ebx
80105054:	83 ec 04             	sub    $0x4,%esp
80105057:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010505a:	e8 61 e9 ff ff       	call   801039c0 <myproc>

  if(addr >= curproc->sz)
8010505f:	39 18                	cmp    %ebx,(%eax)
80105061:	76 29                	jbe    8010508c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80105063:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105066:	89 da                	mov    %ebx,%edx
80105068:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
8010506a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
8010506c:	39 c3                	cmp    %eax,%ebx
8010506e:	73 1c                	jae    8010508c <fetchstr+0x3c>
    if(*s == 0)
80105070:	80 3b 00             	cmpb   $0x0,(%ebx)
80105073:	75 10                	jne    80105085 <fetchstr+0x35>
80105075:	eb 39                	jmp    801050b0 <fetchstr+0x60>
80105077:	89 f6                	mov    %esi,%esi
80105079:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105080:	80 3a 00             	cmpb   $0x0,(%edx)
80105083:	74 1b                	je     801050a0 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80105085:	83 c2 01             	add    $0x1,%edx
80105088:	39 d0                	cmp    %edx,%eax
8010508a:	77 f4                	ja     80105080 <fetchstr+0x30>
    return -1;
8010508c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80105091:	83 c4 04             	add    $0x4,%esp
80105094:	5b                   	pop    %ebx
80105095:	5d                   	pop    %ebp
80105096:	c3                   	ret    
80105097:	89 f6                	mov    %esi,%esi
80105099:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801050a0:	83 c4 04             	add    $0x4,%esp
801050a3:	89 d0                	mov    %edx,%eax
801050a5:	29 d8                	sub    %ebx,%eax
801050a7:	5b                   	pop    %ebx
801050a8:	5d                   	pop    %ebp
801050a9:	c3                   	ret    
801050aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
801050b0:	31 c0                	xor    %eax,%eax
      return s - *pp;
801050b2:	eb dd                	jmp    80105091 <fetchstr+0x41>
801050b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801050ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801050c0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801050c0:	55                   	push   %ebp
801050c1:	89 e5                	mov    %esp,%ebp
801050c3:	56                   	push   %esi
801050c4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801050c5:	e8 f6 e8 ff ff       	call   801039c0 <myproc>
801050ca:	8b 40 18             	mov    0x18(%eax),%eax
801050cd:	8b 55 08             	mov    0x8(%ebp),%edx
801050d0:	8b 40 44             	mov    0x44(%eax),%eax
801050d3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801050d6:	e8 e5 e8 ff ff       	call   801039c0 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801050db:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801050dd:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801050e0:	39 c6                	cmp    %eax,%esi
801050e2:	73 1c                	jae    80105100 <argint+0x40>
801050e4:	8d 53 08             	lea    0x8(%ebx),%edx
801050e7:	39 d0                	cmp    %edx,%eax
801050e9:	72 15                	jb     80105100 <argint+0x40>
  *ip = *(int*)(addr);
801050eb:	8b 45 0c             	mov    0xc(%ebp),%eax
801050ee:	8b 53 04             	mov    0x4(%ebx),%edx
801050f1:	89 10                	mov    %edx,(%eax)
  return 0;
801050f3:	31 c0                	xor    %eax,%eax
}
801050f5:	5b                   	pop    %ebx
801050f6:	5e                   	pop    %esi
801050f7:	5d                   	pop    %ebp
801050f8:	c3                   	ret    
801050f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105100:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105105:	eb ee                	jmp    801050f5 <argint+0x35>
80105107:	89 f6                	mov    %esi,%esi
80105109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105110 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105110:	55                   	push   %ebp
80105111:	89 e5                	mov    %esp,%ebp
80105113:	56                   	push   %esi
80105114:	53                   	push   %ebx
80105115:	83 ec 10             	sub    $0x10,%esp
80105118:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010511b:	e8 a0 e8 ff ff       	call   801039c0 <myproc>
80105120:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80105122:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105125:	83 ec 08             	sub    $0x8,%esp
80105128:	50                   	push   %eax
80105129:	ff 75 08             	pushl  0x8(%ebp)
8010512c:	e8 8f ff ff ff       	call   801050c0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105131:	83 c4 10             	add    $0x10,%esp
80105134:	85 c0                	test   %eax,%eax
80105136:	78 28                	js     80105160 <argptr+0x50>
80105138:	85 db                	test   %ebx,%ebx
8010513a:	78 24                	js     80105160 <argptr+0x50>
8010513c:	8b 16                	mov    (%esi),%edx
8010513e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105141:	39 c2                	cmp    %eax,%edx
80105143:	76 1b                	jbe    80105160 <argptr+0x50>
80105145:	01 c3                	add    %eax,%ebx
80105147:	39 da                	cmp    %ebx,%edx
80105149:	72 15                	jb     80105160 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010514b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010514e:	89 02                	mov    %eax,(%edx)
  return 0;
80105150:	31 c0                	xor    %eax,%eax
}
80105152:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105155:	5b                   	pop    %ebx
80105156:	5e                   	pop    %esi
80105157:	5d                   	pop    %ebp
80105158:	c3                   	ret    
80105159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105160:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105165:	eb eb                	jmp    80105152 <argptr+0x42>
80105167:	89 f6                	mov    %esi,%esi
80105169:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105170 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105170:	55                   	push   %ebp
80105171:	89 e5                	mov    %esp,%ebp
80105173:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105176:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105179:	50                   	push   %eax
8010517a:	ff 75 08             	pushl  0x8(%ebp)
8010517d:	e8 3e ff ff ff       	call   801050c0 <argint>
80105182:	83 c4 10             	add    $0x10,%esp
80105185:	85 c0                	test   %eax,%eax
80105187:	78 17                	js     801051a0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80105189:	83 ec 08             	sub    $0x8,%esp
8010518c:	ff 75 0c             	pushl  0xc(%ebp)
8010518f:	ff 75 f4             	pushl  -0xc(%ebp)
80105192:	e8 b9 fe ff ff       	call   80105050 <fetchstr>
80105197:	83 c4 10             	add    $0x10,%esp
}
8010519a:	c9                   	leave  
8010519b:	c3                   	ret    
8010519c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801051a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051a5:	c9                   	leave  
801051a6:	c3                   	ret    
801051a7:	89 f6                	mov    %esi,%esi
801051a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801051b0 <fill_arglist>:
[SYS_halt]  sys_halt,
[SYS_ticketlockinit]  sys_ticketlockinit,
[SYS_ticketlocktest]  sys_ticketlocktest
};

void fill_arglist(struct syscallarg* end, int type){
801051b0:	55                   	push   %ebp
801051b1:	89 e5                	mov    %esp,%ebp
801051b3:	53                   	push   %ebx
801051b4:	83 ec 14             	sub    $0x14,%esp
801051b7:	8b 45 0c             	mov    0xc(%ebp),%eax
801051ba:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int* fds;
        char *path;
        char *path1;
        uint uargv;
        struct stat *st;
	switch(type){
801051bd:	83 f8 1d             	cmp    $0x1d,%eax
801051c0:	77 4e                	ja     80105210 <fill_arglist+0x60>
801051c2:	ff 24 85 80 8c 10 80 	jmp    *-0x7fef7380(,%eax,4)
801051c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                        end->int_argv[0] = n;
                        break;
               case 18:
               case 20:
               case 9:
                        safestrcpy(end->type[0], "char*", strlen("char*")+1);
801051d0:	83 ec 0c             	sub    $0xc,%esp
801051d3:	68 7c 8a 10 80       	push   $0x80108a7c
801051d8:	e8 03 fe ff ff       	call   80104fe0 <strlen>
801051dd:	83 c4 0c             	add    $0xc,%esp
801051e0:	83 c0 01             	add    $0x1,%eax
801051e3:	50                   	push   %eax
801051e4:	68 7c 8a 10 80       	push   $0x80108a7c
801051e9:	53                   	push   %ebx
801051ea:	e8 b1 fd ff ff       	call   80104fa0 <safestrcpy>
                        if(argstr(0, &path) < 0){
801051ef:	59                   	pop    %ecx
801051f0:	58                   	pop    %eax
801051f1:	8d 45 f0             	lea    -0x10(%ebp),%eax
801051f4:	50                   	push   %eax
801051f5:	6a 00                	push   $0x0
801051f7:	e8 74 ff ff ff       	call   80105170 <argstr>
801051fc:	83 c4 10             	add    $0x10,%esp
801051ff:	85 c0                	test   %eax,%eax
80105201:	0f 88 71 05 00 00    	js     80105778 <fill_arglist+0x5c8>
                               cprintf("bad mknode arg val?\n");
   			       break;
                        }
                        end->int_argv[0] = n;
                        end->int_argv[1] = fd;
                        end->str_argv[0] = path;
80105207:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010520a:	89 83 14 01 00 00    	mov    %eax,0x114(%ebx)
                        break;
	}
}
80105210:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105213:	c9                   	leave  
80105214:	c3                   	ret    
80105215:	8d 76 00             	lea    0x0(%esi),%esi
                        safestrcpy(end->type[0], "int", strlen("int")+1);
80105218:	83 ec 0c             	sub    $0xc,%esp
8010521b:	68 4e 8a 10 80       	push   $0x80108a4e
80105220:	e8 bb fd ff ff       	call   80104fe0 <strlen>
80105225:	83 c4 0c             	add    $0xc,%esp
80105228:	83 c0 01             	add    $0x1,%eax
8010522b:	50                   	push   %eax
8010522c:	68 4e 8a 10 80       	push   $0x80108a4e
80105231:	53                   	push   %ebx
80105232:	e8 69 fd ff ff       	call   80104fa0 <safestrcpy>
                        safestrcpy(end->type[1], "int", strlen("int")+1);
80105237:	c7 04 24 4e 8a 10 80 	movl   $0x80108a4e,(%esp)
8010523e:	e8 9d fd ff ff       	call   80104fe0 <strlen>
80105243:	83 c4 0c             	add    $0xc,%esp
80105246:	83 c0 01             	add    $0x1,%eax
80105249:	50                   	push   %eax
8010524a:	8d 43 1e             	lea    0x1e(%ebx),%eax
8010524d:	68 4e 8a 10 80       	push   $0x80108a4e
80105252:	50                   	push   %eax
80105253:	e8 48 fd ff ff       	call   80104fa0 <safestrcpy>
			if (argint(0, &int_arg) < 0 || argint(1, &int_arg2) < 0){
80105258:	59                   	pop    %ecx
80105259:	58                   	pop    %eax
8010525a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010525d:	50                   	push   %eax
8010525e:	6a 00                	push   $0x0
80105260:	e8 5b fe ff ff       	call   801050c0 <argint>
80105265:	83 c4 10             	add    $0x10,%esp
80105268:	85 c0                	test   %eax,%eax
8010526a:	0f 88 f0 04 00 00    	js     80105760 <fill_arglist+0x5b0>
80105270:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105273:	83 ec 08             	sub    $0x8,%esp
80105276:	50                   	push   %eax
80105277:	6a 01                	push   $0x1
80105279:	e8 42 fe ff ff       	call   801050c0 <argint>
8010527e:	83 c4 10             	add    $0x10,%esp
80105281:	85 c0                	test   %eax,%eax
80105283:	0f 88 d7 04 00 00    	js     80105760 <fill_arglist+0x5b0>
			end->int_argv[0] = int_arg;
80105289:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010528c:	89 83 f0 00 00 00    	mov    %eax,0xf0(%ebx)
                        end->int_argv[1] = int_arg2;
80105292:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105295:	89 83 f4 00 00 00    	mov    %eax,0xf4(%ebx)
			break;
8010529b:	e9 70 ff ff ff       	jmp    80105210 <fill_arglist+0x60>
			safestrcpy(end->type[0], "void", strlen("void")+1);break;
801052a0:	83 ec 0c             	sub    $0xc,%esp
801052a3:	68 49 8a 10 80       	push   $0x80108a49
801052a8:	e8 33 fd ff ff       	call   80104fe0 <strlen>
801052ad:	83 c4 0c             	add    $0xc,%esp
801052b0:	83 c0 01             	add    $0x1,%eax
801052b3:	50                   	push   %eax
801052b4:	68 49 8a 10 80       	push   $0x80108a49
801052b9:	53                   	push   %ebx
801052ba:	e8 e1 fc ff ff       	call   80104fa0 <safestrcpy>
801052bf:	83 c4 10             	add    $0x10,%esp
801052c2:	e9 49 ff ff ff       	jmp    80105210 <fill_arglist+0x60>
801052c7:	89 f6                	mov    %esi,%esi
801052c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
                        safestrcpy(end->type[0], "int*", strlen("int*")+1);
801052d0:	83 ec 0c             	sub    $0xc,%esp
801052d3:	68 64 8a 10 80       	push   $0x80108a64
801052d8:	e8 03 fd ff ff       	call   80104fe0 <strlen>
801052dd:	83 c4 0c             	add    $0xc,%esp
801052e0:	83 c0 01             	add    $0x1,%eax
801052e3:	50                   	push   %eax
801052e4:	68 64 8a 10 80       	push   $0x80108a64
801052e9:	53                   	push   %ebx
801052ea:	e8 b1 fc ff ff       	call   80104fa0 <safestrcpy>
                        if (argptr(0, (void*)&fds, 2*sizeof(fds[0])) < 0){
801052ef:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052f2:	83 c4 0c             	add    $0xc,%esp
801052f5:	6a 08                	push   $0x8
801052f7:	50                   	push   %eax
801052f8:	6a 00                	push   $0x0
801052fa:	e8 11 fe ff ff       	call   80105110 <argptr>
801052ff:	83 c4 10             	add    $0x10,%esp
80105302:	85 c0                	test   %eax,%eax
80105304:	0f 88 ce 04 00 00    	js     801057d8 <fill_arglist+0x628>
                        end->intptr_argv = fds;
8010530a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010530d:	89 83 10 01 00 00    	mov    %eax,0x110(%ebx)
                        break;
80105313:	e9 f8 fe ff ff       	jmp    80105210 <fill_arglist+0x60>
80105318:	90                   	nop
80105319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                        safestrcpy(end->type[0], "int", strlen("int")+1);
80105320:	83 ec 0c             	sub    $0xc,%esp
80105323:	68 4e 8a 10 80       	push   $0x80108a4e
80105328:	e8 b3 fc ff ff       	call   80104fe0 <strlen>
8010532d:	83 c4 0c             	add    $0xc,%esp
80105330:	83 c0 01             	add    $0x1,%eax
80105333:	50                   	push   %eax
80105334:	68 4e 8a 10 80       	push   $0x80108a4e
80105339:	53                   	push   %ebx
8010533a:	e8 61 fc ff ff       	call   80104fa0 <safestrcpy>
                        safestrcpy(end->type[1], "char*", strlen("char*")+1);
8010533f:	c7 04 24 7c 8a 10 80 	movl   $0x80108a7c,(%esp)
80105346:	e8 95 fc ff ff       	call   80104fe0 <strlen>
8010534b:	83 c4 0c             	add    $0xc,%esp
8010534e:	83 c0 01             	add    $0x1,%eax
80105351:	50                   	push   %eax
80105352:	8d 43 1e             	lea    0x1e(%ebx),%eax
80105355:	68 7c 8a 10 80       	push   $0x80108a7c
8010535a:	50                   	push   %eax
8010535b:	e8 40 fc ff ff       	call   80104fa0 <safestrcpy>
                        safestrcpy(end->type[2], "int", strlen("int")+1);
80105360:	c7 04 24 4e 8a 10 80 	movl   $0x80108a4e,(%esp)
80105367:	e8 74 fc ff ff       	call   80104fe0 <strlen>
8010536c:	83 c4 0c             	add    $0xc,%esp
8010536f:	83 c0 01             	add    $0x1,%eax
80105372:	50                   	push   %eax
80105373:	8d 43 3c             	lea    0x3c(%ebx),%eax
80105376:	68 4e 8a 10 80       	push   $0x80108a4e
8010537b:	50                   	push   %eax
8010537c:	e8 1f fc ff ff       	call   80104fa0 <safestrcpy>
                        if(argint(0, &fd) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0){
80105381:	58                   	pop    %eax
80105382:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105385:	5a                   	pop    %edx
80105386:	50                   	push   %eax
80105387:	6a 00                	push   $0x0
80105389:	e8 32 fd ff ff       	call   801050c0 <argint>
8010538e:	83 c4 10             	add    $0x10,%esp
80105391:	85 c0                	test   %eax,%eax
80105393:	0f 88 97 03 00 00    	js     80105730 <fill_arglist+0x580>
80105399:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010539c:	83 ec 08             	sub    $0x8,%esp
8010539f:	50                   	push   %eax
801053a0:	6a 02                	push   $0x2
801053a2:	e8 19 fd ff ff       	call   801050c0 <argint>
801053a7:	83 c4 10             	add    $0x10,%esp
801053aa:	85 c0                	test   %eax,%eax
801053ac:	0f 88 7e 03 00 00    	js     80105730 <fill_arglist+0x580>
801053b2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053b5:	83 ec 04             	sub    $0x4,%esp
801053b8:	ff 75 ec             	pushl  -0x14(%ebp)
801053bb:	50                   	push   %eax
801053bc:	6a 01                	push   $0x1
801053be:	e8 4d fd ff ff       	call   80105110 <argptr>
801053c3:	83 c4 10             	add    $0x10,%esp
801053c6:	85 c0                	test   %eax,%eax
801053c8:	0f 88 62 03 00 00    	js     80105730 <fill_arglist+0x580>
                        end->int_argv[0] = fd;
801053ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
801053d1:	89 83 f0 00 00 00    	mov    %eax,0xf0(%ebx)
                        end->int_argv[1] = n;
801053d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801053da:	89 83 f4 00 00 00    	mov    %eax,0xf4(%ebx)
                        end->str_argv[0] = p;
801053e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053e3:	89 83 14 01 00 00    	mov    %eax,0x114(%ebx)
                        break;
801053e9:	e9 22 fe ff ff       	jmp    80105210 <fill_arglist+0x60>
801053ee:	66 90                	xchg   %ax,%ax
			safestrcpy(end->type[0], "int", strlen("int")+1);
801053f0:	83 ec 0c             	sub    $0xc,%esp
801053f3:	68 4e 8a 10 80       	push   $0x80108a4e
801053f8:	e8 e3 fb ff ff       	call   80104fe0 <strlen>
801053fd:	83 c4 0c             	add    $0xc,%esp
80105400:	83 c0 01             	add    $0x1,%eax
80105403:	50                   	push   %eax
80105404:	68 4e 8a 10 80       	push   $0x80108a4e
80105409:	53                   	push   %ebx
8010540a:	e8 91 fb ff ff       	call   80104fa0 <safestrcpy>
			if (argint(0, &int_arg) < 0){
8010540f:	58                   	pop    %eax
80105410:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105413:	5a                   	pop    %edx
80105414:	50                   	push   %eax
80105415:	6a 00                	push   $0x0
80105417:	e8 a4 fc ff ff       	call   801050c0 <argint>
8010541c:	83 c4 10             	add    $0x10,%esp
8010541f:	85 c0                	test   %eax,%eax
80105421:	0f 88 39 03 00 00    	js     80105760 <fill_arglist+0x5b0>
			end->int_argv[0] = int_arg;
80105427:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010542a:	89 83 f0 00 00 00    	mov    %eax,0xf0(%ebx)
			break;
80105430:	e9 db fd ff ff       	jmp    80105210 <fill_arglist+0x60>
80105435:	8d 76 00             	lea    0x0(%esi),%esi
                        safestrcpy(end->type[0], "char*", strlen("char*")+1);
80105438:	83 ec 0c             	sub    $0xc,%esp
8010543b:	68 7c 8a 10 80       	push   $0x80108a7c
80105440:	e8 9b fb ff ff       	call   80104fe0 <strlen>
80105445:	83 c4 0c             	add    $0xc,%esp
80105448:	83 c0 01             	add    $0x1,%eax
8010544b:	50                   	push   %eax
8010544c:	68 7c 8a 10 80       	push   $0x80108a7c
80105451:	53                   	push   %ebx
80105452:	e8 49 fb ff ff       	call   80104fa0 <safestrcpy>
                        safestrcpy(end->type[1], "int", strlen("int")+1);
80105457:	c7 04 24 4e 8a 10 80 	movl   $0x80108a4e,(%esp)
8010545e:	e8 7d fb ff ff       	call   80104fe0 <strlen>
80105463:	83 c4 0c             	add    $0xc,%esp
80105466:	83 c0 01             	add    $0x1,%eax
80105469:	50                   	push   %eax
8010546a:	8d 43 1e             	lea    0x1e(%ebx),%eax
8010546d:	68 4e 8a 10 80       	push   $0x80108a4e
80105472:	50                   	push   %eax
80105473:	e8 28 fb ff ff       	call   80104fa0 <safestrcpy>
                        if(argstr(0, &path) < 0 || argint(1, &n) < 0){
80105478:	58                   	pop    %eax
80105479:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010547c:	5a                   	pop    %edx
8010547d:	50                   	push   %eax
8010547e:	6a 00                	push   $0x0
80105480:	e8 eb fc ff ff       	call   80105170 <argstr>
80105485:	83 c4 10             	add    $0x10,%esp
80105488:	85 c0                	test   %eax,%eax
8010548a:	0f 88 00 03 00 00    	js     80105790 <fill_arglist+0x5e0>
80105490:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105493:	83 ec 08             	sub    $0x8,%esp
80105496:	50                   	push   %eax
80105497:	6a 01                	push   $0x1
80105499:	e8 22 fc ff ff       	call   801050c0 <argint>
8010549e:	83 c4 10             	add    $0x10,%esp
801054a1:	85 c0                	test   %eax,%eax
801054a3:	0f 88 e7 02 00 00    	js     80105790 <fill_arglist+0x5e0>
                        end->str_argv[0] = path;
801054a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801054ac:	89 83 14 01 00 00    	mov    %eax,0x114(%ebx)
                        end->int_argv[0] = n;
801054b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801054b5:	89 83 f0 00 00 00    	mov    %eax,0xf0(%ebx)
                        break;
801054bb:	e9 50 fd ff ff       	jmp    80105210 <fill_arglist+0x60>
                        safestrcpy(end->type[0], "char*", strlen("char*")+1);
801054c0:	83 ec 0c             	sub    $0xc,%esp
801054c3:	68 7c 8a 10 80       	push   $0x80108a7c
801054c8:	e8 13 fb ff ff       	call   80104fe0 <strlen>
801054cd:	83 c4 0c             	add    $0xc,%esp
801054d0:	83 c0 01             	add    $0x1,%eax
801054d3:	50                   	push   %eax
801054d4:	68 7c 8a 10 80       	push   $0x80108a7c
801054d9:	53                   	push   %ebx
801054da:	e8 c1 fa ff ff       	call   80104fa0 <safestrcpy>
                        safestrcpy(end->type[1], "short", strlen("short")+1);
801054df:	c7 04 24 f3 8a 10 80 	movl   $0x80108af3,(%esp)
801054e6:	e8 f5 fa ff ff       	call   80104fe0 <strlen>
801054eb:	83 c4 0c             	add    $0xc,%esp
801054ee:	83 c0 01             	add    $0x1,%eax
801054f1:	50                   	push   %eax
801054f2:	8d 43 1e             	lea    0x1e(%ebx),%eax
801054f5:	68 f3 8a 10 80       	push   $0x80108af3
801054fa:	50                   	push   %eax
801054fb:	e8 a0 fa ff ff       	call   80104fa0 <safestrcpy>
                        safestrcpy(end->type[2], "short", strlen("short")+1);
80105500:	c7 04 24 f3 8a 10 80 	movl   $0x80108af3,(%esp)
80105507:	e8 d4 fa ff ff       	call   80104fe0 <strlen>
8010550c:	83 c4 0c             	add    $0xc,%esp
8010550f:	83 c0 01             	add    $0x1,%eax
80105512:	50                   	push   %eax
80105513:	8d 43 3c             	lea    0x3c(%ebx),%eax
80105516:	68 f3 8a 10 80       	push   $0x80108af3
8010551b:	50                   	push   %eax
8010551c:	e8 7f fa ff ff       	call   80104fa0 <safestrcpy>
                        if(argstr(0, &path) < 0 || argint(1, &n) < 0 || argint(2, &fd) < 0){
80105521:	58                   	pop    %eax
80105522:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105525:	5a                   	pop    %edx
80105526:	50                   	push   %eax
80105527:	6a 00                	push   $0x0
80105529:	e8 42 fc ff ff       	call   80105170 <argstr>
8010552e:	83 c4 10             	add    $0x10,%esp
80105531:	85 c0                	test   %eax,%eax
80105533:	0f 88 0f 02 00 00    	js     80105748 <fill_arglist+0x598>
80105539:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010553c:	83 ec 08             	sub    $0x8,%esp
8010553f:	50                   	push   %eax
80105540:	6a 01                	push   $0x1
80105542:	e8 79 fb ff ff       	call   801050c0 <argint>
80105547:	83 c4 10             	add    $0x10,%esp
8010554a:	85 c0                	test   %eax,%eax
8010554c:	0f 88 f6 01 00 00    	js     80105748 <fill_arglist+0x598>
80105552:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105555:	83 ec 08             	sub    $0x8,%esp
80105558:	50                   	push   %eax
80105559:	6a 02                	push   $0x2
8010555b:	e8 60 fb ff ff       	call   801050c0 <argint>
80105560:	83 c4 10             	add    $0x10,%esp
80105563:	85 c0                	test   %eax,%eax
80105565:	0f 88 dd 01 00 00    	js     80105748 <fill_arglist+0x598>
                        end->int_argv[0] = n;
8010556b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010556e:	89 83 f0 00 00 00    	mov    %eax,0xf0(%ebx)
                        end->int_argv[1] = fd;
80105574:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105577:	89 83 f4 00 00 00    	mov    %eax,0xf4(%ebx)
8010557d:	e9 85 fc ff ff       	jmp    80105207 <fill_arglist+0x57>
80105582:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                        safestrcpy(end->type[0], "char*", strlen("char*")+1);
80105588:	83 ec 0c             	sub    $0xc,%esp
8010558b:	68 7c 8a 10 80       	push   $0x80108a7c
80105590:	e8 4b fa ff ff       	call   80104fe0 <strlen>
80105595:	83 c4 0c             	add    $0xc,%esp
80105598:	83 c0 01             	add    $0x1,%eax
8010559b:	50                   	push   %eax
8010559c:	68 7c 8a 10 80       	push   $0x80108a7c
801055a1:	53                   	push   %ebx
801055a2:	e8 f9 f9 ff ff       	call   80104fa0 <safestrcpy>
                        safestrcpy(end->type[1], "char*", strlen("char*")+1);
801055a7:	c7 04 24 7c 8a 10 80 	movl   $0x80108a7c,(%esp)
801055ae:	e8 2d fa ff ff       	call   80104fe0 <strlen>
801055b3:	83 c4 0c             	add    $0xc,%esp
801055b6:	83 c0 01             	add    $0x1,%eax
801055b9:	50                   	push   %eax
801055ba:	8d 43 1e             	lea    0x1e(%ebx),%eax
801055bd:	68 7c 8a 10 80       	push   $0x80108a7c
801055c2:	50                   	push   %eax
801055c3:	e8 d8 f9 ff ff       	call   80104fa0 <safestrcpy>
                        if(argstr(0, &path) < 0 || argstr(0, &path1) < 0){
801055c8:	58                   	pop    %eax
801055c9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801055cc:	5a                   	pop    %edx
801055cd:	50                   	push   %eax
801055ce:	6a 00                	push   $0x0
801055d0:	e8 9b fb ff ff       	call   80105170 <argstr>
801055d5:	83 c4 10             	add    $0x10,%esp
801055d8:	85 c0                	test   %eax,%eax
801055da:	0f 88 98 01 00 00    	js     80105778 <fill_arglist+0x5c8>
801055e0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055e3:	83 ec 08             	sub    $0x8,%esp
801055e6:	50                   	push   %eax
801055e7:	6a 00                	push   $0x0
801055e9:	e8 82 fb ff ff       	call   80105170 <argstr>
801055ee:	83 c4 10             	add    $0x10,%esp
801055f1:	85 c0                	test   %eax,%eax
801055f3:	0f 88 7f 01 00 00    	js     80105778 <fill_arglist+0x5c8>
                        end->str_argv[0] = path;
801055f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055fc:	89 83 14 01 00 00    	mov    %eax,0x114(%ebx)
                        end->str_argv[1] = path1;
80105602:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105605:	89 83 18 01 00 00    	mov    %eax,0x118(%ebx)
                        break;
8010560b:	e9 00 fc ff ff       	jmp    80105210 <fill_arglist+0x60>
		        safestrcpy(end->type[0], "char*", strlen("char*")+1);
80105610:	83 ec 0c             	sub    $0xc,%esp
80105613:	68 7c 8a 10 80       	push   $0x80108a7c
80105618:	e8 c3 f9 ff ff       	call   80104fe0 <strlen>
8010561d:	83 c4 0c             	add    $0xc,%esp
80105620:	83 c0 01             	add    $0x1,%eax
80105623:	50                   	push   %eax
80105624:	68 7c 8a 10 80       	push   $0x80108a7c
80105629:	53                   	push   %ebx
8010562a:	e8 71 f9 ff ff       	call   80104fa0 <safestrcpy>
                        safestrcpy(end->type[1], "char**", strlen("char**")+1);
8010562f:	c7 04 24 92 8a 10 80 	movl   $0x80108a92,(%esp)
80105636:	e8 a5 f9 ff ff       	call   80104fe0 <strlen>
8010563b:	83 c4 0c             	add    $0xc,%esp
8010563e:	83 c0 01             	add    $0x1,%eax
80105641:	50                   	push   %eax
80105642:	8d 43 1e             	lea    0x1e(%ebx),%eax
80105645:	68 92 8a 10 80       	push   $0x80108a92
8010564a:	50                   	push   %eax
8010564b:	e8 50 f9 ff ff       	call   80104fa0 <safestrcpy>
                        if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105650:	59                   	pop    %ecx
80105651:	58                   	pop    %eax
80105652:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105655:	50                   	push   %eax
80105656:	6a 00                	push   $0x0
80105658:	e8 13 fb ff ff       	call   80105170 <argstr>
8010565d:	83 c4 10             	add    $0x10,%esp
80105660:	85 c0                	test   %eax,%eax
80105662:	0f 88 58 01 00 00    	js     801057c0 <fill_arglist+0x610>
80105668:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010566b:	83 ec 08             	sub    $0x8,%esp
8010566e:	50                   	push   %eax
8010566f:	6a 01                	push   $0x1
80105671:	e8 4a fa ff ff       	call   801050c0 <argint>
80105676:	83 c4 10             	add    $0x10,%esp
80105679:	85 c0                	test   %eax,%eax
8010567b:	0f 88 3f 01 00 00    	js     801057c0 <fill_arglist+0x610>
                        end->str_argv[0] = path;
80105681:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105684:	89 83 14 01 00 00    	mov    %eax,0x114(%ebx)
                        end->ptr_argv[0] = (char**)uargv;
8010568a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010568d:	89 83 34 01 00 00    	mov    %eax,0x134(%ebx)
                        break;
80105693:	e9 78 fb ff ff       	jmp    80105210 <fill_arglist+0x60>
80105698:	90                   	nop
80105699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                        safestrcpy(end->type[0], "int", strlen("int")+1);
801056a0:	83 ec 0c             	sub    $0xc,%esp
801056a3:	68 4e 8a 10 80       	push   $0x80108a4e
801056a8:	e8 33 f9 ff ff       	call   80104fe0 <strlen>
801056ad:	83 c4 0c             	add    $0xc,%esp
801056b0:	83 c0 01             	add    $0x1,%eax
801056b3:	50                   	push   %eax
801056b4:	68 4e 8a 10 80       	push   $0x80108a4e
801056b9:	53                   	push   %ebx
801056ba:	e8 e1 f8 ff ff       	call   80104fa0 <safestrcpy>
                        safestrcpy(end->type[1], "struct stat*", strlen("struct stat*")+1);
801056bf:	c7 04 24 d2 8a 10 80 	movl   $0x80108ad2,(%esp)
801056c6:	e8 15 f9 ff ff       	call   80104fe0 <strlen>
801056cb:	83 c4 0c             	add    $0xc,%esp
801056ce:	83 c0 01             	add    $0x1,%eax
801056d1:	50                   	push   %eax
801056d2:	8d 43 1e             	lea    0x1e(%ebx),%eax
801056d5:	68 d2 8a 10 80       	push   $0x80108ad2
801056da:	50                   	push   %eax
801056db:	e8 c0 f8 ff ff       	call   80104fa0 <safestrcpy>
                        if(argint(0, &n) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0){
801056e0:	59                   	pop    %ecx
801056e1:	58                   	pop    %eax
801056e2:	8d 45 ec             	lea    -0x14(%ebp),%eax
801056e5:	50                   	push   %eax
801056e6:	6a 00                	push   $0x0
801056e8:	e8 d3 f9 ff ff       	call   801050c0 <argint>
801056ed:	83 c4 10             	add    $0x10,%esp
801056f0:	85 c0                	test   %eax,%eax
801056f2:	0f 88 b0 00 00 00    	js     801057a8 <fill_arglist+0x5f8>
801056f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056fb:	83 ec 04             	sub    $0x4,%esp
801056fe:	6a 14                	push   $0x14
80105700:	50                   	push   %eax
80105701:	6a 01                	push   $0x1
80105703:	e8 08 fa ff ff       	call   80105110 <argptr>
80105708:	83 c4 10             	add    $0x10,%esp
8010570b:	85 c0                	test   %eax,%eax
8010570d:	0f 88 95 00 00 00    	js     801057a8 <fill_arglist+0x5f8>
                        end->int_argv[0] = n;
80105713:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105716:	89 83 f0 00 00 00    	mov    %eax,0xf0(%ebx)
                        end->st = st;
8010571c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010571f:	89 83 54 01 00 00    	mov    %eax,0x154(%ebx)
                        break;
80105725:	e9 e6 fa ff ff       	jmp    80105210 <fill_arglist+0x60>
8010572a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                                cprintf("bad 3 arg val?\n");
80105730:	83 ec 0c             	sub    $0xc,%esp
80105733:	68 82 8a 10 80       	push   $0x80108a82
80105738:	e8 b3 af ff ff       	call   801006f0 <cprintf>
   				break;
8010573d:	83 c4 10             	add    $0x10,%esp
80105740:	e9 cb fa ff ff       	jmp    80105210 <fill_arglist+0x60>
80105745:	8d 76 00             	lea    0x0(%esi),%esi
                               cprintf("bad mknode arg val?\n");
80105748:	83 ec 0c             	sub    $0xc,%esp
8010574b:	68 f9 8a 10 80       	push   $0x80108af9
80105750:	e8 9b af ff ff       	call   801006f0 <cprintf>
   			       break;
80105755:	83 c4 10             	add    $0x10,%esp
80105758:	e9 b3 fa ff ff       	jmp    80105210 <fill_arglist+0x60>
8010575d:	8d 76 00             	lea    0x0(%esi),%esi
   				cprintf("bad int arg val?\n");
80105760:	83 ec 0c             	sub    $0xc,%esp
80105763:	68 52 8a 10 80       	push   $0x80108a52
80105768:	e8 83 af ff ff       	call   801006f0 <cprintf>
   				break;
8010576d:	83 c4 10             	add    $0x10,%esp
80105770:	e9 9b fa ff ff       	jmp    80105210 <fill_arglist+0x60>
80105775:	8d 76 00             	lea    0x0(%esi),%esi
                               cprintf("bad path arg val?\n");
80105778:	83 ec 0c             	sub    $0xc,%esp
8010577b:	68 bf 8a 10 80       	push   $0x80108abf
80105780:	e8 6b af ff ff       	call   801006f0 <cprintf>
   			       break;
80105785:	83 c4 10             	add    $0x10,%esp
80105788:	e9 83 fa ff ff       	jmp    80105210 <fill_arglist+0x60>
8010578d:	8d 76 00             	lea    0x0(%esi),%esi
                               cprintf("bad open arg val?\n");
80105790:	83 ec 0c             	sub    $0xc,%esp
80105793:	68 ac 8a 10 80       	push   $0x80108aac
80105798:	e8 53 af ff ff       	call   801006f0 <cprintf>
   			       break;
8010579d:	83 c4 10             	add    $0x10,%esp
801057a0:	e9 6b fa ff ff       	jmp    80105210 <fill_arglist+0x60>
801057a5:	8d 76 00             	lea    0x0(%esi),%esi
                               cprintf("bad fstat arg val?\n");
801057a8:	83 ec 0c             	sub    $0xc,%esp
801057ab:	68 df 8a 10 80       	push   $0x80108adf
801057b0:	e8 3b af ff ff       	call   801006f0 <cprintf>
   			       break;
801057b5:	83 c4 10             	add    $0x10,%esp
801057b8:	e9 53 fa ff ff       	jmp    80105210 <fill_arglist+0x60>
801057bd:	8d 76 00             	lea    0x0(%esi),%esi
                               cprintf("bad exec arg val?\n");
801057c0:	83 ec 0c             	sub    $0xc,%esp
801057c3:	68 99 8a 10 80       	push   $0x80108a99
801057c8:	e8 23 af ff ff       	call   801006f0 <cprintf>
   			       break;
801057cd:	83 c4 10             	add    $0x10,%esp
801057d0:	e9 3b fa ff ff       	jmp    80105210 <fill_arglist+0x60>
801057d5:	8d 76 00             	lea    0x0(%esi),%esi
                                cprintf("bad int* arg val?\n");
801057d8:	83 ec 0c             	sub    $0xc,%esp
801057db:	68 69 8a 10 80       	push   $0x80108a69
801057e0:	e8 0b af ff ff       	call   801006f0 <cprintf>
   				break;
801057e5:	83 c4 10             	add    $0x10,%esp
801057e8:	e9 23 fa ff ff       	jmp    80105210 <fill_arglist+0x60>
801057ed:	8d 76 00             	lea    0x0(%esi),%esi

801057f0 <syscall>:

void
syscall(void)
{
801057f0:	55                   	push   %ebp
801057f1:	89 e5                	mov    %esp,%ebp
801057f3:	57                   	push   %edi
801057f4:	56                   	push   %esi
801057f5:	53                   	push   %ebx
801057f6:	83 ec 1c             	sub    $0x1c,%esp
  int num;
  struct proc *curproc = myproc();
801057f9:	e8 c2 e1 ff ff       	call   801039c0 <myproc>
801057fe:	89 c7                	mov    %eax,%edi

  num = curproc->tf->eax;
80105800:	8b 40 18             	mov    0x18(%eax),%eax
80105803:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105806:	8d 70 ff             	lea    -0x1(%eax),%esi
  num = curproc->tf->eax;
80105809:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
8010580c:	83 fe 1c             	cmp    $0x1c,%esi
8010580f:	0f 87 3b 01 00 00    	ja     80105950 <syscall+0x160>
80105815:	8b 04 85 00 8d 10 80 	mov    -0x7fef7300(,%eax,4),%eax
8010581c:	85 c0                	test   %eax,%eax
8010581e:	0f 84 2c 01 00 00    	je     80105950 <syscall+0x160>
    curproc->tf->eax = syscalls[num]();
80105824:	ff d0                	call   *%eax
80105826:	8b 4f 18             	mov    0x18(%edi),%ecx
80105829:	89 41 1c             	mov    %eax,0x1c(%ecx)
8010582c:	8b 04 b5 80 8d 10 80 	mov    -0x7fef7280(,%esi,4),%eax
80105833:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if (first_proc == 0){
80105836:	a1 74 e5 12 80       	mov    0x8012e574,%eax
8010583b:	85 c0                	test   %eax,%eax
8010583d:	0f 84 bd 01 00 00    	je     80105a00 <syscall+0x210>
      cmostime(&(first_proc -> date));
      first_proc -> pid = curproc -> pid;
      first_proc -> next = 0;
      last_proc = first_proc;
    }else{
      last_proc -> next = (struct node*) kalloc();
80105843:	8b 1d 78 e5 12 80    	mov    0x8012e578,%ebx
80105849:	e8 32 ce ff ff       	call   80102680 <kalloc>
      safestrcpy(last_proc -> next->name, syscalls_string[num-1], strlen(syscalls_string[num-1])+1);
8010584e:	83 ec 0c             	sub    $0xc,%esp
      last_proc -> next = (struct node*) kalloc();
80105851:	89 43 3c             	mov    %eax,0x3c(%ebx)
      safestrcpy(last_proc -> next->name, syscalls_string[num-1], strlen(syscalls_string[num-1])+1);
80105854:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80105857:	53                   	push   %ebx
80105858:	e8 83 f7 ff ff       	call   80104fe0 <strlen>
8010585d:	83 c4 0c             	add    $0xc,%esp
80105860:	83 c0 01             	add    $0x1,%eax
80105863:	50                   	push   %eax
80105864:	a1 78 e5 12 80       	mov    0x8012e578,%eax
80105869:	53                   	push   %ebx
8010586a:	ff 70 3c             	pushl  0x3c(%eax)
8010586d:	e8 2e f7 ff ff       	call   80104fa0 <safestrcpy>
      cmostime(&(last_proc -> next-> date));
80105872:	a1 78 e5 12 80       	mov    0x8012e578,%eax
80105877:	8b 40 3c             	mov    0x3c(%eax),%eax
8010587a:	83 c0 20             	add    $0x20,%eax
8010587d:	89 04 24             	mov    %eax,(%esp)
80105880:	e8 4b d1 ff ff       	call   801029d0 <cmostime>
      last_proc -> next -> pid = curproc -> pid;
80105885:	a1 78 e5 12 80       	mov    0x8012e578,%eax
8010588a:	8b 5f 10             	mov    0x10(%edi),%ebx
      last_proc -> next -> next = 0;
      last_proc = last_proc -> next;
8010588d:	83 c4 10             	add    $0x10,%esp
      last_proc -> next -> pid = curproc -> pid;
80105890:	8b 48 3c             	mov    0x3c(%eax),%ecx
80105893:	89 59 38             	mov    %ebx,0x38(%ecx)
      last_proc -> next -> next = 0;
80105896:	8b 48 3c             	mov    0x3c(%eax),%ecx
80105899:	c7 41 3c 00 00 00 00 	movl   $0x0,0x3c(%ecx)
      last_proc = last_proc -> next;
801058a0:	8b 40 3c             	mov    0x3c(%eax),%eax
801058a3:	a3 78 e5 12 80       	mov    %eax,0x8012e578
    }
    if (curproc->syscalls[num-1].count == 0){
801058a8:	6b de 34             	imul   $0x34,%esi,%ebx
801058ab:	01 fb                	add    %edi,%ebx
801058ad:	8b 43 7c             	mov    0x7c(%ebx),%eax
801058b0:	85 c0                	test   %eax,%eax
801058b2:	0f 85 c8 00 00 00    	jne    80105980 <syscall+0x190>
    	curproc->syscalls[num-1].datelist = (struct date*)kalloc();
801058b8:	e8 c3 cd ff ff       	call   80102680 <kalloc>
801058bd:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
    	curproc->syscalls[num-1].datelist->next = 0;
801058c3:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    	curproc->syscalls[num-1].datelist_end = curproc->syscalls[num-1].datelist;
801058ca:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
801058d0:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
    	curproc->syscalls[num-1].arglist = (struct syscallarg*)kalloc();
801058d6:	e8 a5 cd ff ff       	call   80102680 <kalloc>
801058db:	89 83 a8 00 00 00    	mov    %eax,0xa8(%ebx)
    	curproc->syscalls[num-1].arglist->next = 0;
801058e1:	c7 80 58 01 00 00 00 	movl   $0x0,0x158(%eax)
801058e8:	00 00 00 
    	curproc->syscalls[num-1].arglist_end = curproc->syscalls[num-1].arglist;
801058eb:	8b 83 a8 00 00 00    	mov    0xa8(%ebx),%eax
801058f1:	89 83 ac 00 00 00    	mov    %eax,0xac(%ebx)
    	curproc->syscalls[num-1].datelist_end = curproc->syscalls[num-1].datelist_end->next;
    	curproc->syscalls[num-1].arglist_end->next = (struct syscallarg*)kalloc();
      curproc->syscalls[num-1].arglist_end->next->next = 0;
    	curproc->syscalls[num-1].arglist_end = curproc->syscalls[num-1].arglist_end->next;
    }
    curproc->syscalls[num-1].count = curproc->syscalls[num-1].count + 1;
801058f7:	6b f6 34             	imul   $0x34,%esi,%esi
    safestrcpy(curproc->syscalls[num-1].name, syscalls_string[num-1], strlen(syscalls_string[num-1])+1);
801058fa:	83 ec 0c             	sub    $0xc,%esp
    curproc->syscalls[num-1].count = curproc->syscalls[num-1].count + 1;
801058fd:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
80105900:	83 43 7c 01          	addl   $0x1,0x7c(%ebx)
    safestrcpy(curproc->syscalls[num-1].name, syscalls_string[num-1], strlen(syscalls_string[num-1])+1);
80105904:	ff 75 e4             	pushl  -0x1c(%ebp)
80105907:	e8 d4 f6 ff ff       	call   80104fe0 <strlen>
8010590c:	83 c4 0c             	add    $0xc,%esp
8010590f:	83 c0 01             	add    $0x1,%eax
80105912:	50                   	push   %eax
80105913:	8d 84 37 88 00 00 00 	lea    0x88(%edi,%esi,1),%eax
8010591a:	ff 75 e4             	pushl  -0x1c(%ebp)
8010591d:	50                   	push   %eax
8010591e:	e8 7d f6 ff ff       	call   80104fa0 <safestrcpy>
   	cmostime(&(curproc->syscalls[num-1].datelist_end->date));
80105923:	58                   	pop    %eax
80105924:	ff b3 84 00 00 00    	pushl  0x84(%ebx)
8010592a:	e8 a1 d0 ff ff       	call   801029d0 <cmostime>
   	fill_arglist(curproc->syscalls[num-1].arglist_end, num);
8010592f:	5a                   	pop    %edx
80105930:	59                   	pop    %ecx
80105931:	ff 75 e0             	pushl  -0x20(%ebp)
80105934:	ff b3 ac 00 00 00    	pushl  0xac(%ebx)
8010593a:	e8 71 f8 ff ff       	call   801051b0 <fill_arglist>
8010593f:	83 c4 10             	add    $0x10,%esp
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105942:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105945:	5b                   	pop    %ebx
80105946:	5e                   	pop    %esi
80105947:	5f                   	pop    %edi
80105948:	5d                   	pop    %ebp
80105949:	c3                   	ret    
8010594a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            curproc->pid, curproc->name, num);
80105950:	8d 47 6c             	lea    0x6c(%edi),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105953:	ff 75 e0             	pushl  -0x20(%ebp)
80105956:	50                   	push   %eax
80105957:	ff 77 10             	pushl  0x10(%edi)
8010595a:	68 0e 8b 10 80       	push   $0x80108b0e
8010595f:	e8 8c ad ff ff       	call   801006f0 <cprintf>
    curproc->tf->eax = -1;
80105964:	8b 47 18             	mov    0x18(%edi),%eax
80105967:	83 c4 10             	add    $0x10,%esp
8010596a:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80105971:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105974:	5b                   	pop    %ebx
80105975:	5e                   	pop    %esi
80105976:	5f                   	pop    %edi
80105977:	5d                   	pop    %ebp
80105978:	c3                   	ret    
80105979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    	curproc->syscalls[num-1].datelist_end->next = (struct date*)kalloc();
80105980:	8b 8b 84 00 00 00    	mov    0x84(%ebx),%ecx
80105986:	89 4d dc             	mov    %ecx,-0x24(%ebp)
80105989:	e8 f2 cc ff ff       	call   80102680 <kalloc>
8010598e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
80105991:	89 41 1c             	mov    %eax,0x1c(%ecx)
      curproc->syscalls[num-1].datelist_end->next->next = 0;
80105994:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
8010599a:	8b 40 1c             	mov    0x1c(%eax),%eax
8010599d:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    	curproc->syscalls[num-1].datelist_end = curproc->syscalls[num-1].datelist_end->next;
801059a4:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
    	curproc->syscalls[num-1].arglist_end->next = (struct syscallarg*)kalloc();
801059aa:	8b 8b ac 00 00 00    	mov    0xac(%ebx),%ecx
    	curproc->syscalls[num-1].datelist_end = curproc->syscalls[num-1].datelist_end->next;
801059b0:	8b 40 1c             	mov    0x1c(%eax),%eax
    	curproc->syscalls[num-1].arglist_end->next = (struct syscallarg*)kalloc();
801059b3:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    	curproc->syscalls[num-1].datelist_end = curproc->syscalls[num-1].datelist_end->next;
801059b6:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
    	curproc->syscalls[num-1].arglist_end->next = (struct syscallarg*)kalloc();
801059bc:	e8 bf cc ff ff       	call   80102680 <kalloc>
801059c1:	8b 4d dc             	mov    -0x24(%ebp),%ecx
801059c4:	89 81 58 01 00 00    	mov    %eax,0x158(%ecx)
      curproc->syscalls[num-1].arglist_end->next->next = 0;
801059ca:	8b 83 ac 00 00 00    	mov    0xac(%ebx),%eax
801059d0:	8b 80 58 01 00 00    	mov    0x158(%eax),%eax
801059d6:	c7 80 58 01 00 00 00 	movl   $0x0,0x158(%eax)
801059dd:	00 00 00 
    	curproc->syscalls[num-1].arglist_end = curproc->syscalls[num-1].arglist_end->next;
801059e0:	8b 83 ac 00 00 00    	mov    0xac(%ebx),%eax
801059e6:	8b 80 58 01 00 00    	mov    0x158(%eax),%eax
801059ec:	89 83 ac 00 00 00    	mov    %eax,0xac(%ebx)
801059f2:	e9 00 ff ff ff       	jmp    801058f7 <syscall+0x107>
801059f7:	89 f6                	mov    %esi,%esi
801059f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      first_proc = (struct node*) kalloc();
80105a00:	e8 7b cc ff ff       	call   80102680 <kalloc>
      safestrcpy(first_proc->name, syscalls_string[num-1], strlen(syscalls_string[num-1])+1);
80105a05:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80105a08:	83 ec 0c             	sub    $0xc,%esp
      first_proc = (struct node*) kalloc();
80105a0b:	a3 74 e5 12 80       	mov    %eax,0x8012e574
      safestrcpy(first_proc->name, syscalls_string[num-1], strlen(syscalls_string[num-1])+1);
80105a10:	53                   	push   %ebx
80105a11:	e8 ca f5 ff ff       	call   80104fe0 <strlen>
80105a16:	83 c4 0c             	add    $0xc,%esp
80105a19:	83 c0 01             	add    $0x1,%eax
80105a1c:	50                   	push   %eax
80105a1d:	53                   	push   %ebx
80105a1e:	ff 35 74 e5 12 80    	pushl  0x8012e574
80105a24:	e8 77 f5 ff ff       	call   80104fa0 <safestrcpy>
      cmostime(&(first_proc -> date));
80105a29:	a1 74 e5 12 80       	mov    0x8012e574,%eax
80105a2e:	83 c0 20             	add    $0x20,%eax
80105a31:	89 04 24             	mov    %eax,(%esp)
80105a34:	e8 97 cf ff ff       	call   801029d0 <cmostime>
      first_proc -> pid = curproc -> pid;
80105a39:	a1 74 e5 12 80       	mov    0x8012e574,%eax
80105a3e:	8b 4f 10             	mov    0x10(%edi),%ecx
80105a41:	83 c4 10             	add    $0x10,%esp
80105a44:	89 48 38             	mov    %ecx,0x38(%eax)
      first_proc -> next = 0;
80105a47:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
      last_proc = first_proc;
80105a4e:	a3 78 e5 12 80       	mov    %eax,0x8012e578
80105a53:	e9 50 fe ff ff       	jmp    801058a8 <syscall+0xb8>
80105a58:	66 90                	xchg   %ax,%ax
80105a5a:	66 90                	xchg   %ax,%ax
80105a5c:	66 90                	xchg   %ax,%ax
80105a5e:	66 90                	xchg   %ax,%ax

80105a60 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105a60:	55                   	push   %ebp
80105a61:	89 e5                	mov    %esp,%ebp
80105a63:	57                   	push   %edi
80105a64:	56                   	push   %esi
80105a65:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105a66:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80105a69:	83 ec 44             	sub    $0x44,%esp
80105a6c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
80105a6f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105a72:	56                   	push   %esi
80105a73:	50                   	push   %eax
{
80105a74:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80105a77:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80105a7a:	e8 41 c6 ff ff       	call   801020c0 <nameiparent>
80105a7f:	83 c4 10             	add    $0x10,%esp
80105a82:	85 c0                	test   %eax,%eax
80105a84:	0f 84 46 01 00 00    	je     80105bd0 <create+0x170>
    return 0;
  ilock(dp);
80105a8a:	83 ec 0c             	sub    $0xc,%esp
80105a8d:	89 c3                	mov    %eax,%ebx
80105a8f:	50                   	push   %eax
80105a90:	e8 ab bd ff ff       	call   80101840 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80105a95:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80105a98:	83 c4 0c             	add    $0xc,%esp
80105a9b:	50                   	push   %eax
80105a9c:	56                   	push   %esi
80105a9d:	53                   	push   %ebx
80105a9e:	e8 cd c2 ff ff       	call   80101d70 <dirlookup>
80105aa3:	83 c4 10             	add    $0x10,%esp
80105aa6:	85 c0                	test   %eax,%eax
80105aa8:	89 c7                	mov    %eax,%edi
80105aaa:	74 34                	je     80105ae0 <create+0x80>
    iunlockput(dp);
80105aac:	83 ec 0c             	sub    $0xc,%esp
80105aaf:	53                   	push   %ebx
80105ab0:	e8 1b c0 ff ff       	call   80101ad0 <iunlockput>
    ilock(ip);
80105ab5:	89 3c 24             	mov    %edi,(%esp)
80105ab8:	e8 83 bd ff ff       	call   80101840 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105abd:	83 c4 10             	add    $0x10,%esp
80105ac0:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80105ac5:	0f 85 95 00 00 00    	jne    80105b60 <create+0x100>
80105acb:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80105ad0:	0f 85 8a 00 00 00    	jne    80105b60 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105ad6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ad9:	89 f8                	mov    %edi,%eax
80105adb:	5b                   	pop    %ebx
80105adc:	5e                   	pop    %esi
80105add:	5f                   	pop    %edi
80105ade:	5d                   	pop    %ebp
80105adf:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
80105ae0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80105ae4:	83 ec 08             	sub    $0x8,%esp
80105ae7:	50                   	push   %eax
80105ae8:	ff 33                	pushl  (%ebx)
80105aea:	e8 e1 bb ff ff       	call   801016d0 <ialloc>
80105aef:	83 c4 10             	add    $0x10,%esp
80105af2:	85 c0                	test   %eax,%eax
80105af4:	89 c7                	mov    %eax,%edi
80105af6:	0f 84 e8 00 00 00    	je     80105be4 <create+0x184>
  ilock(ip);
80105afc:	83 ec 0c             	sub    $0xc,%esp
80105aff:	50                   	push   %eax
80105b00:	e8 3b bd ff ff       	call   80101840 <ilock>
  ip->major = major;
80105b05:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80105b09:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80105b0d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80105b11:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80105b15:	b8 01 00 00 00       	mov    $0x1,%eax
80105b1a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80105b1e:	89 3c 24             	mov    %edi,(%esp)
80105b21:	e8 6a bc ff ff       	call   80101790 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105b26:	83 c4 10             	add    $0x10,%esp
80105b29:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80105b2e:	74 50                	je     80105b80 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105b30:	83 ec 04             	sub    $0x4,%esp
80105b33:	ff 77 04             	pushl  0x4(%edi)
80105b36:	56                   	push   %esi
80105b37:	53                   	push   %ebx
80105b38:	e8 a3 c4 ff ff       	call   80101fe0 <dirlink>
80105b3d:	83 c4 10             	add    $0x10,%esp
80105b40:	85 c0                	test   %eax,%eax
80105b42:	0f 88 8f 00 00 00    	js     80105bd7 <create+0x177>
  iunlockput(dp);
80105b48:	83 ec 0c             	sub    $0xc,%esp
80105b4b:	53                   	push   %ebx
80105b4c:	e8 7f bf ff ff       	call   80101ad0 <iunlockput>
  return ip;
80105b51:	83 c4 10             	add    $0x10,%esp
}
80105b54:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b57:	89 f8                	mov    %edi,%eax
80105b59:	5b                   	pop    %ebx
80105b5a:	5e                   	pop    %esi
80105b5b:	5f                   	pop    %edi
80105b5c:	5d                   	pop    %ebp
80105b5d:	c3                   	ret    
80105b5e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105b60:	83 ec 0c             	sub    $0xc,%esp
80105b63:	57                   	push   %edi
    return 0;
80105b64:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80105b66:	e8 65 bf ff ff       	call   80101ad0 <iunlockput>
    return 0;
80105b6b:	83 c4 10             	add    $0x10,%esp
}
80105b6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b71:	89 f8                	mov    %edi,%eax
80105b73:	5b                   	pop    %ebx
80105b74:	5e                   	pop    %esi
80105b75:	5f                   	pop    %edi
80105b76:	5d                   	pop    %ebp
80105b77:	c3                   	ret    
80105b78:	90                   	nop
80105b79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80105b80:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105b85:	83 ec 0c             	sub    $0xc,%esp
80105b88:	53                   	push   %ebx
80105b89:	e8 02 bc ff ff       	call   80101790 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105b8e:	83 c4 0c             	add    $0xc,%esp
80105b91:	ff 77 04             	pushl  0x4(%edi)
80105b94:	68 10 8e 10 80       	push   $0x80108e10
80105b99:	57                   	push   %edi
80105b9a:	e8 41 c4 ff ff       	call   80101fe0 <dirlink>
80105b9f:	83 c4 10             	add    $0x10,%esp
80105ba2:	85 c0                	test   %eax,%eax
80105ba4:	78 1c                	js     80105bc2 <create+0x162>
80105ba6:	83 ec 04             	sub    $0x4,%esp
80105ba9:	ff 73 04             	pushl  0x4(%ebx)
80105bac:	68 0f 8e 10 80       	push   $0x80108e0f
80105bb1:	57                   	push   %edi
80105bb2:	e8 29 c4 ff ff       	call   80101fe0 <dirlink>
80105bb7:	83 c4 10             	add    $0x10,%esp
80105bba:	85 c0                	test   %eax,%eax
80105bbc:	0f 89 6e ff ff ff    	jns    80105b30 <create+0xd0>
      panic("create dots");
80105bc2:	83 ec 0c             	sub    $0xc,%esp
80105bc5:	68 03 8e 10 80       	push   $0x80108e03
80105bca:	e8 c1 a7 ff ff       	call   80100390 <panic>
80105bcf:	90                   	nop
    return 0;
80105bd0:	31 ff                	xor    %edi,%edi
80105bd2:	e9 ff fe ff ff       	jmp    80105ad6 <create+0x76>
    panic("create: dirlink");
80105bd7:	83 ec 0c             	sub    $0xc,%esp
80105bda:	68 12 8e 10 80       	push   $0x80108e12
80105bdf:	e8 ac a7 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105be4:	83 ec 0c             	sub    $0xc,%esp
80105be7:	68 f4 8d 10 80       	push   $0x80108df4
80105bec:	e8 9f a7 ff ff       	call   80100390 <panic>
80105bf1:	eb 0d                	jmp    80105c00 <argfd.constprop.0>
80105bf3:	90                   	nop
80105bf4:	90                   	nop
80105bf5:	90                   	nop
80105bf6:	90                   	nop
80105bf7:	90                   	nop
80105bf8:	90                   	nop
80105bf9:	90                   	nop
80105bfa:	90                   	nop
80105bfb:	90                   	nop
80105bfc:	90                   	nop
80105bfd:	90                   	nop
80105bfe:	90                   	nop
80105bff:	90                   	nop

80105c00 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105c00:	55                   	push   %ebp
80105c01:	89 e5                	mov    %esp,%ebp
80105c03:	56                   	push   %esi
80105c04:	53                   	push   %ebx
80105c05:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80105c07:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80105c0a:	89 d6                	mov    %edx,%esi
80105c0c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80105c0f:	50                   	push   %eax
80105c10:	6a 00                	push   $0x0
80105c12:	e8 a9 f4 ff ff       	call   801050c0 <argint>
80105c17:	83 c4 10             	add    $0x10,%esp
80105c1a:	85 c0                	test   %eax,%eax
80105c1c:	78 2a                	js     80105c48 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80105c1e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105c22:	77 24                	ja     80105c48 <argfd.constprop.0+0x48>
80105c24:	e8 97 dd ff ff       	call   801039c0 <myproc>
80105c29:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105c2c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105c30:	85 c0                	test   %eax,%eax
80105c32:	74 14                	je     80105c48 <argfd.constprop.0+0x48>
  if(pfd)
80105c34:	85 db                	test   %ebx,%ebx
80105c36:	74 02                	je     80105c3a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105c38:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80105c3a:	89 06                	mov    %eax,(%esi)
  return 0;
80105c3c:	31 c0                	xor    %eax,%eax
}
80105c3e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105c41:	5b                   	pop    %ebx
80105c42:	5e                   	pop    %esi
80105c43:	5d                   	pop    %ebp
80105c44:	c3                   	ret    
80105c45:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105c48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c4d:	eb ef                	jmp    80105c3e <argfd.constprop.0+0x3e>
80105c4f:	90                   	nop

80105c50 <sys_dup>:
{
80105c50:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80105c51:	31 c0                	xor    %eax,%eax
{
80105c53:	89 e5                	mov    %esp,%ebp
80105c55:	56                   	push   %esi
80105c56:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80105c57:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80105c5a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80105c5d:	e8 9e ff ff ff       	call   80105c00 <argfd.constprop.0>
80105c62:	85 c0                	test   %eax,%eax
80105c64:	78 42                	js     80105ca8 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
80105c66:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105c69:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105c6b:	e8 50 dd ff ff       	call   801039c0 <myproc>
80105c70:	eb 0e                	jmp    80105c80 <sys_dup+0x30>
80105c72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105c78:	83 c3 01             	add    $0x1,%ebx
80105c7b:	83 fb 10             	cmp    $0x10,%ebx
80105c7e:	74 28                	je     80105ca8 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80105c80:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105c84:	85 d2                	test   %edx,%edx
80105c86:	75 f0                	jne    80105c78 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80105c88:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105c8c:	83 ec 0c             	sub    $0xc,%esp
80105c8f:	ff 75 f4             	pushl  -0xc(%ebp)
80105c92:	e8 09 b3 ff ff       	call   80100fa0 <filedup>
  return fd;
80105c97:	83 c4 10             	add    $0x10,%esp
}
80105c9a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105c9d:	89 d8                	mov    %ebx,%eax
80105c9f:	5b                   	pop    %ebx
80105ca0:	5e                   	pop    %esi
80105ca1:	5d                   	pop    %ebp
80105ca2:	c3                   	ret    
80105ca3:	90                   	nop
80105ca4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105ca8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80105cab:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105cb0:	89 d8                	mov    %ebx,%eax
80105cb2:	5b                   	pop    %ebx
80105cb3:	5e                   	pop    %esi
80105cb4:	5d                   	pop    %ebp
80105cb5:	c3                   	ret    
80105cb6:	8d 76 00             	lea    0x0(%esi),%esi
80105cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105cc0 <sys_read>:
{
80105cc0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105cc1:	31 c0                	xor    %eax,%eax
{
80105cc3:	89 e5                	mov    %esp,%ebp
80105cc5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105cc8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80105ccb:	e8 30 ff ff ff       	call   80105c00 <argfd.constprop.0>
80105cd0:	85 c0                	test   %eax,%eax
80105cd2:	78 4c                	js     80105d20 <sys_read+0x60>
80105cd4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105cd7:	83 ec 08             	sub    $0x8,%esp
80105cda:	50                   	push   %eax
80105cdb:	6a 02                	push   $0x2
80105cdd:	e8 de f3 ff ff       	call   801050c0 <argint>
80105ce2:	83 c4 10             	add    $0x10,%esp
80105ce5:	85 c0                	test   %eax,%eax
80105ce7:	78 37                	js     80105d20 <sys_read+0x60>
80105ce9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105cec:	83 ec 04             	sub    $0x4,%esp
80105cef:	ff 75 f0             	pushl  -0x10(%ebp)
80105cf2:	50                   	push   %eax
80105cf3:	6a 01                	push   $0x1
80105cf5:	e8 16 f4 ff ff       	call   80105110 <argptr>
80105cfa:	83 c4 10             	add    $0x10,%esp
80105cfd:	85 c0                	test   %eax,%eax
80105cff:	78 1f                	js     80105d20 <sys_read+0x60>
  return fileread(f, p, n);
80105d01:	83 ec 04             	sub    $0x4,%esp
80105d04:	ff 75 f0             	pushl  -0x10(%ebp)
80105d07:	ff 75 f4             	pushl  -0xc(%ebp)
80105d0a:	ff 75 ec             	pushl  -0x14(%ebp)
80105d0d:	e8 fe b3 ff ff       	call   80101110 <fileread>
80105d12:	83 c4 10             	add    $0x10,%esp
}
80105d15:	c9                   	leave  
80105d16:	c3                   	ret    
80105d17:	89 f6                	mov    %esi,%esi
80105d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105d20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d25:	c9                   	leave  
80105d26:	c3                   	ret    
80105d27:	89 f6                	mov    %esi,%esi
80105d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105d30 <sys_write>:
{
80105d30:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105d31:	31 c0                	xor    %eax,%eax
{
80105d33:	89 e5                	mov    %esp,%ebp
80105d35:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105d38:	8d 55 ec             	lea    -0x14(%ebp),%edx
80105d3b:	e8 c0 fe ff ff       	call   80105c00 <argfd.constprop.0>
80105d40:	85 c0                	test   %eax,%eax
80105d42:	78 4c                	js     80105d90 <sys_write+0x60>
80105d44:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105d47:	83 ec 08             	sub    $0x8,%esp
80105d4a:	50                   	push   %eax
80105d4b:	6a 02                	push   $0x2
80105d4d:	e8 6e f3 ff ff       	call   801050c0 <argint>
80105d52:	83 c4 10             	add    $0x10,%esp
80105d55:	85 c0                	test   %eax,%eax
80105d57:	78 37                	js     80105d90 <sys_write+0x60>
80105d59:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d5c:	83 ec 04             	sub    $0x4,%esp
80105d5f:	ff 75 f0             	pushl  -0x10(%ebp)
80105d62:	50                   	push   %eax
80105d63:	6a 01                	push   $0x1
80105d65:	e8 a6 f3 ff ff       	call   80105110 <argptr>
80105d6a:	83 c4 10             	add    $0x10,%esp
80105d6d:	85 c0                	test   %eax,%eax
80105d6f:	78 1f                	js     80105d90 <sys_write+0x60>
  return filewrite(f, p, n);
80105d71:	83 ec 04             	sub    $0x4,%esp
80105d74:	ff 75 f0             	pushl  -0x10(%ebp)
80105d77:	ff 75 f4             	pushl  -0xc(%ebp)
80105d7a:	ff 75 ec             	pushl  -0x14(%ebp)
80105d7d:	e8 1e b4 ff ff       	call   801011a0 <filewrite>
80105d82:	83 c4 10             	add    $0x10,%esp
}
80105d85:	c9                   	leave  
80105d86:	c3                   	ret    
80105d87:	89 f6                	mov    %esi,%esi
80105d89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105d90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d95:	c9                   	leave  
80105d96:	c3                   	ret    
80105d97:	89 f6                	mov    %esi,%esi
80105d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105da0 <sys_close>:
{
80105da0:	55                   	push   %ebp
80105da1:	89 e5                	mov    %esp,%ebp
80105da3:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80105da6:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105da9:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105dac:	e8 4f fe ff ff       	call   80105c00 <argfd.constprop.0>
80105db1:	85 c0                	test   %eax,%eax
80105db3:	78 2b                	js     80105de0 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105db5:	e8 06 dc ff ff       	call   801039c0 <myproc>
80105dba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80105dbd:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105dc0:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105dc7:	00 
  fileclose(f);
80105dc8:	ff 75 f4             	pushl  -0xc(%ebp)
80105dcb:	e8 20 b2 ff ff       	call   80100ff0 <fileclose>
  return 0;
80105dd0:	83 c4 10             	add    $0x10,%esp
80105dd3:	31 c0                	xor    %eax,%eax
}
80105dd5:	c9                   	leave  
80105dd6:	c3                   	ret    
80105dd7:	89 f6                	mov    %esi,%esi
80105dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105de0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105de5:	c9                   	leave  
80105de6:	c3                   	ret    
80105de7:	89 f6                	mov    %esi,%esi
80105de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105df0 <sys_fstat>:
{
80105df0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105df1:	31 c0                	xor    %eax,%eax
{
80105df3:	89 e5                	mov    %esp,%ebp
80105df5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105df8:	8d 55 f0             	lea    -0x10(%ebp),%edx
80105dfb:	e8 00 fe ff ff       	call   80105c00 <argfd.constprop.0>
80105e00:	85 c0                	test   %eax,%eax
80105e02:	78 2c                	js     80105e30 <sys_fstat+0x40>
80105e04:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e07:	83 ec 04             	sub    $0x4,%esp
80105e0a:	6a 14                	push   $0x14
80105e0c:	50                   	push   %eax
80105e0d:	6a 01                	push   $0x1
80105e0f:	e8 fc f2 ff ff       	call   80105110 <argptr>
80105e14:	83 c4 10             	add    $0x10,%esp
80105e17:	85 c0                	test   %eax,%eax
80105e19:	78 15                	js     80105e30 <sys_fstat+0x40>
  return filestat(f, st);
80105e1b:	83 ec 08             	sub    $0x8,%esp
80105e1e:	ff 75 f4             	pushl  -0xc(%ebp)
80105e21:	ff 75 f0             	pushl  -0x10(%ebp)
80105e24:	e8 97 b2 ff ff       	call   801010c0 <filestat>
80105e29:	83 c4 10             	add    $0x10,%esp
}
80105e2c:	c9                   	leave  
80105e2d:	c3                   	ret    
80105e2e:	66 90                	xchg   %ax,%ax
    return -1;
80105e30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e35:	c9                   	leave  
80105e36:	c3                   	ret    
80105e37:	89 f6                	mov    %esi,%esi
80105e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105e40 <sys_link>:
{
80105e40:	55                   	push   %ebp
80105e41:	89 e5                	mov    %esp,%ebp
80105e43:	57                   	push   %edi
80105e44:	56                   	push   %esi
80105e45:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105e46:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105e49:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105e4c:	50                   	push   %eax
80105e4d:	6a 00                	push   $0x0
80105e4f:	e8 1c f3 ff ff       	call   80105170 <argstr>
80105e54:	83 c4 10             	add    $0x10,%esp
80105e57:	85 c0                	test   %eax,%eax
80105e59:	0f 88 fb 00 00 00    	js     80105f5a <sys_link+0x11a>
80105e5f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105e62:	83 ec 08             	sub    $0x8,%esp
80105e65:	50                   	push   %eax
80105e66:	6a 01                	push   $0x1
80105e68:	e8 03 f3 ff ff       	call   80105170 <argstr>
80105e6d:	83 c4 10             	add    $0x10,%esp
80105e70:	85 c0                	test   %eax,%eax
80105e72:	0f 88 e2 00 00 00    	js     80105f5a <sys_link+0x11a>
  begin_op();
80105e78:	e8 e3 ce ff ff       	call   80102d60 <begin_op>
  if((ip = namei(old)) == 0){
80105e7d:	83 ec 0c             	sub    $0xc,%esp
80105e80:	ff 75 d4             	pushl  -0x2c(%ebp)
80105e83:	e8 18 c2 ff ff       	call   801020a0 <namei>
80105e88:	83 c4 10             	add    $0x10,%esp
80105e8b:	85 c0                	test   %eax,%eax
80105e8d:	89 c3                	mov    %eax,%ebx
80105e8f:	0f 84 ea 00 00 00    	je     80105f7f <sys_link+0x13f>
  ilock(ip);
80105e95:	83 ec 0c             	sub    $0xc,%esp
80105e98:	50                   	push   %eax
80105e99:	e8 a2 b9 ff ff       	call   80101840 <ilock>
  if(ip->type == T_DIR){
80105e9e:	83 c4 10             	add    $0x10,%esp
80105ea1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105ea6:	0f 84 bb 00 00 00    	je     80105f67 <sys_link+0x127>
  ip->nlink++;
80105eac:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105eb1:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
80105eb4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105eb7:	53                   	push   %ebx
80105eb8:	e8 d3 b8 ff ff       	call   80101790 <iupdate>
  iunlock(ip);
80105ebd:	89 1c 24             	mov    %ebx,(%esp)
80105ec0:	e8 5b ba ff ff       	call   80101920 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105ec5:	58                   	pop    %eax
80105ec6:	5a                   	pop    %edx
80105ec7:	57                   	push   %edi
80105ec8:	ff 75 d0             	pushl  -0x30(%ebp)
80105ecb:	e8 f0 c1 ff ff       	call   801020c0 <nameiparent>
80105ed0:	83 c4 10             	add    $0x10,%esp
80105ed3:	85 c0                	test   %eax,%eax
80105ed5:	89 c6                	mov    %eax,%esi
80105ed7:	74 5b                	je     80105f34 <sys_link+0xf4>
  ilock(dp);
80105ed9:	83 ec 0c             	sub    $0xc,%esp
80105edc:	50                   	push   %eax
80105edd:	e8 5e b9 ff ff       	call   80101840 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105ee2:	83 c4 10             	add    $0x10,%esp
80105ee5:	8b 03                	mov    (%ebx),%eax
80105ee7:	39 06                	cmp    %eax,(%esi)
80105ee9:	75 3d                	jne    80105f28 <sys_link+0xe8>
80105eeb:	83 ec 04             	sub    $0x4,%esp
80105eee:	ff 73 04             	pushl  0x4(%ebx)
80105ef1:	57                   	push   %edi
80105ef2:	56                   	push   %esi
80105ef3:	e8 e8 c0 ff ff       	call   80101fe0 <dirlink>
80105ef8:	83 c4 10             	add    $0x10,%esp
80105efb:	85 c0                	test   %eax,%eax
80105efd:	78 29                	js     80105f28 <sys_link+0xe8>
  iunlockput(dp);
80105eff:	83 ec 0c             	sub    $0xc,%esp
80105f02:	56                   	push   %esi
80105f03:	e8 c8 bb ff ff       	call   80101ad0 <iunlockput>
  iput(ip);
80105f08:	89 1c 24             	mov    %ebx,(%esp)
80105f0b:	e8 60 ba ff ff       	call   80101970 <iput>
  end_op();
80105f10:	e8 bb ce ff ff       	call   80102dd0 <end_op>
  return 0;
80105f15:	83 c4 10             	add    $0x10,%esp
80105f18:	31 c0                	xor    %eax,%eax
}
80105f1a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f1d:	5b                   	pop    %ebx
80105f1e:	5e                   	pop    %esi
80105f1f:	5f                   	pop    %edi
80105f20:	5d                   	pop    %ebp
80105f21:	c3                   	ret    
80105f22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105f28:	83 ec 0c             	sub    $0xc,%esp
80105f2b:	56                   	push   %esi
80105f2c:	e8 9f bb ff ff       	call   80101ad0 <iunlockput>
    goto bad;
80105f31:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105f34:	83 ec 0c             	sub    $0xc,%esp
80105f37:	53                   	push   %ebx
80105f38:	e8 03 b9 ff ff       	call   80101840 <ilock>
  ip->nlink--;
80105f3d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105f42:	89 1c 24             	mov    %ebx,(%esp)
80105f45:	e8 46 b8 ff ff       	call   80101790 <iupdate>
  iunlockput(ip);
80105f4a:	89 1c 24             	mov    %ebx,(%esp)
80105f4d:	e8 7e bb ff ff       	call   80101ad0 <iunlockput>
  end_op();
80105f52:	e8 79 ce ff ff       	call   80102dd0 <end_op>
  return -1;
80105f57:	83 c4 10             	add    $0x10,%esp
}
80105f5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80105f5d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f62:	5b                   	pop    %ebx
80105f63:	5e                   	pop    %esi
80105f64:	5f                   	pop    %edi
80105f65:	5d                   	pop    %ebp
80105f66:	c3                   	ret    
    iunlockput(ip);
80105f67:	83 ec 0c             	sub    $0xc,%esp
80105f6a:	53                   	push   %ebx
80105f6b:	e8 60 bb ff ff       	call   80101ad0 <iunlockput>
    end_op();
80105f70:	e8 5b ce ff ff       	call   80102dd0 <end_op>
    return -1;
80105f75:	83 c4 10             	add    $0x10,%esp
80105f78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f7d:	eb 9b                	jmp    80105f1a <sys_link+0xda>
    end_op();
80105f7f:	e8 4c ce ff ff       	call   80102dd0 <end_op>
    return -1;
80105f84:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f89:	eb 8f                	jmp    80105f1a <sys_link+0xda>
80105f8b:	90                   	nop
80105f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105f90 <sys_unlink>:
{
80105f90:	55                   	push   %ebp
80105f91:	89 e5                	mov    %esp,%ebp
80105f93:	57                   	push   %edi
80105f94:	56                   	push   %esi
80105f95:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
80105f96:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105f99:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
80105f9c:	50                   	push   %eax
80105f9d:	6a 00                	push   $0x0
80105f9f:	e8 cc f1 ff ff       	call   80105170 <argstr>
80105fa4:	83 c4 10             	add    $0x10,%esp
80105fa7:	85 c0                	test   %eax,%eax
80105fa9:	0f 88 77 01 00 00    	js     80106126 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
80105faf:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105fb2:	e8 a9 cd ff ff       	call   80102d60 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105fb7:	83 ec 08             	sub    $0x8,%esp
80105fba:	53                   	push   %ebx
80105fbb:	ff 75 c0             	pushl  -0x40(%ebp)
80105fbe:	e8 fd c0 ff ff       	call   801020c0 <nameiparent>
80105fc3:	83 c4 10             	add    $0x10,%esp
80105fc6:	85 c0                	test   %eax,%eax
80105fc8:	89 c6                	mov    %eax,%esi
80105fca:	0f 84 60 01 00 00    	je     80106130 <sys_unlink+0x1a0>
  ilock(dp);
80105fd0:	83 ec 0c             	sub    $0xc,%esp
80105fd3:	50                   	push   %eax
80105fd4:	e8 67 b8 ff ff       	call   80101840 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105fd9:	58                   	pop    %eax
80105fda:	5a                   	pop    %edx
80105fdb:	68 10 8e 10 80       	push   $0x80108e10
80105fe0:	53                   	push   %ebx
80105fe1:	e8 6a bd ff ff       	call   80101d50 <namecmp>
80105fe6:	83 c4 10             	add    $0x10,%esp
80105fe9:	85 c0                	test   %eax,%eax
80105feb:	0f 84 03 01 00 00    	je     801060f4 <sys_unlink+0x164>
80105ff1:	83 ec 08             	sub    $0x8,%esp
80105ff4:	68 0f 8e 10 80       	push   $0x80108e0f
80105ff9:	53                   	push   %ebx
80105ffa:	e8 51 bd ff ff       	call   80101d50 <namecmp>
80105fff:	83 c4 10             	add    $0x10,%esp
80106002:	85 c0                	test   %eax,%eax
80106004:	0f 84 ea 00 00 00    	je     801060f4 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010600a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010600d:	83 ec 04             	sub    $0x4,%esp
80106010:	50                   	push   %eax
80106011:	53                   	push   %ebx
80106012:	56                   	push   %esi
80106013:	e8 58 bd ff ff       	call   80101d70 <dirlookup>
80106018:	83 c4 10             	add    $0x10,%esp
8010601b:	85 c0                	test   %eax,%eax
8010601d:	89 c3                	mov    %eax,%ebx
8010601f:	0f 84 cf 00 00 00    	je     801060f4 <sys_unlink+0x164>
  ilock(ip);
80106025:	83 ec 0c             	sub    $0xc,%esp
80106028:	50                   	push   %eax
80106029:	e8 12 b8 ff ff       	call   80101840 <ilock>
  if(ip->nlink < 1)
8010602e:	83 c4 10             	add    $0x10,%esp
80106031:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80106036:	0f 8e 10 01 00 00    	jle    8010614c <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010603c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80106041:	74 6d                	je     801060b0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80106043:	8d 45 d8             	lea    -0x28(%ebp),%eax
80106046:	83 ec 04             	sub    $0x4,%esp
80106049:	6a 10                	push   $0x10
8010604b:	6a 00                	push   $0x0
8010604d:	50                   	push   %eax
8010604e:	e8 6d ed ff ff       	call   80104dc0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106053:	8d 45 d8             	lea    -0x28(%ebp),%eax
80106056:	6a 10                	push   $0x10
80106058:	ff 75 c4             	pushl  -0x3c(%ebp)
8010605b:	50                   	push   %eax
8010605c:	56                   	push   %esi
8010605d:	e8 be bb ff ff       	call   80101c20 <writei>
80106062:	83 c4 20             	add    $0x20,%esp
80106065:	83 f8 10             	cmp    $0x10,%eax
80106068:	0f 85 eb 00 00 00    	jne    80106159 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
8010606e:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80106073:	0f 84 97 00 00 00    	je     80106110 <sys_unlink+0x180>
  iunlockput(dp);
80106079:	83 ec 0c             	sub    $0xc,%esp
8010607c:	56                   	push   %esi
8010607d:	e8 4e ba ff ff       	call   80101ad0 <iunlockput>
  ip->nlink--;
80106082:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80106087:	89 1c 24             	mov    %ebx,(%esp)
8010608a:	e8 01 b7 ff ff       	call   80101790 <iupdate>
  iunlockput(ip);
8010608f:	89 1c 24             	mov    %ebx,(%esp)
80106092:	e8 39 ba ff ff       	call   80101ad0 <iunlockput>
  end_op();
80106097:	e8 34 cd ff ff       	call   80102dd0 <end_op>
  return 0;
8010609c:	83 c4 10             	add    $0x10,%esp
8010609f:	31 c0                	xor    %eax,%eax
}
801060a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801060a4:	5b                   	pop    %ebx
801060a5:	5e                   	pop    %esi
801060a6:	5f                   	pop    %edi
801060a7:	5d                   	pop    %ebp
801060a8:	c3                   	ret    
801060a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801060b0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801060b4:	76 8d                	jbe    80106043 <sys_unlink+0xb3>
801060b6:	bf 20 00 00 00       	mov    $0x20,%edi
801060bb:	eb 0f                	jmp    801060cc <sys_unlink+0x13c>
801060bd:	8d 76 00             	lea    0x0(%esi),%esi
801060c0:	83 c7 10             	add    $0x10,%edi
801060c3:	3b 7b 58             	cmp    0x58(%ebx),%edi
801060c6:	0f 83 77 ff ff ff    	jae    80106043 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801060cc:	8d 45 d8             	lea    -0x28(%ebp),%eax
801060cf:	6a 10                	push   $0x10
801060d1:	57                   	push   %edi
801060d2:	50                   	push   %eax
801060d3:	53                   	push   %ebx
801060d4:	e8 47 ba ff ff       	call   80101b20 <readi>
801060d9:	83 c4 10             	add    $0x10,%esp
801060dc:	83 f8 10             	cmp    $0x10,%eax
801060df:	75 5e                	jne    8010613f <sys_unlink+0x1af>
    if(de.inum != 0)
801060e1:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801060e6:	74 d8                	je     801060c0 <sys_unlink+0x130>
    iunlockput(ip);
801060e8:	83 ec 0c             	sub    $0xc,%esp
801060eb:	53                   	push   %ebx
801060ec:	e8 df b9 ff ff       	call   80101ad0 <iunlockput>
    goto bad;
801060f1:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
801060f4:	83 ec 0c             	sub    $0xc,%esp
801060f7:	56                   	push   %esi
801060f8:	e8 d3 b9 ff ff       	call   80101ad0 <iunlockput>
  end_op();
801060fd:	e8 ce cc ff ff       	call   80102dd0 <end_op>
  return -1;
80106102:	83 c4 10             	add    $0x10,%esp
80106105:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010610a:	eb 95                	jmp    801060a1 <sys_unlink+0x111>
8010610c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
80106110:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80106115:	83 ec 0c             	sub    $0xc,%esp
80106118:	56                   	push   %esi
80106119:	e8 72 b6 ff ff       	call   80101790 <iupdate>
8010611e:	83 c4 10             	add    $0x10,%esp
80106121:	e9 53 ff ff ff       	jmp    80106079 <sys_unlink+0xe9>
    return -1;
80106126:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010612b:	e9 71 ff ff ff       	jmp    801060a1 <sys_unlink+0x111>
    end_op();
80106130:	e8 9b cc ff ff       	call   80102dd0 <end_op>
    return -1;
80106135:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010613a:	e9 62 ff ff ff       	jmp    801060a1 <sys_unlink+0x111>
      panic("isdirempty: readi");
8010613f:	83 ec 0c             	sub    $0xc,%esp
80106142:	68 34 8e 10 80       	push   $0x80108e34
80106147:	e8 44 a2 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
8010614c:	83 ec 0c             	sub    $0xc,%esp
8010614f:	68 22 8e 10 80       	push   $0x80108e22
80106154:	e8 37 a2 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80106159:	83 ec 0c             	sub    $0xc,%esp
8010615c:	68 46 8e 10 80       	push   $0x80108e46
80106161:	e8 2a a2 ff ff       	call   80100390 <panic>
80106166:	8d 76 00             	lea    0x0(%esi),%esi
80106169:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106170 <sys_open>:

int
sys_open(void)
{
80106170:	55                   	push   %ebp
80106171:	89 e5                	mov    %esp,%ebp
80106173:	57                   	push   %edi
80106174:	56                   	push   %esi
80106175:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106176:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80106179:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010617c:	50                   	push   %eax
8010617d:	6a 00                	push   $0x0
8010617f:	e8 ec ef ff ff       	call   80105170 <argstr>
80106184:	83 c4 10             	add    $0x10,%esp
80106187:	85 c0                	test   %eax,%eax
80106189:	0f 88 1d 01 00 00    	js     801062ac <sys_open+0x13c>
8010618f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106192:	83 ec 08             	sub    $0x8,%esp
80106195:	50                   	push   %eax
80106196:	6a 01                	push   $0x1
80106198:	e8 23 ef ff ff       	call   801050c0 <argint>
8010619d:	83 c4 10             	add    $0x10,%esp
801061a0:	85 c0                	test   %eax,%eax
801061a2:	0f 88 04 01 00 00    	js     801062ac <sys_open+0x13c>
    return -1;

  begin_op();
801061a8:	e8 b3 cb ff ff       	call   80102d60 <begin_op>

  if(omode & O_CREATE){
801061ad:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801061b1:	0f 85 a9 00 00 00    	jne    80106260 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801061b7:	83 ec 0c             	sub    $0xc,%esp
801061ba:	ff 75 e0             	pushl  -0x20(%ebp)
801061bd:	e8 de be ff ff       	call   801020a0 <namei>
801061c2:	83 c4 10             	add    $0x10,%esp
801061c5:	85 c0                	test   %eax,%eax
801061c7:	89 c6                	mov    %eax,%esi
801061c9:	0f 84 b2 00 00 00    	je     80106281 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
801061cf:	83 ec 0c             	sub    $0xc,%esp
801061d2:	50                   	push   %eax
801061d3:	e8 68 b6 ff ff       	call   80101840 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801061d8:	83 c4 10             	add    $0x10,%esp
801061db:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801061e0:	0f 84 aa 00 00 00    	je     80106290 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801061e6:	e8 45 ad ff ff       	call   80100f30 <filealloc>
801061eb:	85 c0                	test   %eax,%eax
801061ed:	89 c7                	mov    %eax,%edi
801061ef:	0f 84 a6 00 00 00    	je     8010629b <sys_open+0x12b>
  struct proc *curproc = myproc();
801061f5:	e8 c6 d7 ff ff       	call   801039c0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801061fa:	31 db                	xor    %ebx,%ebx
801061fc:	eb 0e                	jmp    8010620c <sys_open+0x9c>
801061fe:	66 90                	xchg   %ax,%ax
80106200:	83 c3 01             	add    $0x1,%ebx
80106203:	83 fb 10             	cmp    $0x10,%ebx
80106206:	0f 84 ac 00 00 00    	je     801062b8 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
8010620c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80106210:	85 d2                	test   %edx,%edx
80106212:	75 ec                	jne    80106200 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80106214:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80106217:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010621b:	56                   	push   %esi
8010621c:	e8 ff b6 ff ff       	call   80101920 <iunlock>
  end_op();
80106221:	e8 aa cb ff ff       	call   80102dd0 <end_op>

  f->type = FD_INODE;
80106226:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010622c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010622f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80106232:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80106235:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010623c:	89 d0                	mov    %edx,%eax
8010623e:	f7 d0                	not    %eax
80106240:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106243:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80106246:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106249:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
8010624d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106250:	89 d8                	mov    %ebx,%eax
80106252:	5b                   	pop    %ebx
80106253:	5e                   	pop    %esi
80106254:	5f                   	pop    %edi
80106255:	5d                   	pop    %ebp
80106256:	c3                   	ret    
80106257:	89 f6                	mov    %esi,%esi
80106259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80106260:	83 ec 0c             	sub    $0xc,%esp
80106263:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106266:	31 c9                	xor    %ecx,%ecx
80106268:	6a 00                	push   $0x0
8010626a:	ba 02 00 00 00       	mov    $0x2,%edx
8010626f:	e8 ec f7 ff ff       	call   80105a60 <create>
    if(ip == 0){
80106274:	83 c4 10             	add    $0x10,%esp
80106277:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80106279:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010627b:	0f 85 65 ff ff ff    	jne    801061e6 <sys_open+0x76>
      end_op();
80106281:	e8 4a cb ff ff       	call   80102dd0 <end_op>
      return -1;
80106286:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010628b:	eb c0                	jmp    8010624d <sys_open+0xdd>
8010628d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80106290:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106293:	85 c9                	test   %ecx,%ecx
80106295:	0f 84 4b ff ff ff    	je     801061e6 <sys_open+0x76>
    iunlockput(ip);
8010629b:	83 ec 0c             	sub    $0xc,%esp
8010629e:	56                   	push   %esi
8010629f:	e8 2c b8 ff ff       	call   80101ad0 <iunlockput>
    end_op();
801062a4:	e8 27 cb ff ff       	call   80102dd0 <end_op>
    return -1;
801062a9:	83 c4 10             	add    $0x10,%esp
801062ac:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801062b1:	eb 9a                	jmp    8010624d <sys_open+0xdd>
801062b3:	90                   	nop
801062b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
801062b8:	83 ec 0c             	sub    $0xc,%esp
801062bb:	57                   	push   %edi
801062bc:	e8 2f ad ff ff       	call   80100ff0 <fileclose>
801062c1:	83 c4 10             	add    $0x10,%esp
801062c4:	eb d5                	jmp    8010629b <sys_open+0x12b>
801062c6:	8d 76 00             	lea    0x0(%esi),%esi
801062c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801062d0 <sys_mkdir>:

int
sys_mkdir(void)
{
801062d0:	55                   	push   %ebp
801062d1:	89 e5                	mov    %esp,%ebp
801062d3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801062d6:	e8 85 ca ff ff       	call   80102d60 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801062db:	8d 45 f4             	lea    -0xc(%ebp),%eax
801062de:	83 ec 08             	sub    $0x8,%esp
801062e1:	50                   	push   %eax
801062e2:	6a 00                	push   $0x0
801062e4:	e8 87 ee ff ff       	call   80105170 <argstr>
801062e9:	83 c4 10             	add    $0x10,%esp
801062ec:	85 c0                	test   %eax,%eax
801062ee:	78 30                	js     80106320 <sys_mkdir+0x50>
801062f0:	83 ec 0c             	sub    $0xc,%esp
801062f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062f6:	31 c9                	xor    %ecx,%ecx
801062f8:	6a 00                	push   $0x0
801062fa:	ba 01 00 00 00       	mov    $0x1,%edx
801062ff:	e8 5c f7 ff ff       	call   80105a60 <create>
80106304:	83 c4 10             	add    $0x10,%esp
80106307:	85 c0                	test   %eax,%eax
80106309:	74 15                	je     80106320 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010630b:	83 ec 0c             	sub    $0xc,%esp
8010630e:	50                   	push   %eax
8010630f:	e8 bc b7 ff ff       	call   80101ad0 <iunlockput>
  end_op();
80106314:	e8 b7 ca ff ff       	call   80102dd0 <end_op>
  return 0;
80106319:	83 c4 10             	add    $0x10,%esp
8010631c:	31 c0                	xor    %eax,%eax
}
8010631e:	c9                   	leave  
8010631f:	c3                   	ret    
    end_op();
80106320:	e8 ab ca ff ff       	call   80102dd0 <end_op>
    return -1;
80106325:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010632a:	c9                   	leave  
8010632b:	c3                   	ret    
8010632c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106330 <sys_mknod>:

int
sys_mknod(void)
{
80106330:	55                   	push   %ebp
80106331:	89 e5                	mov    %esp,%ebp
80106333:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80106336:	e8 25 ca ff ff       	call   80102d60 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010633b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010633e:	83 ec 08             	sub    $0x8,%esp
80106341:	50                   	push   %eax
80106342:	6a 00                	push   $0x0
80106344:	e8 27 ee ff ff       	call   80105170 <argstr>
80106349:	83 c4 10             	add    $0x10,%esp
8010634c:	85 c0                	test   %eax,%eax
8010634e:	78 60                	js     801063b0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80106350:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106353:	83 ec 08             	sub    $0x8,%esp
80106356:	50                   	push   %eax
80106357:	6a 01                	push   $0x1
80106359:	e8 62 ed ff ff       	call   801050c0 <argint>
  if((argstr(0, &path)) < 0 ||
8010635e:	83 c4 10             	add    $0x10,%esp
80106361:	85 c0                	test   %eax,%eax
80106363:	78 4b                	js     801063b0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80106365:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106368:	83 ec 08             	sub    $0x8,%esp
8010636b:	50                   	push   %eax
8010636c:	6a 02                	push   $0x2
8010636e:	e8 4d ed ff ff       	call   801050c0 <argint>
     argint(1, &major) < 0 ||
80106373:	83 c4 10             	add    $0x10,%esp
80106376:	85 c0                	test   %eax,%eax
80106378:	78 36                	js     801063b0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010637a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
8010637e:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
80106381:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
80106385:	ba 03 00 00 00       	mov    $0x3,%edx
8010638a:	50                   	push   %eax
8010638b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010638e:	e8 cd f6 ff ff       	call   80105a60 <create>
80106393:	83 c4 10             	add    $0x10,%esp
80106396:	85 c0                	test   %eax,%eax
80106398:	74 16                	je     801063b0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010639a:	83 ec 0c             	sub    $0xc,%esp
8010639d:	50                   	push   %eax
8010639e:	e8 2d b7 ff ff       	call   80101ad0 <iunlockput>
  end_op();
801063a3:	e8 28 ca ff ff       	call   80102dd0 <end_op>
  return 0;
801063a8:	83 c4 10             	add    $0x10,%esp
801063ab:	31 c0                	xor    %eax,%eax
}
801063ad:	c9                   	leave  
801063ae:	c3                   	ret    
801063af:	90                   	nop
    end_op();
801063b0:	e8 1b ca ff ff       	call   80102dd0 <end_op>
    return -1;
801063b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801063ba:	c9                   	leave  
801063bb:	c3                   	ret    
801063bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801063c0 <sys_chdir>:

int
sys_chdir(void)
{
801063c0:	55                   	push   %ebp
801063c1:	89 e5                	mov    %esp,%ebp
801063c3:	56                   	push   %esi
801063c4:	53                   	push   %ebx
801063c5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801063c8:	e8 f3 d5 ff ff       	call   801039c0 <myproc>
801063cd:	89 c6                	mov    %eax,%esi
  
  begin_op();
801063cf:	e8 8c c9 ff ff       	call   80102d60 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801063d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801063d7:	83 ec 08             	sub    $0x8,%esp
801063da:	50                   	push   %eax
801063db:	6a 00                	push   $0x0
801063dd:	e8 8e ed ff ff       	call   80105170 <argstr>
801063e2:	83 c4 10             	add    $0x10,%esp
801063e5:	85 c0                	test   %eax,%eax
801063e7:	78 77                	js     80106460 <sys_chdir+0xa0>
801063e9:	83 ec 0c             	sub    $0xc,%esp
801063ec:	ff 75 f4             	pushl  -0xc(%ebp)
801063ef:	e8 ac bc ff ff       	call   801020a0 <namei>
801063f4:	83 c4 10             	add    $0x10,%esp
801063f7:	85 c0                	test   %eax,%eax
801063f9:	89 c3                	mov    %eax,%ebx
801063fb:	74 63                	je     80106460 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801063fd:	83 ec 0c             	sub    $0xc,%esp
80106400:	50                   	push   %eax
80106401:	e8 3a b4 ff ff       	call   80101840 <ilock>
  if(ip->type != T_DIR){
80106406:	83 c4 10             	add    $0x10,%esp
80106409:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010640e:	75 30                	jne    80106440 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80106410:	83 ec 0c             	sub    $0xc,%esp
80106413:	53                   	push   %ebx
80106414:	e8 07 b5 ff ff       	call   80101920 <iunlock>
  iput(curproc->cwd);
80106419:	58                   	pop    %eax
8010641a:	ff 76 68             	pushl  0x68(%esi)
8010641d:	e8 4e b5 ff ff       	call   80101970 <iput>
  end_op();
80106422:	e8 a9 c9 ff ff       	call   80102dd0 <end_op>
  curproc->cwd = ip;
80106427:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010642a:	83 c4 10             	add    $0x10,%esp
8010642d:	31 c0                	xor    %eax,%eax
}
8010642f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106432:	5b                   	pop    %ebx
80106433:	5e                   	pop    %esi
80106434:	5d                   	pop    %ebp
80106435:	c3                   	ret    
80106436:	8d 76 00             	lea    0x0(%esi),%esi
80106439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80106440:	83 ec 0c             	sub    $0xc,%esp
80106443:	53                   	push   %ebx
80106444:	e8 87 b6 ff ff       	call   80101ad0 <iunlockput>
    end_op();
80106449:	e8 82 c9 ff ff       	call   80102dd0 <end_op>
    return -1;
8010644e:	83 c4 10             	add    $0x10,%esp
80106451:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106456:	eb d7                	jmp    8010642f <sys_chdir+0x6f>
80106458:	90                   	nop
80106459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80106460:	e8 6b c9 ff ff       	call   80102dd0 <end_op>
    return -1;
80106465:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010646a:	eb c3                	jmp    8010642f <sys_chdir+0x6f>
8010646c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106470 <sys_exec>:

int
sys_exec(void)
{
80106470:	55                   	push   %ebp
80106471:	89 e5                	mov    %esp,%ebp
80106473:	57                   	push   %edi
80106474:	56                   	push   %esi
80106475:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106476:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010647c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106482:	50                   	push   %eax
80106483:	6a 00                	push   $0x0
80106485:	e8 e6 ec ff ff       	call   80105170 <argstr>
8010648a:	83 c4 10             	add    $0x10,%esp
8010648d:	85 c0                	test   %eax,%eax
8010648f:	0f 88 87 00 00 00    	js     8010651c <sys_exec+0xac>
80106495:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010649b:	83 ec 08             	sub    $0x8,%esp
8010649e:	50                   	push   %eax
8010649f:	6a 01                	push   $0x1
801064a1:	e8 1a ec ff ff       	call   801050c0 <argint>
801064a6:	83 c4 10             	add    $0x10,%esp
801064a9:	85 c0                	test   %eax,%eax
801064ab:	78 6f                	js     8010651c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801064ad:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801064b3:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
801064b6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801064b8:	68 80 00 00 00       	push   $0x80
801064bd:	6a 00                	push   $0x0
801064bf:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801064c5:	50                   	push   %eax
801064c6:	e8 f5 e8 ff ff       	call   80104dc0 <memset>
801064cb:	83 c4 10             	add    $0x10,%esp
801064ce:	eb 2c                	jmp    801064fc <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
801064d0:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801064d6:	85 c0                	test   %eax,%eax
801064d8:	74 56                	je     80106530 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801064da:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
801064e0:	83 ec 08             	sub    $0x8,%esp
801064e3:	8d 14 31             	lea    (%ecx,%esi,1),%edx
801064e6:	52                   	push   %edx
801064e7:	50                   	push   %eax
801064e8:	e8 63 eb ff ff       	call   80105050 <fetchstr>
801064ed:	83 c4 10             	add    $0x10,%esp
801064f0:	85 c0                	test   %eax,%eax
801064f2:	78 28                	js     8010651c <sys_exec+0xac>
  for(i=0;; i++){
801064f4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801064f7:	83 fb 20             	cmp    $0x20,%ebx
801064fa:	74 20                	je     8010651c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801064fc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80106502:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80106509:	83 ec 08             	sub    $0x8,%esp
8010650c:	57                   	push   %edi
8010650d:	01 f0                	add    %esi,%eax
8010650f:	50                   	push   %eax
80106510:	e8 fb ea ff ff       	call   80105010 <fetchint>
80106515:	83 c4 10             	add    $0x10,%esp
80106518:	85 c0                	test   %eax,%eax
8010651a:	79 b4                	jns    801064d0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010651c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010651f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106524:	5b                   	pop    %ebx
80106525:	5e                   	pop    %esi
80106526:	5f                   	pop    %edi
80106527:	5d                   	pop    %ebp
80106528:	c3                   	ret    
80106529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80106530:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106536:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80106539:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80106540:	00 00 00 00 
  return exec(path, argv);
80106544:	50                   	push   %eax
80106545:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010654b:	e8 70 a6 ff ff       	call   80100bc0 <exec>
80106550:	83 c4 10             	add    $0x10,%esp
}
80106553:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106556:	5b                   	pop    %ebx
80106557:	5e                   	pop    %esi
80106558:	5f                   	pop    %edi
80106559:	5d                   	pop    %ebp
8010655a:	c3                   	ret    
8010655b:	90                   	nop
8010655c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106560 <sys_pipe>:

int
sys_pipe(void)
{
80106560:	55                   	push   %ebp
80106561:	89 e5                	mov    %esp,%ebp
80106563:	57                   	push   %edi
80106564:	56                   	push   %esi
80106565:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106566:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80106569:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010656c:	6a 08                	push   $0x8
8010656e:	50                   	push   %eax
8010656f:	6a 00                	push   $0x0
80106571:	e8 9a eb ff ff       	call   80105110 <argptr>
80106576:	83 c4 10             	add    $0x10,%esp
80106579:	85 c0                	test   %eax,%eax
8010657b:	0f 88 ae 00 00 00    	js     8010662f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80106581:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106584:	83 ec 08             	sub    $0x8,%esp
80106587:	50                   	push   %eax
80106588:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010658b:	50                   	push   %eax
8010658c:	e8 6f ce ff ff       	call   80103400 <pipealloc>
80106591:	83 c4 10             	add    $0x10,%esp
80106594:	85 c0                	test   %eax,%eax
80106596:	0f 88 93 00 00 00    	js     8010662f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010659c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010659f:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801065a1:	e8 1a d4 ff ff       	call   801039c0 <myproc>
801065a6:	eb 10                	jmp    801065b8 <sys_pipe+0x58>
801065a8:	90                   	nop
801065a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
801065b0:	83 c3 01             	add    $0x1,%ebx
801065b3:	83 fb 10             	cmp    $0x10,%ebx
801065b6:	74 60                	je     80106618 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
801065b8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801065bc:	85 f6                	test   %esi,%esi
801065be:	75 f0                	jne    801065b0 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
801065c0:	8d 73 08             	lea    0x8(%ebx),%esi
801065c3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801065c7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801065ca:	e8 f1 d3 ff ff       	call   801039c0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801065cf:	31 d2                	xor    %edx,%edx
801065d1:	eb 0d                	jmp    801065e0 <sys_pipe+0x80>
801065d3:	90                   	nop
801065d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801065d8:	83 c2 01             	add    $0x1,%edx
801065db:	83 fa 10             	cmp    $0x10,%edx
801065de:	74 28                	je     80106608 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
801065e0:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801065e4:	85 c9                	test   %ecx,%ecx
801065e6:	75 f0                	jne    801065d8 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
801065e8:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801065ec:	8b 45 dc             	mov    -0x24(%ebp),%eax
801065ef:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801065f1:	8b 45 dc             	mov    -0x24(%ebp),%eax
801065f4:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801065f7:	31 c0                	xor    %eax,%eax
}
801065f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801065fc:	5b                   	pop    %ebx
801065fd:	5e                   	pop    %esi
801065fe:	5f                   	pop    %edi
801065ff:	5d                   	pop    %ebp
80106600:	c3                   	ret    
80106601:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80106608:	e8 b3 d3 ff ff       	call   801039c0 <myproc>
8010660d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80106614:	00 
80106615:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80106618:	83 ec 0c             	sub    $0xc,%esp
8010661b:	ff 75 e0             	pushl  -0x20(%ebp)
8010661e:	e8 cd a9 ff ff       	call   80100ff0 <fileclose>
    fileclose(wf);
80106623:	58                   	pop    %eax
80106624:	ff 75 e4             	pushl  -0x1c(%ebp)
80106627:	e8 c4 a9 ff ff       	call   80100ff0 <fileclose>
    return -1;
8010662c:	83 c4 10             	add    $0x10,%esp
8010662f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106634:	eb c3                	jmp    801065f9 <sys_pipe+0x99>
80106636:	66 90                	xchg   %ax,%ax
80106638:	66 90                	xchg   %ax,%ax
8010663a:	66 90                	xchg   %ax,%ax
8010663c:	66 90                	xchg   %ax,%ax
8010663e:	66 90                	xchg   %ax,%ax

80106640 <sys_fork>:
struct ticket_lock ticketlock;
int safe_count = 0;

int
sys_fork(void)
{
80106640:	55                   	push   %ebp
80106641:	89 e5                	mov    %esp,%ebp
  return fork();
}
80106643:	5d                   	pop    %ebp
  return fork();
80106644:	e9 17 d5 ff ff       	jmp    80103b60 <fork>
80106649:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106650 <sys_exit>:

int
sys_exit(void)
{
80106650:	55                   	push   %ebp
80106651:	89 e5                	mov    %esp,%ebp
80106653:	83 ec 08             	sub    $0x8,%esp
  exit();
80106656:	e8 85 d7 ff ff       	call   80103de0 <exit>
  return 0;  // not reached
}
8010665b:	31 c0                	xor    %eax,%eax
8010665d:	c9                   	leave  
8010665e:	c3                   	ret    
8010665f:	90                   	nop

80106660 <sys_wait>:

int
sys_wait(void)
{
80106660:	55                   	push   %ebp
80106661:	89 e5                	mov    %esp,%ebp
  return wait();
}
80106663:	5d                   	pop    %ebp
  return wait();
80106664:	e9 27 da ff ff       	jmp    80104090 <wait>
80106669:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106670 <sys_kill>:

int
sys_kill(void)
{
80106670:	55                   	push   %ebp
80106671:	89 e5                	mov    %esp,%ebp
80106673:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106676:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106679:	50                   	push   %eax
8010667a:	6a 00                	push   $0x0
8010667c:	e8 3f ea ff ff       	call   801050c0 <argint>
80106681:	83 c4 10             	add    $0x10,%esp
80106684:	85 c0                	test   %eax,%eax
80106686:	78 18                	js     801066a0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80106688:	83 ec 0c             	sub    $0xc,%esp
8010668b:	ff 75 f4             	pushl  -0xc(%ebp)
8010668e:	e8 1d e0 ff ff       	call   801046b0 <kill>
80106693:	83 c4 10             	add    $0x10,%esp
}
80106696:	c9                   	leave  
80106697:	c3                   	ret    
80106698:	90                   	nop
80106699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801066a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801066a5:	c9                   	leave  
801066a6:	c3                   	ret    
801066a7:	89 f6                	mov    %esi,%esi
801066a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801066b0 <sys_inc_num>:

int
sys_inc_num(void)
{
801066b0:	55                   	push   %ebp
801066b1:	89 e5                	mov    %esp,%ebp
801066b3:	83 ec 20             	sub    $0x20,%esp
  int num;
 // register int *num asm ("ebx");
   if(argint(0, &num) < 0)
801066b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801066b9:	50                   	push   %eax
801066ba:	6a 00                	push   $0x0
801066bc:	e8 ff e9 ff ff       	call   801050c0 <argint>
801066c1:	83 c4 10             	add    $0x10,%esp
801066c4:	85 c0                	test   %eax,%eax
801066c6:	78 20                	js     801066e8 <sys_inc_num+0x38>
     return -1;
  cprintf("num : %d\n", num+1);
801066c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066cb:	83 ec 08             	sub    $0x8,%esp
801066ce:	83 c0 01             	add    $0x1,%eax
801066d1:	50                   	push   %eax
801066d2:	68 55 8e 10 80       	push   $0x80108e55
801066d7:	e8 14 a0 ff ff       	call   801006f0 <cprintf>
  return 0;
801066dc:	83 c4 10             	add    $0x10,%esp
801066df:	31 c0                	xor    %eax,%eax
}
801066e1:	c9                   	leave  
801066e2:	c3                   	ret    
801066e3:	90                   	nop
801066e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     return -1;
801066e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801066ed:	c9                   	leave  
801066ee:	c3                   	ret    
801066ef:	90                   	nop

801066f0 <sys_invoked_syscalls>:

int
sys_invoked_syscalls(void)
{
801066f0:	55                   	push   %ebp
801066f1:	89 e5                	mov    %esp,%ebp
801066f3:	83 ec 20             	sub    $0x20,%esp
  int pid, i;

  if(argint(0, &pid) < 0)
801066f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801066f9:	50                   	push   %eax
801066fa:	6a 00                	push   $0x0
801066fc:	e8 bf e9 ff ff       	call   801050c0 <argint>
80106701:	83 c4 10             	add    $0x10,%esp
80106704:	85 c0                	test   %eax,%eax
80106706:	78 28                	js     80106730 <sys_invoked_syscalls+0x40>
    return -1;
  cprintf("num : %d\n", pid);
80106708:	83 ec 08             	sub    $0x8,%esp
8010670b:	ff 75 f4             	pushl  -0xc(%ebp)
8010670e:	68 55 8e 10 80       	push   $0x80108e55
80106713:	e8 d8 9f ff ff       	call   801006f0 <cprintf>
  i = invocation_log(pid);
80106718:	58                   	pop    %eax
80106719:	ff 75 f4             	pushl  -0xc(%ebp)
8010671c:	e8 cf da ff ff       	call   801041f0 <invocation_log>
80106721:	83 c4 10             	add    $0x10,%esp
  if(i >= 0){
80106724:	c1 f8 1f             	sar    $0x1f,%eax
    return 0;
  }
  return -1;
}
80106727:	c9                   	leave  
80106728:	c3                   	ret    
80106729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106730:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106735:	c9                   	leave  
80106736:	c3                   	ret    
80106737:	89 f6                	mov    %esi,%esi
80106739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106740 <sys_sort_syscalls>:
80106740:	55                   	push   %ebp
80106741:	89 e5                	mov    %esp,%ebp
80106743:	5d                   	pop    %ebp
80106744:	eb aa                	jmp    801066f0 <sys_invoked_syscalls>
80106746:	8d 76 00             	lea    0x0(%esi),%esi
80106749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106750 <sys_get_count>:
  return -1;
}

int
sys_get_count(void)
{
80106750:	55                   	push   %ebp
80106751:	89 e5                	mov    %esp,%ebp
80106753:	53                   	push   %ebx
  int pid, sysnum, result;

  if (argint(0, &pid) < 0 || argint(1, &sysnum) < 0)
80106754:	8d 45 f0             	lea    -0x10(%ebp),%eax
{
80106757:	83 ec 1c             	sub    $0x1c,%esp
  if (argint(0, &pid) < 0 || argint(1, &sysnum) < 0)
8010675a:	50                   	push   %eax
8010675b:	6a 00                	push   $0x0
8010675d:	e8 5e e9 ff ff       	call   801050c0 <argint>
80106762:	83 c4 10             	add    $0x10,%esp
80106765:	85 c0                	test   %eax,%eax
80106767:	78 47                	js     801067b0 <sys_get_count+0x60>
80106769:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010676c:	83 ec 08             	sub    $0x8,%esp
8010676f:	50                   	push   %eax
80106770:	6a 01                	push   $0x1
80106772:	e8 49 e9 ff ff       	call   801050c0 <argint>
80106777:	83 c4 10             	add    $0x10,%esp
8010677a:	85 c0                	test   %eax,%eax
8010677c:	78 32                	js     801067b0 <sys_get_count+0x60>
    return -1;
  result = get_syscall_count(pid, sysnum);
8010677e:	83 ec 08             	sub    $0x8,%esp
80106781:	ff 75 f4             	pushl  -0xc(%ebp)
80106784:	ff 75 f0             	pushl  -0x10(%ebp)
80106787:	e8 44 de ff ff       	call   801045d0 <get_syscall_count>
  cprintf("count_syscall: pid: %d sysnum: %d res:%d\n", pid, sysnum, result);
8010678c:	50                   	push   %eax
8010678d:	ff 75 f4             	pushl  -0xc(%ebp)
  result = get_syscall_count(pid, sysnum);
80106790:	89 c3                	mov    %eax,%ebx
  cprintf("count_syscall: pid: %d sysnum: %d res:%d\n", pid, sysnum, result);
80106792:	ff 75 f0             	pushl  -0x10(%ebp)
80106795:	68 74 8e 10 80       	push   $0x80108e74
8010679a:	e8 51 9f ff ff       	call   801006f0 <cprintf>
  return result;
8010679f:	83 c4 20             	add    $0x20,%esp
}
801067a2:	89 d8                	mov    %ebx,%eax
801067a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801067a7:	c9                   	leave  
801067a8:	c3                   	ret    
801067a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801067b0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801067b5:	eb eb                	jmp    801067a2 <sys_get_count+0x52>
801067b7:	89 f6                	mov    %esi,%esi
801067b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801067c0 <sys_log_syscalls>:

void
sys_log_syscalls(void)
{
801067c0:	55                   	push   %ebp
801067c1:	89 e5                	mov    %esp,%ebp
801067c3:	83 ec 14             	sub    $0x14,%esp
  log_syscalls(first_proc);
801067c6:	ff 35 74 e5 12 80    	pushl  0x8012e574
801067cc:	e8 8f de ff ff       	call   80104660 <log_syscalls>
}
801067d1:	83 c4 10             	add    $0x10,%esp
801067d4:	c9                   	leave  
801067d5:	c3                   	ret    
801067d6:	8d 76 00             	lea    0x0(%esi),%esi
801067d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801067e0 <sys_ticketlockinit>:

void
sys_ticketlockinit(void)
{
801067e0:	55                   	push   %ebp
801067e1:	89 e5                	mov    %esp,%ebp
801067e3:	83 ec 10             	sub    $0x10,%esp
  init_ticket_lock(&ticketlock, "ticket_lock");
801067e6:	68 5f 8e 10 80       	push   $0x80108e5f
801067eb:	68 7c e5 12 80       	push   $0x8012e57c
801067f0:	e8 bb e3 ff ff       	call   80104bb0 <init_ticket_lock>
}
801067f5:	83 c4 10             	add    $0x10,%esp
801067f8:	c9                   	leave  
801067f9:	c3                   	ret    
801067fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106800 <sys_ticketlocktest>:

void
sys_ticketlocktest(void)
{
80106800:	55                   	push   %ebp
80106801:	89 e5                	mov    %esp,%ebp
80106803:	83 ec 14             	sub    $0x14,%esp
  ticket_acquire(&ticketlock);
80106806:	68 7c e5 12 80       	push   $0x8012e57c
8010680b:	e8 d0 e3 ff ff       	call   80104be0 <ticket_acquire>
  safe_count++;
  //cprintf("ali: %d\n", safe_count);
  ticket_release(&ticketlock);
80106810:	c7 04 24 7c e5 12 80 	movl   $0x8012e57c,(%esp)
  safe_count++;
80106817:	83 05 bc c5 10 80 01 	addl   $0x1,0x8010c5bc
  ticket_release(&ticketlock);
8010681e:	e8 0d e4 ff ff       	call   80104c30 <ticket_release>
  cprintf("ali: %d\n", safe_count);
80106823:	58                   	pop    %eax
80106824:	5a                   	pop    %edx
80106825:	ff 35 bc c5 10 80    	pushl  0x8010c5bc
8010682b:	68 6b 8e 10 80       	push   $0x80108e6b
80106830:	e8 bb 9e ff ff       	call   801006f0 <cprintf>
}
80106835:	83 c4 10             	add    $0x10,%esp
80106838:	c9                   	leave  
80106839:	c3                   	ret    
8010683a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106840 <sys_getpid>:

int
sys_getpid(void)
{
80106840:	55                   	push   %ebp
80106841:	89 e5                	mov    %esp,%ebp
80106843:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80106846:	e8 75 d1 ff ff       	call   801039c0 <myproc>
8010684b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010684e:	c9                   	leave  
8010684f:	c3                   	ret    

80106850 <sys_sbrk>:

int
sys_sbrk(void)
{
80106850:	55                   	push   %ebp
80106851:	89 e5                	mov    %esp,%ebp
80106853:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106854:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106857:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010685a:	50                   	push   %eax
8010685b:	6a 00                	push   $0x0
8010685d:	e8 5e e8 ff ff       	call   801050c0 <argint>
80106862:	83 c4 10             	add    $0x10,%esp
80106865:	85 c0                	test   %eax,%eax
80106867:	78 27                	js     80106890 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80106869:	e8 52 d1 ff ff       	call   801039c0 <myproc>
  if(growproc(n) < 0)
8010686e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106871:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106873:	ff 75 f4             	pushl  -0xc(%ebp)
80106876:	e8 65 d2 ff ff       	call   80103ae0 <growproc>
8010687b:	83 c4 10             	add    $0x10,%esp
8010687e:	85 c0                	test   %eax,%eax
80106880:	78 0e                	js     80106890 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106882:	89 d8                	mov    %ebx,%eax
80106884:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106887:	c9                   	leave  
80106888:	c3                   	ret    
80106889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106890:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106895:	eb eb                	jmp    80106882 <sys_sbrk+0x32>
80106897:	89 f6                	mov    %esi,%esi
80106899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801068a0 <sys_sleep>:

int
sys_sleep(void)
{
801068a0:	55                   	push   %ebp
801068a1:	89 e5                	mov    %esp,%ebp
801068a3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801068a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801068a7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801068aa:	50                   	push   %eax
801068ab:	6a 00                	push   $0x0
801068ad:	e8 0e e8 ff ff       	call   801050c0 <argint>
801068b2:	83 c4 10             	add    $0x10,%esp
801068b5:	85 c0                	test   %eax,%eax
801068b7:	0f 88 8a 00 00 00    	js     80106947 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801068bd:	83 ec 0c             	sub    $0xc,%esp
801068c0:	68 a0 e5 12 80       	push   $0x8012e5a0
801068c5:	e8 d6 e1 ff ff       	call   80104aa0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801068ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
801068cd:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
801068d0:	8b 1d e0 ed 12 80    	mov    0x8012ede0,%ebx
  while(ticks - ticks0 < n){
801068d6:	85 d2                	test   %edx,%edx
801068d8:	75 27                	jne    80106901 <sys_sleep+0x61>
801068da:	eb 54                	jmp    80106930 <sys_sleep+0x90>
801068dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801068e0:	83 ec 08             	sub    $0x8,%esp
801068e3:	68 a0 e5 12 80       	push   $0x8012e5a0
801068e8:	68 e0 ed 12 80       	push   $0x8012ede0
801068ed:	e8 de d6 ff ff       	call   80103fd0 <sleep>
  while(ticks - ticks0 < n){
801068f2:	a1 e0 ed 12 80       	mov    0x8012ede0,%eax
801068f7:	83 c4 10             	add    $0x10,%esp
801068fa:	29 d8                	sub    %ebx,%eax
801068fc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801068ff:	73 2f                	jae    80106930 <sys_sleep+0x90>
    if(myproc()->killed){
80106901:	e8 ba d0 ff ff       	call   801039c0 <myproc>
80106906:	8b 40 24             	mov    0x24(%eax),%eax
80106909:	85 c0                	test   %eax,%eax
8010690b:	74 d3                	je     801068e0 <sys_sleep+0x40>
      release(&tickslock);
8010690d:	83 ec 0c             	sub    $0xc,%esp
80106910:	68 a0 e5 12 80       	push   $0x8012e5a0
80106915:	e8 46 e2 ff ff       	call   80104b60 <release>
      return -1;
8010691a:	83 c4 10             	add    $0x10,%esp
8010691d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80106922:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106925:	c9                   	leave  
80106926:	c3                   	ret    
80106927:	89 f6                	mov    %esi,%esi
80106929:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80106930:	83 ec 0c             	sub    $0xc,%esp
80106933:	68 a0 e5 12 80       	push   $0x8012e5a0
80106938:	e8 23 e2 ff ff       	call   80104b60 <release>
  return 0;
8010693d:	83 c4 10             	add    $0x10,%esp
80106940:	31 c0                	xor    %eax,%eax
}
80106942:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106945:	c9                   	leave  
80106946:	c3                   	ret    
    return -1;
80106947:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010694c:	eb f4                	jmp    80106942 <sys_sleep+0xa2>
8010694e:	66 90                	xchg   %ax,%ax

80106950 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106950:	55                   	push   %ebp
80106951:	89 e5                	mov    %esp,%ebp
80106953:	53                   	push   %ebx
80106954:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80106957:	68 a0 e5 12 80       	push   $0x8012e5a0
8010695c:	e8 3f e1 ff ff       	call   80104aa0 <acquire>
  xticks = ticks;
80106961:	8b 1d e0 ed 12 80    	mov    0x8012ede0,%ebx
  release(&tickslock);
80106967:	c7 04 24 a0 e5 12 80 	movl   $0x8012e5a0,(%esp)
8010696e:	e8 ed e1 ff ff       	call   80104b60 <release>
  return xticks;
}
80106973:	89 d8                	mov    %ebx,%eax
80106975:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106978:	c9                   	leave  
80106979:	c3                   	ret    
8010697a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106980 <sys_halt>:

int
sys_halt(void)
{
80106980:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106981:	31 c0                	xor    %eax,%eax
80106983:	ba f4 00 00 00       	mov    $0xf4,%edx
80106988:	89 e5                	mov    %esp,%ebp
8010698a:	ee                   	out    %al,(%dx)
  outb(0xf4, 0x00);
  return 0;
}
8010698b:	31 c0                	xor    %eax,%eax
8010698d:	5d                   	pop    %ebp
8010698e:	c3                   	ret    

8010698f <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010698f:	1e                   	push   %ds
  pushl %es
80106990:	06                   	push   %es
  pushl %fs
80106991:	0f a0                	push   %fs
  pushl %gs
80106993:	0f a8                	push   %gs
  pushal
80106995:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106996:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010699a:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010699c:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
8010699e:	54                   	push   %esp
  call trap
8010699f:	e8 cc 00 00 00       	call   80106a70 <trap>
  addl $4, %esp
801069a4:	83 c4 04             	add    $0x4,%esp

801069a7 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801069a7:	61                   	popa   
  popl %gs
801069a8:	0f a9                	pop    %gs
  popl %fs
801069aa:	0f a1                	pop    %fs
  popl %es
801069ac:	07                   	pop    %es
  popl %ds
801069ad:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801069ae:	83 c4 08             	add    $0x8,%esp
  iret
801069b1:	cf                   	iret   
801069b2:	66 90                	xchg   %ax,%ax
801069b4:	66 90                	xchg   %ax,%ax
801069b6:	66 90                	xchg   %ax,%ax
801069b8:	66 90                	xchg   %ax,%ax
801069ba:	66 90                	xchg   %ax,%ax
801069bc:	66 90                	xchg   %ax,%ax
801069be:	66 90                	xchg   %ax,%ax

801069c0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801069c0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
801069c1:	31 c0                	xor    %eax,%eax
{
801069c3:	89 e5                	mov    %esp,%ebp
801069c5:	83 ec 08             	sub    $0x8,%esp
801069c8:	90                   	nop
801069c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801069d0:	8b 14 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%edx
801069d7:	c7 04 c5 e2 e5 12 80 	movl   $0x8e000008,-0x7fed1a1e(,%eax,8)
801069de:	08 00 00 8e 
801069e2:	66 89 14 c5 e0 e5 12 	mov    %dx,-0x7fed1a20(,%eax,8)
801069e9:	80 
801069ea:	c1 ea 10             	shr    $0x10,%edx
801069ed:	66 89 14 c5 e6 e5 12 	mov    %dx,-0x7fed1a1a(,%eax,8)
801069f4:	80 
  for(i = 0; i < 256; i++)
801069f5:	83 c0 01             	add    $0x1,%eax
801069f8:	3d 00 01 00 00       	cmp    $0x100,%eax
801069fd:	75 d1                	jne    801069d0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801069ff:	a1 08 c1 10 80       	mov    0x8010c108,%eax

  initlock(&tickslock, "time");
80106a04:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106a07:	c7 05 e2 e7 12 80 08 	movl   $0xef000008,0x8012e7e2
80106a0e:	00 00 ef 
  initlock(&tickslock, "time");
80106a11:	68 a9 8b 10 80       	push   $0x80108ba9
80106a16:	68 a0 e5 12 80       	push   $0x8012e5a0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106a1b:	66 a3 e0 e7 12 80    	mov    %ax,0x8012e7e0
80106a21:	c1 e8 10             	shr    $0x10,%eax
80106a24:	66 a3 e6 e7 12 80    	mov    %ax,0x8012e7e6
  initlock(&tickslock, "time");
80106a2a:	e8 31 df ff ff       	call   80104960 <initlock>
}
80106a2f:	83 c4 10             	add    $0x10,%esp
80106a32:	c9                   	leave  
80106a33:	c3                   	ret    
80106a34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106a3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106a40 <idtinit>:

void
idtinit(void)
{
80106a40:	55                   	push   %ebp
  pd[0] = size-1;
80106a41:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106a46:	89 e5                	mov    %esp,%ebp
80106a48:	83 ec 10             	sub    $0x10,%esp
80106a4b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106a4f:	b8 e0 e5 12 80       	mov    $0x8012e5e0,%eax
80106a54:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106a58:	c1 e8 10             	shr    $0x10,%eax
80106a5b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106a5f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106a62:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106a65:	c9                   	leave  
80106a66:	c3                   	ret    
80106a67:	89 f6                	mov    %esi,%esi
80106a69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106a70 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106a70:	55                   	push   %ebp
80106a71:	89 e5                	mov    %esp,%ebp
80106a73:	57                   	push   %edi
80106a74:	56                   	push   %esi
80106a75:	53                   	push   %ebx
80106a76:	83 ec 1c             	sub    $0x1c,%esp
80106a79:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
80106a7c:	8b 47 30             	mov    0x30(%edi),%eax
80106a7f:	83 f8 40             	cmp    $0x40,%eax
80106a82:	0f 84 f0 00 00 00    	je     80106b78 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80106a88:	83 e8 20             	sub    $0x20,%eax
80106a8b:	83 f8 1f             	cmp    $0x1f,%eax
80106a8e:	77 10                	ja     80106aa0 <trap+0x30>
80106a90:	ff 24 85 40 8f 10 80 	jmp    *-0x7fef70c0(,%eax,4)
80106a97:	89 f6                	mov    %esi,%esi
80106a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80106aa0:	e8 1b cf ff ff       	call   801039c0 <myproc>
80106aa5:	85 c0                	test   %eax,%eax
80106aa7:	8b 5f 38             	mov    0x38(%edi),%ebx
80106aaa:	0f 84 14 02 00 00    	je     80106cc4 <trap+0x254>
80106ab0:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80106ab4:	0f 84 0a 02 00 00    	je     80106cc4 <trap+0x254>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106aba:	0f 20 d1             	mov    %cr2,%ecx
80106abd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106ac0:	e8 db ce ff ff       	call   801039a0 <cpuid>
80106ac5:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106ac8:	8b 47 34             	mov    0x34(%edi),%eax
80106acb:	8b 77 30             	mov    0x30(%edi),%esi
80106ace:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106ad1:	e8 ea ce ff ff       	call   801039c0 <myproc>
80106ad6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106ad9:	e8 e2 ce ff ff       	call   801039c0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106ade:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106ae1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106ae4:	51                   	push   %ecx
80106ae5:	53                   	push   %ebx
80106ae6:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80106ae7:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106aea:	ff 75 e4             	pushl  -0x1c(%ebp)
80106aed:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80106aee:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106af1:	52                   	push   %edx
80106af2:	ff 70 10             	pushl  0x10(%eax)
80106af5:	68 fc 8e 10 80       	push   $0x80108efc
80106afa:	e8 f1 9b ff ff       	call   801006f0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80106aff:	83 c4 20             	add    $0x20,%esp
80106b02:	e8 b9 ce ff ff       	call   801039c0 <myproc>
80106b07:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106b0e:	e8 ad ce ff ff       	call   801039c0 <myproc>
80106b13:	85 c0                	test   %eax,%eax
80106b15:	74 1d                	je     80106b34 <trap+0xc4>
80106b17:	e8 a4 ce ff ff       	call   801039c0 <myproc>
80106b1c:	8b 50 24             	mov    0x24(%eax),%edx
80106b1f:	85 d2                	test   %edx,%edx
80106b21:	74 11                	je     80106b34 <trap+0xc4>
80106b23:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106b27:	83 e0 03             	and    $0x3,%eax
80106b2a:	66 83 f8 03          	cmp    $0x3,%ax
80106b2e:	0f 84 4c 01 00 00    	je     80106c80 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106b34:	e8 87 ce ff ff       	call   801039c0 <myproc>
80106b39:	85 c0                	test   %eax,%eax
80106b3b:	74 0b                	je     80106b48 <trap+0xd8>
80106b3d:	e8 7e ce ff ff       	call   801039c0 <myproc>
80106b42:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106b46:	74 68                	je     80106bb0 <trap+0x140>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106b48:	e8 73 ce ff ff       	call   801039c0 <myproc>
80106b4d:	85 c0                	test   %eax,%eax
80106b4f:	74 19                	je     80106b6a <trap+0xfa>
80106b51:	e8 6a ce ff ff       	call   801039c0 <myproc>
80106b56:	8b 40 24             	mov    0x24(%eax),%eax
80106b59:	85 c0                	test   %eax,%eax
80106b5b:	74 0d                	je     80106b6a <trap+0xfa>
80106b5d:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106b61:	83 e0 03             	and    $0x3,%eax
80106b64:	66 83 f8 03          	cmp    $0x3,%ax
80106b68:	74 37                	je     80106ba1 <trap+0x131>
    exit();
}
80106b6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b6d:	5b                   	pop    %ebx
80106b6e:	5e                   	pop    %esi
80106b6f:	5f                   	pop    %edi
80106b70:	5d                   	pop    %ebp
80106b71:	c3                   	ret    
80106b72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
80106b78:	e8 43 ce ff ff       	call   801039c0 <myproc>
80106b7d:	8b 58 24             	mov    0x24(%eax),%ebx
80106b80:	85 db                	test   %ebx,%ebx
80106b82:	0f 85 e8 00 00 00    	jne    80106c70 <trap+0x200>
    myproc()->tf = tf;
80106b88:	e8 33 ce ff ff       	call   801039c0 <myproc>
80106b8d:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80106b90:	e8 5b ec ff ff       	call   801057f0 <syscall>
    if(myproc()->killed)
80106b95:	e8 26 ce ff ff       	call   801039c0 <myproc>
80106b9a:	8b 48 24             	mov    0x24(%eax),%ecx
80106b9d:	85 c9                	test   %ecx,%ecx
80106b9f:	74 c9                	je     80106b6a <trap+0xfa>
}
80106ba1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ba4:	5b                   	pop    %ebx
80106ba5:	5e                   	pop    %esi
80106ba6:	5f                   	pop    %edi
80106ba7:	5d                   	pop    %ebp
      exit();
80106ba8:	e9 33 d2 ff ff       	jmp    80103de0 <exit>
80106bad:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80106bb0:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80106bb4:	75 92                	jne    80106b48 <trap+0xd8>
    yield();
80106bb6:	e8 55 d3 ff ff       	call   80103f10 <yield>
80106bbb:	eb 8b                	jmp    80106b48 <trap+0xd8>
80106bbd:	8d 76 00             	lea    0x0(%esi),%esi
    if(cpuid() == 0){
80106bc0:	e8 db cd ff ff       	call   801039a0 <cpuid>
80106bc5:	85 c0                	test   %eax,%eax
80106bc7:	0f 84 c3 00 00 00    	je     80106c90 <trap+0x220>
    lapiceoi();
80106bcd:	e8 3e bd ff ff       	call   80102910 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106bd2:	e8 e9 cd ff ff       	call   801039c0 <myproc>
80106bd7:	85 c0                	test   %eax,%eax
80106bd9:	0f 85 38 ff ff ff    	jne    80106b17 <trap+0xa7>
80106bdf:	e9 50 ff ff ff       	jmp    80106b34 <trap+0xc4>
80106be4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106be8:	e8 e3 bb ff ff       	call   801027d0 <kbdintr>
    lapiceoi();
80106bed:	e8 1e bd ff ff       	call   80102910 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106bf2:	e8 c9 cd ff ff       	call   801039c0 <myproc>
80106bf7:	85 c0                	test   %eax,%eax
80106bf9:	0f 85 18 ff ff ff    	jne    80106b17 <trap+0xa7>
80106bff:	e9 30 ff ff ff       	jmp    80106b34 <trap+0xc4>
80106c04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106c08:	e8 53 02 00 00       	call   80106e60 <uartintr>
    lapiceoi();
80106c0d:	e8 fe bc ff ff       	call   80102910 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106c12:	e8 a9 cd ff ff       	call   801039c0 <myproc>
80106c17:	85 c0                	test   %eax,%eax
80106c19:	0f 85 f8 fe ff ff    	jne    80106b17 <trap+0xa7>
80106c1f:	e9 10 ff ff ff       	jmp    80106b34 <trap+0xc4>
80106c24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106c28:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80106c2c:	8b 77 38             	mov    0x38(%edi),%esi
80106c2f:	e8 6c cd ff ff       	call   801039a0 <cpuid>
80106c34:	56                   	push   %esi
80106c35:	53                   	push   %ebx
80106c36:	50                   	push   %eax
80106c37:	68 a4 8e 10 80       	push   $0x80108ea4
80106c3c:	e8 af 9a ff ff       	call   801006f0 <cprintf>
    lapiceoi();
80106c41:	e8 ca bc ff ff       	call   80102910 <lapiceoi>
    break;
80106c46:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106c49:	e8 72 cd ff ff       	call   801039c0 <myproc>
80106c4e:	85 c0                	test   %eax,%eax
80106c50:	0f 85 c1 fe ff ff    	jne    80106b17 <trap+0xa7>
80106c56:	e9 d9 fe ff ff       	jmp    80106b34 <trap+0xc4>
80106c5b:	90                   	nop
80106c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80106c60:	e8 db b5 ff ff       	call   80102240 <ideintr>
80106c65:	e9 63 ff ff ff       	jmp    80106bcd <trap+0x15d>
80106c6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106c70:	e8 6b d1 ff ff       	call   80103de0 <exit>
80106c75:	e9 0e ff ff ff       	jmp    80106b88 <trap+0x118>
80106c7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80106c80:	e8 5b d1 ff ff       	call   80103de0 <exit>
80106c85:	e9 aa fe ff ff       	jmp    80106b34 <trap+0xc4>
80106c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80106c90:	83 ec 0c             	sub    $0xc,%esp
80106c93:	68 a0 e5 12 80       	push   $0x8012e5a0
80106c98:	e8 03 de ff ff       	call   80104aa0 <acquire>
      wakeup(&ticks);
80106c9d:	c7 04 24 e0 ed 12 80 	movl   $0x8012ede0,(%esp)
      ticks++;
80106ca4:	83 05 e0 ed 12 80 01 	addl   $0x1,0x8012ede0
      wakeup(&ticks);
80106cab:	e8 e0 d4 ff ff       	call   80104190 <wakeup>
      release(&tickslock);
80106cb0:	c7 04 24 a0 e5 12 80 	movl   $0x8012e5a0,(%esp)
80106cb7:	e8 a4 de ff ff       	call   80104b60 <release>
80106cbc:	83 c4 10             	add    $0x10,%esp
80106cbf:	e9 09 ff ff ff       	jmp    80106bcd <trap+0x15d>
80106cc4:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106cc7:	e8 d4 cc ff ff       	call   801039a0 <cpuid>
80106ccc:	83 ec 0c             	sub    $0xc,%esp
80106ccf:	56                   	push   %esi
80106cd0:	53                   	push   %ebx
80106cd1:	50                   	push   %eax
80106cd2:	ff 77 30             	pushl  0x30(%edi)
80106cd5:	68 c8 8e 10 80       	push   $0x80108ec8
80106cda:	e8 11 9a ff ff       	call   801006f0 <cprintf>
      panic("trap");
80106cdf:	83 c4 14             	add    $0x14,%esp
80106ce2:	68 9e 8e 10 80       	push   $0x80108e9e
80106ce7:	e8 a4 96 ff ff       	call   80100390 <panic>
80106cec:	66 90                	xchg   %ax,%ax
80106cee:	66 90                	xchg   %ax,%ax

80106cf0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106cf0:	a1 c0 c5 10 80       	mov    0x8010c5c0,%eax
{
80106cf5:	55                   	push   %ebp
80106cf6:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106cf8:	85 c0                	test   %eax,%eax
80106cfa:	74 1c                	je     80106d18 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106cfc:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106d01:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106d02:	a8 01                	test   $0x1,%al
80106d04:	74 12                	je     80106d18 <uartgetc+0x28>
80106d06:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106d0b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106d0c:	0f b6 c0             	movzbl %al,%eax
}
80106d0f:	5d                   	pop    %ebp
80106d10:	c3                   	ret    
80106d11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106d18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106d1d:	5d                   	pop    %ebp
80106d1e:	c3                   	ret    
80106d1f:	90                   	nop

80106d20 <uartputc.part.0>:
uartputc(int c)
80106d20:	55                   	push   %ebp
80106d21:	89 e5                	mov    %esp,%ebp
80106d23:	57                   	push   %edi
80106d24:	56                   	push   %esi
80106d25:	53                   	push   %ebx
80106d26:	89 c7                	mov    %eax,%edi
80106d28:	bb 80 00 00 00       	mov    $0x80,%ebx
80106d2d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106d32:	83 ec 0c             	sub    $0xc,%esp
80106d35:	eb 1b                	jmp    80106d52 <uartputc.part.0+0x32>
80106d37:	89 f6                	mov    %esi,%esi
80106d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80106d40:	83 ec 0c             	sub    $0xc,%esp
80106d43:	6a 0a                	push   $0xa
80106d45:	e8 e6 bb ff ff       	call   80102930 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106d4a:	83 c4 10             	add    $0x10,%esp
80106d4d:	83 eb 01             	sub    $0x1,%ebx
80106d50:	74 07                	je     80106d59 <uartputc.part.0+0x39>
80106d52:	89 f2                	mov    %esi,%edx
80106d54:	ec                   	in     (%dx),%al
80106d55:	a8 20                	test   $0x20,%al
80106d57:	74 e7                	je     80106d40 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106d59:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106d5e:	89 f8                	mov    %edi,%eax
80106d60:	ee                   	out    %al,(%dx)
}
80106d61:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d64:	5b                   	pop    %ebx
80106d65:	5e                   	pop    %esi
80106d66:	5f                   	pop    %edi
80106d67:	5d                   	pop    %ebp
80106d68:	c3                   	ret    
80106d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106d70 <uartinit>:
{
80106d70:	55                   	push   %ebp
80106d71:	31 c9                	xor    %ecx,%ecx
80106d73:	89 c8                	mov    %ecx,%eax
80106d75:	89 e5                	mov    %esp,%ebp
80106d77:	57                   	push   %edi
80106d78:	56                   	push   %esi
80106d79:	53                   	push   %ebx
80106d7a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80106d7f:	89 da                	mov    %ebx,%edx
80106d81:	83 ec 0c             	sub    $0xc,%esp
80106d84:	ee                   	out    %al,(%dx)
80106d85:	bf fb 03 00 00       	mov    $0x3fb,%edi
80106d8a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106d8f:	89 fa                	mov    %edi,%edx
80106d91:	ee                   	out    %al,(%dx)
80106d92:	b8 0c 00 00 00       	mov    $0xc,%eax
80106d97:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106d9c:	ee                   	out    %al,(%dx)
80106d9d:	be f9 03 00 00       	mov    $0x3f9,%esi
80106da2:	89 c8                	mov    %ecx,%eax
80106da4:	89 f2                	mov    %esi,%edx
80106da6:	ee                   	out    %al,(%dx)
80106da7:	b8 03 00 00 00       	mov    $0x3,%eax
80106dac:	89 fa                	mov    %edi,%edx
80106dae:	ee                   	out    %al,(%dx)
80106daf:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106db4:	89 c8                	mov    %ecx,%eax
80106db6:	ee                   	out    %al,(%dx)
80106db7:	b8 01 00 00 00       	mov    $0x1,%eax
80106dbc:	89 f2                	mov    %esi,%edx
80106dbe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106dbf:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106dc4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106dc5:	3c ff                	cmp    $0xff,%al
80106dc7:	74 5a                	je     80106e23 <uartinit+0xb3>
  uart = 1;
80106dc9:	c7 05 c0 c5 10 80 01 	movl   $0x1,0x8010c5c0
80106dd0:	00 00 00 
80106dd3:	89 da                	mov    %ebx,%edx
80106dd5:	ec                   	in     (%dx),%al
80106dd6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106ddb:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106ddc:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80106ddf:	bb c0 8f 10 80       	mov    $0x80108fc0,%ebx
  ioapicenable(IRQ_COM1, 0);
80106de4:	6a 00                	push   $0x0
80106de6:	6a 04                	push   $0x4
80106de8:	e8 a3 b6 ff ff       	call   80102490 <ioapicenable>
80106ded:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106df0:	b8 78 00 00 00       	mov    $0x78,%eax
80106df5:	eb 13                	jmp    80106e0a <uartinit+0x9a>
80106df7:	89 f6                	mov    %esi,%esi
80106df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106e00:	83 c3 01             	add    $0x1,%ebx
80106e03:	0f be 03             	movsbl (%ebx),%eax
80106e06:	84 c0                	test   %al,%al
80106e08:	74 19                	je     80106e23 <uartinit+0xb3>
  if(!uart)
80106e0a:	8b 15 c0 c5 10 80    	mov    0x8010c5c0,%edx
80106e10:	85 d2                	test   %edx,%edx
80106e12:	74 ec                	je     80106e00 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80106e14:	83 c3 01             	add    $0x1,%ebx
80106e17:	e8 04 ff ff ff       	call   80106d20 <uartputc.part.0>
80106e1c:	0f be 03             	movsbl (%ebx),%eax
80106e1f:	84 c0                	test   %al,%al
80106e21:	75 e7                	jne    80106e0a <uartinit+0x9a>
}
80106e23:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e26:	5b                   	pop    %ebx
80106e27:	5e                   	pop    %esi
80106e28:	5f                   	pop    %edi
80106e29:	5d                   	pop    %ebp
80106e2a:	c3                   	ret    
80106e2b:	90                   	nop
80106e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106e30 <uartputc>:
  if(!uart)
80106e30:	8b 15 c0 c5 10 80    	mov    0x8010c5c0,%edx
{
80106e36:	55                   	push   %ebp
80106e37:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106e39:	85 d2                	test   %edx,%edx
{
80106e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80106e3e:	74 10                	je     80106e50 <uartputc+0x20>
}
80106e40:	5d                   	pop    %ebp
80106e41:	e9 da fe ff ff       	jmp    80106d20 <uartputc.part.0>
80106e46:	8d 76 00             	lea    0x0(%esi),%esi
80106e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106e50:	5d                   	pop    %ebp
80106e51:	c3                   	ret    
80106e52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106e60 <uartintr>:

void
uartintr(void)
{
80106e60:	55                   	push   %ebp
80106e61:	89 e5                	mov    %esp,%ebp
80106e63:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106e66:	68 f0 6c 10 80       	push   $0x80106cf0
80106e6b:	e8 30 9a ff ff       	call   801008a0 <consoleintr>
}
80106e70:	83 c4 10             	add    $0x10,%esp
80106e73:	c9                   	leave  
80106e74:	c3                   	ret    

80106e75 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106e75:	6a 00                	push   $0x0
  pushl $0
80106e77:	6a 00                	push   $0x0
  jmp alltraps
80106e79:	e9 11 fb ff ff       	jmp    8010698f <alltraps>

80106e7e <vector1>:
.globl vector1
vector1:
  pushl $0
80106e7e:	6a 00                	push   $0x0
  pushl $1
80106e80:	6a 01                	push   $0x1
  jmp alltraps
80106e82:	e9 08 fb ff ff       	jmp    8010698f <alltraps>

80106e87 <vector2>:
.globl vector2
vector2:
  pushl $0
80106e87:	6a 00                	push   $0x0
  pushl $2
80106e89:	6a 02                	push   $0x2
  jmp alltraps
80106e8b:	e9 ff fa ff ff       	jmp    8010698f <alltraps>

80106e90 <vector3>:
.globl vector3
vector3:
  pushl $0
80106e90:	6a 00                	push   $0x0
  pushl $3
80106e92:	6a 03                	push   $0x3
  jmp alltraps
80106e94:	e9 f6 fa ff ff       	jmp    8010698f <alltraps>

80106e99 <vector4>:
.globl vector4
vector4:
  pushl $0
80106e99:	6a 00                	push   $0x0
  pushl $4
80106e9b:	6a 04                	push   $0x4
  jmp alltraps
80106e9d:	e9 ed fa ff ff       	jmp    8010698f <alltraps>

80106ea2 <vector5>:
.globl vector5
vector5:
  pushl $0
80106ea2:	6a 00                	push   $0x0
  pushl $5
80106ea4:	6a 05                	push   $0x5
  jmp alltraps
80106ea6:	e9 e4 fa ff ff       	jmp    8010698f <alltraps>

80106eab <vector6>:
.globl vector6
vector6:
  pushl $0
80106eab:	6a 00                	push   $0x0
  pushl $6
80106ead:	6a 06                	push   $0x6
  jmp alltraps
80106eaf:	e9 db fa ff ff       	jmp    8010698f <alltraps>

80106eb4 <vector7>:
.globl vector7
vector7:
  pushl $0
80106eb4:	6a 00                	push   $0x0
  pushl $7
80106eb6:	6a 07                	push   $0x7
  jmp alltraps
80106eb8:	e9 d2 fa ff ff       	jmp    8010698f <alltraps>

80106ebd <vector8>:
.globl vector8
vector8:
  pushl $8
80106ebd:	6a 08                	push   $0x8
  jmp alltraps
80106ebf:	e9 cb fa ff ff       	jmp    8010698f <alltraps>

80106ec4 <vector9>:
.globl vector9
vector9:
  pushl $0
80106ec4:	6a 00                	push   $0x0
  pushl $9
80106ec6:	6a 09                	push   $0x9
  jmp alltraps
80106ec8:	e9 c2 fa ff ff       	jmp    8010698f <alltraps>

80106ecd <vector10>:
.globl vector10
vector10:
  pushl $10
80106ecd:	6a 0a                	push   $0xa
  jmp alltraps
80106ecf:	e9 bb fa ff ff       	jmp    8010698f <alltraps>

80106ed4 <vector11>:
.globl vector11
vector11:
  pushl $11
80106ed4:	6a 0b                	push   $0xb
  jmp alltraps
80106ed6:	e9 b4 fa ff ff       	jmp    8010698f <alltraps>

80106edb <vector12>:
.globl vector12
vector12:
  pushl $12
80106edb:	6a 0c                	push   $0xc
  jmp alltraps
80106edd:	e9 ad fa ff ff       	jmp    8010698f <alltraps>

80106ee2 <vector13>:
.globl vector13
vector13:
  pushl $13
80106ee2:	6a 0d                	push   $0xd
  jmp alltraps
80106ee4:	e9 a6 fa ff ff       	jmp    8010698f <alltraps>

80106ee9 <vector14>:
.globl vector14
vector14:
  pushl $14
80106ee9:	6a 0e                	push   $0xe
  jmp alltraps
80106eeb:	e9 9f fa ff ff       	jmp    8010698f <alltraps>

80106ef0 <vector15>:
.globl vector15
vector15:
  pushl $0
80106ef0:	6a 00                	push   $0x0
  pushl $15
80106ef2:	6a 0f                	push   $0xf
  jmp alltraps
80106ef4:	e9 96 fa ff ff       	jmp    8010698f <alltraps>

80106ef9 <vector16>:
.globl vector16
vector16:
  pushl $0
80106ef9:	6a 00                	push   $0x0
  pushl $16
80106efb:	6a 10                	push   $0x10
  jmp alltraps
80106efd:	e9 8d fa ff ff       	jmp    8010698f <alltraps>

80106f02 <vector17>:
.globl vector17
vector17:
  pushl $17
80106f02:	6a 11                	push   $0x11
  jmp alltraps
80106f04:	e9 86 fa ff ff       	jmp    8010698f <alltraps>

80106f09 <vector18>:
.globl vector18
vector18:
  pushl $0
80106f09:	6a 00                	push   $0x0
  pushl $18
80106f0b:	6a 12                	push   $0x12
  jmp alltraps
80106f0d:	e9 7d fa ff ff       	jmp    8010698f <alltraps>

80106f12 <vector19>:
.globl vector19
vector19:
  pushl $0
80106f12:	6a 00                	push   $0x0
  pushl $19
80106f14:	6a 13                	push   $0x13
  jmp alltraps
80106f16:	e9 74 fa ff ff       	jmp    8010698f <alltraps>

80106f1b <vector20>:
.globl vector20
vector20:
  pushl $0
80106f1b:	6a 00                	push   $0x0
  pushl $20
80106f1d:	6a 14                	push   $0x14
  jmp alltraps
80106f1f:	e9 6b fa ff ff       	jmp    8010698f <alltraps>

80106f24 <vector21>:
.globl vector21
vector21:
  pushl $0
80106f24:	6a 00                	push   $0x0
  pushl $21
80106f26:	6a 15                	push   $0x15
  jmp alltraps
80106f28:	e9 62 fa ff ff       	jmp    8010698f <alltraps>

80106f2d <vector22>:
.globl vector22
vector22:
  pushl $0
80106f2d:	6a 00                	push   $0x0
  pushl $22
80106f2f:	6a 16                	push   $0x16
  jmp alltraps
80106f31:	e9 59 fa ff ff       	jmp    8010698f <alltraps>

80106f36 <vector23>:
.globl vector23
vector23:
  pushl $0
80106f36:	6a 00                	push   $0x0
  pushl $23
80106f38:	6a 17                	push   $0x17
  jmp alltraps
80106f3a:	e9 50 fa ff ff       	jmp    8010698f <alltraps>

80106f3f <vector24>:
.globl vector24
vector24:
  pushl $0
80106f3f:	6a 00                	push   $0x0
  pushl $24
80106f41:	6a 18                	push   $0x18
  jmp alltraps
80106f43:	e9 47 fa ff ff       	jmp    8010698f <alltraps>

80106f48 <vector25>:
.globl vector25
vector25:
  pushl $0
80106f48:	6a 00                	push   $0x0
  pushl $25
80106f4a:	6a 19                	push   $0x19
  jmp alltraps
80106f4c:	e9 3e fa ff ff       	jmp    8010698f <alltraps>

80106f51 <vector26>:
.globl vector26
vector26:
  pushl $0
80106f51:	6a 00                	push   $0x0
  pushl $26
80106f53:	6a 1a                	push   $0x1a
  jmp alltraps
80106f55:	e9 35 fa ff ff       	jmp    8010698f <alltraps>

80106f5a <vector27>:
.globl vector27
vector27:
  pushl $0
80106f5a:	6a 00                	push   $0x0
  pushl $27
80106f5c:	6a 1b                	push   $0x1b
  jmp alltraps
80106f5e:	e9 2c fa ff ff       	jmp    8010698f <alltraps>

80106f63 <vector28>:
.globl vector28
vector28:
  pushl $0
80106f63:	6a 00                	push   $0x0
  pushl $28
80106f65:	6a 1c                	push   $0x1c
  jmp alltraps
80106f67:	e9 23 fa ff ff       	jmp    8010698f <alltraps>

80106f6c <vector29>:
.globl vector29
vector29:
  pushl $0
80106f6c:	6a 00                	push   $0x0
  pushl $29
80106f6e:	6a 1d                	push   $0x1d
  jmp alltraps
80106f70:	e9 1a fa ff ff       	jmp    8010698f <alltraps>

80106f75 <vector30>:
.globl vector30
vector30:
  pushl $0
80106f75:	6a 00                	push   $0x0
  pushl $30
80106f77:	6a 1e                	push   $0x1e
  jmp alltraps
80106f79:	e9 11 fa ff ff       	jmp    8010698f <alltraps>

80106f7e <vector31>:
.globl vector31
vector31:
  pushl $0
80106f7e:	6a 00                	push   $0x0
  pushl $31
80106f80:	6a 1f                	push   $0x1f
  jmp alltraps
80106f82:	e9 08 fa ff ff       	jmp    8010698f <alltraps>

80106f87 <vector32>:
.globl vector32
vector32:
  pushl $0
80106f87:	6a 00                	push   $0x0
  pushl $32
80106f89:	6a 20                	push   $0x20
  jmp alltraps
80106f8b:	e9 ff f9 ff ff       	jmp    8010698f <alltraps>

80106f90 <vector33>:
.globl vector33
vector33:
  pushl $0
80106f90:	6a 00                	push   $0x0
  pushl $33
80106f92:	6a 21                	push   $0x21
  jmp alltraps
80106f94:	e9 f6 f9 ff ff       	jmp    8010698f <alltraps>

80106f99 <vector34>:
.globl vector34
vector34:
  pushl $0
80106f99:	6a 00                	push   $0x0
  pushl $34
80106f9b:	6a 22                	push   $0x22
  jmp alltraps
80106f9d:	e9 ed f9 ff ff       	jmp    8010698f <alltraps>

80106fa2 <vector35>:
.globl vector35
vector35:
  pushl $0
80106fa2:	6a 00                	push   $0x0
  pushl $35
80106fa4:	6a 23                	push   $0x23
  jmp alltraps
80106fa6:	e9 e4 f9 ff ff       	jmp    8010698f <alltraps>

80106fab <vector36>:
.globl vector36
vector36:
  pushl $0
80106fab:	6a 00                	push   $0x0
  pushl $36
80106fad:	6a 24                	push   $0x24
  jmp alltraps
80106faf:	e9 db f9 ff ff       	jmp    8010698f <alltraps>

80106fb4 <vector37>:
.globl vector37
vector37:
  pushl $0
80106fb4:	6a 00                	push   $0x0
  pushl $37
80106fb6:	6a 25                	push   $0x25
  jmp alltraps
80106fb8:	e9 d2 f9 ff ff       	jmp    8010698f <alltraps>

80106fbd <vector38>:
.globl vector38
vector38:
  pushl $0
80106fbd:	6a 00                	push   $0x0
  pushl $38
80106fbf:	6a 26                	push   $0x26
  jmp alltraps
80106fc1:	e9 c9 f9 ff ff       	jmp    8010698f <alltraps>

80106fc6 <vector39>:
.globl vector39
vector39:
  pushl $0
80106fc6:	6a 00                	push   $0x0
  pushl $39
80106fc8:	6a 27                	push   $0x27
  jmp alltraps
80106fca:	e9 c0 f9 ff ff       	jmp    8010698f <alltraps>

80106fcf <vector40>:
.globl vector40
vector40:
  pushl $0
80106fcf:	6a 00                	push   $0x0
  pushl $40
80106fd1:	6a 28                	push   $0x28
  jmp alltraps
80106fd3:	e9 b7 f9 ff ff       	jmp    8010698f <alltraps>

80106fd8 <vector41>:
.globl vector41
vector41:
  pushl $0
80106fd8:	6a 00                	push   $0x0
  pushl $41
80106fda:	6a 29                	push   $0x29
  jmp alltraps
80106fdc:	e9 ae f9 ff ff       	jmp    8010698f <alltraps>

80106fe1 <vector42>:
.globl vector42
vector42:
  pushl $0
80106fe1:	6a 00                	push   $0x0
  pushl $42
80106fe3:	6a 2a                	push   $0x2a
  jmp alltraps
80106fe5:	e9 a5 f9 ff ff       	jmp    8010698f <alltraps>

80106fea <vector43>:
.globl vector43
vector43:
  pushl $0
80106fea:	6a 00                	push   $0x0
  pushl $43
80106fec:	6a 2b                	push   $0x2b
  jmp alltraps
80106fee:	e9 9c f9 ff ff       	jmp    8010698f <alltraps>

80106ff3 <vector44>:
.globl vector44
vector44:
  pushl $0
80106ff3:	6a 00                	push   $0x0
  pushl $44
80106ff5:	6a 2c                	push   $0x2c
  jmp alltraps
80106ff7:	e9 93 f9 ff ff       	jmp    8010698f <alltraps>

80106ffc <vector45>:
.globl vector45
vector45:
  pushl $0
80106ffc:	6a 00                	push   $0x0
  pushl $45
80106ffe:	6a 2d                	push   $0x2d
  jmp alltraps
80107000:	e9 8a f9 ff ff       	jmp    8010698f <alltraps>

80107005 <vector46>:
.globl vector46
vector46:
  pushl $0
80107005:	6a 00                	push   $0x0
  pushl $46
80107007:	6a 2e                	push   $0x2e
  jmp alltraps
80107009:	e9 81 f9 ff ff       	jmp    8010698f <alltraps>

8010700e <vector47>:
.globl vector47
vector47:
  pushl $0
8010700e:	6a 00                	push   $0x0
  pushl $47
80107010:	6a 2f                	push   $0x2f
  jmp alltraps
80107012:	e9 78 f9 ff ff       	jmp    8010698f <alltraps>

80107017 <vector48>:
.globl vector48
vector48:
  pushl $0
80107017:	6a 00                	push   $0x0
  pushl $48
80107019:	6a 30                	push   $0x30
  jmp alltraps
8010701b:	e9 6f f9 ff ff       	jmp    8010698f <alltraps>

80107020 <vector49>:
.globl vector49
vector49:
  pushl $0
80107020:	6a 00                	push   $0x0
  pushl $49
80107022:	6a 31                	push   $0x31
  jmp alltraps
80107024:	e9 66 f9 ff ff       	jmp    8010698f <alltraps>

80107029 <vector50>:
.globl vector50
vector50:
  pushl $0
80107029:	6a 00                	push   $0x0
  pushl $50
8010702b:	6a 32                	push   $0x32
  jmp alltraps
8010702d:	e9 5d f9 ff ff       	jmp    8010698f <alltraps>

80107032 <vector51>:
.globl vector51
vector51:
  pushl $0
80107032:	6a 00                	push   $0x0
  pushl $51
80107034:	6a 33                	push   $0x33
  jmp alltraps
80107036:	e9 54 f9 ff ff       	jmp    8010698f <alltraps>

8010703b <vector52>:
.globl vector52
vector52:
  pushl $0
8010703b:	6a 00                	push   $0x0
  pushl $52
8010703d:	6a 34                	push   $0x34
  jmp alltraps
8010703f:	e9 4b f9 ff ff       	jmp    8010698f <alltraps>

80107044 <vector53>:
.globl vector53
vector53:
  pushl $0
80107044:	6a 00                	push   $0x0
  pushl $53
80107046:	6a 35                	push   $0x35
  jmp alltraps
80107048:	e9 42 f9 ff ff       	jmp    8010698f <alltraps>

8010704d <vector54>:
.globl vector54
vector54:
  pushl $0
8010704d:	6a 00                	push   $0x0
  pushl $54
8010704f:	6a 36                	push   $0x36
  jmp alltraps
80107051:	e9 39 f9 ff ff       	jmp    8010698f <alltraps>

80107056 <vector55>:
.globl vector55
vector55:
  pushl $0
80107056:	6a 00                	push   $0x0
  pushl $55
80107058:	6a 37                	push   $0x37
  jmp alltraps
8010705a:	e9 30 f9 ff ff       	jmp    8010698f <alltraps>

8010705f <vector56>:
.globl vector56
vector56:
  pushl $0
8010705f:	6a 00                	push   $0x0
  pushl $56
80107061:	6a 38                	push   $0x38
  jmp alltraps
80107063:	e9 27 f9 ff ff       	jmp    8010698f <alltraps>

80107068 <vector57>:
.globl vector57
vector57:
  pushl $0
80107068:	6a 00                	push   $0x0
  pushl $57
8010706a:	6a 39                	push   $0x39
  jmp alltraps
8010706c:	e9 1e f9 ff ff       	jmp    8010698f <alltraps>

80107071 <vector58>:
.globl vector58
vector58:
  pushl $0
80107071:	6a 00                	push   $0x0
  pushl $58
80107073:	6a 3a                	push   $0x3a
  jmp alltraps
80107075:	e9 15 f9 ff ff       	jmp    8010698f <alltraps>

8010707a <vector59>:
.globl vector59
vector59:
  pushl $0
8010707a:	6a 00                	push   $0x0
  pushl $59
8010707c:	6a 3b                	push   $0x3b
  jmp alltraps
8010707e:	e9 0c f9 ff ff       	jmp    8010698f <alltraps>

80107083 <vector60>:
.globl vector60
vector60:
  pushl $0
80107083:	6a 00                	push   $0x0
  pushl $60
80107085:	6a 3c                	push   $0x3c
  jmp alltraps
80107087:	e9 03 f9 ff ff       	jmp    8010698f <alltraps>

8010708c <vector61>:
.globl vector61
vector61:
  pushl $0
8010708c:	6a 00                	push   $0x0
  pushl $61
8010708e:	6a 3d                	push   $0x3d
  jmp alltraps
80107090:	e9 fa f8 ff ff       	jmp    8010698f <alltraps>

80107095 <vector62>:
.globl vector62
vector62:
  pushl $0
80107095:	6a 00                	push   $0x0
  pushl $62
80107097:	6a 3e                	push   $0x3e
  jmp alltraps
80107099:	e9 f1 f8 ff ff       	jmp    8010698f <alltraps>

8010709e <vector63>:
.globl vector63
vector63:
  pushl $0
8010709e:	6a 00                	push   $0x0
  pushl $63
801070a0:	6a 3f                	push   $0x3f
  jmp alltraps
801070a2:	e9 e8 f8 ff ff       	jmp    8010698f <alltraps>

801070a7 <vector64>:
.globl vector64
vector64:
  pushl $0
801070a7:	6a 00                	push   $0x0
  pushl $64
801070a9:	6a 40                	push   $0x40
  jmp alltraps
801070ab:	e9 df f8 ff ff       	jmp    8010698f <alltraps>

801070b0 <vector65>:
.globl vector65
vector65:
  pushl $0
801070b0:	6a 00                	push   $0x0
  pushl $65
801070b2:	6a 41                	push   $0x41
  jmp alltraps
801070b4:	e9 d6 f8 ff ff       	jmp    8010698f <alltraps>

801070b9 <vector66>:
.globl vector66
vector66:
  pushl $0
801070b9:	6a 00                	push   $0x0
  pushl $66
801070bb:	6a 42                	push   $0x42
  jmp alltraps
801070bd:	e9 cd f8 ff ff       	jmp    8010698f <alltraps>

801070c2 <vector67>:
.globl vector67
vector67:
  pushl $0
801070c2:	6a 00                	push   $0x0
  pushl $67
801070c4:	6a 43                	push   $0x43
  jmp alltraps
801070c6:	e9 c4 f8 ff ff       	jmp    8010698f <alltraps>

801070cb <vector68>:
.globl vector68
vector68:
  pushl $0
801070cb:	6a 00                	push   $0x0
  pushl $68
801070cd:	6a 44                	push   $0x44
  jmp alltraps
801070cf:	e9 bb f8 ff ff       	jmp    8010698f <alltraps>

801070d4 <vector69>:
.globl vector69
vector69:
  pushl $0
801070d4:	6a 00                	push   $0x0
  pushl $69
801070d6:	6a 45                	push   $0x45
  jmp alltraps
801070d8:	e9 b2 f8 ff ff       	jmp    8010698f <alltraps>

801070dd <vector70>:
.globl vector70
vector70:
  pushl $0
801070dd:	6a 00                	push   $0x0
  pushl $70
801070df:	6a 46                	push   $0x46
  jmp alltraps
801070e1:	e9 a9 f8 ff ff       	jmp    8010698f <alltraps>

801070e6 <vector71>:
.globl vector71
vector71:
  pushl $0
801070e6:	6a 00                	push   $0x0
  pushl $71
801070e8:	6a 47                	push   $0x47
  jmp alltraps
801070ea:	e9 a0 f8 ff ff       	jmp    8010698f <alltraps>

801070ef <vector72>:
.globl vector72
vector72:
  pushl $0
801070ef:	6a 00                	push   $0x0
  pushl $72
801070f1:	6a 48                	push   $0x48
  jmp alltraps
801070f3:	e9 97 f8 ff ff       	jmp    8010698f <alltraps>

801070f8 <vector73>:
.globl vector73
vector73:
  pushl $0
801070f8:	6a 00                	push   $0x0
  pushl $73
801070fa:	6a 49                	push   $0x49
  jmp alltraps
801070fc:	e9 8e f8 ff ff       	jmp    8010698f <alltraps>

80107101 <vector74>:
.globl vector74
vector74:
  pushl $0
80107101:	6a 00                	push   $0x0
  pushl $74
80107103:	6a 4a                	push   $0x4a
  jmp alltraps
80107105:	e9 85 f8 ff ff       	jmp    8010698f <alltraps>

8010710a <vector75>:
.globl vector75
vector75:
  pushl $0
8010710a:	6a 00                	push   $0x0
  pushl $75
8010710c:	6a 4b                	push   $0x4b
  jmp alltraps
8010710e:	e9 7c f8 ff ff       	jmp    8010698f <alltraps>

80107113 <vector76>:
.globl vector76
vector76:
  pushl $0
80107113:	6a 00                	push   $0x0
  pushl $76
80107115:	6a 4c                	push   $0x4c
  jmp alltraps
80107117:	e9 73 f8 ff ff       	jmp    8010698f <alltraps>

8010711c <vector77>:
.globl vector77
vector77:
  pushl $0
8010711c:	6a 00                	push   $0x0
  pushl $77
8010711e:	6a 4d                	push   $0x4d
  jmp alltraps
80107120:	e9 6a f8 ff ff       	jmp    8010698f <alltraps>

80107125 <vector78>:
.globl vector78
vector78:
  pushl $0
80107125:	6a 00                	push   $0x0
  pushl $78
80107127:	6a 4e                	push   $0x4e
  jmp alltraps
80107129:	e9 61 f8 ff ff       	jmp    8010698f <alltraps>

8010712e <vector79>:
.globl vector79
vector79:
  pushl $0
8010712e:	6a 00                	push   $0x0
  pushl $79
80107130:	6a 4f                	push   $0x4f
  jmp alltraps
80107132:	e9 58 f8 ff ff       	jmp    8010698f <alltraps>

80107137 <vector80>:
.globl vector80
vector80:
  pushl $0
80107137:	6a 00                	push   $0x0
  pushl $80
80107139:	6a 50                	push   $0x50
  jmp alltraps
8010713b:	e9 4f f8 ff ff       	jmp    8010698f <alltraps>

80107140 <vector81>:
.globl vector81
vector81:
  pushl $0
80107140:	6a 00                	push   $0x0
  pushl $81
80107142:	6a 51                	push   $0x51
  jmp alltraps
80107144:	e9 46 f8 ff ff       	jmp    8010698f <alltraps>

80107149 <vector82>:
.globl vector82
vector82:
  pushl $0
80107149:	6a 00                	push   $0x0
  pushl $82
8010714b:	6a 52                	push   $0x52
  jmp alltraps
8010714d:	e9 3d f8 ff ff       	jmp    8010698f <alltraps>

80107152 <vector83>:
.globl vector83
vector83:
  pushl $0
80107152:	6a 00                	push   $0x0
  pushl $83
80107154:	6a 53                	push   $0x53
  jmp alltraps
80107156:	e9 34 f8 ff ff       	jmp    8010698f <alltraps>

8010715b <vector84>:
.globl vector84
vector84:
  pushl $0
8010715b:	6a 00                	push   $0x0
  pushl $84
8010715d:	6a 54                	push   $0x54
  jmp alltraps
8010715f:	e9 2b f8 ff ff       	jmp    8010698f <alltraps>

80107164 <vector85>:
.globl vector85
vector85:
  pushl $0
80107164:	6a 00                	push   $0x0
  pushl $85
80107166:	6a 55                	push   $0x55
  jmp alltraps
80107168:	e9 22 f8 ff ff       	jmp    8010698f <alltraps>

8010716d <vector86>:
.globl vector86
vector86:
  pushl $0
8010716d:	6a 00                	push   $0x0
  pushl $86
8010716f:	6a 56                	push   $0x56
  jmp alltraps
80107171:	e9 19 f8 ff ff       	jmp    8010698f <alltraps>

80107176 <vector87>:
.globl vector87
vector87:
  pushl $0
80107176:	6a 00                	push   $0x0
  pushl $87
80107178:	6a 57                	push   $0x57
  jmp alltraps
8010717a:	e9 10 f8 ff ff       	jmp    8010698f <alltraps>

8010717f <vector88>:
.globl vector88
vector88:
  pushl $0
8010717f:	6a 00                	push   $0x0
  pushl $88
80107181:	6a 58                	push   $0x58
  jmp alltraps
80107183:	e9 07 f8 ff ff       	jmp    8010698f <alltraps>

80107188 <vector89>:
.globl vector89
vector89:
  pushl $0
80107188:	6a 00                	push   $0x0
  pushl $89
8010718a:	6a 59                	push   $0x59
  jmp alltraps
8010718c:	e9 fe f7 ff ff       	jmp    8010698f <alltraps>

80107191 <vector90>:
.globl vector90
vector90:
  pushl $0
80107191:	6a 00                	push   $0x0
  pushl $90
80107193:	6a 5a                	push   $0x5a
  jmp alltraps
80107195:	e9 f5 f7 ff ff       	jmp    8010698f <alltraps>

8010719a <vector91>:
.globl vector91
vector91:
  pushl $0
8010719a:	6a 00                	push   $0x0
  pushl $91
8010719c:	6a 5b                	push   $0x5b
  jmp alltraps
8010719e:	e9 ec f7 ff ff       	jmp    8010698f <alltraps>

801071a3 <vector92>:
.globl vector92
vector92:
  pushl $0
801071a3:	6a 00                	push   $0x0
  pushl $92
801071a5:	6a 5c                	push   $0x5c
  jmp alltraps
801071a7:	e9 e3 f7 ff ff       	jmp    8010698f <alltraps>

801071ac <vector93>:
.globl vector93
vector93:
  pushl $0
801071ac:	6a 00                	push   $0x0
  pushl $93
801071ae:	6a 5d                	push   $0x5d
  jmp alltraps
801071b0:	e9 da f7 ff ff       	jmp    8010698f <alltraps>

801071b5 <vector94>:
.globl vector94
vector94:
  pushl $0
801071b5:	6a 00                	push   $0x0
  pushl $94
801071b7:	6a 5e                	push   $0x5e
  jmp alltraps
801071b9:	e9 d1 f7 ff ff       	jmp    8010698f <alltraps>

801071be <vector95>:
.globl vector95
vector95:
  pushl $0
801071be:	6a 00                	push   $0x0
  pushl $95
801071c0:	6a 5f                	push   $0x5f
  jmp alltraps
801071c2:	e9 c8 f7 ff ff       	jmp    8010698f <alltraps>

801071c7 <vector96>:
.globl vector96
vector96:
  pushl $0
801071c7:	6a 00                	push   $0x0
  pushl $96
801071c9:	6a 60                	push   $0x60
  jmp alltraps
801071cb:	e9 bf f7 ff ff       	jmp    8010698f <alltraps>

801071d0 <vector97>:
.globl vector97
vector97:
  pushl $0
801071d0:	6a 00                	push   $0x0
  pushl $97
801071d2:	6a 61                	push   $0x61
  jmp alltraps
801071d4:	e9 b6 f7 ff ff       	jmp    8010698f <alltraps>

801071d9 <vector98>:
.globl vector98
vector98:
  pushl $0
801071d9:	6a 00                	push   $0x0
  pushl $98
801071db:	6a 62                	push   $0x62
  jmp alltraps
801071dd:	e9 ad f7 ff ff       	jmp    8010698f <alltraps>

801071e2 <vector99>:
.globl vector99
vector99:
  pushl $0
801071e2:	6a 00                	push   $0x0
  pushl $99
801071e4:	6a 63                	push   $0x63
  jmp alltraps
801071e6:	e9 a4 f7 ff ff       	jmp    8010698f <alltraps>

801071eb <vector100>:
.globl vector100
vector100:
  pushl $0
801071eb:	6a 00                	push   $0x0
  pushl $100
801071ed:	6a 64                	push   $0x64
  jmp alltraps
801071ef:	e9 9b f7 ff ff       	jmp    8010698f <alltraps>

801071f4 <vector101>:
.globl vector101
vector101:
  pushl $0
801071f4:	6a 00                	push   $0x0
  pushl $101
801071f6:	6a 65                	push   $0x65
  jmp alltraps
801071f8:	e9 92 f7 ff ff       	jmp    8010698f <alltraps>

801071fd <vector102>:
.globl vector102
vector102:
  pushl $0
801071fd:	6a 00                	push   $0x0
  pushl $102
801071ff:	6a 66                	push   $0x66
  jmp alltraps
80107201:	e9 89 f7 ff ff       	jmp    8010698f <alltraps>

80107206 <vector103>:
.globl vector103
vector103:
  pushl $0
80107206:	6a 00                	push   $0x0
  pushl $103
80107208:	6a 67                	push   $0x67
  jmp alltraps
8010720a:	e9 80 f7 ff ff       	jmp    8010698f <alltraps>

8010720f <vector104>:
.globl vector104
vector104:
  pushl $0
8010720f:	6a 00                	push   $0x0
  pushl $104
80107211:	6a 68                	push   $0x68
  jmp alltraps
80107213:	e9 77 f7 ff ff       	jmp    8010698f <alltraps>

80107218 <vector105>:
.globl vector105
vector105:
  pushl $0
80107218:	6a 00                	push   $0x0
  pushl $105
8010721a:	6a 69                	push   $0x69
  jmp alltraps
8010721c:	e9 6e f7 ff ff       	jmp    8010698f <alltraps>

80107221 <vector106>:
.globl vector106
vector106:
  pushl $0
80107221:	6a 00                	push   $0x0
  pushl $106
80107223:	6a 6a                	push   $0x6a
  jmp alltraps
80107225:	e9 65 f7 ff ff       	jmp    8010698f <alltraps>

8010722a <vector107>:
.globl vector107
vector107:
  pushl $0
8010722a:	6a 00                	push   $0x0
  pushl $107
8010722c:	6a 6b                	push   $0x6b
  jmp alltraps
8010722e:	e9 5c f7 ff ff       	jmp    8010698f <alltraps>

80107233 <vector108>:
.globl vector108
vector108:
  pushl $0
80107233:	6a 00                	push   $0x0
  pushl $108
80107235:	6a 6c                	push   $0x6c
  jmp alltraps
80107237:	e9 53 f7 ff ff       	jmp    8010698f <alltraps>

8010723c <vector109>:
.globl vector109
vector109:
  pushl $0
8010723c:	6a 00                	push   $0x0
  pushl $109
8010723e:	6a 6d                	push   $0x6d
  jmp alltraps
80107240:	e9 4a f7 ff ff       	jmp    8010698f <alltraps>

80107245 <vector110>:
.globl vector110
vector110:
  pushl $0
80107245:	6a 00                	push   $0x0
  pushl $110
80107247:	6a 6e                	push   $0x6e
  jmp alltraps
80107249:	e9 41 f7 ff ff       	jmp    8010698f <alltraps>

8010724e <vector111>:
.globl vector111
vector111:
  pushl $0
8010724e:	6a 00                	push   $0x0
  pushl $111
80107250:	6a 6f                	push   $0x6f
  jmp alltraps
80107252:	e9 38 f7 ff ff       	jmp    8010698f <alltraps>

80107257 <vector112>:
.globl vector112
vector112:
  pushl $0
80107257:	6a 00                	push   $0x0
  pushl $112
80107259:	6a 70                	push   $0x70
  jmp alltraps
8010725b:	e9 2f f7 ff ff       	jmp    8010698f <alltraps>

80107260 <vector113>:
.globl vector113
vector113:
  pushl $0
80107260:	6a 00                	push   $0x0
  pushl $113
80107262:	6a 71                	push   $0x71
  jmp alltraps
80107264:	e9 26 f7 ff ff       	jmp    8010698f <alltraps>

80107269 <vector114>:
.globl vector114
vector114:
  pushl $0
80107269:	6a 00                	push   $0x0
  pushl $114
8010726b:	6a 72                	push   $0x72
  jmp alltraps
8010726d:	e9 1d f7 ff ff       	jmp    8010698f <alltraps>

80107272 <vector115>:
.globl vector115
vector115:
  pushl $0
80107272:	6a 00                	push   $0x0
  pushl $115
80107274:	6a 73                	push   $0x73
  jmp alltraps
80107276:	e9 14 f7 ff ff       	jmp    8010698f <alltraps>

8010727b <vector116>:
.globl vector116
vector116:
  pushl $0
8010727b:	6a 00                	push   $0x0
  pushl $116
8010727d:	6a 74                	push   $0x74
  jmp alltraps
8010727f:	e9 0b f7 ff ff       	jmp    8010698f <alltraps>

80107284 <vector117>:
.globl vector117
vector117:
  pushl $0
80107284:	6a 00                	push   $0x0
  pushl $117
80107286:	6a 75                	push   $0x75
  jmp alltraps
80107288:	e9 02 f7 ff ff       	jmp    8010698f <alltraps>

8010728d <vector118>:
.globl vector118
vector118:
  pushl $0
8010728d:	6a 00                	push   $0x0
  pushl $118
8010728f:	6a 76                	push   $0x76
  jmp alltraps
80107291:	e9 f9 f6 ff ff       	jmp    8010698f <alltraps>

80107296 <vector119>:
.globl vector119
vector119:
  pushl $0
80107296:	6a 00                	push   $0x0
  pushl $119
80107298:	6a 77                	push   $0x77
  jmp alltraps
8010729a:	e9 f0 f6 ff ff       	jmp    8010698f <alltraps>

8010729f <vector120>:
.globl vector120
vector120:
  pushl $0
8010729f:	6a 00                	push   $0x0
  pushl $120
801072a1:	6a 78                	push   $0x78
  jmp alltraps
801072a3:	e9 e7 f6 ff ff       	jmp    8010698f <alltraps>

801072a8 <vector121>:
.globl vector121
vector121:
  pushl $0
801072a8:	6a 00                	push   $0x0
  pushl $121
801072aa:	6a 79                	push   $0x79
  jmp alltraps
801072ac:	e9 de f6 ff ff       	jmp    8010698f <alltraps>

801072b1 <vector122>:
.globl vector122
vector122:
  pushl $0
801072b1:	6a 00                	push   $0x0
  pushl $122
801072b3:	6a 7a                	push   $0x7a
  jmp alltraps
801072b5:	e9 d5 f6 ff ff       	jmp    8010698f <alltraps>

801072ba <vector123>:
.globl vector123
vector123:
  pushl $0
801072ba:	6a 00                	push   $0x0
  pushl $123
801072bc:	6a 7b                	push   $0x7b
  jmp alltraps
801072be:	e9 cc f6 ff ff       	jmp    8010698f <alltraps>

801072c3 <vector124>:
.globl vector124
vector124:
  pushl $0
801072c3:	6a 00                	push   $0x0
  pushl $124
801072c5:	6a 7c                	push   $0x7c
  jmp alltraps
801072c7:	e9 c3 f6 ff ff       	jmp    8010698f <alltraps>

801072cc <vector125>:
.globl vector125
vector125:
  pushl $0
801072cc:	6a 00                	push   $0x0
  pushl $125
801072ce:	6a 7d                	push   $0x7d
  jmp alltraps
801072d0:	e9 ba f6 ff ff       	jmp    8010698f <alltraps>

801072d5 <vector126>:
.globl vector126
vector126:
  pushl $0
801072d5:	6a 00                	push   $0x0
  pushl $126
801072d7:	6a 7e                	push   $0x7e
  jmp alltraps
801072d9:	e9 b1 f6 ff ff       	jmp    8010698f <alltraps>

801072de <vector127>:
.globl vector127
vector127:
  pushl $0
801072de:	6a 00                	push   $0x0
  pushl $127
801072e0:	6a 7f                	push   $0x7f
  jmp alltraps
801072e2:	e9 a8 f6 ff ff       	jmp    8010698f <alltraps>

801072e7 <vector128>:
.globl vector128
vector128:
  pushl $0
801072e7:	6a 00                	push   $0x0
  pushl $128
801072e9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801072ee:	e9 9c f6 ff ff       	jmp    8010698f <alltraps>

801072f3 <vector129>:
.globl vector129
vector129:
  pushl $0
801072f3:	6a 00                	push   $0x0
  pushl $129
801072f5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801072fa:	e9 90 f6 ff ff       	jmp    8010698f <alltraps>

801072ff <vector130>:
.globl vector130
vector130:
  pushl $0
801072ff:	6a 00                	push   $0x0
  pushl $130
80107301:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80107306:	e9 84 f6 ff ff       	jmp    8010698f <alltraps>

8010730b <vector131>:
.globl vector131
vector131:
  pushl $0
8010730b:	6a 00                	push   $0x0
  pushl $131
8010730d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107312:	e9 78 f6 ff ff       	jmp    8010698f <alltraps>

80107317 <vector132>:
.globl vector132
vector132:
  pushl $0
80107317:	6a 00                	push   $0x0
  pushl $132
80107319:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010731e:	e9 6c f6 ff ff       	jmp    8010698f <alltraps>

80107323 <vector133>:
.globl vector133
vector133:
  pushl $0
80107323:	6a 00                	push   $0x0
  pushl $133
80107325:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010732a:	e9 60 f6 ff ff       	jmp    8010698f <alltraps>

8010732f <vector134>:
.globl vector134
vector134:
  pushl $0
8010732f:	6a 00                	push   $0x0
  pushl $134
80107331:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80107336:	e9 54 f6 ff ff       	jmp    8010698f <alltraps>

8010733b <vector135>:
.globl vector135
vector135:
  pushl $0
8010733b:	6a 00                	push   $0x0
  pushl $135
8010733d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107342:	e9 48 f6 ff ff       	jmp    8010698f <alltraps>

80107347 <vector136>:
.globl vector136
vector136:
  pushl $0
80107347:	6a 00                	push   $0x0
  pushl $136
80107349:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010734e:	e9 3c f6 ff ff       	jmp    8010698f <alltraps>

80107353 <vector137>:
.globl vector137
vector137:
  pushl $0
80107353:	6a 00                	push   $0x0
  pushl $137
80107355:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010735a:	e9 30 f6 ff ff       	jmp    8010698f <alltraps>

8010735f <vector138>:
.globl vector138
vector138:
  pushl $0
8010735f:	6a 00                	push   $0x0
  pushl $138
80107361:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80107366:	e9 24 f6 ff ff       	jmp    8010698f <alltraps>

8010736b <vector139>:
.globl vector139
vector139:
  pushl $0
8010736b:	6a 00                	push   $0x0
  pushl $139
8010736d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107372:	e9 18 f6 ff ff       	jmp    8010698f <alltraps>

80107377 <vector140>:
.globl vector140
vector140:
  pushl $0
80107377:	6a 00                	push   $0x0
  pushl $140
80107379:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010737e:	e9 0c f6 ff ff       	jmp    8010698f <alltraps>

80107383 <vector141>:
.globl vector141
vector141:
  pushl $0
80107383:	6a 00                	push   $0x0
  pushl $141
80107385:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010738a:	e9 00 f6 ff ff       	jmp    8010698f <alltraps>

8010738f <vector142>:
.globl vector142
vector142:
  pushl $0
8010738f:	6a 00                	push   $0x0
  pushl $142
80107391:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107396:	e9 f4 f5 ff ff       	jmp    8010698f <alltraps>

8010739b <vector143>:
.globl vector143
vector143:
  pushl $0
8010739b:	6a 00                	push   $0x0
  pushl $143
8010739d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801073a2:	e9 e8 f5 ff ff       	jmp    8010698f <alltraps>

801073a7 <vector144>:
.globl vector144
vector144:
  pushl $0
801073a7:	6a 00                	push   $0x0
  pushl $144
801073a9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801073ae:	e9 dc f5 ff ff       	jmp    8010698f <alltraps>

801073b3 <vector145>:
.globl vector145
vector145:
  pushl $0
801073b3:	6a 00                	push   $0x0
  pushl $145
801073b5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801073ba:	e9 d0 f5 ff ff       	jmp    8010698f <alltraps>

801073bf <vector146>:
.globl vector146
vector146:
  pushl $0
801073bf:	6a 00                	push   $0x0
  pushl $146
801073c1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801073c6:	e9 c4 f5 ff ff       	jmp    8010698f <alltraps>

801073cb <vector147>:
.globl vector147
vector147:
  pushl $0
801073cb:	6a 00                	push   $0x0
  pushl $147
801073cd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801073d2:	e9 b8 f5 ff ff       	jmp    8010698f <alltraps>

801073d7 <vector148>:
.globl vector148
vector148:
  pushl $0
801073d7:	6a 00                	push   $0x0
  pushl $148
801073d9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801073de:	e9 ac f5 ff ff       	jmp    8010698f <alltraps>

801073e3 <vector149>:
.globl vector149
vector149:
  pushl $0
801073e3:	6a 00                	push   $0x0
  pushl $149
801073e5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801073ea:	e9 a0 f5 ff ff       	jmp    8010698f <alltraps>

801073ef <vector150>:
.globl vector150
vector150:
  pushl $0
801073ef:	6a 00                	push   $0x0
  pushl $150
801073f1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801073f6:	e9 94 f5 ff ff       	jmp    8010698f <alltraps>

801073fb <vector151>:
.globl vector151
vector151:
  pushl $0
801073fb:	6a 00                	push   $0x0
  pushl $151
801073fd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107402:	e9 88 f5 ff ff       	jmp    8010698f <alltraps>

80107407 <vector152>:
.globl vector152
vector152:
  pushl $0
80107407:	6a 00                	push   $0x0
  pushl $152
80107409:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010740e:	e9 7c f5 ff ff       	jmp    8010698f <alltraps>

80107413 <vector153>:
.globl vector153
vector153:
  pushl $0
80107413:	6a 00                	push   $0x0
  pushl $153
80107415:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010741a:	e9 70 f5 ff ff       	jmp    8010698f <alltraps>

8010741f <vector154>:
.globl vector154
vector154:
  pushl $0
8010741f:	6a 00                	push   $0x0
  pushl $154
80107421:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107426:	e9 64 f5 ff ff       	jmp    8010698f <alltraps>

8010742b <vector155>:
.globl vector155
vector155:
  pushl $0
8010742b:	6a 00                	push   $0x0
  pushl $155
8010742d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107432:	e9 58 f5 ff ff       	jmp    8010698f <alltraps>

80107437 <vector156>:
.globl vector156
vector156:
  pushl $0
80107437:	6a 00                	push   $0x0
  pushl $156
80107439:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010743e:	e9 4c f5 ff ff       	jmp    8010698f <alltraps>

80107443 <vector157>:
.globl vector157
vector157:
  pushl $0
80107443:	6a 00                	push   $0x0
  pushl $157
80107445:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010744a:	e9 40 f5 ff ff       	jmp    8010698f <alltraps>

8010744f <vector158>:
.globl vector158
vector158:
  pushl $0
8010744f:	6a 00                	push   $0x0
  pushl $158
80107451:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107456:	e9 34 f5 ff ff       	jmp    8010698f <alltraps>

8010745b <vector159>:
.globl vector159
vector159:
  pushl $0
8010745b:	6a 00                	push   $0x0
  pushl $159
8010745d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107462:	e9 28 f5 ff ff       	jmp    8010698f <alltraps>

80107467 <vector160>:
.globl vector160
vector160:
  pushl $0
80107467:	6a 00                	push   $0x0
  pushl $160
80107469:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010746e:	e9 1c f5 ff ff       	jmp    8010698f <alltraps>

80107473 <vector161>:
.globl vector161
vector161:
  pushl $0
80107473:	6a 00                	push   $0x0
  pushl $161
80107475:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010747a:	e9 10 f5 ff ff       	jmp    8010698f <alltraps>

8010747f <vector162>:
.globl vector162
vector162:
  pushl $0
8010747f:	6a 00                	push   $0x0
  pushl $162
80107481:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107486:	e9 04 f5 ff ff       	jmp    8010698f <alltraps>

8010748b <vector163>:
.globl vector163
vector163:
  pushl $0
8010748b:	6a 00                	push   $0x0
  pushl $163
8010748d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107492:	e9 f8 f4 ff ff       	jmp    8010698f <alltraps>

80107497 <vector164>:
.globl vector164
vector164:
  pushl $0
80107497:	6a 00                	push   $0x0
  pushl $164
80107499:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010749e:	e9 ec f4 ff ff       	jmp    8010698f <alltraps>

801074a3 <vector165>:
.globl vector165
vector165:
  pushl $0
801074a3:	6a 00                	push   $0x0
  pushl $165
801074a5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801074aa:	e9 e0 f4 ff ff       	jmp    8010698f <alltraps>

801074af <vector166>:
.globl vector166
vector166:
  pushl $0
801074af:	6a 00                	push   $0x0
  pushl $166
801074b1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801074b6:	e9 d4 f4 ff ff       	jmp    8010698f <alltraps>

801074bb <vector167>:
.globl vector167
vector167:
  pushl $0
801074bb:	6a 00                	push   $0x0
  pushl $167
801074bd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801074c2:	e9 c8 f4 ff ff       	jmp    8010698f <alltraps>

801074c7 <vector168>:
.globl vector168
vector168:
  pushl $0
801074c7:	6a 00                	push   $0x0
  pushl $168
801074c9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801074ce:	e9 bc f4 ff ff       	jmp    8010698f <alltraps>

801074d3 <vector169>:
.globl vector169
vector169:
  pushl $0
801074d3:	6a 00                	push   $0x0
  pushl $169
801074d5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801074da:	e9 b0 f4 ff ff       	jmp    8010698f <alltraps>

801074df <vector170>:
.globl vector170
vector170:
  pushl $0
801074df:	6a 00                	push   $0x0
  pushl $170
801074e1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801074e6:	e9 a4 f4 ff ff       	jmp    8010698f <alltraps>

801074eb <vector171>:
.globl vector171
vector171:
  pushl $0
801074eb:	6a 00                	push   $0x0
  pushl $171
801074ed:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801074f2:	e9 98 f4 ff ff       	jmp    8010698f <alltraps>

801074f7 <vector172>:
.globl vector172
vector172:
  pushl $0
801074f7:	6a 00                	push   $0x0
  pushl $172
801074f9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801074fe:	e9 8c f4 ff ff       	jmp    8010698f <alltraps>

80107503 <vector173>:
.globl vector173
vector173:
  pushl $0
80107503:	6a 00                	push   $0x0
  pushl $173
80107505:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010750a:	e9 80 f4 ff ff       	jmp    8010698f <alltraps>

8010750f <vector174>:
.globl vector174
vector174:
  pushl $0
8010750f:	6a 00                	push   $0x0
  pushl $174
80107511:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107516:	e9 74 f4 ff ff       	jmp    8010698f <alltraps>

8010751b <vector175>:
.globl vector175
vector175:
  pushl $0
8010751b:	6a 00                	push   $0x0
  pushl $175
8010751d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107522:	e9 68 f4 ff ff       	jmp    8010698f <alltraps>

80107527 <vector176>:
.globl vector176
vector176:
  pushl $0
80107527:	6a 00                	push   $0x0
  pushl $176
80107529:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010752e:	e9 5c f4 ff ff       	jmp    8010698f <alltraps>

80107533 <vector177>:
.globl vector177
vector177:
  pushl $0
80107533:	6a 00                	push   $0x0
  pushl $177
80107535:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010753a:	e9 50 f4 ff ff       	jmp    8010698f <alltraps>

8010753f <vector178>:
.globl vector178
vector178:
  pushl $0
8010753f:	6a 00                	push   $0x0
  pushl $178
80107541:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107546:	e9 44 f4 ff ff       	jmp    8010698f <alltraps>

8010754b <vector179>:
.globl vector179
vector179:
  pushl $0
8010754b:	6a 00                	push   $0x0
  pushl $179
8010754d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107552:	e9 38 f4 ff ff       	jmp    8010698f <alltraps>

80107557 <vector180>:
.globl vector180
vector180:
  pushl $0
80107557:	6a 00                	push   $0x0
  pushl $180
80107559:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010755e:	e9 2c f4 ff ff       	jmp    8010698f <alltraps>

80107563 <vector181>:
.globl vector181
vector181:
  pushl $0
80107563:	6a 00                	push   $0x0
  pushl $181
80107565:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010756a:	e9 20 f4 ff ff       	jmp    8010698f <alltraps>

8010756f <vector182>:
.globl vector182
vector182:
  pushl $0
8010756f:	6a 00                	push   $0x0
  pushl $182
80107571:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107576:	e9 14 f4 ff ff       	jmp    8010698f <alltraps>

8010757b <vector183>:
.globl vector183
vector183:
  pushl $0
8010757b:	6a 00                	push   $0x0
  pushl $183
8010757d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107582:	e9 08 f4 ff ff       	jmp    8010698f <alltraps>

80107587 <vector184>:
.globl vector184
vector184:
  pushl $0
80107587:	6a 00                	push   $0x0
  pushl $184
80107589:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010758e:	e9 fc f3 ff ff       	jmp    8010698f <alltraps>

80107593 <vector185>:
.globl vector185
vector185:
  pushl $0
80107593:	6a 00                	push   $0x0
  pushl $185
80107595:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010759a:	e9 f0 f3 ff ff       	jmp    8010698f <alltraps>

8010759f <vector186>:
.globl vector186
vector186:
  pushl $0
8010759f:	6a 00                	push   $0x0
  pushl $186
801075a1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801075a6:	e9 e4 f3 ff ff       	jmp    8010698f <alltraps>

801075ab <vector187>:
.globl vector187
vector187:
  pushl $0
801075ab:	6a 00                	push   $0x0
  pushl $187
801075ad:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801075b2:	e9 d8 f3 ff ff       	jmp    8010698f <alltraps>

801075b7 <vector188>:
.globl vector188
vector188:
  pushl $0
801075b7:	6a 00                	push   $0x0
  pushl $188
801075b9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801075be:	e9 cc f3 ff ff       	jmp    8010698f <alltraps>

801075c3 <vector189>:
.globl vector189
vector189:
  pushl $0
801075c3:	6a 00                	push   $0x0
  pushl $189
801075c5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801075ca:	e9 c0 f3 ff ff       	jmp    8010698f <alltraps>

801075cf <vector190>:
.globl vector190
vector190:
  pushl $0
801075cf:	6a 00                	push   $0x0
  pushl $190
801075d1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801075d6:	e9 b4 f3 ff ff       	jmp    8010698f <alltraps>

801075db <vector191>:
.globl vector191
vector191:
  pushl $0
801075db:	6a 00                	push   $0x0
  pushl $191
801075dd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801075e2:	e9 a8 f3 ff ff       	jmp    8010698f <alltraps>

801075e7 <vector192>:
.globl vector192
vector192:
  pushl $0
801075e7:	6a 00                	push   $0x0
  pushl $192
801075e9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801075ee:	e9 9c f3 ff ff       	jmp    8010698f <alltraps>

801075f3 <vector193>:
.globl vector193
vector193:
  pushl $0
801075f3:	6a 00                	push   $0x0
  pushl $193
801075f5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801075fa:	e9 90 f3 ff ff       	jmp    8010698f <alltraps>

801075ff <vector194>:
.globl vector194
vector194:
  pushl $0
801075ff:	6a 00                	push   $0x0
  pushl $194
80107601:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107606:	e9 84 f3 ff ff       	jmp    8010698f <alltraps>

8010760b <vector195>:
.globl vector195
vector195:
  pushl $0
8010760b:	6a 00                	push   $0x0
  pushl $195
8010760d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107612:	e9 78 f3 ff ff       	jmp    8010698f <alltraps>

80107617 <vector196>:
.globl vector196
vector196:
  pushl $0
80107617:	6a 00                	push   $0x0
  pushl $196
80107619:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010761e:	e9 6c f3 ff ff       	jmp    8010698f <alltraps>

80107623 <vector197>:
.globl vector197
vector197:
  pushl $0
80107623:	6a 00                	push   $0x0
  pushl $197
80107625:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010762a:	e9 60 f3 ff ff       	jmp    8010698f <alltraps>

8010762f <vector198>:
.globl vector198
vector198:
  pushl $0
8010762f:	6a 00                	push   $0x0
  pushl $198
80107631:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107636:	e9 54 f3 ff ff       	jmp    8010698f <alltraps>

8010763b <vector199>:
.globl vector199
vector199:
  pushl $0
8010763b:	6a 00                	push   $0x0
  pushl $199
8010763d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107642:	e9 48 f3 ff ff       	jmp    8010698f <alltraps>

80107647 <vector200>:
.globl vector200
vector200:
  pushl $0
80107647:	6a 00                	push   $0x0
  pushl $200
80107649:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010764e:	e9 3c f3 ff ff       	jmp    8010698f <alltraps>

80107653 <vector201>:
.globl vector201
vector201:
  pushl $0
80107653:	6a 00                	push   $0x0
  pushl $201
80107655:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010765a:	e9 30 f3 ff ff       	jmp    8010698f <alltraps>

8010765f <vector202>:
.globl vector202
vector202:
  pushl $0
8010765f:	6a 00                	push   $0x0
  pushl $202
80107661:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107666:	e9 24 f3 ff ff       	jmp    8010698f <alltraps>

8010766b <vector203>:
.globl vector203
vector203:
  pushl $0
8010766b:	6a 00                	push   $0x0
  pushl $203
8010766d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107672:	e9 18 f3 ff ff       	jmp    8010698f <alltraps>

80107677 <vector204>:
.globl vector204
vector204:
  pushl $0
80107677:	6a 00                	push   $0x0
  pushl $204
80107679:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010767e:	e9 0c f3 ff ff       	jmp    8010698f <alltraps>

80107683 <vector205>:
.globl vector205
vector205:
  pushl $0
80107683:	6a 00                	push   $0x0
  pushl $205
80107685:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010768a:	e9 00 f3 ff ff       	jmp    8010698f <alltraps>

8010768f <vector206>:
.globl vector206
vector206:
  pushl $0
8010768f:	6a 00                	push   $0x0
  pushl $206
80107691:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107696:	e9 f4 f2 ff ff       	jmp    8010698f <alltraps>

8010769b <vector207>:
.globl vector207
vector207:
  pushl $0
8010769b:	6a 00                	push   $0x0
  pushl $207
8010769d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801076a2:	e9 e8 f2 ff ff       	jmp    8010698f <alltraps>

801076a7 <vector208>:
.globl vector208
vector208:
  pushl $0
801076a7:	6a 00                	push   $0x0
  pushl $208
801076a9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801076ae:	e9 dc f2 ff ff       	jmp    8010698f <alltraps>

801076b3 <vector209>:
.globl vector209
vector209:
  pushl $0
801076b3:	6a 00                	push   $0x0
  pushl $209
801076b5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801076ba:	e9 d0 f2 ff ff       	jmp    8010698f <alltraps>

801076bf <vector210>:
.globl vector210
vector210:
  pushl $0
801076bf:	6a 00                	push   $0x0
  pushl $210
801076c1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801076c6:	e9 c4 f2 ff ff       	jmp    8010698f <alltraps>

801076cb <vector211>:
.globl vector211
vector211:
  pushl $0
801076cb:	6a 00                	push   $0x0
  pushl $211
801076cd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801076d2:	e9 b8 f2 ff ff       	jmp    8010698f <alltraps>

801076d7 <vector212>:
.globl vector212
vector212:
  pushl $0
801076d7:	6a 00                	push   $0x0
  pushl $212
801076d9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801076de:	e9 ac f2 ff ff       	jmp    8010698f <alltraps>

801076e3 <vector213>:
.globl vector213
vector213:
  pushl $0
801076e3:	6a 00                	push   $0x0
  pushl $213
801076e5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801076ea:	e9 a0 f2 ff ff       	jmp    8010698f <alltraps>

801076ef <vector214>:
.globl vector214
vector214:
  pushl $0
801076ef:	6a 00                	push   $0x0
  pushl $214
801076f1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801076f6:	e9 94 f2 ff ff       	jmp    8010698f <alltraps>

801076fb <vector215>:
.globl vector215
vector215:
  pushl $0
801076fb:	6a 00                	push   $0x0
  pushl $215
801076fd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107702:	e9 88 f2 ff ff       	jmp    8010698f <alltraps>

80107707 <vector216>:
.globl vector216
vector216:
  pushl $0
80107707:	6a 00                	push   $0x0
  pushl $216
80107709:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010770e:	e9 7c f2 ff ff       	jmp    8010698f <alltraps>

80107713 <vector217>:
.globl vector217
vector217:
  pushl $0
80107713:	6a 00                	push   $0x0
  pushl $217
80107715:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010771a:	e9 70 f2 ff ff       	jmp    8010698f <alltraps>

8010771f <vector218>:
.globl vector218
vector218:
  pushl $0
8010771f:	6a 00                	push   $0x0
  pushl $218
80107721:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107726:	e9 64 f2 ff ff       	jmp    8010698f <alltraps>

8010772b <vector219>:
.globl vector219
vector219:
  pushl $0
8010772b:	6a 00                	push   $0x0
  pushl $219
8010772d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107732:	e9 58 f2 ff ff       	jmp    8010698f <alltraps>

80107737 <vector220>:
.globl vector220
vector220:
  pushl $0
80107737:	6a 00                	push   $0x0
  pushl $220
80107739:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010773e:	e9 4c f2 ff ff       	jmp    8010698f <alltraps>

80107743 <vector221>:
.globl vector221
vector221:
  pushl $0
80107743:	6a 00                	push   $0x0
  pushl $221
80107745:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010774a:	e9 40 f2 ff ff       	jmp    8010698f <alltraps>

8010774f <vector222>:
.globl vector222
vector222:
  pushl $0
8010774f:	6a 00                	push   $0x0
  pushl $222
80107751:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107756:	e9 34 f2 ff ff       	jmp    8010698f <alltraps>

8010775b <vector223>:
.globl vector223
vector223:
  pushl $0
8010775b:	6a 00                	push   $0x0
  pushl $223
8010775d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107762:	e9 28 f2 ff ff       	jmp    8010698f <alltraps>

80107767 <vector224>:
.globl vector224
vector224:
  pushl $0
80107767:	6a 00                	push   $0x0
  pushl $224
80107769:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010776e:	e9 1c f2 ff ff       	jmp    8010698f <alltraps>

80107773 <vector225>:
.globl vector225
vector225:
  pushl $0
80107773:	6a 00                	push   $0x0
  pushl $225
80107775:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010777a:	e9 10 f2 ff ff       	jmp    8010698f <alltraps>

8010777f <vector226>:
.globl vector226
vector226:
  pushl $0
8010777f:	6a 00                	push   $0x0
  pushl $226
80107781:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107786:	e9 04 f2 ff ff       	jmp    8010698f <alltraps>

8010778b <vector227>:
.globl vector227
vector227:
  pushl $0
8010778b:	6a 00                	push   $0x0
  pushl $227
8010778d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107792:	e9 f8 f1 ff ff       	jmp    8010698f <alltraps>

80107797 <vector228>:
.globl vector228
vector228:
  pushl $0
80107797:	6a 00                	push   $0x0
  pushl $228
80107799:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010779e:	e9 ec f1 ff ff       	jmp    8010698f <alltraps>

801077a3 <vector229>:
.globl vector229
vector229:
  pushl $0
801077a3:	6a 00                	push   $0x0
  pushl $229
801077a5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801077aa:	e9 e0 f1 ff ff       	jmp    8010698f <alltraps>

801077af <vector230>:
.globl vector230
vector230:
  pushl $0
801077af:	6a 00                	push   $0x0
  pushl $230
801077b1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801077b6:	e9 d4 f1 ff ff       	jmp    8010698f <alltraps>

801077bb <vector231>:
.globl vector231
vector231:
  pushl $0
801077bb:	6a 00                	push   $0x0
  pushl $231
801077bd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801077c2:	e9 c8 f1 ff ff       	jmp    8010698f <alltraps>

801077c7 <vector232>:
.globl vector232
vector232:
  pushl $0
801077c7:	6a 00                	push   $0x0
  pushl $232
801077c9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801077ce:	e9 bc f1 ff ff       	jmp    8010698f <alltraps>

801077d3 <vector233>:
.globl vector233
vector233:
  pushl $0
801077d3:	6a 00                	push   $0x0
  pushl $233
801077d5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801077da:	e9 b0 f1 ff ff       	jmp    8010698f <alltraps>

801077df <vector234>:
.globl vector234
vector234:
  pushl $0
801077df:	6a 00                	push   $0x0
  pushl $234
801077e1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801077e6:	e9 a4 f1 ff ff       	jmp    8010698f <alltraps>

801077eb <vector235>:
.globl vector235
vector235:
  pushl $0
801077eb:	6a 00                	push   $0x0
  pushl $235
801077ed:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801077f2:	e9 98 f1 ff ff       	jmp    8010698f <alltraps>

801077f7 <vector236>:
.globl vector236
vector236:
  pushl $0
801077f7:	6a 00                	push   $0x0
  pushl $236
801077f9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801077fe:	e9 8c f1 ff ff       	jmp    8010698f <alltraps>

80107803 <vector237>:
.globl vector237
vector237:
  pushl $0
80107803:	6a 00                	push   $0x0
  pushl $237
80107805:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010780a:	e9 80 f1 ff ff       	jmp    8010698f <alltraps>

8010780f <vector238>:
.globl vector238
vector238:
  pushl $0
8010780f:	6a 00                	push   $0x0
  pushl $238
80107811:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107816:	e9 74 f1 ff ff       	jmp    8010698f <alltraps>

8010781b <vector239>:
.globl vector239
vector239:
  pushl $0
8010781b:	6a 00                	push   $0x0
  pushl $239
8010781d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107822:	e9 68 f1 ff ff       	jmp    8010698f <alltraps>

80107827 <vector240>:
.globl vector240
vector240:
  pushl $0
80107827:	6a 00                	push   $0x0
  pushl $240
80107829:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010782e:	e9 5c f1 ff ff       	jmp    8010698f <alltraps>

80107833 <vector241>:
.globl vector241
vector241:
  pushl $0
80107833:	6a 00                	push   $0x0
  pushl $241
80107835:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010783a:	e9 50 f1 ff ff       	jmp    8010698f <alltraps>

8010783f <vector242>:
.globl vector242
vector242:
  pushl $0
8010783f:	6a 00                	push   $0x0
  pushl $242
80107841:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107846:	e9 44 f1 ff ff       	jmp    8010698f <alltraps>

8010784b <vector243>:
.globl vector243
vector243:
  pushl $0
8010784b:	6a 00                	push   $0x0
  pushl $243
8010784d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107852:	e9 38 f1 ff ff       	jmp    8010698f <alltraps>

80107857 <vector244>:
.globl vector244
vector244:
  pushl $0
80107857:	6a 00                	push   $0x0
  pushl $244
80107859:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010785e:	e9 2c f1 ff ff       	jmp    8010698f <alltraps>

80107863 <vector245>:
.globl vector245
vector245:
  pushl $0
80107863:	6a 00                	push   $0x0
  pushl $245
80107865:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010786a:	e9 20 f1 ff ff       	jmp    8010698f <alltraps>

8010786f <vector246>:
.globl vector246
vector246:
  pushl $0
8010786f:	6a 00                	push   $0x0
  pushl $246
80107871:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107876:	e9 14 f1 ff ff       	jmp    8010698f <alltraps>

8010787b <vector247>:
.globl vector247
vector247:
  pushl $0
8010787b:	6a 00                	push   $0x0
  pushl $247
8010787d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107882:	e9 08 f1 ff ff       	jmp    8010698f <alltraps>

80107887 <vector248>:
.globl vector248
vector248:
  pushl $0
80107887:	6a 00                	push   $0x0
  pushl $248
80107889:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010788e:	e9 fc f0 ff ff       	jmp    8010698f <alltraps>

80107893 <vector249>:
.globl vector249
vector249:
  pushl $0
80107893:	6a 00                	push   $0x0
  pushl $249
80107895:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010789a:	e9 f0 f0 ff ff       	jmp    8010698f <alltraps>

8010789f <vector250>:
.globl vector250
vector250:
  pushl $0
8010789f:	6a 00                	push   $0x0
  pushl $250
801078a1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801078a6:	e9 e4 f0 ff ff       	jmp    8010698f <alltraps>

801078ab <vector251>:
.globl vector251
vector251:
  pushl $0
801078ab:	6a 00                	push   $0x0
  pushl $251
801078ad:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801078b2:	e9 d8 f0 ff ff       	jmp    8010698f <alltraps>

801078b7 <vector252>:
.globl vector252
vector252:
  pushl $0
801078b7:	6a 00                	push   $0x0
  pushl $252
801078b9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801078be:	e9 cc f0 ff ff       	jmp    8010698f <alltraps>

801078c3 <vector253>:
.globl vector253
vector253:
  pushl $0
801078c3:	6a 00                	push   $0x0
  pushl $253
801078c5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801078ca:	e9 c0 f0 ff ff       	jmp    8010698f <alltraps>

801078cf <vector254>:
.globl vector254
vector254:
  pushl $0
801078cf:	6a 00                	push   $0x0
  pushl $254
801078d1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801078d6:	e9 b4 f0 ff ff       	jmp    8010698f <alltraps>

801078db <vector255>:
.globl vector255
vector255:
  pushl $0
801078db:	6a 00                	push   $0x0
  pushl $255
801078dd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801078e2:	e9 a8 f0 ff ff       	jmp    8010698f <alltraps>
801078e7:	66 90                	xchg   %ax,%ax
801078e9:	66 90                	xchg   %ax,%ax
801078eb:	66 90                	xchg   %ax,%ax
801078ed:	66 90                	xchg   %ax,%ax
801078ef:	90                   	nop

801078f0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801078f0:	55                   	push   %ebp
801078f1:	89 e5                	mov    %esp,%ebp
801078f3:	57                   	push   %edi
801078f4:	56                   	push   %esi
801078f5:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801078f6:	89 d3                	mov    %edx,%ebx
{
801078f8:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
801078fa:	c1 eb 16             	shr    $0x16,%ebx
801078fd:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80107900:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80107903:	8b 06                	mov    (%esi),%eax
80107905:	a8 01                	test   $0x1,%al
80107907:	74 27                	je     80107930 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107909:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010790e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80107914:	c1 ef 0a             	shr    $0xa,%edi
}
80107917:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
8010791a:	89 fa                	mov    %edi,%edx
8010791c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107922:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80107925:	5b                   	pop    %ebx
80107926:	5e                   	pop    %esi
80107927:	5f                   	pop    %edi
80107928:	5d                   	pop    %ebp
80107929:	c3                   	ret    
8010792a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107930:	85 c9                	test   %ecx,%ecx
80107932:	74 2c                	je     80107960 <walkpgdir+0x70>
80107934:	e8 47 ad ff ff       	call   80102680 <kalloc>
80107939:	85 c0                	test   %eax,%eax
8010793b:	89 c3                	mov    %eax,%ebx
8010793d:	74 21                	je     80107960 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
8010793f:	83 ec 04             	sub    $0x4,%esp
80107942:	68 00 10 00 00       	push   $0x1000
80107947:	6a 00                	push   $0x0
80107949:	50                   	push   %eax
8010794a:	e8 71 d4 ff ff       	call   80104dc0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010794f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107955:	83 c4 10             	add    $0x10,%esp
80107958:	83 c8 07             	or     $0x7,%eax
8010795b:	89 06                	mov    %eax,(%esi)
8010795d:	eb b5                	jmp    80107914 <walkpgdir+0x24>
8010795f:	90                   	nop
}
80107960:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80107963:	31 c0                	xor    %eax,%eax
}
80107965:	5b                   	pop    %ebx
80107966:	5e                   	pop    %esi
80107967:	5f                   	pop    %edi
80107968:	5d                   	pop    %ebp
80107969:	c3                   	ret    
8010796a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107970 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107970:	55                   	push   %ebp
80107971:	89 e5                	mov    %esp,%ebp
80107973:	57                   	push   %edi
80107974:	56                   	push   %esi
80107975:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80107976:	89 d3                	mov    %edx,%ebx
80107978:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
8010797e:	83 ec 1c             	sub    $0x1c,%esp
80107981:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107984:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107988:	8b 7d 08             	mov    0x8(%ebp),%edi
8010798b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107990:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80107993:	8b 45 0c             	mov    0xc(%ebp),%eax
80107996:	29 df                	sub    %ebx,%edi
80107998:	83 c8 01             	or     $0x1,%eax
8010799b:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010799e:	eb 15                	jmp    801079b5 <mappages+0x45>
    if(*pte & PTE_P)
801079a0:	f6 00 01             	testb  $0x1,(%eax)
801079a3:	75 45                	jne    801079ea <mappages+0x7a>
    *pte = pa | perm | PTE_P;
801079a5:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
801079a8:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
801079ab:	89 30                	mov    %esi,(%eax)
    if(a == last)
801079ad:	74 31                	je     801079e0 <mappages+0x70>
      break;
    a += PGSIZE;
801079af:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801079b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801079b8:	b9 01 00 00 00       	mov    $0x1,%ecx
801079bd:	89 da                	mov    %ebx,%edx
801079bf:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
801079c2:	e8 29 ff ff ff       	call   801078f0 <walkpgdir>
801079c7:	85 c0                	test   %eax,%eax
801079c9:	75 d5                	jne    801079a0 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
801079cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801079ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801079d3:	5b                   	pop    %ebx
801079d4:	5e                   	pop    %esi
801079d5:	5f                   	pop    %edi
801079d6:	5d                   	pop    %ebp
801079d7:	c3                   	ret    
801079d8:	90                   	nop
801079d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801079e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801079e3:	31 c0                	xor    %eax,%eax
}
801079e5:	5b                   	pop    %ebx
801079e6:	5e                   	pop    %esi
801079e7:	5f                   	pop    %edi
801079e8:	5d                   	pop    %ebp
801079e9:	c3                   	ret    
      panic("remap");
801079ea:	83 ec 0c             	sub    $0xc,%esp
801079ed:	68 c8 8f 10 80       	push   $0x80108fc8
801079f2:	e8 99 89 ff ff       	call   80100390 <panic>
801079f7:	89 f6                	mov    %esi,%esi
801079f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107a00 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107a00:	55                   	push   %ebp
80107a01:	89 e5                	mov    %esp,%ebp
80107a03:	57                   	push   %edi
80107a04:	56                   	push   %esi
80107a05:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80107a06:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107a0c:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
80107a0e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107a14:	83 ec 1c             	sub    $0x1c,%esp
80107a17:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107a1a:	39 d3                	cmp    %edx,%ebx
80107a1c:	73 66                	jae    80107a84 <deallocuvm.part.0+0x84>
80107a1e:	89 d6                	mov    %edx,%esi
80107a20:	eb 3d                	jmp    80107a5f <deallocuvm.part.0+0x5f>
80107a22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80107a28:	8b 10                	mov    (%eax),%edx
80107a2a:	f6 c2 01             	test   $0x1,%dl
80107a2d:	74 26                	je     80107a55 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80107a2f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80107a35:	74 58                	je     80107a8f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80107a37:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80107a3a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107a40:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80107a43:	52                   	push   %edx
80107a44:	e8 87 aa ff ff       	call   801024d0 <kfree>
      *pte = 0;
80107a49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107a4c:	83 c4 10             	add    $0x10,%esp
80107a4f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80107a55:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107a5b:	39 f3                	cmp    %esi,%ebx
80107a5d:	73 25                	jae    80107a84 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
80107a5f:	31 c9                	xor    %ecx,%ecx
80107a61:	89 da                	mov    %ebx,%edx
80107a63:	89 f8                	mov    %edi,%eax
80107a65:	e8 86 fe ff ff       	call   801078f0 <walkpgdir>
    if(!pte)
80107a6a:	85 c0                	test   %eax,%eax
80107a6c:	75 ba                	jne    80107a28 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107a6e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80107a74:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80107a7a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107a80:	39 f3                	cmp    %esi,%ebx
80107a82:	72 db                	jb     80107a5f <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
80107a84:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107a87:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a8a:	5b                   	pop    %ebx
80107a8b:	5e                   	pop    %esi
80107a8c:	5f                   	pop    %edi
80107a8d:	5d                   	pop    %ebp
80107a8e:	c3                   	ret    
        panic("kfree");
80107a8f:	83 ec 0c             	sub    $0xc,%esp
80107a92:	68 86 84 10 80       	push   $0x80108486
80107a97:	e8 f4 88 ff ff       	call   80100390 <panic>
80107a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107aa0 <seginit>:
{
80107aa0:	55                   	push   %ebp
80107aa1:	89 e5                	mov    %esp,%ebp
80107aa3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107aa6:	e8 f5 be ff ff       	call   801039a0 <cpuid>
80107aab:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80107ab1:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107ab6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107aba:	c7 80 18 48 11 80 ff 	movl   $0xffff,-0x7feeb7e8(%eax)
80107ac1:	ff 00 00 
80107ac4:	c7 80 1c 48 11 80 00 	movl   $0xcf9a00,-0x7feeb7e4(%eax)
80107acb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107ace:	c7 80 20 48 11 80 ff 	movl   $0xffff,-0x7feeb7e0(%eax)
80107ad5:	ff 00 00 
80107ad8:	c7 80 24 48 11 80 00 	movl   $0xcf9200,-0x7feeb7dc(%eax)
80107adf:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107ae2:	c7 80 28 48 11 80 ff 	movl   $0xffff,-0x7feeb7d8(%eax)
80107ae9:	ff 00 00 
80107aec:	c7 80 2c 48 11 80 00 	movl   $0xcffa00,-0x7feeb7d4(%eax)
80107af3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107af6:	c7 80 30 48 11 80 ff 	movl   $0xffff,-0x7feeb7d0(%eax)
80107afd:	ff 00 00 
80107b00:	c7 80 34 48 11 80 00 	movl   $0xcff200,-0x7feeb7cc(%eax)
80107b07:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80107b0a:	05 10 48 11 80       	add    $0x80114810,%eax
  pd[1] = (uint)p;
80107b0f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107b13:	c1 e8 10             	shr    $0x10,%eax
80107b16:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80107b1a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80107b1d:	0f 01 10             	lgdtl  (%eax)
}
80107b20:	c9                   	leave  
80107b21:	c3                   	ret    
80107b22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107b30 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107b30:	a1 e4 ed 12 80       	mov    0x8012ede4,%eax
{
80107b35:	55                   	push   %ebp
80107b36:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107b38:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107b3d:	0f 22 d8             	mov    %eax,%cr3
}
80107b40:	5d                   	pop    %ebp
80107b41:	c3                   	ret    
80107b42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107b50 <switchuvm>:
{
80107b50:	55                   	push   %ebp
80107b51:	89 e5                	mov    %esp,%ebp
80107b53:	57                   	push   %edi
80107b54:	56                   	push   %esi
80107b55:	53                   	push   %ebx
80107b56:	83 ec 1c             	sub    $0x1c,%esp
80107b59:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
80107b5c:	85 db                	test   %ebx,%ebx
80107b5e:	0f 84 cb 00 00 00    	je     80107c2f <switchuvm+0xdf>
  if(p->kstack == 0)
80107b64:	8b 43 08             	mov    0x8(%ebx),%eax
80107b67:	85 c0                	test   %eax,%eax
80107b69:	0f 84 da 00 00 00    	je     80107c49 <switchuvm+0xf9>
  if(p->pgdir == 0)
80107b6f:	8b 43 04             	mov    0x4(%ebx),%eax
80107b72:	85 c0                	test   %eax,%eax
80107b74:	0f 84 c2 00 00 00    	je     80107c3c <switchuvm+0xec>
  pushcli();
80107b7a:	e8 51 ce ff ff       	call   801049d0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107b7f:	e8 9c bd ff ff       	call   80103920 <mycpu>
80107b84:	89 c6                	mov    %eax,%esi
80107b86:	e8 95 bd ff ff       	call   80103920 <mycpu>
80107b8b:	89 c7                	mov    %eax,%edi
80107b8d:	e8 8e bd ff ff       	call   80103920 <mycpu>
80107b92:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107b95:	83 c7 08             	add    $0x8,%edi
80107b98:	e8 83 bd ff ff       	call   80103920 <mycpu>
80107b9d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107ba0:	83 c0 08             	add    $0x8,%eax
80107ba3:	ba 67 00 00 00       	mov    $0x67,%edx
80107ba8:	c1 e8 18             	shr    $0x18,%eax
80107bab:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80107bb2:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80107bb9:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107bbf:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107bc4:	83 c1 08             	add    $0x8,%ecx
80107bc7:	c1 e9 10             	shr    $0x10,%ecx
80107bca:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80107bd0:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107bd5:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107bdc:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80107be1:	e8 3a bd ff ff       	call   80103920 <mycpu>
80107be6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107bed:	e8 2e bd ff ff       	call   80103920 <mycpu>
80107bf2:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107bf6:	8b 73 08             	mov    0x8(%ebx),%esi
80107bf9:	e8 22 bd ff ff       	call   80103920 <mycpu>
80107bfe:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107c04:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107c07:	e8 14 bd ff ff       	call   80103920 <mycpu>
80107c0c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107c10:	b8 28 00 00 00       	mov    $0x28,%eax
80107c15:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107c18:	8b 43 04             	mov    0x4(%ebx),%eax
80107c1b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107c20:	0f 22 d8             	mov    %eax,%cr3
}
80107c23:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107c26:	5b                   	pop    %ebx
80107c27:	5e                   	pop    %esi
80107c28:	5f                   	pop    %edi
80107c29:	5d                   	pop    %ebp
  popcli();
80107c2a:	e9 e1 cd ff ff       	jmp    80104a10 <popcli>
    panic("switchuvm: no process");
80107c2f:	83 ec 0c             	sub    $0xc,%esp
80107c32:	68 ce 8f 10 80       	push   $0x80108fce
80107c37:	e8 54 87 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80107c3c:	83 ec 0c             	sub    $0xc,%esp
80107c3f:	68 f9 8f 10 80       	push   $0x80108ff9
80107c44:	e8 47 87 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80107c49:	83 ec 0c             	sub    $0xc,%esp
80107c4c:	68 e4 8f 10 80       	push   $0x80108fe4
80107c51:	e8 3a 87 ff ff       	call   80100390 <panic>
80107c56:	8d 76 00             	lea    0x0(%esi),%esi
80107c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107c60 <inituvm>:
{
80107c60:	55                   	push   %ebp
80107c61:	89 e5                	mov    %esp,%ebp
80107c63:	57                   	push   %edi
80107c64:	56                   	push   %esi
80107c65:	53                   	push   %ebx
80107c66:	83 ec 1c             	sub    $0x1c,%esp
80107c69:	8b 75 10             	mov    0x10(%ebp),%esi
80107c6c:	8b 45 08             	mov    0x8(%ebp),%eax
80107c6f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80107c72:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80107c78:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107c7b:	77 49                	ja     80107cc6 <inituvm+0x66>
  mem = kalloc();
80107c7d:	e8 fe a9 ff ff       	call   80102680 <kalloc>
  memset(mem, 0, PGSIZE);
80107c82:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80107c85:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107c87:	68 00 10 00 00       	push   $0x1000
80107c8c:	6a 00                	push   $0x0
80107c8e:	50                   	push   %eax
80107c8f:	e8 2c d1 ff ff       	call   80104dc0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107c94:	58                   	pop    %eax
80107c95:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107c9b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107ca0:	5a                   	pop    %edx
80107ca1:	6a 06                	push   $0x6
80107ca3:	50                   	push   %eax
80107ca4:	31 d2                	xor    %edx,%edx
80107ca6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107ca9:	e8 c2 fc ff ff       	call   80107970 <mappages>
  memmove(mem, init, sz);
80107cae:	89 75 10             	mov    %esi,0x10(%ebp)
80107cb1:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107cb4:	83 c4 10             	add    $0x10,%esp
80107cb7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80107cba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107cbd:	5b                   	pop    %ebx
80107cbe:	5e                   	pop    %esi
80107cbf:	5f                   	pop    %edi
80107cc0:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107cc1:	e9 aa d1 ff ff       	jmp    80104e70 <memmove>
    panic("inituvm: more than a page");
80107cc6:	83 ec 0c             	sub    $0xc,%esp
80107cc9:	68 0d 90 10 80       	push   $0x8010900d
80107cce:	e8 bd 86 ff ff       	call   80100390 <panic>
80107cd3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107cd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107ce0 <loaduvm>:
{
80107ce0:	55                   	push   %ebp
80107ce1:	89 e5                	mov    %esp,%ebp
80107ce3:	57                   	push   %edi
80107ce4:	56                   	push   %esi
80107ce5:	53                   	push   %ebx
80107ce6:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80107ce9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80107cf0:	0f 85 91 00 00 00    	jne    80107d87 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80107cf6:	8b 75 18             	mov    0x18(%ebp),%esi
80107cf9:	31 db                	xor    %ebx,%ebx
80107cfb:	85 f6                	test   %esi,%esi
80107cfd:	75 1a                	jne    80107d19 <loaduvm+0x39>
80107cff:	eb 6f                	jmp    80107d70 <loaduvm+0x90>
80107d01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107d08:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107d0e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80107d14:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80107d17:	76 57                	jbe    80107d70 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107d19:	8b 55 0c             	mov    0xc(%ebp),%edx
80107d1c:	8b 45 08             	mov    0x8(%ebp),%eax
80107d1f:	31 c9                	xor    %ecx,%ecx
80107d21:	01 da                	add    %ebx,%edx
80107d23:	e8 c8 fb ff ff       	call   801078f0 <walkpgdir>
80107d28:	85 c0                	test   %eax,%eax
80107d2a:	74 4e                	je     80107d7a <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
80107d2c:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107d2e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80107d31:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107d36:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107d3b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107d41:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107d44:	01 d9                	add    %ebx,%ecx
80107d46:	05 00 00 00 80       	add    $0x80000000,%eax
80107d4b:	57                   	push   %edi
80107d4c:	51                   	push   %ecx
80107d4d:	50                   	push   %eax
80107d4e:	ff 75 10             	pushl  0x10(%ebp)
80107d51:	e8 ca 9d ff ff       	call   80101b20 <readi>
80107d56:	83 c4 10             	add    $0x10,%esp
80107d59:	39 f8                	cmp    %edi,%eax
80107d5b:	74 ab                	je     80107d08 <loaduvm+0x28>
}
80107d5d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107d60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107d65:	5b                   	pop    %ebx
80107d66:	5e                   	pop    %esi
80107d67:	5f                   	pop    %edi
80107d68:	5d                   	pop    %ebp
80107d69:	c3                   	ret    
80107d6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107d70:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107d73:	31 c0                	xor    %eax,%eax
}
80107d75:	5b                   	pop    %ebx
80107d76:	5e                   	pop    %esi
80107d77:	5f                   	pop    %edi
80107d78:	5d                   	pop    %ebp
80107d79:	c3                   	ret    
      panic("loaduvm: address should exist");
80107d7a:	83 ec 0c             	sub    $0xc,%esp
80107d7d:	68 27 90 10 80       	push   $0x80109027
80107d82:	e8 09 86 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107d87:	83 ec 0c             	sub    $0xc,%esp
80107d8a:	68 c8 90 10 80       	push   $0x801090c8
80107d8f:	e8 fc 85 ff ff       	call   80100390 <panic>
80107d94:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107d9a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107da0 <allocuvm>:
{
80107da0:	55                   	push   %ebp
80107da1:	89 e5                	mov    %esp,%ebp
80107da3:	57                   	push   %edi
80107da4:	56                   	push   %esi
80107da5:	53                   	push   %ebx
80107da6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107da9:	8b 7d 10             	mov    0x10(%ebp),%edi
80107dac:	85 ff                	test   %edi,%edi
80107dae:	0f 88 8e 00 00 00    	js     80107e42 <allocuvm+0xa2>
  if(newsz < oldsz)
80107db4:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107db7:	0f 82 93 00 00 00    	jb     80107e50 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
80107dbd:	8b 45 0c             	mov    0xc(%ebp),%eax
80107dc0:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107dc6:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80107dcc:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107dcf:	0f 86 7e 00 00 00    	jbe    80107e53 <allocuvm+0xb3>
80107dd5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80107dd8:	8b 7d 08             	mov    0x8(%ebp),%edi
80107ddb:	eb 42                	jmp    80107e1f <allocuvm+0x7f>
80107ddd:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80107de0:	83 ec 04             	sub    $0x4,%esp
80107de3:	68 00 10 00 00       	push   $0x1000
80107de8:	6a 00                	push   $0x0
80107dea:	50                   	push   %eax
80107deb:	e8 d0 cf ff ff       	call   80104dc0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107df0:	58                   	pop    %eax
80107df1:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107df7:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107dfc:	5a                   	pop    %edx
80107dfd:	6a 06                	push   $0x6
80107dff:	50                   	push   %eax
80107e00:	89 da                	mov    %ebx,%edx
80107e02:	89 f8                	mov    %edi,%eax
80107e04:	e8 67 fb ff ff       	call   80107970 <mappages>
80107e09:	83 c4 10             	add    $0x10,%esp
80107e0c:	85 c0                	test   %eax,%eax
80107e0e:	78 50                	js     80107e60 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
80107e10:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107e16:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107e19:	0f 86 81 00 00 00    	jbe    80107ea0 <allocuvm+0x100>
    mem = kalloc();
80107e1f:	e8 5c a8 ff ff       	call   80102680 <kalloc>
    if(mem == 0){
80107e24:	85 c0                	test   %eax,%eax
    mem = kalloc();
80107e26:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80107e28:	75 b6                	jne    80107de0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107e2a:	83 ec 0c             	sub    $0xc,%esp
80107e2d:	68 45 90 10 80       	push   $0x80109045
80107e32:	e8 b9 88 ff ff       	call   801006f0 <cprintf>
  if(newsz >= oldsz)
80107e37:	83 c4 10             	add    $0x10,%esp
80107e3a:	8b 45 0c             	mov    0xc(%ebp),%eax
80107e3d:	39 45 10             	cmp    %eax,0x10(%ebp)
80107e40:	77 6e                	ja     80107eb0 <allocuvm+0x110>
}
80107e42:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80107e45:	31 ff                	xor    %edi,%edi
}
80107e47:	89 f8                	mov    %edi,%eax
80107e49:	5b                   	pop    %ebx
80107e4a:	5e                   	pop    %esi
80107e4b:	5f                   	pop    %edi
80107e4c:	5d                   	pop    %ebp
80107e4d:	c3                   	ret    
80107e4e:	66 90                	xchg   %ax,%ax
    return oldsz;
80107e50:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80107e53:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107e56:	89 f8                	mov    %edi,%eax
80107e58:	5b                   	pop    %ebx
80107e59:	5e                   	pop    %esi
80107e5a:	5f                   	pop    %edi
80107e5b:	5d                   	pop    %ebp
80107e5c:	c3                   	ret    
80107e5d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107e60:	83 ec 0c             	sub    $0xc,%esp
80107e63:	68 5d 90 10 80       	push   $0x8010905d
80107e68:	e8 83 88 ff ff       	call   801006f0 <cprintf>
  if(newsz >= oldsz)
80107e6d:	83 c4 10             	add    $0x10,%esp
80107e70:	8b 45 0c             	mov    0xc(%ebp),%eax
80107e73:	39 45 10             	cmp    %eax,0x10(%ebp)
80107e76:	76 0d                	jbe    80107e85 <allocuvm+0xe5>
80107e78:	89 c1                	mov    %eax,%ecx
80107e7a:	8b 55 10             	mov    0x10(%ebp),%edx
80107e7d:	8b 45 08             	mov    0x8(%ebp),%eax
80107e80:	e8 7b fb ff ff       	call   80107a00 <deallocuvm.part.0>
      kfree(mem);
80107e85:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80107e88:	31 ff                	xor    %edi,%edi
      kfree(mem);
80107e8a:	56                   	push   %esi
80107e8b:	e8 40 a6 ff ff       	call   801024d0 <kfree>
      return 0;
80107e90:	83 c4 10             	add    $0x10,%esp
}
80107e93:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107e96:	89 f8                	mov    %edi,%eax
80107e98:	5b                   	pop    %ebx
80107e99:	5e                   	pop    %esi
80107e9a:	5f                   	pop    %edi
80107e9b:	5d                   	pop    %ebp
80107e9c:	c3                   	ret    
80107e9d:	8d 76 00             	lea    0x0(%esi),%esi
80107ea0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80107ea3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107ea6:	5b                   	pop    %ebx
80107ea7:	89 f8                	mov    %edi,%eax
80107ea9:	5e                   	pop    %esi
80107eaa:	5f                   	pop    %edi
80107eab:	5d                   	pop    %ebp
80107eac:	c3                   	ret    
80107ead:	8d 76 00             	lea    0x0(%esi),%esi
80107eb0:	89 c1                	mov    %eax,%ecx
80107eb2:	8b 55 10             	mov    0x10(%ebp),%edx
80107eb5:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80107eb8:	31 ff                	xor    %edi,%edi
80107eba:	e8 41 fb ff ff       	call   80107a00 <deallocuvm.part.0>
80107ebf:	eb 92                	jmp    80107e53 <allocuvm+0xb3>
80107ec1:	eb 0d                	jmp    80107ed0 <deallocuvm>
80107ec3:	90                   	nop
80107ec4:	90                   	nop
80107ec5:	90                   	nop
80107ec6:	90                   	nop
80107ec7:	90                   	nop
80107ec8:	90                   	nop
80107ec9:	90                   	nop
80107eca:	90                   	nop
80107ecb:	90                   	nop
80107ecc:	90                   	nop
80107ecd:	90                   	nop
80107ece:	90                   	nop
80107ecf:	90                   	nop

80107ed0 <deallocuvm>:
{
80107ed0:	55                   	push   %ebp
80107ed1:	89 e5                	mov    %esp,%ebp
80107ed3:	8b 55 0c             	mov    0xc(%ebp),%edx
80107ed6:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80107edc:	39 d1                	cmp    %edx,%ecx
80107ede:	73 10                	jae    80107ef0 <deallocuvm+0x20>
}
80107ee0:	5d                   	pop    %ebp
80107ee1:	e9 1a fb ff ff       	jmp    80107a00 <deallocuvm.part.0>
80107ee6:	8d 76 00             	lea    0x0(%esi),%esi
80107ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107ef0:	89 d0                	mov    %edx,%eax
80107ef2:	5d                   	pop    %ebp
80107ef3:	c3                   	ret    
80107ef4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107efa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107f00 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107f00:	55                   	push   %ebp
80107f01:	89 e5                	mov    %esp,%ebp
80107f03:	57                   	push   %edi
80107f04:	56                   	push   %esi
80107f05:	53                   	push   %ebx
80107f06:	83 ec 0c             	sub    $0xc,%esp
80107f09:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80107f0c:	85 f6                	test   %esi,%esi
80107f0e:	74 59                	je     80107f69 <freevm+0x69>
80107f10:	31 c9                	xor    %ecx,%ecx
80107f12:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107f17:	89 f0                	mov    %esi,%eax
80107f19:	e8 e2 fa ff ff       	call   80107a00 <deallocuvm.part.0>
80107f1e:	89 f3                	mov    %esi,%ebx
80107f20:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107f26:	eb 0f                	jmp    80107f37 <freevm+0x37>
80107f28:	90                   	nop
80107f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107f30:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107f33:	39 fb                	cmp    %edi,%ebx
80107f35:	74 23                	je     80107f5a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107f37:	8b 03                	mov    (%ebx),%eax
80107f39:	a8 01                	test   $0x1,%al
80107f3b:	74 f3                	je     80107f30 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107f3d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107f42:	83 ec 0c             	sub    $0xc,%esp
80107f45:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107f48:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80107f4d:	50                   	push   %eax
80107f4e:	e8 7d a5 ff ff       	call   801024d0 <kfree>
80107f53:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107f56:	39 fb                	cmp    %edi,%ebx
80107f58:	75 dd                	jne    80107f37 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80107f5a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80107f5d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107f60:	5b                   	pop    %ebx
80107f61:	5e                   	pop    %esi
80107f62:	5f                   	pop    %edi
80107f63:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107f64:	e9 67 a5 ff ff       	jmp    801024d0 <kfree>
    panic("freevm: no pgdir");
80107f69:	83 ec 0c             	sub    $0xc,%esp
80107f6c:	68 79 90 10 80       	push   $0x80109079
80107f71:	e8 1a 84 ff ff       	call   80100390 <panic>
80107f76:	8d 76 00             	lea    0x0(%esi),%esi
80107f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107f80 <setupkvm>:
{
80107f80:	55                   	push   %ebp
80107f81:	89 e5                	mov    %esp,%ebp
80107f83:	56                   	push   %esi
80107f84:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107f85:	e8 f6 a6 ff ff       	call   80102680 <kalloc>
80107f8a:	85 c0                	test   %eax,%eax
80107f8c:	89 c6                	mov    %eax,%esi
80107f8e:	74 42                	je     80107fd2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107f90:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107f93:	bb 20 c4 10 80       	mov    $0x8010c420,%ebx
  memset(pgdir, 0, PGSIZE);
80107f98:	68 00 10 00 00       	push   $0x1000
80107f9d:	6a 00                	push   $0x0
80107f9f:	50                   	push   %eax
80107fa0:	e8 1b ce ff ff       	call   80104dc0 <memset>
80107fa5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107fa8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107fab:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107fae:	83 ec 08             	sub    $0x8,%esp
80107fb1:	8b 13                	mov    (%ebx),%edx
80107fb3:	ff 73 0c             	pushl  0xc(%ebx)
80107fb6:	50                   	push   %eax
80107fb7:	29 c1                	sub    %eax,%ecx
80107fb9:	89 f0                	mov    %esi,%eax
80107fbb:	e8 b0 f9 ff ff       	call   80107970 <mappages>
80107fc0:	83 c4 10             	add    $0x10,%esp
80107fc3:	85 c0                	test   %eax,%eax
80107fc5:	78 19                	js     80107fe0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107fc7:	83 c3 10             	add    $0x10,%ebx
80107fca:	81 fb 60 c4 10 80    	cmp    $0x8010c460,%ebx
80107fd0:	75 d6                	jne    80107fa8 <setupkvm+0x28>
}
80107fd2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107fd5:	89 f0                	mov    %esi,%eax
80107fd7:	5b                   	pop    %ebx
80107fd8:	5e                   	pop    %esi
80107fd9:	5d                   	pop    %ebp
80107fda:	c3                   	ret    
80107fdb:	90                   	nop
80107fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107fe0:	83 ec 0c             	sub    $0xc,%esp
80107fe3:	56                   	push   %esi
      return 0;
80107fe4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107fe6:	e8 15 ff ff ff       	call   80107f00 <freevm>
      return 0;
80107feb:	83 c4 10             	add    $0x10,%esp
}
80107fee:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107ff1:	89 f0                	mov    %esi,%eax
80107ff3:	5b                   	pop    %ebx
80107ff4:	5e                   	pop    %esi
80107ff5:	5d                   	pop    %ebp
80107ff6:	c3                   	ret    
80107ff7:	89 f6                	mov    %esi,%esi
80107ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108000 <kvmalloc>:
{
80108000:	55                   	push   %ebp
80108001:	89 e5                	mov    %esp,%ebp
80108003:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80108006:	e8 75 ff ff ff       	call   80107f80 <setupkvm>
8010800b:	a3 e4 ed 12 80       	mov    %eax,0x8012ede4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80108010:	05 00 00 00 80       	add    $0x80000000,%eax
80108015:	0f 22 d8             	mov    %eax,%cr3
}
80108018:	c9                   	leave  
80108019:	c3                   	ret    
8010801a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108020 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108020:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108021:	31 c9                	xor    %ecx,%ecx
{
80108023:	89 e5                	mov    %esp,%ebp
80108025:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80108028:	8b 55 0c             	mov    0xc(%ebp),%edx
8010802b:	8b 45 08             	mov    0x8(%ebp),%eax
8010802e:	e8 bd f8 ff ff       	call   801078f0 <walkpgdir>
  if(pte == 0)
80108033:	85 c0                	test   %eax,%eax
80108035:	74 05                	je     8010803c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80108037:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010803a:	c9                   	leave  
8010803b:	c3                   	ret    
    panic("clearpteu");
8010803c:	83 ec 0c             	sub    $0xc,%esp
8010803f:	68 8a 90 10 80       	push   $0x8010908a
80108044:	e8 47 83 ff ff       	call   80100390 <panic>
80108049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80108050 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108050:	55                   	push   %ebp
80108051:	89 e5                	mov    %esp,%ebp
80108053:	57                   	push   %edi
80108054:	56                   	push   %esi
80108055:	53                   	push   %ebx
80108056:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80108059:	e8 22 ff ff ff       	call   80107f80 <setupkvm>
8010805e:	85 c0                	test   %eax,%eax
80108060:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108063:	0f 84 9f 00 00 00    	je     80108108 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80108069:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010806c:	85 c9                	test   %ecx,%ecx
8010806e:	0f 84 94 00 00 00    	je     80108108 <copyuvm+0xb8>
80108074:	31 ff                	xor    %edi,%edi
80108076:	eb 4a                	jmp    801080c2 <copyuvm+0x72>
80108078:	90                   	nop
80108079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80108080:	83 ec 04             	sub    $0x4,%esp
80108083:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80108089:	68 00 10 00 00       	push   $0x1000
8010808e:	53                   	push   %ebx
8010808f:	50                   	push   %eax
80108090:	e8 db cd ff ff       	call   80104e70 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80108095:	58                   	pop    %eax
80108096:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010809c:	b9 00 10 00 00       	mov    $0x1000,%ecx
801080a1:	5a                   	pop    %edx
801080a2:	ff 75 e4             	pushl  -0x1c(%ebp)
801080a5:	50                   	push   %eax
801080a6:	89 fa                	mov    %edi,%edx
801080a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801080ab:	e8 c0 f8 ff ff       	call   80107970 <mappages>
801080b0:	83 c4 10             	add    $0x10,%esp
801080b3:	85 c0                	test   %eax,%eax
801080b5:	78 61                	js     80108118 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
801080b7:	81 c7 00 10 00 00    	add    $0x1000,%edi
801080bd:	39 7d 0c             	cmp    %edi,0xc(%ebp)
801080c0:	76 46                	jbe    80108108 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801080c2:	8b 45 08             	mov    0x8(%ebp),%eax
801080c5:	31 c9                	xor    %ecx,%ecx
801080c7:	89 fa                	mov    %edi,%edx
801080c9:	e8 22 f8 ff ff       	call   801078f0 <walkpgdir>
801080ce:	85 c0                	test   %eax,%eax
801080d0:	74 61                	je     80108133 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
801080d2:	8b 00                	mov    (%eax),%eax
801080d4:	a8 01                	test   $0x1,%al
801080d6:	74 4e                	je     80108126 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
801080d8:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
801080da:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
801080df:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
801080e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
801080e8:	e8 93 a5 ff ff       	call   80102680 <kalloc>
801080ed:	85 c0                	test   %eax,%eax
801080ef:	89 c6                	mov    %eax,%esi
801080f1:	75 8d                	jne    80108080 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
801080f3:	83 ec 0c             	sub    $0xc,%esp
801080f6:	ff 75 e0             	pushl  -0x20(%ebp)
801080f9:	e8 02 fe ff ff       	call   80107f00 <freevm>
  return 0;
801080fe:	83 c4 10             	add    $0x10,%esp
80108101:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80108108:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010810b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010810e:	5b                   	pop    %ebx
8010810f:	5e                   	pop    %esi
80108110:	5f                   	pop    %edi
80108111:	5d                   	pop    %ebp
80108112:	c3                   	ret    
80108113:	90                   	nop
80108114:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80108118:	83 ec 0c             	sub    $0xc,%esp
8010811b:	56                   	push   %esi
8010811c:	e8 af a3 ff ff       	call   801024d0 <kfree>
      goto bad;
80108121:	83 c4 10             	add    $0x10,%esp
80108124:	eb cd                	jmp    801080f3 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80108126:	83 ec 0c             	sub    $0xc,%esp
80108129:	68 ae 90 10 80       	push   $0x801090ae
8010812e:	e8 5d 82 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80108133:	83 ec 0c             	sub    $0xc,%esp
80108136:	68 94 90 10 80       	push   $0x80109094
8010813b:	e8 50 82 ff ff       	call   80100390 <panic>

80108140 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108140:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108141:	31 c9                	xor    %ecx,%ecx
{
80108143:	89 e5                	mov    %esp,%ebp
80108145:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80108148:	8b 55 0c             	mov    0xc(%ebp),%edx
8010814b:	8b 45 08             	mov    0x8(%ebp),%eax
8010814e:	e8 9d f7 ff ff       	call   801078f0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80108153:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80108155:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80108156:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80108158:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
8010815d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80108160:	05 00 00 00 80       	add    $0x80000000,%eax
80108165:	83 fa 05             	cmp    $0x5,%edx
80108168:	ba 00 00 00 00       	mov    $0x0,%edx
8010816d:	0f 45 c2             	cmovne %edx,%eax
}
80108170:	c3                   	ret    
80108171:	eb 0d                	jmp    80108180 <copyout>
80108173:	90                   	nop
80108174:	90                   	nop
80108175:	90                   	nop
80108176:	90                   	nop
80108177:	90                   	nop
80108178:	90                   	nop
80108179:	90                   	nop
8010817a:	90                   	nop
8010817b:	90                   	nop
8010817c:	90                   	nop
8010817d:	90                   	nop
8010817e:	90                   	nop
8010817f:	90                   	nop

80108180 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108180:	55                   	push   %ebp
80108181:	89 e5                	mov    %esp,%ebp
80108183:	57                   	push   %edi
80108184:	56                   	push   %esi
80108185:	53                   	push   %ebx
80108186:	83 ec 1c             	sub    $0x1c,%esp
80108189:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010818c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010818f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108192:	85 db                	test   %ebx,%ebx
80108194:	75 40                	jne    801081d6 <copyout+0x56>
80108196:	eb 70                	jmp    80108208 <copyout+0x88>
80108198:	90                   	nop
80108199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
801081a0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801081a3:	89 f1                	mov    %esi,%ecx
801081a5:	29 d1                	sub    %edx,%ecx
801081a7:	81 c1 00 10 00 00    	add    $0x1000,%ecx
801081ad:	39 d9                	cmp    %ebx,%ecx
801081af:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801081b2:	29 f2                	sub    %esi,%edx
801081b4:	83 ec 04             	sub    $0x4,%esp
801081b7:	01 d0                	add    %edx,%eax
801081b9:	51                   	push   %ecx
801081ba:	57                   	push   %edi
801081bb:	50                   	push   %eax
801081bc:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801081bf:	e8 ac cc ff ff       	call   80104e70 <memmove>
    len -= n;
    buf += n;
801081c4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
801081c7:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
801081ca:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
801081d0:	01 cf                	add    %ecx,%edi
  while(len > 0){
801081d2:	29 cb                	sub    %ecx,%ebx
801081d4:	74 32                	je     80108208 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
801081d6:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801081d8:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
801081db:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801081de:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801081e4:	56                   	push   %esi
801081e5:	ff 75 08             	pushl  0x8(%ebp)
801081e8:	e8 53 ff ff ff       	call   80108140 <uva2ka>
    if(pa0 == 0)
801081ed:	83 c4 10             	add    $0x10,%esp
801081f0:	85 c0                	test   %eax,%eax
801081f2:	75 ac                	jne    801081a0 <copyout+0x20>
  }
  return 0;
}
801081f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801081f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801081fc:	5b                   	pop    %ebx
801081fd:	5e                   	pop    %esi
801081fe:	5f                   	pop    %edi
801081ff:	5d                   	pop    %ebp
80108200:	c3                   	ret    
80108201:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108208:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010820b:	31 c0                	xor    %eax,%eax
}
8010820d:	5b                   	pop    %ebx
8010820e:	5e                   	pop    %esi
8010820f:	5f                   	pop    %edi
80108210:	5d                   	pop    %ebp
80108211:	c3                   	ret    
