
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc d0 d5 10 80       	mov    $0x8010d5d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 00 30 10 80       	mov    $0x80103000,%eax
  jmp *%eax
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
  struct buf head;
} bcache;

void
binit(void)
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010004c:	68 80 81 10 80       	push   $0x80108180
80100051:	68 e0 d5 10 80       	push   $0x8010d5e0
80100056:	e8 75 48 00 00       	call   801048d0 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
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
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 dc 1c 11 80 	movl   $0x80111cdc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 87 81 10 80       	push   $0x80108187
80100097:	50                   	push   %eax
80100098:	e8 e3 46 00 00       	call   80104780 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 30 1d 11 80       	mov    0x80111d30,%eax

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
801000b0:	89 1d 30 1d 11 80    	mov    %ebx,0x80111d30

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d dc 1c 11 80       	cmp    $0x80111cdc,%eax
801000bb:	75 c3                	jne    80100080 <binit+0x40>
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
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
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.lock);
801000df:	68 e0 d5 10 80       	push   $0x8010d5e0
801000e4:	e8 47 49 00 00       	call   80104a30 <acquire>

  // Is the block already cached?
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
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
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
80100162:	e8 79 49 00 00       	call   80104ae0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 4e 46 00 00       	call   801047c0 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 0d 21 00 00       	call   80102290 <iderw>
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
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 8e 81 10 80       	push   $0x8010818e
80100198:	e8 d3 01 00 00       	call   80100370 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:
}

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
801001ae:	e8 cd 46 00 00       	call   80104880 <holdingsleep>
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
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  b->flags |= B_DIRTY;
  iderw(b);
801001c4:	e9 c7 20 00 00       	jmp    80102290 <iderw>
// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 9f 81 10 80       	push   $0x8010819f
801001d1:	e8 9a 01 00 00       	call   80100370 <panic>
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
801001ef:	e8 8c 46 00 00       	call   80104880 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 1c 46 00 00       	call   80104820 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 e0 d5 10 80 	movl   $0x8010d5e0,(%esp)
8010020b:	e8 20 48 00 00       	call   80104a30 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
    panic("brelse");

  releasesleep(&b->lock);

  acquire(&bcache.lock);
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
    panic("brelse");

  releasesleep(&b->lock);

  acquire(&bcache.lock);
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
  b->refcnt--;
  if (b->refcnt == 0) {
    // no one is waiting for it.
    b->next->prev = b->prev;
    b->prev->next = b->next;
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
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
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
  
  release(&bcache.lock);
8010025c:	e9 7f 48 00 00       	jmp    80104ae0 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 a6 81 10 80       	push   $0x801081a6
80100269:	e8 02 01 00 00       	call   80100370 <panic>
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
80100280:	e8 6b 16 00 00       	call   801018f0 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
8010028c:	e8 9f 47 00 00       	call   80104a30 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e 9a 00 00 00    	jle    8010033b <consoleread+0xcb>
    while(input.r == input.w){
801002a1:	a1 c0 1f 11 80       	mov    0x80111fc0,%eax
801002a6:	3b 05 c4 1f 11 80    	cmp    0x80111fc4,%eax
801002ac:	74 24                	je     801002d2 <consoleread+0x62>
801002ae:	eb 58                	jmp    80100308 <consoleread+0x98>
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b0:	83 ec 08             	sub    $0x8,%esp
801002b3:	68 20 c5 10 80       	push   $0x8010c520
801002b8:	68 c0 1f 11 80       	push   $0x80111fc0
801002bd:	e8 4e 3c 00 00       	call   80103f10 <sleep>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
801002c2:	a1 c0 1f 11 80       	mov    0x80111fc0,%eax
801002c7:	83 c4 10             	add    $0x10,%esp
801002ca:	3b 05 c4 1f 11 80    	cmp    0x80111fc4,%eax
801002d0:	75 36                	jne    80100308 <consoleread+0x98>
      if(myproc()->killed){
801002d2:	e8 79 36 00 00       	call   80103950 <myproc>
801002d7:	8b 40 24             	mov    0x24(%eax),%eax
801002da:	85 c0                	test   %eax,%eax
801002dc:	74 d2                	je     801002b0 <consoleread+0x40>
        release(&cons.lock);
801002de:	83 ec 0c             	sub    $0xc,%esp
801002e1:	68 20 c5 10 80       	push   $0x8010c520
801002e6:	e8 f5 47 00 00       	call   80104ae0 <release>
        ilock(ip);
801002eb:	89 3c 24             	mov    %edi,(%esp)
801002ee:	e8 1d 15 00 00       	call   80101810 <ilock>
        return -1;
801002f3:	83 c4 10             	add    $0x10,%esp
801002f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801002fe:	5b                   	pop    %ebx
801002ff:	5e                   	pop    %esi
80100300:	5f                   	pop    %edi
80100301:	5d                   	pop    %ebp
80100302:	c3                   	ret    
80100303:	90                   	nop
80100304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100308:	8d 50 01             	lea    0x1(%eax),%edx
8010030b:	89 15 c0 1f 11 80    	mov    %edx,0x80111fc0
80100311:	89 c2                	mov    %eax,%edx
80100313:	83 e2 7f             	and    $0x7f,%edx
80100316:	0f be 92 40 1f 11 80 	movsbl -0x7feee0c0(%edx),%edx
    if(c == C('D')){  // EOF
8010031d:	83 fa 04             	cmp    $0x4,%edx
80100320:	74 39                	je     8010035b <consoleread+0xeb>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
80100322:	83 c6 01             	add    $0x1,%esi
    --n;
80100325:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
80100328:	83 fa 0a             	cmp    $0xa,%edx
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
8010032b:	88 56 ff             	mov    %dl,-0x1(%esi)
    --n;
    if(c == '\n')
8010032e:	74 35                	je     80100365 <consoleread+0xf5>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100330:	85 db                	test   %ebx,%ebx
80100332:	0f 85 69 ff ff ff    	jne    801002a1 <consoleread+0x31>
80100338:	8b 45 10             	mov    0x10(%ebp),%eax
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
8010033b:	83 ec 0c             	sub    $0xc,%esp
8010033e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100341:	68 20 c5 10 80       	push   $0x8010c520
80100346:	e8 95 47 00 00       	call   80104ae0 <release>
  ilock(ip);
8010034b:	89 3c 24             	mov    %edi,(%esp)
8010034e:	e8 bd 14 00 00       	call   80101810 <ilock>

  return target - n;
80100353:	83 c4 10             	add    $0x10,%esp
80100356:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100359:	eb a0                	jmp    801002fb <consoleread+0x8b>
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
8010035b:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010035e:	76 05                	jbe    80100365 <consoleread+0xf5>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100360:	a3 c0 1f 11 80       	mov    %eax,0x80111fc0
80100365:	8b 45 10             	mov    0x10(%ebp),%eax
80100368:	29 d8                	sub    %ebx,%eax
8010036a:	eb cf                	jmp    8010033b <consoleread+0xcb>
8010036c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100370 <panic>:
    release(&cons.lock);
}

void
panic(char *s)
{
80100370:	55                   	push   %ebp
80100371:	89 e5                	mov    %esp,%ebp
80100373:	56                   	push   %esi
80100374:	53                   	push   %ebx
80100375:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100378:	fa                   	cli    
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
80100379:	c7 05 54 c5 10 80 00 	movl   $0x0,0x8010c554
80100380:	00 00 00 
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
80100383:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100386:	8d 75 f8             	lea    -0x8(%ebp),%esi
  uint pcs[10];

  cli();
  cons.locking = 0;
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
80100389:	e8 02 25 00 00       	call   80102890 <lapicid>
8010038e:	83 ec 08             	sub    $0x8,%esp
80100391:	50                   	push   %eax
80100392:	68 ad 81 10 80       	push   $0x801081ad
80100397:	e8 44 03 00 00       	call   801006e0 <cprintf>
  cprintf(s);
8010039c:	58                   	pop    %eax
8010039d:	ff 75 08             	pushl  0x8(%ebp)
801003a0:	e8 3b 03 00 00       	call   801006e0 <cprintf>
  cprintf("\n");
801003a5:	c7 04 24 59 88 10 80 	movl   $0x80108859,(%esp)
801003ac:	e8 2f 03 00 00       	call   801006e0 <cprintf>
  getcallerpcs(&s, pcs);
801003b1:	5a                   	pop    %edx
801003b2:	8d 45 08             	lea    0x8(%ebp),%eax
801003b5:	59                   	pop    %ecx
801003b6:	53                   	push   %ebx
801003b7:	50                   	push   %eax
801003b8:	e8 33 45 00 00       	call   801048f0 <getcallerpcs>
801003bd:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003c0:	83 ec 08             	sub    $0x8,%esp
801003c3:	ff 33                	pushl  (%ebx)
801003c5:	83 c3 04             	add    $0x4,%ebx
801003c8:	68 c1 81 10 80       	push   $0x801081c1
801003cd:	e8 0e 03 00 00       	call   801006e0 <cprintf>
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801003d2:	83 c4 10             	add    $0x10,%esp
801003d5:	39 f3                	cmp    %esi,%ebx
801003d7:	75 e7                	jne    801003c0 <panic+0x50>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801003d9:	c7 05 58 c5 10 80 01 	movl   $0x1,0x8010c558
801003e0:	00 00 00 
801003e3:	eb fe                	jmp    801003e3 <panic+0x73>
801003e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801003e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801003f0 <consputc>:
}

void
consputc(int c)
{
  if(panicked){
801003f0:	8b 15 58 c5 10 80    	mov    0x8010c558,%edx
801003f6:	85 d2                	test   %edx,%edx
801003f8:	74 06                	je     80100400 <consputc+0x10>
801003fa:	fa                   	cli    
801003fb:	eb fe                	jmp    801003fb <consputc+0xb>
801003fd:	8d 76 00             	lea    0x0(%esi),%esi
 // }
}

void
consputc(int c)
{
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c6                	mov    %eax,%esi
80100408:	83 ec 0c             	sub    $0xc,%esp
    cli();
    for(;;)
      ;
  }

  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 ed 00 00 00    	je     80100503 <consputc+0x113>
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else if(c != UP && c != DOWN && c != LEFT && c != RIGHT){
80100416:	8d 80 1e ff ff ff    	lea    -0xe2(%eax),%eax
8010041c:	83 f8 03             	cmp    $0x3,%eax
8010041f:	0f 87 c7 01 00 00    	ja     801005ec <consputc+0x1fc>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100425:	bf d4 03 00 00       	mov    $0x3d4,%edi
8010042a:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042f:	89 fa                	mov    %edi,%edx
80100431:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100432:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100437:	89 ca                	mov    %ecx,%edx
80100439:	ec                   	in     (%dx),%al
{
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
8010043a:	0f b6 d8             	movzbl %al,%ebx
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043d:	89 fa                	mov    %edi,%edx
8010043f:	b8 0f 00 00 00       	mov    $0xf,%eax
80100444:	c1 e3 08             	shl    $0x8,%ebx
80100447:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100448:	89 ca                	mov    %ecx,%edx
8010044a:	ec                   	in     (%dx),%al
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);
8010044b:	0f b6 c0             	movzbl %al,%eax
8010044e:	09 c3                	or     %eax,%ebx

  //if(pos > maximum_pos)
  //  maximum_pos = pos;

  if(c == '\n')
80100450:	83 fe 0a             	cmp    $0xa,%esi
80100453:	0f 84 77 01 00 00    	je     801005d0 <consputc+0x1e0>
    pos += BUFF_SIZE - pos % BUFF_SIZE;
  else if(c == BACKSPACE) {
80100459:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010045f:	0f 84 2f 01 00 00    	je     80100594 <consputc+0x1a4>
      if (pos > 0){
 	--pos;
	//maximum_pos = pos + 1;
	memmove(crt + pos, crt + pos + 1, sizeof(crt[0])*(24*80 - pos));
      }
  } else if(c == LEFT){
80100465:	81 fe e4 00 00 00    	cmp    $0xe4,%esi
8010046b:	0f 84 17 01 00 00    	je     80100588 <consputc+0x198>
      if (pos > 0)
	--pos;
  } else if(c == RIGHT){
80100471:	81 fe e5 00 00 00    	cmp    $0xe5,%esi
80100477:	0f 84 b0 00 00 00    	je     8010052d <consputc+0x13d>
      /*if (pos < maximum_pos)*/ ++pos;
  } else if(c == UP){
    // Up
  } else if(c == DOWN){
8010047d:	8d 86 1e ff ff ff    	lea    -0xe2(%esi),%eax
80100483:	83 f8 01             	cmp    $0x1,%eax
80100486:	76 38                	jbe    801004c0 <consputc+0xd0>
    // Down
  } else{
    memmove(crt + pos + 1, crt + pos, sizeof(crt[0])*(24*80 - pos));
80100488:	b8 80 07 00 00       	mov    $0x780,%eax
8010048d:	8d 3c 1b             	lea    (%ebx,%ebx,1),%edi
80100490:	83 ec 04             	sub    $0x4,%esp
80100493:	29 d8                	sub    %ebx,%eax
    crt[pos++] = (c & 0xff) | 0x0700;  // black on white
80100495:	83 c3 01             	add    $0x1,%ebx
  } else if(c == UP){
    // Up
  } else if(c == DOWN){
    // Down
  } else{
    memmove(crt + pos + 1, crt + pos, sizeof(crt[0])*(24*80 - pos));
80100498:	01 c0                	add    %eax,%eax
8010049a:	8d 97 00 80 0b 80    	lea    -0x7ff48000(%edi),%edx
801004a0:	50                   	push   %eax
801004a1:	8d 87 02 80 0b 80    	lea    -0x7ff47ffe(%edi),%eax
801004a7:	52                   	push   %edx
801004a8:	50                   	push   %eax
801004a9:	e8 b2 48 00 00       	call   80104d60 <memmove>
    crt[pos++] = (c & 0xff) | 0x0700;  // black on white
801004ae:	89 f0                	mov    %esi,%eax
801004b0:	83 c4 10             	add    $0x10,%esp
801004b3:	0f b6 c0             	movzbl %al,%eax
801004b6:	80 cc 07             	or     $0x7,%ah
801004b9:	66 89 87 00 80 0b 80 	mov    %ax,-0x7ff48000(%edi)
   // if(pos > maximum_pos)
     // maximum_pos = pos;
  }

  if(pos < 0 || pos > 25*80)
801004c0:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
801004c6:	7f 70                	jg     80100538 <consputc+0x148>
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
801004c8:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801004ce:	7f 75                	jg     80100545 <consputc+0x155>
801004d0:	89 d8                	mov    %ebx,%eax
801004d2:	c1 e8 08             	shr    $0x8,%eax
801004d5:	89 c1                	mov    %eax,%ecx
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004d7:	bf d4 03 00 00       	mov    $0x3d4,%edi
801004dc:	b8 0e 00 00 00       	mov    $0xe,%eax
801004e1:	89 fa                	mov    %edi,%edx
801004e3:	ee                   	out    %al,(%dx)
801004e4:	be d5 03 00 00       	mov    $0x3d5,%esi
801004e9:	89 c8                	mov    %ecx,%eax
801004eb:	89 f2                	mov    %esi,%edx
801004ed:	ee                   	out    %al,(%dx)
801004ee:	b8 0f 00 00 00       	mov    $0xf,%eax
801004f3:	89 fa                	mov    %edi,%edx
801004f5:	ee                   	out    %al,(%dx)
801004f6:	89 d8                	mov    %ebx,%eax
801004f8:	89 f2                	mov    %esi,%edx
801004fa:	ee                   	out    %al,(%dx)
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else if(c != UP && c != DOWN && c != LEFT && c != RIGHT){
    uartputc(c);
  }
  cgaputc(c);
}
801004fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004fe:	5b                   	pop    %ebx
801004ff:	5e                   	pop    %esi
80100500:	5f                   	pop    %edi
80100501:	5d                   	pop    %ebp
80100502:	c3                   	ret    
    for(;;)
      ;
  }

  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100503:	83 ec 0c             	sub    $0xc,%esp
80100506:	6a 08                	push   $0x8
80100508:	e8 33 68 00 00       	call   80106d40 <uartputc>
8010050d:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100514:	e8 27 68 00 00       	call   80106d40 <uartputc>
80100519:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100520:	e8 1b 68 00 00       	call   80106d40 <uartputc>
80100525:	83 c4 10             	add    $0x10,%esp
80100528:	e9 f8 fe ff ff       	jmp    80100425 <consputc+0x35>
      }
  } else if(c == LEFT){
      if (pos > 0)
	--pos;
  } else if(c == RIGHT){
      /*if (pos < maximum_pos)*/ ++pos;
8010052d:	83 c3 01             	add    $0x1,%ebx
    crt[pos++] = (c & 0xff) | 0x0700;  // black on white
   // if(pos > maximum_pos)
     // maximum_pos = pos;
  }

  if(pos < 0 || pos > 25*80)
80100530:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
80100536:	7e 90                	jle    801004c8 <consputc+0xd8>
    panic("pos under/overflow");
80100538:	83 ec 0c             	sub    $0xc,%esp
8010053b:	68 c5 81 10 80       	push   $0x801081c5
80100540:	e8 2b fe ff ff       	call   80100370 <panic>

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100545:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100548:	83 eb 50             	sub    $0x50,%ebx

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010054b:	68 60 0e 00 00       	push   $0xe60
80100550:	68 a0 80 0b 80       	push   $0x800b80a0
80100555:	68 00 80 0b 80       	push   $0x800b8000
8010055a:	e8 01 48 00 00       	call   80104d60 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
8010055f:	b8 80 07 00 00       	mov    $0x780,%eax
80100564:	83 c4 0c             	add    $0xc,%esp
80100567:	29 d8                	sub    %ebx,%eax
80100569:	01 c0                	add    %eax,%eax
8010056b:	50                   	push   %eax
8010056c:	8d 84 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%eax
80100573:	6a 00                	push   $0x0
80100575:	50                   	push   %eax
80100576:	e8 35 47 00 00       	call   80104cb0 <memset>
8010057b:	83 c4 10             	add    $0x10,%esp
8010057e:	b9 07 00 00 00       	mov    $0x7,%ecx
80100583:	e9 4f ff ff ff       	jmp    801004d7 <consputc+0xe7>
 	--pos;
	//maximum_pos = pos + 1;
	memmove(crt + pos, crt + pos + 1, sizeof(crt[0])*(24*80 - pos));
      }
  } else if(c == LEFT){
      if (pos > 0)
80100588:	85 db                	test   %ebx,%ebx
8010058a:	74 3b                	je     801005c7 <consputc+0x1d7>
	--pos;
8010058c:	83 eb 01             	sub    $0x1,%ebx
8010058f:	e9 2c ff ff ff       	jmp    801004c0 <consputc+0xd0>

  if(c == '\n')
    pos += BUFF_SIZE - pos % BUFF_SIZE;
  else if(c == BACKSPACE) {
      //backspace_hit = 1;
      if (pos > 0){
80100594:	85 db                	test   %ebx,%ebx
80100596:	74 2f                	je     801005c7 <consputc+0x1d7>
 	--pos;
80100598:	83 eb 01             	sub    $0x1,%ebx
	//maximum_pos = pos + 1;
	memmove(crt + pos, crt + pos + 1, sizeof(crt[0])*(24*80 - pos));
8010059b:	b8 80 07 00 00       	mov    $0x780,%eax
801005a0:	83 ec 04             	sub    $0x4,%esp
801005a3:	8d 54 1b 02          	lea    0x2(%ebx,%ebx,1),%edx
801005a7:	29 d8                	sub    %ebx,%eax
801005a9:	01 c0                	add    %eax,%eax
801005ab:	50                   	push   %eax
801005ac:	8d 82 00 80 0b 80    	lea    -0x7ff48000(%edx),%eax
801005b2:	81 ea 02 80 f4 7f    	sub    $0x7ff48002,%edx
801005b8:	50                   	push   %eax
801005b9:	52                   	push   %edx
801005ba:	e8 a1 47 00 00       	call   80104d60 <memmove>
801005bf:	83 c4 10             	add    $0x10,%esp
801005c2:	e9 f9 fe ff ff       	jmp    801004c0 <consputc+0xd0>
      }
  } else if(c == LEFT){
      if (pos > 0)
801005c7:	31 db                	xor    %ebx,%ebx
801005c9:	31 c9                	xor    %ecx,%ecx
801005cb:	e9 07 ff ff ff       	jmp    801004d7 <consputc+0xe7>

  //if(pos > maximum_pos)
  //  maximum_pos = pos;

  if(c == '\n')
    pos += BUFF_SIZE - pos % BUFF_SIZE;
801005d0:	89 d8                	mov    %ebx,%eax
801005d2:	ba 67 66 66 66       	mov    $0x66666667,%edx
801005d7:	f7 ea                	imul   %edx
801005d9:	89 d0                	mov    %edx,%eax
801005db:	c1 e8 05             	shr    $0x5,%eax
801005de:	8d 04 80             	lea    (%eax,%eax,4),%eax
801005e1:	c1 e0 04             	shl    $0x4,%eax
801005e4:	8d 58 50             	lea    0x50(%eax),%ebx
801005e7:	e9 d4 fe ff ff       	jmp    801004c0 <consputc+0xd0>
  }

  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else if(c != UP && c != DOWN && c != LEFT && c != RIGHT){
    uartputc(c);
801005ec:	83 ec 0c             	sub    $0xc,%esp
801005ef:	56                   	push   %esi
801005f0:	e8 4b 67 00 00       	call   80106d40 <uartputc>
801005f5:	83 c4 10             	add    $0x10,%esp
801005f8:	e9 28 fe ff ff       	jmp    80100425 <consputc+0x35>
801005fd:	8d 76 00             	lea    0x0(%esi),%esi

80100600 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	89 d6                	mov    %edx,%esi
80100608:	83 ec 2c             	sub    $0x2c,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010060b:	85 c9                	test   %ecx,%ecx
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
8010060d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100610:	74 0c                	je     8010061e <printint+0x1e>
80100612:	89 c7                	mov    %eax,%edi
80100614:	c1 ef 1f             	shr    $0x1f,%edi
80100617:	85 c0                	test   %eax,%eax
80100619:	89 7d d4             	mov    %edi,-0x2c(%ebp)
8010061c:	78 51                	js     8010066f <printint+0x6f>
    x = -xx;
  else
    x = xx;

  i = 0;
8010061e:	31 ff                	xor    %edi,%edi
80100620:	8d 5d d7             	lea    -0x29(%ebp),%ebx
80100623:	eb 05                	jmp    8010062a <printint+0x2a>
80100625:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
80100628:	89 cf                	mov    %ecx,%edi
8010062a:	31 d2                	xor    %edx,%edx
8010062c:	8d 4f 01             	lea    0x1(%edi),%ecx
8010062f:	f7 f6                	div    %esi
80100631:	0f b6 92 f0 81 10 80 	movzbl -0x7fef7e10(%edx),%edx
  }while((x /= base) != 0);
80100638:	85 c0                	test   %eax,%eax
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
8010063a:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
8010063d:	75 e9                	jne    80100628 <printint+0x28>

  if(sign)
8010063f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100642:	85 c0                	test   %eax,%eax
80100644:	74 08                	je     8010064e <printint+0x4e>
    buf[i++] = '-';
80100646:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
8010064b:	8d 4f 02             	lea    0x2(%edi),%ecx
8010064e:	8d 74 0d d7          	lea    -0x29(%ebp,%ecx,1),%esi
80100652:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  while(--i >= 0)
    consputc(buf[i]);
80100658:	0f be 06             	movsbl (%esi),%eax
8010065b:	83 ee 01             	sub    $0x1,%esi
8010065e:	e8 8d fd ff ff       	call   801003f0 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
80100663:	39 de                	cmp    %ebx,%esi
80100665:	75 f1                	jne    80100658 <printint+0x58>
    consputc(buf[i]);
}
80100667:	83 c4 2c             	add    $0x2c,%esp
8010066a:	5b                   	pop    %ebx
8010066b:	5e                   	pop    %esi
8010066c:	5f                   	pop    %edi
8010066d:	5d                   	pop    %ebp
8010066e:	c3                   	ret    
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    x = -xx;
8010066f:	f7 d8                	neg    %eax
80100671:	eb ab                	jmp    8010061e <printint+0x1e>
80100673:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100679:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100680 <consolewrite>:
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100680:	55                   	push   %ebp
80100681:	89 e5                	mov    %esp,%ebp
80100683:	57                   	push   %edi
80100684:	56                   	push   %esi
80100685:	53                   	push   %ebx
80100686:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100689:	ff 75 08             	pushl  0x8(%ebp)
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
8010068c:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010068f:	e8 5c 12 00 00       	call   801018f0 <iunlock>
  acquire(&cons.lock);
80100694:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
8010069b:	e8 90 43 00 00       	call   80104a30 <acquire>
801006a0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  for(i = 0; i < n; i++)
801006a3:	83 c4 10             	add    $0x10,%esp
801006a6:	85 f6                	test   %esi,%esi
801006a8:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
801006ab:	7e 12                	jle    801006bf <consolewrite+0x3f>
801006ad:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
801006b0:	0f b6 07             	movzbl (%edi),%eax
801006b3:	83 c7 01             	add    $0x1,%edi
801006b6:	e8 35 fd ff ff       	call   801003f0 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
801006bb:	39 df                	cmp    %ebx,%edi
801006bd:	75 f1                	jne    801006b0 <consolewrite+0x30>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
801006bf:	83 ec 0c             	sub    $0xc,%esp
801006c2:	68 20 c5 10 80       	push   $0x8010c520
801006c7:	e8 14 44 00 00       	call   80104ae0 <release>
  ilock(ip);
801006cc:	58                   	pop    %eax
801006cd:	ff 75 08             	pushl  0x8(%ebp)
801006d0:	e8 3b 11 00 00       	call   80101810 <ilock>

  return n;
}
801006d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801006d8:	89 f0                	mov    %esi,%eax
801006da:	5b                   	pop    %ebx
801006db:	5e                   	pop    %esi
801006dc:	5f                   	pop    %edi
801006dd:	5d                   	pop    %ebp
801006de:	c3                   	ret    
801006df:	90                   	nop

801006e0 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801006e0:	55                   	push   %ebp
801006e1:	89 e5                	mov    %esp,%ebp
801006e3:	57                   	push   %edi
801006e4:	56                   	push   %esi
801006e5:	53                   	push   %ebx
801006e6:	83 ec 1c             	sub    $0x1c,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801006e9:	a1 54 c5 10 80       	mov    0x8010c554,%eax
  if(locking)
801006ee:	85 c0                	test   %eax,%eax
{
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801006f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
801006f3:	0f 85 47 01 00 00    	jne    80100840 <cprintf+0x160>
    acquire(&cons.lock);

  if (fmt == 0)
801006f9:	8b 45 08             	mov    0x8(%ebp),%eax
801006fc:	85 c0                	test   %eax,%eax
801006fe:	89 c1                	mov    %eax,%ecx
80100700:	0f 84 4f 01 00 00    	je     80100855 <cprintf+0x175>
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100706:	0f b6 00             	movzbl (%eax),%eax
80100709:	31 db                	xor    %ebx,%ebx
8010070b:	8d 75 0c             	lea    0xc(%ebp),%esi
8010070e:	89 cf                	mov    %ecx,%edi
80100710:	85 c0                	test   %eax,%eax
80100712:	75 55                	jne    80100769 <cprintf+0x89>
80100714:	eb 68                	jmp    8010077e <cprintf+0x9e>
80100716:	8d 76 00             	lea    0x0(%esi),%esi
80100719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c != '%'){
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
80100720:	83 c3 01             	add    $0x1,%ebx
80100723:	0f b6 14 1f          	movzbl (%edi,%ebx,1),%edx
    if(c == 0)
80100727:	85 d2                	test   %edx,%edx
80100729:	74 53                	je     8010077e <cprintf+0x9e>
      break;
    switch(c){
8010072b:	83 fa 70             	cmp    $0x70,%edx
8010072e:	74 7a                	je     801007aa <cprintf+0xca>
80100730:	7f 6e                	jg     801007a0 <cprintf+0xc0>
80100732:	83 fa 25             	cmp    $0x25,%edx
80100735:	0f 84 ad 00 00 00    	je     801007e8 <cprintf+0x108>
8010073b:	83 fa 64             	cmp    $0x64,%edx
8010073e:	0f 85 84 00 00 00    	jne    801007c8 <cprintf+0xe8>
    case 'd':
      printint(*argp++, 10, 1);
80100744:	8d 46 04             	lea    0x4(%esi),%eax
80100747:	b9 01 00 00 00       	mov    $0x1,%ecx
8010074c:	ba 0a 00 00 00       	mov    $0xa,%edx
80100751:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100754:	8b 06                	mov    (%esi),%eax
80100756:	e8 a5 fe ff ff       	call   80100600 <printint>
8010075b:	8b 75 e4             	mov    -0x1c(%ebp),%esi

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010075e:	83 c3 01             	add    $0x1,%ebx
80100761:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
80100765:	85 c0                	test   %eax,%eax
80100767:	74 15                	je     8010077e <cprintf+0x9e>
    if(c != '%'){
80100769:	83 f8 25             	cmp    $0x25,%eax
8010076c:	74 b2                	je     80100720 <cprintf+0x40>
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
8010076e:	e8 7d fc ff ff       	call   801003f0 <consputc>

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100773:	83 c3 01             	add    $0x1,%ebx
80100776:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
8010077a:	85 c0                	test   %eax,%eax
8010077c:	75 eb                	jne    80100769 <cprintf+0x89>
      consputc(c);
      break;
    }
  }

  if(locking)
8010077e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100781:	85 c0                	test   %eax,%eax
80100783:	74 10                	je     80100795 <cprintf+0xb5>
    release(&cons.lock);
80100785:	83 ec 0c             	sub    $0xc,%esp
80100788:	68 20 c5 10 80       	push   $0x8010c520
8010078d:	e8 4e 43 00 00       	call   80104ae0 <release>
80100792:	83 c4 10             	add    $0x10,%esp
}
80100795:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100798:	5b                   	pop    %ebx
80100799:	5e                   	pop    %esi
8010079a:	5f                   	pop    %edi
8010079b:	5d                   	pop    %ebp
8010079c:	c3                   	ret    
8010079d:	8d 76 00             	lea    0x0(%esi),%esi
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
801007a0:	83 fa 73             	cmp    $0x73,%edx
801007a3:	74 5b                	je     80100800 <cprintf+0x120>
801007a5:	83 fa 78             	cmp    $0x78,%edx
801007a8:	75 1e                	jne    801007c8 <cprintf+0xe8>
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
801007aa:	8d 46 04             	lea    0x4(%esi),%eax
801007ad:	31 c9                	xor    %ecx,%ecx
801007af:	ba 10 00 00 00       	mov    $0x10,%edx
801007b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801007b7:	8b 06                	mov    (%esi),%eax
801007b9:	e8 42 fe ff ff       	call   80100600 <printint>
801007be:	8b 75 e4             	mov    -0x1c(%ebp),%esi
      break;
801007c1:	eb 9b                	jmp    8010075e <cprintf+0x7e>
801007c3:	90                   	nop
801007c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
801007c8:	b8 25 00 00 00       	mov    $0x25,%eax
801007cd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801007d0:	e8 1b fc ff ff       	call   801003f0 <consputc>
      consputc(c);
801007d5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801007d8:	89 d0                	mov    %edx,%eax
801007da:	e8 11 fc ff ff       	call   801003f0 <consputc>
      break;
801007df:	e9 7a ff ff ff       	jmp    8010075e <cprintf+0x7e>
801007e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
801007e8:	b8 25 00 00 00       	mov    $0x25,%eax
801007ed:	e8 fe fb ff ff       	call   801003f0 <consputc>
801007f2:	e9 7c ff ff ff       	jmp    80100773 <cprintf+0x93>
801007f7:	89 f6                	mov    %esi,%esi
801007f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
80100800:	8d 46 04             	lea    0x4(%esi),%eax
80100803:	8b 36                	mov    (%esi),%esi
80100805:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        s = "(null)";
80100808:	b8 d8 81 10 80       	mov    $0x801081d8,%eax
8010080d:	85 f6                	test   %esi,%esi
8010080f:	0f 44 f0             	cmove  %eax,%esi
      for(; *s; s++)
80100812:	0f be 06             	movsbl (%esi),%eax
80100815:	84 c0                	test   %al,%al
80100817:	74 16                	je     8010082f <cprintf+0x14f>
80100819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100820:	83 c6 01             	add    $0x1,%esi
        consputc(*s);
80100823:	e8 c8 fb ff ff       	call   801003f0 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
80100828:	0f be 06             	movsbl (%esi),%eax
8010082b:	84 c0                	test   %al,%al
8010082d:	75 f1                	jne    80100820 <cprintf+0x140>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
8010082f:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80100832:	e9 27 ff ff ff       	jmp    8010075e <cprintf+0x7e>
80100837:	89 f6                	mov    %esi,%esi
80100839:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  uint *argp;
  char *s;

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);
80100840:	83 ec 0c             	sub    $0xc,%esp
80100843:	68 20 c5 10 80       	push   $0x8010c520
80100848:	e8 e3 41 00 00       	call   80104a30 <acquire>
8010084d:	83 c4 10             	add    $0x10,%esp
80100850:	e9 a4 fe ff ff       	jmp    801006f9 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
80100855:	83 ec 0c             	sub    $0xc,%esp
80100858:	68 df 81 10 80       	push   $0x801081df
8010085d:	e8 0e fb ff ff       	call   80100370 <panic>
80100862:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100869:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100870 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
80100870:	55                   	push   %ebp
80100871:	89 e5                	mov    %esp,%ebp
80100873:	57                   	push   %edi
80100874:	56                   	push   %esi
80100875:	53                   	push   %ebx
  int c, doprocdump = 0;
80100876:	31 f6                	xor    %esi,%esi

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
80100878:	83 ec 18             	sub    $0x18,%esp
8010087b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int c, doprocdump = 0;

  acquire(&cons.lock);
8010087e:	68 20 c5 10 80       	push   $0x8010c520
80100883:	e8 a8 41 00 00       	call   80104a30 <acquire>
  while((c = getc()) >= 0){
80100888:	83 c4 10             	add    $0x10,%esp
8010088b:	90                   	nop
8010088c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100890:	ff d3                	call   *%ebx
80100892:	85 c0                	test   %eax,%eax
80100894:	89 c7                	mov    %eax,%edi
80100896:	78 58                	js     801008f0 <consoleintr+0x80>
    switch(c){
80100898:	83 ff 7f             	cmp    $0x7f,%edi
8010089b:	0f 84 0f 02 00 00    	je     80100ab0 <consoleintr+0x240>
801008a1:	7e 6d                	jle    80100910 <consoleintr+0xa0>
801008a3:	81 ff e3 00 00 00    	cmp    $0xe3,%edi
801008a9:	0f 84 e9 01 00 00    	je     80100a98 <consoleintr+0x228>
801008af:	0f 8e 2b 01 00 00    	jle    801009e0 <consoleintr+0x170>
801008b5:	81 ff e4 00 00 00    	cmp    $0xe4,%edi
801008bb:	0f 84 4f 01 00 00    	je     80100a10 <consoleintr+0x1a0>
801008c1:	81 ff e5 00 00 00    	cmp    $0xe5,%edi
801008c7:	75 62                	jne    8010092b <consoleintr+0xbb>
	      input.e--;
        consputc(c);
      }
      break;
    case RIGHT:
      if(input.e < input.max){
801008c9:	a1 c8 1f 11 80       	mov    0x80111fc8,%eax
801008ce:	3b 05 cc 1f 11 80    	cmp    0x80111fcc,%eax
801008d4:	73 ba                	jae    80100890 <consoleintr+0x20>
	      input.e++;
801008d6:	83 c0 01             	add    $0x1,%eax
801008d9:	a3 c8 1f 11 80       	mov    %eax,0x80111fc8
        consputc(c);
801008de:	b8 e5 00 00 00       	mov    $0xe5,%eax
801008e3:	e8 08 fb ff ff       	call   801003f0 <consputc>
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
801008e8:	ff d3                	call   *%ebx
801008ea:	85 c0                	test   %eax,%eax
801008ec:	89 c7                	mov    %eax,%edi
801008ee:	79 a8                	jns    80100898 <consoleintr+0x28>
        }
      }
      break;
    }
  }
  release(&cons.lock);
801008f0:	83 ec 0c             	sub    $0xc,%esp
801008f3:	68 20 c5 10 80       	push   $0x8010c520
801008f8:	e8 e3 41 00 00       	call   80104ae0 <release>
  if(doprocdump) {
801008fd:	83 c4 10             	add    $0x10,%esp
80100900:	85 f6                	test   %esi,%esi
80100902:	0f 85 00 02 00 00    	jne    80100b08 <consoleintr+0x298>
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100908:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010090b:	5b                   	pop    %ebx
8010090c:	5e                   	pop    %esi
8010090d:	5f                   	pop    %edi
8010090e:	5d                   	pop    %ebp
8010090f:	c3                   	ret    
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
80100910:	83 ff 10             	cmp    $0x10,%edi
80100913:	0f 84 e7 00 00 00    	je     80100a00 <consoleintr+0x190>
80100919:	83 ff 15             	cmp    $0x15,%edi
8010091c:	0f 84 1e 01 00 00    	je     80100a40 <consoleintr+0x1d0>
80100922:	83 ff 08             	cmp    $0x8,%edi
80100925:	0f 84 85 01 00 00    	je     80100ab0 <consoleintr+0x240>
	      input.e++;
        consputc(c);
      }
      break;
    default:
      if(c != 0 && input.max < INPUT_BUF){
8010092b:	85 ff                	test   %edi,%edi
8010092d:	0f 84 5d ff ff ff    	je     80100890 <consoleintr+0x20>
80100933:	a1 cc 1f 11 80       	mov    0x80111fcc,%eax
80100938:	83 f8 7f             	cmp    $0x7f,%eax
8010093b:	0f 87 4f ff ff ff    	ja     80100890 <consoleintr+0x20>
        c = (c == '\r') ? '\n' : c;
80100941:	83 ff 0d             	cmp    $0xd,%edi
80100944:	0f 84 ca 01 00 00    	je     80100b14 <consoleintr+0x2a4>
	if(c != '\n'){
8010094a:	83 ff 0a             	cmp    $0xa,%edi
8010094d:	0f 84 c1 01 00 00    	je     80100b14 <consoleintr+0x2a4>
	  memmove(input.buf + input.e + 1, input.buf + input.e, input.max - input.e);	
80100953:	8b 15 c8 1f 11 80    	mov    0x80111fc8,%edx
80100959:	83 ec 04             	sub    $0x4,%esp
8010095c:	29 d0                	sub    %edx,%eax
8010095e:	50                   	push   %eax
8010095f:	8d 82 40 1f 11 80    	lea    -0x7feee0c0(%edx),%eax
80100965:	81 c2 41 1f 11 80    	add    $0x80111f41,%edx
8010096b:	50                   	push   %eax
8010096c:	52                   	push   %edx
8010096d:	e8 ee 43 00 00       	call   80104d60 <memmove>
	  input.buf[input.e++ % INPUT_BUF] = c;
80100972:	a1 c8 1f 11 80       	mov    0x80111fc8,%eax
80100977:	89 f9                	mov    %edi,%ecx
	  input.max++;
80100979:	83 05 cc 1f 11 80 01 	addl   $0x1,0x80111fcc
    default:
      if(c != 0 && input.max < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
	if(c != '\n'){
	  memmove(input.buf + input.e + 1, input.buf + input.e, input.max - input.e);	
	  input.buf[input.e++ % INPUT_BUF] = c;
80100980:	8d 50 01             	lea    0x1(%eax),%edx
80100983:	83 e0 7f             	and    $0x7f,%eax
80100986:	88 88 40 1f 11 80    	mov    %cl,-0x7feee0c0(%eax)
	  input.max++;
	  consputc(c);
8010098c:	89 f8                	mov    %edi,%eax
    default:
      if(c != 0 && input.max < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
	if(c != '\n'){
	  memmove(input.buf + input.e + 1, input.buf + input.e, input.max - input.e);	
	  input.buf[input.e++ % INPUT_BUF] = c;
8010098e:	89 15 c8 1f 11 80    	mov    %edx,0x80111fc8
	  input.max++;
	  consputc(c);
80100994:	e8 57 fa ff ff       	call   801003f0 <consputc>
	}
        else{
          input.buf[input.max++ % INPUT_BUF] = c;
          consputc(c);
        }
        if(c == '\n' || c == C('D') || input.max == input.r + INPUT_BUF){
80100999:	83 c4 10             	add    $0x10,%esp
8010099c:	83 ff 04             	cmp    $0x4,%edi
8010099f:	0f 84 89 01 00 00    	je     80100b2e <consoleintr+0x2be>
801009a5:	a1 c0 1f 11 80       	mov    0x80111fc0,%eax
801009aa:	83 e8 80             	sub    $0xffffff80,%eax
801009ad:	39 05 cc 1f 11 80    	cmp    %eax,0x80111fcc
801009b3:	0f 85 d7 fe ff ff    	jne    80100890 <consoleintr+0x20>
          input.w = input.max;
	  input.e = input.max;
          wakeup(&input.r);
801009b9:	83 ec 0c             	sub    $0xc,%esp
        else{
          input.buf[input.max++ % INPUT_BUF] = c;
          consputc(c);
        }
        if(c == '\n' || c == C('D') || input.max == input.r + INPUT_BUF){
          input.w = input.max;
801009bc:	a3 c4 1f 11 80       	mov    %eax,0x80111fc4
	  input.e = input.max;
801009c1:	a3 c8 1f 11 80       	mov    %eax,0x80111fc8
          wakeup(&input.r);
801009c6:	68 c0 1f 11 80       	push   $0x80111fc0
801009cb:	e8 00 37 00 00       	call   801040d0 <wakeup>
801009d0:	83 c4 10             	add    $0x10,%esp
801009d3:	e9 b8 fe ff ff       	jmp    80100890 <consoleintr+0x20>
801009d8:	90                   	nop
801009d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
801009e0:	81 ff e2 00 00 00    	cmp    $0xe2,%edi
801009e6:	0f 85 3f ff ff ff    	jne    8010092b <consoleintr+0xbb>
        memmove(input.buf + input.e, input.buf + input.e + 1, input.max - input.e); // TODO: check indices
        consputc(BACKSPACE);
      }
      break;
    case UP:
      consputc(c);
801009ec:	b8 e2 00 00 00       	mov    $0xe2,%eax
801009f1:	e8 fa f9 ff ff       	call   801003f0 <consputc>
      break;
801009f6:	e9 95 fe ff ff       	jmp    80100890 <consoleintr+0x20>
801009fb:	90                   	nop
801009fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
80100a00:	be 01 00 00 00       	mov    $0x1,%esi
80100a05:	e9 86 fe ff ff       	jmp    80100890 <consoleintr+0x20>
80100a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      break;
    case DOWN:
      consputc(c);
      break;
    case LEFT:
      if(input.e != input.w){
80100a10:	a1 c8 1f 11 80       	mov    0x80111fc8,%eax
80100a15:	3b 05 c4 1f 11 80    	cmp    0x80111fc4,%eax
80100a1b:	0f 84 6f fe ff ff    	je     80100890 <consoleintr+0x20>
	      input.e--;
80100a21:	83 e8 01             	sub    $0x1,%eax
80100a24:	a3 c8 1f 11 80       	mov    %eax,0x80111fc8
        consputc(c);
80100a29:	b8 e4 00 00 00       	mov    $0xe4,%eax
80100a2e:	e8 bd f9 ff ff       	call   801003f0 <consputc>
80100a33:	e9 58 fe ff ff       	jmp    80100890 <consoleintr+0x20>
80100a38:	90                   	nop
80100a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.max != input.w &&
80100a40:	a1 cc 1f 11 80       	mov    0x80111fcc,%eax
80100a45:	39 05 c4 1f 11 80    	cmp    %eax,0x80111fc4
80100a4b:	75 32                	jne    80100a7f <consoleintr+0x20f>
80100a4d:	e9 3e fe ff ff       	jmp    80100890 <consoleintr+0x20>
80100a52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            input.buf[(input.max-1) % INPUT_BUF] != '\n'){
        input.max--;
80100a58:	a3 cc 1f 11 80       	mov    %eax,0x80111fcc
	      input.e--;
        consputc(BACKSPACE);
80100a5d:	b8 00 01 00 00       	mov    $0x100,%eax
      break;
    case C('U'):  // Kill line.
      while(input.max != input.w &&
            input.buf[(input.max-1) % INPUT_BUF] != '\n'){
        input.max--;
	      input.e--;
80100a62:	83 2d c8 1f 11 80 01 	subl   $0x1,0x80111fc8
        consputc(BACKSPACE);
80100a69:	e8 82 f9 ff ff       	call   801003f0 <consputc>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.max != input.w &&
80100a6e:	a1 cc 1f 11 80       	mov    0x80111fcc,%eax
80100a73:	3b 05 c4 1f 11 80    	cmp    0x80111fc4,%eax
80100a79:	0f 84 11 fe ff ff    	je     80100890 <consoleintr+0x20>
            input.buf[(input.max-1) % INPUT_BUF] != '\n'){
80100a7f:	83 e8 01             	sub    $0x1,%eax
80100a82:	89 c2                	mov    %eax,%edx
80100a84:	83 e2 7f             	and    $0x7f,%edx
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.max != input.w &&
80100a87:	80 ba 40 1f 11 80 0a 	cmpb   $0xa,-0x7feee0c0(%edx)
80100a8e:	75 c8                	jne    80100a58 <consoleintr+0x1e8>
80100a90:	e9 fb fd ff ff       	jmp    80100890 <consoleintr+0x20>
80100a95:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    case UP:
      consputc(c);
      break;
    case DOWN:
      consputc(c);
80100a98:	b8 e3 00 00 00       	mov    $0xe3,%eax
80100a9d:	e8 4e f9 ff ff       	call   801003f0 <consputc>
      break;
80100aa2:	e9 e9 fd ff ff       	jmp    80100890 <consoleintr+0x20>
80100aa7:	89 f6                	mov    %esi,%esi
80100aa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
	      input.e--;
        consputc(BACKSPACE);
      }
      break;
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100ab0:	a1 c8 1f 11 80       	mov    0x80111fc8,%eax
80100ab5:	3b 05 c4 1f 11 80    	cmp    0x80111fc4,%eax
80100abb:	0f 84 cf fd ff ff    	je     80100890 <consoleintr+0x20>
        input.max--;
80100ac1:	8b 0d cc 1f 11 80    	mov    0x80111fcc,%ecx
	      input.e--;
        memmove(input.buf + input.e, input.buf + input.e + 1, input.max - input.e); // TODO: check indices
80100ac7:	83 ec 04             	sub    $0x4,%esp
        consputc(BACKSPACE);
      }
      break;
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
        input.max--;
80100aca:	8d 51 ff             	lea    -0x1(%ecx),%edx
	      input.e--;
80100acd:	8d 48 ff             	lea    -0x1(%eax),%ecx
        memmove(input.buf + input.e, input.buf + input.e + 1, input.max - input.e); // TODO: check indices
80100ad0:	05 40 1f 11 80       	add    $0x80111f40,%eax
        consputc(BACKSPACE);
      }
      break;
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
        input.max--;
80100ad5:	89 15 cc 1f 11 80    	mov    %edx,0x80111fcc
	      input.e--;
80100adb:	89 0d c8 1f 11 80    	mov    %ecx,0x80111fc8
        memmove(input.buf + input.e, input.buf + input.e + 1, input.max - input.e); // TODO: check indices
80100ae1:	29 ca                	sub    %ecx,%edx
80100ae3:	81 c1 40 1f 11 80    	add    $0x80111f40,%ecx
80100ae9:	52                   	push   %edx
80100aea:	50                   	push   %eax
80100aeb:	51                   	push   %ecx
80100aec:	e8 6f 42 00 00       	call   80104d60 <memmove>
        consputc(BACKSPACE);
80100af1:	b8 00 01 00 00       	mov    $0x100,%eax
80100af6:	e8 f5 f8 ff ff       	call   801003f0 <consputc>
80100afb:	83 c4 10             	add    $0x10,%esp
80100afe:	e9 8d fd ff ff       	jmp    80100890 <consoleintr+0x20>
80100b03:	90                   	nop
80100b04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100b08:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b0b:	5b                   	pop    %ebx
80100b0c:	5e                   	pop    %esi
80100b0d:	5f                   	pop    %edi
80100b0e:	5d                   	pop    %ebp
      break;
    }
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
80100b0f:	e9 8c 3b 00 00       	jmp    801046a0 <procdump>
	  input.buf[input.e++ % INPUT_BUF] = c;
	  input.max++;
	  consputc(c);
	}
        else{
          input.buf[input.max++ % INPUT_BUF] = c;
80100b14:	8d 50 01             	lea    0x1(%eax),%edx
80100b17:	c6 80 40 1f 11 80 0a 	movb   $0xa,-0x7feee0c0(%eax)
          consputc(c);
80100b1e:	b8 0a 00 00 00       	mov    $0xa,%eax
	  input.buf[input.e++ % INPUT_BUF] = c;
	  input.max++;
	  consputc(c);
	}
        else{
          input.buf[input.max++ % INPUT_BUF] = c;
80100b23:	89 15 cc 1f 11 80    	mov    %edx,0x80111fcc
          consputc(c);
80100b29:	e8 c2 f8 ff ff       	call   801003f0 <consputc>
80100b2e:	a1 cc 1f 11 80       	mov    0x80111fcc,%eax
80100b33:	e9 81 fe ff ff       	jmp    801009b9 <consoleintr+0x149>
80100b38:	90                   	nop
80100b39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100b40 <consoleinit>:
  return n;
}

void
consoleinit(void)
{
80100b40:	55                   	push   %ebp
80100b41:	89 e5                	mov    %esp,%ebp
80100b43:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100b46:	68 e8 81 10 80       	push   $0x801081e8
80100b4b:	68 20 c5 10 80       	push   $0x8010c520
80100b50:	e8 7b 3d 00 00       	call   801048d0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100b55:	58                   	pop    %eax
80100b56:	5a                   	pop    %edx
80100b57:	6a 00                	push   $0x0
80100b59:	6a 01                	push   $0x1
void
consoleinit(void)
{
  initlock(&cons.lock, "console");

  devsw[CONSOLE].write = consolewrite;
80100b5b:	c7 05 8c 29 11 80 80 	movl   $0x80100680,0x8011298c
80100b62:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100b65:	c7 05 88 29 11 80 70 	movl   $0x80100270,0x80112988
80100b6c:	02 10 80 
  cons.locking = 1;
80100b6f:	c7 05 54 c5 10 80 01 	movl   $0x1,0x8010c554
80100b76:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
80100b79:	e8 c2 18 00 00       	call   80102440 <ioapicenable>
}
80100b7e:	83 c4 10             	add    $0x10,%esp
80100b81:	c9                   	leave  
80100b82:	c3                   	ret    
80100b83:	66 90                	xchg   %ax,%ax
80100b85:	66 90                	xchg   %ax,%ax
80100b87:	66 90                	xchg   %ax,%ax
80100b89:	66 90                	xchg   %ax,%ax
80100b8b:	66 90                	xchg   %ax,%ax
80100b8d:	66 90                	xchg   %ax,%ax
80100b8f:	90                   	nop

80100b90 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100b90:	55                   	push   %ebp
80100b91:	89 e5                	mov    %esp,%ebp
80100b93:	57                   	push   %edi
80100b94:	56                   	push   %esi
80100b95:	53                   	push   %ebx
80100b96:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100b9c:	e8 af 2d 00 00       	call   80103950 <myproc>
80100ba1:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100ba7:	e8 44 21 00 00       	call   80102cf0 <begin_op>

  if((ip = namei(path)) == 0){
80100bac:	83 ec 0c             	sub    $0xc,%esp
80100baf:	ff 75 08             	pushl  0x8(%ebp)
80100bb2:	e8 a9 14 00 00       	call   80102060 <namei>
80100bb7:	83 c4 10             	add    $0x10,%esp
80100bba:	85 c0                	test   %eax,%eax
80100bbc:	0f 84 9c 01 00 00    	je     80100d5e <exec+0x1ce>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100bc2:	83 ec 0c             	sub    $0xc,%esp
80100bc5:	89 c3                	mov    %eax,%ebx
80100bc7:	50                   	push   %eax
80100bc8:	e8 43 0c 00 00       	call   80101810 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100bcd:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100bd3:	6a 34                	push   $0x34
80100bd5:	6a 00                	push   $0x0
80100bd7:	50                   	push   %eax
80100bd8:	53                   	push   %ebx
80100bd9:	e8 12 0f 00 00       	call   80101af0 <readi>
80100bde:	83 c4 20             	add    $0x20,%esp
80100be1:	83 f8 34             	cmp    $0x34,%eax
80100be4:	74 22                	je     80100c08 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100be6:	83 ec 0c             	sub    $0xc,%esp
80100be9:	53                   	push   %ebx
80100bea:	e8 b1 0e 00 00       	call   80101aa0 <iunlockput>
    end_op();
80100bef:	e8 6c 21 00 00       	call   80102d60 <end_op>
80100bf4:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100bf7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100bfc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100bff:	5b                   	pop    %ebx
80100c00:	5e                   	pop    %esi
80100c01:	5f                   	pop    %edi
80100c02:	5d                   	pop    %ebp
80100c03:	c3                   	ret    
80100c04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100c08:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100c0f:	45 4c 46 
80100c12:	75 d2                	jne    80100be6 <exec+0x56>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100c14:	e8 b7 72 00 00       	call   80107ed0 <setupkvm>
80100c19:	85 c0                	test   %eax,%eax
80100c1b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100c21:	74 c3                	je     80100be6 <exec+0x56>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c23:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100c2a:	00 
80100c2b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100c31:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
80100c38:	00 00 00 
80100c3b:	0f 84 c5 00 00 00    	je     80100d06 <exec+0x176>
80100c41:	31 ff                	xor    %edi,%edi
80100c43:	eb 18                	jmp    80100c5d <exec+0xcd>
80100c45:	8d 76 00             	lea    0x0(%esi),%esi
80100c48:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100c4f:	83 c7 01             	add    $0x1,%edi
80100c52:	83 c6 20             	add    $0x20,%esi
80100c55:	39 f8                	cmp    %edi,%eax
80100c57:	0f 8e a9 00 00 00    	jle    80100d06 <exec+0x176>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100c5d:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100c63:	6a 20                	push   $0x20
80100c65:	56                   	push   %esi
80100c66:	50                   	push   %eax
80100c67:	53                   	push   %ebx
80100c68:	e8 83 0e 00 00       	call   80101af0 <readi>
80100c6d:	83 c4 10             	add    $0x10,%esp
80100c70:	83 f8 20             	cmp    $0x20,%eax
80100c73:	75 7b                	jne    80100cf0 <exec+0x160>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100c75:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100c7c:	75 ca                	jne    80100c48 <exec+0xb8>
      continue;
    if(ph.memsz < ph.filesz)
80100c7e:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100c84:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100c8a:	72 64                	jb     80100cf0 <exec+0x160>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100c8c:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100c92:	72 5c                	jb     80100cf0 <exec+0x160>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100c94:	83 ec 04             	sub    $0x4,%esp
80100c97:	50                   	push   %eax
80100c98:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100c9e:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100ca4:	e8 77 70 00 00       	call   80107d20 <allocuvm>
80100ca9:	83 c4 10             	add    $0x10,%esp
80100cac:	85 c0                	test   %eax,%eax
80100cae:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100cb4:	74 3a                	je     80100cf0 <exec+0x160>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100cb6:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100cbc:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100cc1:	75 2d                	jne    80100cf0 <exec+0x160>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100cc3:	83 ec 0c             	sub    $0xc,%esp
80100cc6:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100ccc:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100cd2:	53                   	push   %ebx
80100cd3:	50                   	push   %eax
80100cd4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100cda:	e8 81 6f 00 00       	call   80107c60 <loaduvm>
80100cdf:	83 c4 20             	add    $0x20,%esp
80100ce2:	85 c0                	test   %eax,%eax
80100ce4:	0f 89 5e ff ff ff    	jns    80100c48 <exec+0xb8>
80100cea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100cf0:	83 ec 0c             	sub    $0xc,%esp
80100cf3:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100cf9:	e8 52 71 00 00       	call   80107e50 <freevm>
80100cfe:	83 c4 10             	add    $0x10,%esp
80100d01:	e9 e0 fe ff ff       	jmp    80100be6 <exec+0x56>
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100d06:	83 ec 0c             	sub    $0xc,%esp
80100d09:	53                   	push   %ebx
80100d0a:	e8 91 0d 00 00       	call   80101aa0 <iunlockput>
  end_op();
80100d0f:	e8 4c 20 00 00       	call   80102d60 <end_op>
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100d14:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100d1a:	83 c4 0c             	add    $0xc,%esp
  end_op();
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100d1d:	05 ff 0f 00 00       	add    $0xfff,%eax
80100d22:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100d27:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100d2d:	52                   	push   %edx
80100d2e:	50                   	push   %eax
80100d2f:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100d35:	e8 e6 6f 00 00       	call   80107d20 <allocuvm>
80100d3a:	83 c4 10             	add    $0x10,%esp
80100d3d:	85 c0                	test   %eax,%eax
80100d3f:	89 c6                	mov    %eax,%esi
80100d41:	75 3a                	jne    80100d7d <exec+0x1ed>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100d43:	83 ec 0c             	sub    $0xc,%esp
80100d46:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100d4c:	e8 ff 70 00 00       	call   80107e50 <freevm>
80100d51:	83 c4 10             	add    $0x10,%esp
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
80100d54:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d59:	e9 9e fe ff ff       	jmp    80100bfc <exec+0x6c>
  struct proc *curproc = myproc();

  begin_op();

  if((ip = namei(path)) == 0){
    end_op();
80100d5e:	e8 fd 1f 00 00       	call   80102d60 <end_op>
    cprintf("exec: fail\n");
80100d63:	83 ec 0c             	sub    $0xc,%esp
80100d66:	68 01 82 10 80       	push   $0x80108201
80100d6b:	e8 70 f9 ff ff       	call   801006e0 <cprintf>
    return -1;
80100d70:	83 c4 10             	add    $0x10,%esp
80100d73:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d78:	e9 7f fe ff ff       	jmp    80100bfc <exec+0x6c>
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100d7d:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100d83:	83 ec 08             	sub    $0x8,%esp
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d86:	31 ff                	xor    %edi,%edi
80100d88:	89 f3                	mov    %esi,%ebx
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100d8a:	50                   	push   %eax
80100d8b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100d91:	e8 da 71 00 00       	call   80107f70 <clearpteu>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d96:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d99:	83 c4 10             	add    $0x10,%esp
80100d9c:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100da2:	8b 00                	mov    (%eax),%eax
80100da4:	85 c0                	test   %eax,%eax
80100da6:	74 79                	je     80100e21 <exec+0x291>
80100da8:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100dae:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100db4:	eb 13                	jmp    80100dc9 <exec+0x239>
80100db6:	8d 76 00             	lea    0x0(%esi),%esi
80100db9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(argc >= MAXARG)
80100dc0:	83 ff 20             	cmp    $0x20,%edi
80100dc3:	0f 84 7a ff ff ff    	je     80100d43 <exec+0x1b3>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100dc9:	83 ec 0c             	sub    $0xc,%esp
80100dcc:	50                   	push   %eax
80100dcd:	e8 1e 41 00 00       	call   80104ef0 <strlen>
80100dd2:	f7 d0                	not    %eax
80100dd4:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100dd6:	8b 45 0c             	mov    0xc(%ebp),%eax
80100dd9:	5a                   	pop    %edx

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100dda:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ddd:	ff 34 b8             	pushl  (%eax,%edi,4)
80100de0:	e8 0b 41 00 00       	call   80104ef0 <strlen>
80100de5:	83 c0 01             	add    $0x1,%eax
80100de8:	50                   	push   %eax
80100de9:	8b 45 0c             	mov    0xc(%ebp),%eax
80100dec:	ff 34 b8             	pushl  (%eax,%edi,4)
80100def:	53                   	push   %ebx
80100df0:	56                   	push   %esi
80100df1:	e8 ea 72 00 00       	call   801080e0 <copyout>
80100df6:	83 c4 20             	add    $0x20,%esp
80100df9:	85 c0                	test   %eax,%eax
80100dfb:	0f 88 42 ff ff ff    	js     80100d43 <exec+0x1b3>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100e01:	8b 45 0c             	mov    0xc(%ebp),%eax
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100e04:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100e0b:	83 c7 01             	add    $0x1,%edi
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100e0e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100e14:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100e17:	85 c0                	test   %eax,%eax
80100e19:	75 a5                	jne    80100dc0 <exec+0x230>
80100e1b:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e21:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100e28:	89 d9                	mov    %ebx,%ecx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100e2a:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100e31:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100e35:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100e3c:	ff ff ff 
  ustack[1] = argc;
80100e3f:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e45:	29 c1                	sub    %eax,%ecx

  sp -= (3+argc+1) * 4;
80100e47:	83 c0 0c             	add    $0xc,%eax
80100e4a:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100e4c:	50                   	push   %eax
80100e4d:	52                   	push   %edx
80100e4e:	53                   	push   %ebx
80100e4f:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e55:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100e5b:	e8 80 72 00 00       	call   801080e0 <copyout>
80100e60:	83 c4 10             	add    $0x10,%esp
80100e63:	85 c0                	test   %eax,%eax
80100e65:	0f 88 d8 fe ff ff    	js     80100d43 <exec+0x1b3>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e6b:	8b 45 08             	mov    0x8(%ebp),%eax
80100e6e:	0f b6 10             	movzbl (%eax),%edx
80100e71:	84 d2                	test   %dl,%dl
80100e73:	74 19                	je     80100e8e <exec+0x2fe>
80100e75:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100e78:	83 c0 01             	add    $0x1,%eax
    if(*s == '/')
      last = s+1;
80100e7b:	80 fa 2f             	cmp    $0x2f,%dl
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e7e:	0f b6 10             	movzbl (%eax),%edx
    if(*s == '/')
      last = s+1;
80100e81:	0f 44 c8             	cmove  %eax,%ecx
80100e84:	83 c0 01             	add    $0x1,%eax
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e87:	84 d2                	test   %dl,%dl
80100e89:	75 f0                	jne    80100e7b <exec+0x2eb>
80100e8b:	89 4d 08             	mov    %ecx,0x8(%ebp)
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100e8e:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100e94:	50                   	push   %eax
80100e95:	6a 10                	push   $0x10
80100e97:	ff 75 08             	pushl  0x8(%ebp)
80100e9a:	89 f8                	mov    %edi,%eax
80100e9c:	83 c0 6c             	add    $0x6c,%eax
80100e9f:	50                   	push   %eax
80100ea0:	e8 0b 40 00 00       	call   80104eb0 <safestrcpy>

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
80100ea5:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
80100eab:	89 f8                	mov    %edi,%eax
80100ead:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->pgdir = pgdir;
  curproc->sz = sz;
80100eb0:	89 30                	mov    %esi,(%eax)
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
80100eb2:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->sz = sz;
  curproc->tf->eip = elf.entry;  // main
80100eb5:	89 c1                	mov    %eax,%ecx
80100eb7:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100ebd:	8b 40 18             	mov    0x18(%eax),%eax
80100ec0:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100ec3:	8b 41 18             	mov    0x18(%ecx),%eax
80100ec6:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100ec9:	89 0c 24             	mov    %ecx,(%esp)
80100ecc:	e8 ff 6b 00 00       	call   80107ad0 <switchuvm>
  freevm(oldpgdir);
80100ed1:	89 3c 24             	mov    %edi,(%esp)
80100ed4:	e8 77 6f 00 00       	call   80107e50 <freevm>
  return 0;
80100ed9:	83 c4 10             	add    $0x10,%esp
80100edc:	31 c0                	xor    %eax,%eax
80100ede:	e9 19 fd ff ff       	jmp    80100bfc <exec+0x6c>
80100ee3:	66 90                	xchg   %ax,%ax
80100ee5:	66 90                	xchg   %ax,%ax
80100ee7:	66 90                	xchg   %ax,%ax
80100ee9:	66 90                	xchg   %ax,%ax
80100eeb:	66 90                	xchg   %ax,%ax
80100eed:	66 90                	xchg   %ax,%ax
80100eef:	90                   	nop

80100ef0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100ef0:	55                   	push   %ebp
80100ef1:	89 e5                	mov    %esp,%ebp
80100ef3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100ef6:	68 0d 82 10 80       	push   $0x8010820d
80100efb:	68 e0 1f 11 80       	push   $0x80111fe0
80100f00:	e8 cb 39 00 00       	call   801048d0 <initlock>
}
80100f05:	83 c4 10             	add    $0x10,%esp
80100f08:	c9                   	leave  
80100f09:	c3                   	ret    
80100f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100f10 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f10:	55                   	push   %ebp
80100f11:	89 e5                	mov    %esp,%ebp
80100f13:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f14:	bb 14 20 11 80       	mov    $0x80112014,%ebx
}

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f19:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
80100f1c:	68 e0 1f 11 80       	push   $0x80111fe0
80100f21:	e8 0a 3b 00 00       	call   80104a30 <acquire>
80100f26:	83 c4 10             	add    $0x10,%esp
80100f29:	eb 10                	jmp    80100f3b <filealloc+0x2b>
80100f2b:	90                   	nop
80100f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f30:	83 c3 18             	add    $0x18,%ebx
80100f33:	81 fb 74 29 11 80    	cmp    $0x80112974,%ebx
80100f39:	74 25                	je     80100f60 <filealloc+0x50>
    if(f->ref == 0){
80100f3b:	8b 43 04             	mov    0x4(%ebx),%eax
80100f3e:	85 c0                	test   %eax,%eax
80100f40:	75 ee                	jne    80100f30 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100f42:	83 ec 0c             	sub    $0xc,%esp
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
80100f45:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100f4c:	68 e0 1f 11 80       	push   $0x80111fe0
80100f51:	e8 8a 3b 00 00       	call   80104ae0 <release>
      return f;
80100f56:	89 d8                	mov    %ebx,%eax
80100f58:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ftable.lock);
  return 0;
}
80100f5b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f5e:	c9                   	leave  
80100f5f:	c3                   	ret    
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100f60:	83 ec 0c             	sub    $0xc,%esp
80100f63:	68 e0 1f 11 80       	push   $0x80111fe0
80100f68:	e8 73 3b 00 00       	call   80104ae0 <release>
  return 0;
80100f6d:	83 c4 10             	add    $0x10,%esp
80100f70:	31 c0                	xor    %eax,%eax
}
80100f72:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f75:	c9                   	leave  
80100f76:	c3                   	ret    
80100f77:	89 f6                	mov    %esi,%esi
80100f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f80 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100f80:	55                   	push   %ebp
80100f81:	89 e5                	mov    %esp,%ebp
80100f83:	53                   	push   %ebx
80100f84:	83 ec 10             	sub    $0x10,%esp
80100f87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100f8a:	68 e0 1f 11 80       	push   $0x80111fe0
80100f8f:	e8 9c 3a 00 00       	call   80104a30 <acquire>
  if(f->ref < 1)
80100f94:	8b 43 04             	mov    0x4(%ebx),%eax
80100f97:	83 c4 10             	add    $0x10,%esp
80100f9a:	85 c0                	test   %eax,%eax
80100f9c:	7e 1a                	jle    80100fb8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100f9e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100fa1:	83 ec 0c             	sub    $0xc,%esp
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
  f->ref++;
80100fa4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100fa7:	68 e0 1f 11 80       	push   $0x80111fe0
80100fac:	e8 2f 3b 00 00       	call   80104ae0 <release>
  return f;
}
80100fb1:	89 d8                	mov    %ebx,%eax
80100fb3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100fb6:	c9                   	leave  
80100fb7:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
80100fb8:	83 ec 0c             	sub    $0xc,%esp
80100fbb:	68 14 82 10 80       	push   $0x80108214
80100fc0:	e8 ab f3 ff ff       	call   80100370 <panic>
80100fc5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100fd0 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100fd0:	55                   	push   %ebp
80100fd1:	89 e5                	mov    %esp,%ebp
80100fd3:	57                   	push   %edi
80100fd4:	56                   	push   %esi
80100fd5:	53                   	push   %ebx
80100fd6:	83 ec 28             	sub    $0x28,%esp
80100fd9:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100fdc:	68 e0 1f 11 80       	push   $0x80111fe0
80100fe1:	e8 4a 3a 00 00       	call   80104a30 <acquire>
  if(f->ref < 1)
80100fe6:	8b 47 04             	mov    0x4(%edi),%eax
80100fe9:	83 c4 10             	add    $0x10,%esp
80100fec:	85 c0                	test   %eax,%eax
80100fee:	0f 8e 9b 00 00 00    	jle    8010108f <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100ff4:	83 e8 01             	sub    $0x1,%eax
80100ff7:	85 c0                	test   %eax,%eax
80100ff9:	89 47 04             	mov    %eax,0x4(%edi)
80100ffc:	74 1a                	je     80101018 <fileclose+0x48>
    release(&ftable.lock);
80100ffe:	c7 45 08 e0 1f 11 80 	movl   $0x80111fe0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80101005:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101008:	5b                   	pop    %ebx
80101009:	5e                   	pop    %esi
8010100a:	5f                   	pop    %edi
8010100b:	5d                   	pop    %ebp

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
8010100c:	e9 cf 3a 00 00       	jmp    80104ae0 <release>
80101011:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return;
  }
  ff = *f;
80101018:	0f b6 47 09          	movzbl 0x9(%edi),%eax
8010101c:	8b 1f                	mov    (%edi),%ebx
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
8010101e:	83 ec 0c             	sub    $0xc,%esp
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80101021:	8b 77 0c             	mov    0xc(%edi),%esi
  f->ref = 0;
  f->type = FD_NONE;
80101024:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
8010102a:	88 45 e7             	mov    %al,-0x19(%ebp)
8010102d:	8b 47 10             	mov    0x10(%edi),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80101030:	68 e0 1f 11 80       	push   $0x80111fe0
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80101035:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80101038:	e8 a3 3a 00 00       	call   80104ae0 <release>

  if(ff.type == FD_PIPE)
8010103d:	83 c4 10             	add    $0x10,%esp
80101040:	83 fb 01             	cmp    $0x1,%ebx
80101043:	74 13                	je     80101058 <fileclose+0x88>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80101045:	83 fb 02             	cmp    $0x2,%ebx
80101048:	74 26                	je     80101070 <fileclose+0xa0>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
8010104a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010104d:	5b                   	pop    %ebx
8010104e:	5e                   	pop    %esi
8010104f:	5f                   	pop    %edi
80101050:	5d                   	pop    %ebp
80101051:	c3                   	ret    
80101052:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);

  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
80101058:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
8010105c:	83 ec 08             	sub    $0x8,%esp
8010105f:	53                   	push   %ebx
80101060:	56                   	push   %esi
80101061:	e8 2a 24 00 00       	call   80103490 <pipeclose>
80101066:	83 c4 10             	add    $0x10,%esp
80101069:	eb df                	jmp    8010104a <fileclose+0x7a>
8010106b:	90                   	nop
8010106c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  else if(ff.type == FD_INODE){
    begin_op();
80101070:	e8 7b 1c 00 00       	call   80102cf0 <begin_op>
    iput(ff.ip);
80101075:	83 ec 0c             	sub    $0xc,%esp
80101078:	ff 75 e0             	pushl  -0x20(%ebp)
8010107b:	e8 c0 08 00 00       	call   80101940 <iput>
    end_op();
80101080:	83 c4 10             	add    $0x10,%esp
  }
}
80101083:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101086:	5b                   	pop    %ebx
80101087:	5e                   	pop    %esi
80101088:	5f                   	pop    %edi
80101089:	5d                   	pop    %ebp
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
8010108a:	e9 d1 1c 00 00       	jmp    80102d60 <end_op>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
8010108f:	83 ec 0c             	sub    $0xc,%esp
80101092:	68 1c 82 10 80       	push   $0x8010821c
80101097:	e8 d4 f2 ff ff       	call   80100370 <panic>
8010109c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801010a0 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801010a0:	55                   	push   %ebp
801010a1:	89 e5                	mov    %esp,%ebp
801010a3:	53                   	push   %ebx
801010a4:	83 ec 04             	sub    $0x4,%esp
801010a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
801010aa:	83 3b 02             	cmpl   $0x2,(%ebx)
801010ad:	75 31                	jne    801010e0 <filestat+0x40>
    ilock(f->ip);
801010af:	83 ec 0c             	sub    $0xc,%esp
801010b2:	ff 73 10             	pushl  0x10(%ebx)
801010b5:	e8 56 07 00 00       	call   80101810 <ilock>
    stati(f->ip, st);
801010ba:	58                   	pop    %eax
801010bb:	5a                   	pop    %edx
801010bc:	ff 75 0c             	pushl  0xc(%ebp)
801010bf:	ff 73 10             	pushl  0x10(%ebx)
801010c2:	e8 f9 09 00 00       	call   80101ac0 <stati>
    iunlock(f->ip);
801010c7:	59                   	pop    %ecx
801010c8:	ff 73 10             	pushl  0x10(%ebx)
801010cb:	e8 20 08 00 00       	call   801018f0 <iunlock>
    return 0;
801010d0:	83 c4 10             	add    $0x10,%esp
801010d3:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
801010d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801010d8:	c9                   	leave  
801010d9:	c3                   	ret    
801010da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
801010e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801010e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801010e8:	c9                   	leave  
801010e9:	c3                   	ret    
801010ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801010f0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
801010f0:	55                   	push   %ebp
801010f1:	89 e5                	mov    %esp,%ebp
801010f3:	57                   	push   %edi
801010f4:	56                   	push   %esi
801010f5:	53                   	push   %ebx
801010f6:	83 ec 0c             	sub    $0xc,%esp
801010f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801010fc:	8b 75 0c             	mov    0xc(%ebp),%esi
801010ff:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101102:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101106:	74 60                	je     80101168 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101108:	8b 03                	mov    (%ebx),%eax
8010110a:	83 f8 01             	cmp    $0x1,%eax
8010110d:	74 41                	je     80101150 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010110f:	83 f8 02             	cmp    $0x2,%eax
80101112:	75 5b                	jne    8010116f <fileread+0x7f>
    ilock(f->ip);
80101114:	83 ec 0c             	sub    $0xc,%esp
80101117:	ff 73 10             	pushl  0x10(%ebx)
8010111a:	e8 f1 06 00 00       	call   80101810 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010111f:	57                   	push   %edi
80101120:	ff 73 14             	pushl  0x14(%ebx)
80101123:	56                   	push   %esi
80101124:	ff 73 10             	pushl  0x10(%ebx)
80101127:	e8 c4 09 00 00       	call   80101af0 <readi>
8010112c:	83 c4 20             	add    $0x20,%esp
8010112f:	85 c0                	test   %eax,%eax
80101131:	89 c6                	mov    %eax,%esi
80101133:	7e 03                	jle    80101138 <fileread+0x48>
      f->off += r;
80101135:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101138:	83 ec 0c             	sub    $0xc,%esp
8010113b:	ff 73 10             	pushl  0x10(%ebx)
8010113e:	e8 ad 07 00 00       	call   801018f0 <iunlock>
    return r;
80101143:	83 c4 10             	add    $0x10,%esp
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
    ilock(f->ip);
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101146:	89 f0                	mov    %esi,%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80101148:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010114b:	5b                   	pop    %ebx
8010114c:	5e                   	pop    %esi
8010114d:	5f                   	pop    %edi
8010114e:	5d                   	pop    %ebp
8010114f:	c3                   	ret    
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80101150:	8b 43 0c             	mov    0xc(%ebx),%eax
80101153:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80101156:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101159:	5b                   	pop    %ebx
8010115a:	5e                   	pop    %esi
8010115b:	5f                   	pop    %edi
8010115c:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
8010115d:	e9 ce 24 00 00       	jmp    80103630 <piperead>
80101162:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fileread(struct file *f, char *addr, int n)
{
  int r;

  if(f->readable == 0)
    return -1;
80101168:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010116d:	eb d9                	jmp    80101148 <fileread+0x58>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
8010116f:	83 ec 0c             	sub    $0xc,%esp
80101172:	68 26 82 10 80       	push   $0x80108226
80101177:	e8 f4 f1 ff ff       	call   80100370 <panic>
8010117c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101180 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101180:	55                   	push   %ebp
80101181:	89 e5                	mov    %esp,%ebp
80101183:	57                   	push   %edi
80101184:	56                   	push   %esi
80101185:	53                   	push   %ebx
80101186:	83 ec 1c             	sub    $0x1c,%esp
80101189:	8b 75 08             	mov    0x8(%ebp),%esi
8010118c:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
8010118f:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101193:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101196:	8b 45 10             	mov    0x10(%ebp),%eax
80101199:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
8010119c:	0f 84 aa 00 00 00    	je     8010124c <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
801011a2:	8b 06                	mov    (%esi),%eax
801011a4:	83 f8 01             	cmp    $0x1,%eax
801011a7:	0f 84 c2 00 00 00    	je     8010126f <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801011ad:	83 f8 02             	cmp    $0x2,%eax
801011b0:	0f 85 d8 00 00 00    	jne    8010128e <filewrite+0x10e>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801011b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801011b9:	31 ff                	xor    %edi,%edi
801011bb:	85 c0                	test   %eax,%eax
801011bd:	7f 34                	jg     801011f3 <filewrite+0x73>
801011bf:	e9 9c 00 00 00       	jmp    80101260 <filewrite+0xe0>
801011c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801011c8:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
801011cb:	83 ec 0c             	sub    $0xc,%esp
801011ce:	ff 76 10             	pushl  0x10(%esi)
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801011d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801011d4:	e8 17 07 00 00       	call   801018f0 <iunlock>
      end_op();
801011d9:	e8 82 1b 00 00       	call   80102d60 <end_op>
801011de:	8b 45 e0             	mov    -0x20(%ebp),%eax
801011e1:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
801011e4:	39 d8                	cmp    %ebx,%eax
801011e6:	0f 85 95 00 00 00    	jne    80101281 <filewrite+0x101>
        panic("short filewrite");
      i += r;
801011ec:	01 c7                	add    %eax,%edi
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801011ee:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801011f1:	7e 6d                	jle    80101260 <filewrite+0xe0>
      int n1 = n - i;
801011f3:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801011f6:	b8 00 06 00 00       	mov    $0x600,%eax
801011fb:	29 fb                	sub    %edi,%ebx
801011fd:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101203:	0f 4f d8             	cmovg  %eax,%ebx
      if(n1 > max)
        n1 = max;

      begin_op();
80101206:	e8 e5 1a 00 00       	call   80102cf0 <begin_op>
      ilock(f->ip);
8010120b:	83 ec 0c             	sub    $0xc,%esp
8010120e:	ff 76 10             	pushl  0x10(%esi)
80101211:	e8 fa 05 00 00       	call   80101810 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101216:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101219:	53                   	push   %ebx
8010121a:	ff 76 14             	pushl  0x14(%esi)
8010121d:	01 f8                	add    %edi,%eax
8010121f:	50                   	push   %eax
80101220:	ff 76 10             	pushl  0x10(%esi)
80101223:	e8 c8 09 00 00       	call   80101bf0 <writei>
80101228:	83 c4 20             	add    $0x20,%esp
8010122b:	85 c0                	test   %eax,%eax
8010122d:	7f 99                	jg     801011c8 <filewrite+0x48>
        f->off += r;
      iunlock(f->ip);
8010122f:	83 ec 0c             	sub    $0xc,%esp
80101232:	ff 76 10             	pushl  0x10(%esi)
80101235:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101238:	e8 b3 06 00 00       	call   801018f0 <iunlock>
      end_op();
8010123d:	e8 1e 1b 00 00       	call   80102d60 <end_op>

      if(r < 0)
80101242:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101245:	83 c4 10             	add    $0x10,%esp
80101248:	85 c0                	test   %eax,%eax
8010124a:	74 98                	je     801011e4 <filewrite+0x64>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
8010124c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
8010124f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80101254:	5b                   	pop    %ebx
80101255:	5e                   	pop    %esi
80101256:	5f                   	pop    %edi
80101257:	5d                   	pop    %ebp
80101258:	c3                   	ret    
80101259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
80101260:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80101263:	75 e7                	jne    8010124c <filewrite+0xcc>
  }
  panic("filewrite");
}
80101265:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101268:	89 f8                	mov    %edi,%eax
8010126a:	5b                   	pop    %ebx
8010126b:	5e                   	pop    %esi
8010126c:	5f                   	pop    %edi
8010126d:	5d                   	pop    %ebp
8010126e:	c3                   	ret    
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
8010126f:	8b 46 0c             	mov    0xc(%esi),%eax
80101272:	89 45 08             	mov    %eax,0x8(%ebp)
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
80101275:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101278:	5b                   	pop    %ebx
80101279:	5e                   	pop    %esi
8010127a:	5f                   	pop    %edi
8010127b:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
8010127c:	e9 af 22 00 00       	jmp    80103530 <pipewrite>
      end_op();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
80101281:	83 ec 0c             	sub    $0xc,%esp
80101284:	68 2f 82 10 80       	push   $0x8010822f
80101289:	e8 e2 f0 ff ff       	call   80100370 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
8010128e:	83 ec 0c             	sub    $0xc,%esp
80101291:	68 35 82 10 80       	push   $0x80108235
80101296:	e8 d5 f0 ff ff       	call   80100370 <panic>
8010129b:	66 90                	xchg   %ax,%ax
8010129d:	66 90                	xchg   %ax,%ax
8010129f:	90                   	nop

801012a0 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801012a0:	55                   	push   %ebp
801012a1:	89 e5                	mov    %esp,%ebp
801012a3:	57                   	push   %edi
801012a4:	56                   	push   %esi
801012a5:	53                   	push   %ebx
801012a6:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801012a9:	8b 0d e0 29 11 80    	mov    0x801129e0,%ecx
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801012af:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801012b2:	85 c9                	test   %ecx,%ecx
801012b4:	0f 84 85 00 00 00    	je     8010133f <balloc+0x9f>
801012ba:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801012c1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801012c4:	83 ec 08             	sub    $0x8,%esp
801012c7:	89 f0                	mov    %esi,%eax
801012c9:	c1 f8 0c             	sar    $0xc,%eax
801012cc:	03 05 f8 29 11 80    	add    0x801129f8,%eax
801012d2:	50                   	push   %eax
801012d3:	ff 75 d8             	pushl  -0x28(%ebp)
801012d6:	e8 f5 ed ff ff       	call   801000d0 <bread>
801012db:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801012de:	a1 e0 29 11 80       	mov    0x801129e0,%eax
801012e3:	83 c4 10             	add    $0x10,%esp
801012e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012e9:	31 c0                	xor    %eax,%eax
801012eb:	eb 2d                	jmp    8010131a <balloc+0x7a>
801012ed:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801012f0:	89 c1                	mov    %eax,%ecx
801012f2:	ba 01 00 00 00       	mov    $0x1,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801012f7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
801012fa:	83 e1 07             	and    $0x7,%ecx
801012fd:	d3 e2                	shl    %cl,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801012ff:	89 c1                	mov    %eax,%ecx
80101301:	c1 f9 03             	sar    $0x3,%ecx
80101304:	0f b6 7c 0b 5c       	movzbl 0x5c(%ebx,%ecx,1),%edi
80101309:	85 d7                	test   %edx,%edi
8010130b:	74 43                	je     80101350 <balloc+0xb0>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010130d:	83 c0 01             	add    $0x1,%eax
80101310:	83 c6 01             	add    $0x1,%esi
80101313:	3d 00 10 00 00       	cmp    $0x1000,%eax
80101318:	74 05                	je     8010131f <balloc+0x7f>
8010131a:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010131d:	72 d1                	jb     801012f0 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
8010131f:	83 ec 0c             	sub    $0xc,%esp
80101322:	ff 75 e4             	pushl  -0x1c(%ebp)
80101325:	e8 b6 ee ff ff       	call   801001e0 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010132a:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101331:	83 c4 10             	add    $0x10,%esp
80101334:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101337:	39 05 e0 29 11 80    	cmp    %eax,0x801129e0
8010133d:	77 82                	ja     801012c1 <balloc+0x21>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
8010133f:	83 ec 0c             	sub    $0xc,%esp
80101342:	68 3f 82 10 80       	push   $0x8010823f
80101347:	e8 24 f0 ff ff       	call   80100370 <panic>
8010134c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
80101350:	09 fa                	or     %edi,%edx
80101352:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101355:	83 ec 0c             	sub    $0xc,%esp
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
80101358:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010135c:	57                   	push   %edi
8010135d:	e8 6e 1b 00 00       	call   80102ed0 <log_write>
        brelse(bp);
80101362:	89 3c 24             	mov    %edi,(%esp)
80101365:	e8 76 ee ff ff       	call   801001e0 <brelse>
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
8010136a:	58                   	pop    %eax
8010136b:	5a                   	pop    %edx
8010136c:	56                   	push   %esi
8010136d:	ff 75 d8             	pushl  -0x28(%ebp)
80101370:	e8 5b ed ff ff       	call   801000d0 <bread>
80101375:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101377:	8d 40 5c             	lea    0x5c(%eax),%eax
8010137a:	83 c4 0c             	add    $0xc,%esp
8010137d:	68 00 02 00 00       	push   $0x200
80101382:	6a 00                	push   $0x0
80101384:	50                   	push   %eax
80101385:	e8 26 39 00 00       	call   80104cb0 <memset>
  log_write(bp);
8010138a:	89 1c 24             	mov    %ebx,(%esp)
8010138d:	e8 3e 1b 00 00       	call   80102ed0 <log_write>
  brelse(bp);
80101392:	89 1c 24             	mov    %ebx,(%esp)
80101395:	e8 46 ee ff ff       	call   801001e0 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
8010139a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010139d:	89 f0                	mov    %esi,%eax
8010139f:	5b                   	pop    %ebx
801013a0:	5e                   	pop    %esi
801013a1:	5f                   	pop    %edi
801013a2:	5d                   	pop    %ebp
801013a3:	c3                   	ret    
801013a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801013aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801013b0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801013b0:	55                   	push   %ebp
801013b1:	89 e5                	mov    %esp,%ebp
801013b3:	57                   	push   %edi
801013b4:	56                   	push   %esi
801013b5:	53                   	push   %ebx
801013b6:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801013b8:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013ba:	bb 34 2a 11 80       	mov    $0x80112a34,%ebx
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801013bf:	83 ec 28             	sub    $0x28,%esp
801013c2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
801013c5:	68 00 2a 11 80       	push   $0x80112a00
801013ca:	e8 61 36 00 00       	call   80104a30 <acquire>
801013cf:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013d2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801013d5:	eb 1b                	jmp    801013f2 <iget+0x42>
801013d7:	89 f6                	mov    %esi,%esi
801013d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801013e0:	85 f6                	test   %esi,%esi
801013e2:	74 44                	je     80101428 <iget+0x78>

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013e4:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013ea:	81 fb 54 46 11 80    	cmp    $0x80114654,%ebx
801013f0:	74 4e                	je     80101440 <iget+0x90>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013f2:	8b 4b 08             	mov    0x8(%ebx),%ecx
801013f5:	85 c9                	test   %ecx,%ecx
801013f7:	7e e7                	jle    801013e0 <iget+0x30>
801013f9:	39 3b                	cmp    %edi,(%ebx)
801013fb:	75 e3                	jne    801013e0 <iget+0x30>
801013fd:	39 53 04             	cmp    %edx,0x4(%ebx)
80101400:	75 de                	jne    801013e0 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
80101402:	83 ec 0c             	sub    $0xc,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
80101405:	83 c1 01             	add    $0x1,%ecx
      release(&icache.lock);
      return ip;
80101408:	89 de                	mov    %ebx,%esi
  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
8010140a:	68 00 2a 11 80       	push   $0x80112a00

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
8010140f:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101412:	e8 c9 36 00 00       	call   80104ae0 <release>
      return ip;
80101417:	83 c4 10             	add    $0x10,%esp
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);

  return ip;
}
8010141a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010141d:	89 f0                	mov    %esi,%eax
8010141f:	5b                   	pop    %ebx
80101420:	5e                   	pop    %esi
80101421:	5f                   	pop    %edi
80101422:	5d                   	pop    %ebp
80101423:	c3                   	ret    
80101424:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101428:	85 c9                	test   %ecx,%ecx
8010142a:	0f 44 f3             	cmove  %ebx,%esi

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010142d:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101433:	81 fb 54 46 11 80    	cmp    $0x80114654,%ebx
80101439:	75 b7                	jne    801013f2 <iget+0x42>
8010143b:	90                   	nop
8010143c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101440:	85 f6                	test   %esi,%esi
80101442:	74 2d                	je     80101471 <iget+0xc1>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101444:	83 ec 0c             	sub    $0xc,%esp
  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
80101447:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101449:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010144c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101453:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010145a:	68 00 2a 11 80       	push   $0x80112a00
8010145f:	e8 7c 36 00 00       	call   80104ae0 <release>

  return ip;
80101464:	83 c4 10             	add    $0x10,%esp
}
80101467:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010146a:	89 f0                	mov    %esi,%eax
8010146c:	5b                   	pop    %ebx
8010146d:	5e                   	pop    %esi
8010146e:	5f                   	pop    %edi
8010146f:	5d                   	pop    %ebp
80101470:	c3                   	ret    
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");
80101471:	83 ec 0c             	sub    $0xc,%esp
80101474:	68 55 82 10 80       	push   $0x80108255
80101479:	e8 f2 ee ff ff       	call   80100370 <panic>
8010147e:	66 90                	xchg   %ax,%ax

80101480 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101480:	55                   	push   %ebp
80101481:	89 e5                	mov    %esp,%ebp
80101483:	57                   	push   %edi
80101484:	56                   	push   %esi
80101485:	53                   	push   %ebx
80101486:	89 c6                	mov    %eax,%esi
80101488:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010148b:	83 fa 0b             	cmp    $0xb,%edx
8010148e:	77 18                	ja     801014a8 <bmap+0x28>
80101490:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
    if((addr = ip->addrs[bn]) == 0)
80101493:	8b 43 5c             	mov    0x5c(%ebx),%eax
80101496:	85 c0                	test   %eax,%eax
80101498:	74 76                	je     80101510 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010149a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010149d:	5b                   	pop    %ebx
8010149e:	5e                   	pop    %esi
8010149f:	5f                   	pop    %edi
801014a0:	5d                   	pop    %ebp
801014a1:	c3                   	ret    
801014a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801014a8:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
801014ab:	83 fb 7f             	cmp    $0x7f,%ebx
801014ae:	0f 87 83 00 00 00    	ja     80101537 <bmap+0xb7>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801014b4:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801014ba:	85 c0                	test   %eax,%eax
801014bc:	74 6a                	je     80101528 <bmap+0xa8>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801014be:	83 ec 08             	sub    $0x8,%esp
801014c1:	50                   	push   %eax
801014c2:	ff 36                	pushl  (%esi)
801014c4:	e8 07 ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801014c9:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
801014cd:	83 c4 10             	add    $0x10,%esp

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801014d0:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801014d2:	8b 1a                	mov    (%edx),%ebx
801014d4:	85 db                	test   %ebx,%ebx
801014d6:	75 1d                	jne    801014f5 <bmap+0x75>
      a[bn] = addr = balloc(ip->dev);
801014d8:	8b 06                	mov    (%esi),%eax
801014da:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801014dd:	e8 be fd ff ff       	call   801012a0 <balloc>
801014e2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801014e5:	83 ec 0c             	sub    $0xc,%esp
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
801014e8:	89 c3                	mov    %eax,%ebx
801014ea:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801014ec:	57                   	push   %edi
801014ed:	e8 de 19 00 00       	call   80102ed0 <log_write>
801014f2:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
801014f5:	83 ec 0c             	sub    $0xc,%esp
801014f8:	57                   	push   %edi
801014f9:	e8 e2 ec ff ff       	call   801001e0 <brelse>
801014fe:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80101501:	8d 65 f4             	lea    -0xc(%ebp),%esp
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101504:	89 d8                	mov    %ebx,%eax
    return addr;
  }

  panic("bmap: out of range");
}
80101506:	5b                   	pop    %ebx
80101507:	5e                   	pop    %esi
80101508:	5f                   	pop    %edi
80101509:	5d                   	pop    %ebp
8010150a:	c3                   	ret    
8010150b:	90                   	nop
8010150c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
80101510:	8b 06                	mov    (%esi),%eax
80101512:	e8 89 fd ff ff       	call   801012a0 <balloc>
80101517:	89 43 5c             	mov    %eax,0x5c(%ebx)
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010151a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010151d:	5b                   	pop    %ebx
8010151e:	5e                   	pop    %esi
8010151f:	5f                   	pop    %edi
80101520:	5d                   	pop    %ebp
80101521:	c3                   	ret    
80101522:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101528:	8b 06                	mov    (%esi),%eax
8010152a:	e8 71 fd ff ff       	call   801012a0 <balloc>
8010152f:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101535:	eb 87                	jmp    801014be <bmap+0x3e>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
80101537:	83 ec 0c             	sub    $0xc,%esp
8010153a:	68 65 82 10 80       	push   $0x80108265
8010153f:	e8 2c ee ff ff       	call   80100370 <panic>
80101544:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010154a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101550 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101550:	55                   	push   %ebp
80101551:	89 e5                	mov    %esp,%ebp
80101553:	56                   	push   %esi
80101554:	53                   	push   %ebx
80101555:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct buf *bp;

  bp = bread(dev, 1);
80101558:	83 ec 08             	sub    $0x8,%esp
8010155b:	6a 01                	push   $0x1
8010155d:	ff 75 08             	pushl  0x8(%ebp)
80101560:	e8 6b eb ff ff       	call   801000d0 <bread>
80101565:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101567:	8d 40 5c             	lea    0x5c(%eax),%eax
8010156a:	83 c4 0c             	add    $0xc,%esp
8010156d:	6a 1c                	push   $0x1c
8010156f:	50                   	push   %eax
80101570:	56                   	push   %esi
80101571:	e8 ea 37 00 00       	call   80104d60 <memmove>
  brelse(bp);
80101576:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101579:	83 c4 10             	add    $0x10,%esp
}
8010157c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010157f:	5b                   	pop    %ebx
80101580:	5e                   	pop    %esi
80101581:	5d                   	pop    %ebp
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
80101582:	e9 59 ec ff ff       	jmp    801001e0 <brelse>
80101587:	89 f6                	mov    %esi,%esi
80101589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101590 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101590:	55                   	push   %ebp
80101591:	89 e5                	mov    %esp,%ebp
80101593:	56                   	push   %esi
80101594:	53                   	push   %ebx
80101595:	89 d3                	mov    %edx,%ebx
80101597:	89 c6                	mov    %eax,%esi
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
80101599:	83 ec 08             	sub    $0x8,%esp
8010159c:	68 e0 29 11 80       	push   $0x801129e0
801015a1:	50                   	push   %eax
801015a2:	e8 a9 ff ff ff       	call   80101550 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
801015a7:	58                   	pop    %eax
801015a8:	5a                   	pop    %edx
801015a9:	89 da                	mov    %ebx,%edx
801015ab:	c1 ea 0c             	shr    $0xc,%edx
801015ae:	03 15 f8 29 11 80    	add    0x801129f8,%edx
801015b4:	52                   	push   %edx
801015b5:	56                   	push   %esi
801015b6:	e8 15 eb ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801015bb:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801015bd:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
801015c3:	ba 01 00 00 00       	mov    $0x1,%edx
801015c8:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801015cb:	c1 fb 03             	sar    $0x3,%ebx
801015ce:	83 c4 10             	add    $0x10,%esp
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
801015d1:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
801015d3:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
801015d8:	85 d1                	test   %edx,%ecx
801015da:	74 27                	je     80101603 <bfree+0x73>
801015dc:	89 c6                	mov    %eax,%esi
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801015de:	f7 d2                	not    %edx
801015e0:	89 c8                	mov    %ecx,%eax
  log_write(bp);
801015e2:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801015e5:	21 d0                	and    %edx,%eax
801015e7:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
801015eb:	56                   	push   %esi
801015ec:	e8 df 18 00 00       	call   80102ed0 <log_write>
  brelse(bp);
801015f1:	89 34 24             	mov    %esi,(%esp)
801015f4:	e8 e7 eb ff ff       	call   801001e0 <brelse>
}
801015f9:	83 c4 10             	add    $0x10,%esp
801015fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801015ff:	5b                   	pop    %ebx
80101600:	5e                   	pop    %esi
80101601:	5d                   	pop    %ebp
80101602:	c3                   	ret    
  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
80101603:	83 ec 0c             	sub    $0xc,%esp
80101606:	68 78 82 10 80       	push   $0x80108278
8010160b:	e8 60 ed ff ff       	call   80100370 <panic>

80101610 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101610:	55                   	push   %ebp
80101611:	89 e5                	mov    %esp,%ebp
80101613:	53                   	push   %ebx
80101614:	bb 40 2a 11 80       	mov    $0x80112a40,%ebx
80101619:	83 ec 0c             	sub    $0xc,%esp
  int i = 0;
  
  initlock(&icache.lock, "icache");
8010161c:	68 8b 82 10 80       	push   $0x8010828b
80101621:	68 00 2a 11 80       	push   $0x80112a00
80101626:	e8 a5 32 00 00       	call   801048d0 <initlock>
8010162b:	83 c4 10             	add    $0x10,%esp
8010162e:	66 90                	xchg   %ax,%ax
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
80101630:	83 ec 08             	sub    $0x8,%esp
80101633:	68 92 82 10 80       	push   $0x80108292
80101638:	53                   	push   %ebx
80101639:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010163f:	e8 3c 31 00 00       	call   80104780 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
80101644:	83 c4 10             	add    $0x10,%esp
80101647:	81 fb 60 46 11 80    	cmp    $0x80114660,%ebx
8010164d:	75 e1                	jne    80101630 <iinit+0x20>
    initsleeplock(&icache.inode[i].lock, "inode");
  }

  readsb(dev, &sb);
8010164f:	83 ec 08             	sub    $0x8,%esp
80101652:	68 e0 29 11 80       	push   $0x801129e0
80101657:	ff 75 08             	pushl  0x8(%ebp)
8010165a:	e8 f1 fe ff ff       	call   80101550 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010165f:	ff 35 f8 29 11 80    	pushl  0x801129f8
80101665:	ff 35 f4 29 11 80    	pushl  0x801129f4
8010166b:	ff 35 f0 29 11 80    	pushl  0x801129f0
80101671:	ff 35 ec 29 11 80    	pushl  0x801129ec
80101677:	ff 35 e8 29 11 80    	pushl  0x801129e8
8010167d:	ff 35 e4 29 11 80    	pushl  0x801129e4
80101683:	ff 35 e0 29 11 80    	pushl  0x801129e0
80101689:	68 f8 82 10 80       	push   $0x801082f8
8010168e:	e8 4d f0 ff ff       	call   801006e0 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
80101693:	83 c4 30             	add    $0x30,%esp
80101696:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101699:	c9                   	leave  
8010169a:	c3                   	ret    
8010169b:	90                   	nop
8010169c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801016a0 <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
801016a0:	55                   	push   %ebp
801016a1:	89 e5                	mov    %esp,%ebp
801016a3:	57                   	push   %edi
801016a4:	56                   	push   %esi
801016a5:	53                   	push   %ebx
801016a6:	83 ec 1c             	sub    $0x1c,%esp
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801016a9:	83 3d e8 29 11 80 01 	cmpl   $0x1,0x801129e8
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
801016b0:	8b 45 0c             	mov    0xc(%ebp),%eax
801016b3:	8b 75 08             	mov    0x8(%ebp),%esi
801016b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801016b9:	0f 86 91 00 00 00    	jbe    80101750 <ialloc+0xb0>
801016bf:	bb 01 00 00 00       	mov    $0x1,%ebx
801016c4:	eb 21                	jmp    801016e7 <ialloc+0x47>
801016c6:	8d 76 00             	lea    0x0(%esi),%esi
801016c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
801016d0:	83 ec 0c             	sub    $0xc,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801016d3:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
801016d6:	57                   	push   %edi
801016d7:	e8 04 eb ff ff       	call   801001e0 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801016dc:	83 c4 10             	add    $0x10,%esp
801016df:	39 1d e8 29 11 80    	cmp    %ebx,0x801129e8
801016e5:	76 69                	jbe    80101750 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
801016e7:	89 d8                	mov    %ebx,%eax
801016e9:	83 ec 08             	sub    $0x8,%esp
801016ec:	c1 e8 03             	shr    $0x3,%eax
801016ef:	03 05 f4 29 11 80    	add    0x801129f4,%eax
801016f5:	50                   	push   %eax
801016f6:	56                   	push   %esi
801016f7:	e8 d4 e9 ff ff       	call   801000d0 <bread>
801016fc:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
801016fe:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101700:	83 c4 10             	add    $0x10,%esp
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
80101703:	83 e0 07             	and    $0x7,%eax
80101706:	c1 e0 06             	shl    $0x6,%eax
80101709:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010170d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101711:	75 bd                	jne    801016d0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101713:	83 ec 04             	sub    $0x4,%esp
80101716:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101719:	6a 40                	push   $0x40
8010171b:	6a 00                	push   $0x0
8010171d:	51                   	push   %ecx
8010171e:	e8 8d 35 00 00       	call   80104cb0 <memset>
      dip->type = type;
80101723:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101727:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010172a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010172d:	89 3c 24             	mov    %edi,(%esp)
80101730:	e8 9b 17 00 00       	call   80102ed0 <log_write>
      brelse(bp);
80101735:	89 3c 24             	mov    %edi,(%esp)
80101738:	e8 a3 ea ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
8010173d:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101740:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
80101743:	89 da                	mov    %ebx,%edx
80101745:	89 f0                	mov    %esi,%eax
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101747:	5b                   	pop    %ebx
80101748:	5e                   	pop    %esi
80101749:	5f                   	pop    %edi
8010174a:	5d                   	pop    %ebp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
8010174b:	e9 60 fc ff ff       	jmp    801013b0 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
80101750:	83 ec 0c             	sub    $0xc,%esp
80101753:	68 98 82 10 80       	push   $0x80108298
80101758:	e8 13 ec ff ff       	call   80100370 <panic>
8010175d:	8d 76 00             	lea    0x0(%esi),%esi

80101760 <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
80101760:	55                   	push   %ebp
80101761:	89 e5                	mov    %esp,%ebp
80101763:	56                   	push   %esi
80101764:	53                   	push   %ebx
80101765:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101768:	83 ec 08             	sub    $0x8,%esp
8010176b:	8b 43 04             	mov    0x4(%ebx),%eax
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010176e:	83 c3 5c             	add    $0x5c,%ebx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101771:	c1 e8 03             	shr    $0x3,%eax
80101774:	03 05 f4 29 11 80    	add    0x801129f4,%eax
8010177a:	50                   	push   %eax
8010177b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010177e:	e8 4d e9 ff ff       	call   801000d0 <bread>
80101783:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101785:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
80101788:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010178c:	83 c4 0c             	add    $0xc,%esp
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010178f:	83 e0 07             	and    $0x7,%eax
80101792:	c1 e0 06             	shl    $0x6,%eax
80101795:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101799:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010179c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801017a0:	83 c0 0c             	add    $0xc,%eax
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
  dip->major = ip->major;
801017a3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801017a7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801017ab:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801017af:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801017b3:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801017b7:	8b 53 fc             	mov    -0x4(%ebx),%edx
801017ba:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801017bd:	6a 34                	push   $0x34
801017bf:	53                   	push   %ebx
801017c0:	50                   	push   %eax
801017c1:	e8 9a 35 00 00       	call   80104d60 <memmove>
  log_write(bp);
801017c6:	89 34 24             	mov    %esi,(%esp)
801017c9:	e8 02 17 00 00       	call   80102ed0 <log_write>
  brelse(bp);
801017ce:	89 75 08             	mov    %esi,0x8(%ebp)
801017d1:	83 c4 10             	add    $0x10,%esp
}
801017d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017d7:	5b                   	pop    %ebx
801017d8:	5e                   	pop    %esi
801017d9:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  log_write(bp);
  brelse(bp);
801017da:	e9 01 ea ff ff       	jmp    801001e0 <brelse>
801017df:	90                   	nop

801017e0 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
801017e0:	55                   	push   %ebp
801017e1:	89 e5                	mov    %esp,%ebp
801017e3:	53                   	push   %ebx
801017e4:	83 ec 10             	sub    $0x10,%esp
801017e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801017ea:	68 00 2a 11 80       	push   $0x80112a00
801017ef:	e8 3c 32 00 00       	call   80104a30 <acquire>
  ip->ref++;
801017f4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801017f8:	c7 04 24 00 2a 11 80 	movl   $0x80112a00,(%esp)
801017ff:	e8 dc 32 00 00       	call   80104ae0 <release>
  return ip;
}
80101804:	89 d8                	mov    %ebx,%eax
80101806:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101809:	c9                   	leave  
8010180a:	c3                   	ret    
8010180b:	90                   	nop
8010180c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101810 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101810:	55                   	push   %ebp
80101811:	89 e5                	mov    %esp,%ebp
80101813:	56                   	push   %esi
80101814:	53                   	push   %ebx
80101815:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101818:	85 db                	test   %ebx,%ebx
8010181a:	0f 84 b7 00 00 00    	je     801018d7 <ilock+0xc7>
80101820:	8b 53 08             	mov    0x8(%ebx),%edx
80101823:	85 d2                	test   %edx,%edx
80101825:	0f 8e ac 00 00 00    	jle    801018d7 <ilock+0xc7>
    panic("ilock");

  acquiresleep(&ip->lock);
8010182b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010182e:	83 ec 0c             	sub    $0xc,%esp
80101831:	50                   	push   %eax
80101832:	e8 89 2f 00 00       	call   801047c0 <acquiresleep>

  if(ip->valid == 0){
80101837:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010183a:	83 c4 10             	add    $0x10,%esp
8010183d:	85 c0                	test   %eax,%eax
8010183f:	74 0f                	je     80101850 <ilock+0x40>
    brelse(bp);
    ip->valid = 1;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
80101841:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101844:	5b                   	pop    %ebx
80101845:	5e                   	pop    %esi
80101846:	5d                   	pop    %ebp
80101847:	c3                   	ret    
80101848:	90                   	nop
80101849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("ilock");

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101850:	8b 43 04             	mov    0x4(%ebx),%eax
80101853:	83 ec 08             	sub    $0x8,%esp
80101856:	c1 e8 03             	shr    $0x3,%eax
80101859:	03 05 f4 29 11 80    	add    0x801129f4,%eax
8010185f:	50                   	push   %eax
80101860:	ff 33                	pushl  (%ebx)
80101862:	e8 69 e8 ff ff       	call   801000d0 <bread>
80101867:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101869:	8b 43 04             	mov    0x4(%ebx),%eax
    ip->type = dip->type;
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010186c:	83 c4 0c             	add    $0xc,%esp

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010186f:	83 e0 07             	and    $0x7,%eax
80101872:	c1 e0 06             	shl    $0x6,%eax
80101875:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101879:	0f b7 10             	movzwl (%eax),%edx
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010187c:	83 c0 0c             	add    $0xc,%eax
  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
8010187f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101883:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101887:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010188b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010188f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101893:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101897:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010189b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010189e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801018a1:	6a 34                	push   $0x34
801018a3:	50                   	push   %eax
801018a4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801018a7:	50                   	push   %eax
801018a8:	e8 b3 34 00 00       	call   80104d60 <memmove>
    brelse(bp);
801018ad:	89 34 24             	mov    %esi,(%esp)
801018b0:	e8 2b e9 ff ff       	call   801001e0 <brelse>
    ip->valid = 1;
    if(ip->type == 0)
801018b5:	83 c4 10             	add    $0x10,%esp
801018b8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    brelse(bp);
    ip->valid = 1;
801018bd:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
801018c4:	0f 85 77 ff ff ff    	jne    80101841 <ilock+0x31>
      panic("ilock: no type");
801018ca:	83 ec 0c             	sub    $0xc,%esp
801018cd:	68 b0 82 10 80       	push   $0x801082b0
801018d2:	e8 99 ea ff ff       	call   80100370 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
801018d7:	83 ec 0c             	sub    $0xc,%esp
801018da:	68 aa 82 10 80       	push   $0x801082aa
801018df:	e8 8c ea ff ff       	call   80100370 <panic>
801018e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801018ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801018f0 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
801018f0:	55                   	push   %ebp
801018f1:	89 e5                	mov    %esp,%ebp
801018f3:	56                   	push   %esi
801018f4:	53                   	push   %ebx
801018f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801018f8:	85 db                	test   %ebx,%ebx
801018fa:	74 28                	je     80101924 <iunlock+0x34>
801018fc:	8d 73 0c             	lea    0xc(%ebx),%esi
801018ff:	83 ec 0c             	sub    $0xc,%esp
80101902:	56                   	push   %esi
80101903:	e8 78 2f 00 00       	call   80104880 <holdingsleep>
80101908:	83 c4 10             	add    $0x10,%esp
8010190b:	85 c0                	test   %eax,%eax
8010190d:	74 15                	je     80101924 <iunlock+0x34>
8010190f:	8b 43 08             	mov    0x8(%ebx),%eax
80101912:	85 c0                	test   %eax,%eax
80101914:	7e 0e                	jle    80101924 <iunlock+0x34>
    panic("iunlock");

  releasesleep(&ip->lock);
80101916:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101919:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010191c:	5b                   	pop    %ebx
8010191d:	5e                   	pop    %esi
8010191e:	5d                   	pop    %ebp
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");

  releasesleep(&ip->lock);
8010191f:	e9 fc 2e 00 00       	jmp    80104820 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
80101924:	83 ec 0c             	sub    $0xc,%esp
80101927:	68 bf 82 10 80       	push   $0x801082bf
8010192c:	e8 3f ea ff ff       	call   80100370 <panic>
80101931:	eb 0d                	jmp    80101940 <iput>
80101933:	90                   	nop
80101934:	90                   	nop
80101935:	90                   	nop
80101936:	90                   	nop
80101937:	90                   	nop
80101938:	90                   	nop
80101939:	90                   	nop
8010193a:	90                   	nop
8010193b:	90                   	nop
8010193c:	90                   	nop
8010193d:	90                   	nop
8010193e:	90                   	nop
8010193f:	90                   	nop

80101940 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101940:	55                   	push   %ebp
80101941:	89 e5                	mov    %esp,%ebp
80101943:	57                   	push   %edi
80101944:	56                   	push   %esi
80101945:	53                   	push   %ebx
80101946:	83 ec 28             	sub    $0x28,%esp
80101949:	8b 75 08             	mov    0x8(%ebp),%esi
  acquiresleep(&ip->lock);
8010194c:	8d 7e 0c             	lea    0xc(%esi),%edi
8010194f:	57                   	push   %edi
80101950:	e8 6b 2e 00 00       	call   801047c0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101955:	8b 56 4c             	mov    0x4c(%esi),%edx
80101958:	83 c4 10             	add    $0x10,%esp
8010195b:	85 d2                	test   %edx,%edx
8010195d:	74 07                	je     80101966 <iput+0x26>
8010195f:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
80101964:	74 32                	je     80101998 <iput+0x58>
      ip->type = 0;
      iupdate(ip);
      ip->valid = 0;
    }
  }
  releasesleep(&ip->lock);
80101966:	83 ec 0c             	sub    $0xc,%esp
80101969:	57                   	push   %edi
8010196a:	e8 b1 2e 00 00       	call   80104820 <releasesleep>

  acquire(&icache.lock);
8010196f:	c7 04 24 00 2a 11 80 	movl   $0x80112a00,(%esp)
80101976:	e8 b5 30 00 00       	call   80104a30 <acquire>
  ip->ref--;
8010197b:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
8010197f:	83 c4 10             	add    $0x10,%esp
80101982:	c7 45 08 00 2a 11 80 	movl   $0x80112a00,0x8(%ebp)
}
80101989:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010198c:	5b                   	pop    %ebx
8010198d:	5e                   	pop    %esi
8010198e:	5f                   	pop    %edi
8010198f:	5d                   	pop    %ebp
  }
  releasesleep(&ip->lock);

  acquire(&icache.lock);
  ip->ref--;
  release(&icache.lock);
80101990:	e9 4b 31 00 00       	jmp    80104ae0 <release>
80101995:	8d 76 00             	lea    0x0(%esi),%esi
void
iput(struct inode *ip)
{
  acquiresleep(&ip->lock);
  if(ip->valid && ip->nlink == 0){
    acquire(&icache.lock);
80101998:	83 ec 0c             	sub    $0xc,%esp
8010199b:	68 00 2a 11 80       	push   $0x80112a00
801019a0:	e8 8b 30 00 00       	call   80104a30 <acquire>
    int r = ip->ref;
801019a5:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
801019a8:	c7 04 24 00 2a 11 80 	movl   $0x80112a00,(%esp)
801019af:	e8 2c 31 00 00       	call   80104ae0 <release>
    if(r == 1){
801019b4:	83 c4 10             	add    $0x10,%esp
801019b7:	83 fb 01             	cmp    $0x1,%ebx
801019ba:	75 aa                	jne    80101966 <iput+0x26>
801019bc:	8d 8e 8c 00 00 00    	lea    0x8c(%esi),%ecx
801019c2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801019c5:	8d 5e 5c             	lea    0x5c(%esi),%ebx
801019c8:	89 cf                	mov    %ecx,%edi
801019ca:	eb 0b                	jmp    801019d7 <iput+0x97>
801019cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801019d0:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801019d3:	39 fb                	cmp    %edi,%ebx
801019d5:	74 19                	je     801019f0 <iput+0xb0>
    if(ip->addrs[i]){
801019d7:	8b 13                	mov    (%ebx),%edx
801019d9:	85 d2                	test   %edx,%edx
801019db:	74 f3                	je     801019d0 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
801019dd:	8b 06                	mov    (%esi),%eax
801019df:	e8 ac fb ff ff       	call   80101590 <bfree>
      ip->addrs[i] = 0;
801019e4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801019ea:	eb e4                	jmp    801019d0 <iput+0x90>
801019ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
801019f0:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
801019f6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019f9:	85 c0                	test   %eax,%eax
801019fb:	75 33                	jne    80101a30 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
801019fd:	83 ec 0c             	sub    $0xc,%esp
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
80101a00:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
80101a07:	56                   	push   %esi
80101a08:	e8 53 fd ff ff       	call   80101760 <iupdate>
    int r = ip->ref;
    release(&icache.lock);
    if(r == 1){
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
      ip->type = 0;
80101a0d:	31 c0                	xor    %eax,%eax
80101a0f:	66 89 46 50          	mov    %ax,0x50(%esi)
      iupdate(ip);
80101a13:	89 34 24             	mov    %esi,(%esp)
80101a16:	e8 45 fd ff ff       	call   80101760 <iupdate>
      ip->valid = 0;
80101a1b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
80101a22:	83 c4 10             	add    $0x10,%esp
80101a25:	e9 3c ff ff ff       	jmp    80101966 <iput+0x26>
80101a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101a30:	83 ec 08             	sub    $0x8,%esp
80101a33:	50                   	push   %eax
80101a34:	ff 36                	pushl  (%esi)
80101a36:	e8 95 e6 ff ff       	call   801000d0 <bread>
80101a3b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101a41:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101a44:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101a47:	8d 58 5c             	lea    0x5c(%eax),%ebx
80101a4a:	83 c4 10             	add    $0x10,%esp
80101a4d:	89 cf                	mov    %ecx,%edi
80101a4f:	eb 0e                	jmp    80101a5f <iput+0x11f>
80101a51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a58:	83 c3 04             	add    $0x4,%ebx
    for(j = 0; j < NINDIRECT; j++){
80101a5b:	39 fb                	cmp    %edi,%ebx
80101a5d:	74 0f                	je     80101a6e <iput+0x12e>
      if(a[j])
80101a5f:	8b 13                	mov    (%ebx),%edx
80101a61:	85 d2                	test   %edx,%edx
80101a63:	74 f3                	je     80101a58 <iput+0x118>
        bfree(ip->dev, a[j]);
80101a65:	8b 06                	mov    (%esi),%eax
80101a67:	e8 24 fb ff ff       	call   80101590 <bfree>
80101a6c:	eb ea                	jmp    80101a58 <iput+0x118>
    }
    brelse(bp);
80101a6e:	83 ec 0c             	sub    $0xc,%esp
80101a71:	ff 75 e4             	pushl  -0x1c(%ebp)
80101a74:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101a77:	e8 64 e7 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101a7c:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
80101a82:	8b 06                	mov    (%esi),%eax
80101a84:	e8 07 fb ff ff       	call   80101590 <bfree>
    ip->addrs[NDIRECT] = 0;
80101a89:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
80101a90:	00 00 00 
80101a93:	83 c4 10             	add    $0x10,%esp
80101a96:	e9 62 ff ff ff       	jmp    801019fd <iput+0xbd>
80101a9b:	90                   	nop
80101a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101aa0 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101aa0:	55                   	push   %ebp
80101aa1:	89 e5                	mov    %esp,%ebp
80101aa3:	53                   	push   %ebx
80101aa4:	83 ec 10             	sub    $0x10,%esp
80101aa7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101aaa:	53                   	push   %ebx
80101aab:	e8 40 fe ff ff       	call   801018f0 <iunlock>
  iput(ip);
80101ab0:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101ab3:	83 c4 10             	add    $0x10,%esp
}
80101ab6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101ab9:	c9                   	leave  
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
80101aba:	e9 81 fe ff ff       	jmp    80101940 <iput>
80101abf:	90                   	nop

80101ac0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101ac0:	55                   	push   %ebp
80101ac1:	89 e5                	mov    %esp,%ebp
80101ac3:	8b 55 08             	mov    0x8(%ebp),%edx
80101ac6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101ac9:	8b 0a                	mov    (%edx),%ecx
80101acb:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101ace:	8b 4a 04             	mov    0x4(%edx),%ecx
80101ad1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101ad4:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101ad8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101adb:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101adf:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101ae3:	8b 52 58             	mov    0x58(%edx),%edx
80101ae6:	89 50 10             	mov    %edx,0x10(%eax)
}
80101ae9:	5d                   	pop    %ebp
80101aea:	c3                   	ret    
80101aeb:	90                   	nop
80101aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101af0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101af0:	55                   	push   %ebp
80101af1:	89 e5                	mov    %esp,%ebp
80101af3:	57                   	push   %edi
80101af4:	56                   	push   %esi
80101af5:	53                   	push   %ebx
80101af6:	83 ec 1c             	sub    $0x1c,%esp
80101af9:	8b 45 08             	mov    0x8(%ebp),%eax
80101afc:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101aff:	8b 75 10             	mov    0x10(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b02:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101b07:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101b0a:	8b 7d 14             	mov    0x14(%ebp),%edi
80101b0d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b10:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b13:	0f 84 a7 00 00 00    	je     80101bc0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101b19:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b1c:	8b 40 58             	mov    0x58(%eax),%eax
80101b1f:	39 f0                	cmp    %esi,%eax
80101b21:	0f 82 c1 00 00 00    	jb     80101be8 <readi+0xf8>
80101b27:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101b2a:	89 fa                	mov    %edi,%edx
80101b2c:	01 f2                	add    %esi,%edx
80101b2e:	0f 82 b4 00 00 00    	jb     80101be8 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101b34:	89 c1                	mov    %eax,%ecx
80101b36:	29 f1                	sub    %esi,%ecx
80101b38:	39 d0                	cmp    %edx,%eax
80101b3a:	0f 43 cf             	cmovae %edi,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b3d:	31 ff                	xor    %edi,%edi
80101b3f:	85 c9                	test   %ecx,%ecx
  }

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101b41:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b44:	74 6d                	je     80101bb3 <readi+0xc3>
80101b46:	8d 76 00             	lea    0x0(%esi),%esi
80101b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b50:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101b53:	89 f2                	mov    %esi,%edx
80101b55:	c1 ea 09             	shr    $0x9,%edx
80101b58:	89 d8                	mov    %ebx,%eax
80101b5a:	e8 21 f9 ff ff       	call   80101480 <bmap>
80101b5f:	83 ec 08             	sub    $0x8,%esp
80101b62:	50                   	push   %eax
80101b63:	ff 33                	pushl  (%ebx)
    m = min(n - tot, BSIZE - off%BSIZE);
80101b65:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b6a:	e8 61 e5 ff ff       	call   801000d0 <bread>
80101b6f:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b74:	89 f1                	mov    %esi,%ecx
80101b76:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80101b7c:	83 c4 0c             	add    $0xc,%esp
    memmove(dst, bp->data + off%BSIZE, m);
80101b7f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101b82:	29 cb                	sub    %ecx,%ebx
80101b84:	29 f8                	sub    %edi,%eax
80101b86:	39 c3                	cmp    %eax,%ebx
80101b88:	0f 47 d8             	cmova  %eax,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b8b:	8d 44 0a 5c          	lea    0x5c(%edx,%ecx,1),%eax
80101b8f:	53                   	push   %ebx
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b90:	01 df                	add    %ebx,%edi
80101b92:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
80101b94:	50                   	push   %eax
80101b95:	ff 75 e0             	pushl  -0x20(%ebp)
80101b98:	e8 c3 31 00 00       	call   80104d60 <memmove>
    brelse(bp);
80101b9d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101ba0:	89 14 24             	mov    %edx,(%esp)
80101ba3:	e8 38 e6 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ba8:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101bab:	83 c4 10             	add    $0x10,%esp
80101bae:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101bb1:	77 9d                	ja     80101b50 <readi+0x60>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101bb3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101bb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bb9:	5b                   	pop    %ebx
80101bba:	5e                   	pop    %esi
80101bbb:	5f                   	pop    %edi
80101bbc:	5d                   	pop    %ebp
80101bbd:	c3                   	ret    
80101bbe:	66 90                	xchg   %ax,%ax
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101bc0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101bc4:	66 83 f8 09          	cmp    $0x9,%ax
80101bc8:	77 1e                	ja     80101be8 <readi+0xf8>
80101bca:	8b 04 c5 80 29 11 80 	mov    -0x7feed680(,%eax,8),%eax
80101bd1:	85 c0                	test   %eax,%eax
80101bd3:	74 13                	je     80101be8 <readi+0xf8>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101bd5:	89 7d 10             	mov    %edi,0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
80101bd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bdb:	5b                   	pop    %ebx
80101bdc:	5e                   	pop    %esi
80101bdd:	5f                   	pop    %edi
80101bde:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101bdf:	ff e0                	jmp    *%eax
80101be1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
80101be8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101bed:	eb c7                	jmp    80101bb6 <readi+0xc6>
80101bef:	90                   	nop

80101bf0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101bf0:	55                   	push   %ebp
80101bf1:	89 e5                	mov    %esp,%ebp
80101bf3:	57                   	push   %edi
80101bf4:	56                   	push   %esi
80101bf5:	53                   	push   %ebx
80101bf6:	83 ec 1c             	sub    $0x1c,%esp
80101bf9:	8b 45 08             	mov    0x8(%ebp),%eax
80101bfc:	8b 75 0c             	mov    0xc(%ebp),%esi
80101bff:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101c02:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101c07:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101c0a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101c0d:	8b 75 10             	mov    0x10(%ebp),%esi
80101c10:	89 7d e0             	mov    %edi,-0x20(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101c13:	0f 84 b7 00 00 00    	je     80101cd0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101c19:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c1c:	39 70 58             	cmp    %esi,0x58(%eax)
80101c1f:	0f 82 eb 00 00 00    	jb     80101d10 <writei+0x120>
80101c25:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101c28:	89 f8                	mov    %edi,%eax
80101c2a:	01 f0                	add    %esi,%eax
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101c2c:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101c31:	0f 87 d9 00 00 00    	ja     80101d10 <writei+0x120>
80101c37:	39 c6                	cmp    %eax,%esi
80101c39:	0f 87 d1 00 00 00    	ja     80101d10 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c3f:	85 ff                	test   %edi,%edi
80101c41:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101c48:	74 78                	je     80101cc2 <writei+0xd2>
80101c4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c50:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101c53:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101c55:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c5a:	c1 ea 09             	shr    $0x9,%edx
80101c5d:	89 f8                	mov    %edi,%eax
80101c5f:	e8 1c f8 ff ff       	call   80101480 <bmap>
80101c64:	83 ec 08             	sub    $0x8,%esp
80101c67:	50                   	push   %eax
80101c68:	ff 37                	pushl  (%edi)
80101c6a:	e8 61 e4 ff ff       	call   801000d0 <bread>
80101c6f:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c71:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101c74:	2b 45 e4             	sub    -0x1c(%ebp),%eax
80101c77:	89 f1                	mov    %esi,%ecx
80101c79:	83 c4 0c             	add    $0xc,%esp
80101c7c:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80101c82:	29 cb                	sub    %ecx,%ebx
80101c84:	39 c3                	cmp    %eax,%ebx
80101c86:	0f 47 d8             	cmova  %eax,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c89:	8d 44 0f 5c          	lea    0x5c(%edi,%ecx,1),%eax
80101c8d:	53                   	push   %ebx
80101c8e:	ff 75 dc             	pushl  -0x24(%ebp)
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c91:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
80101c93:	50                   	push   %eax
80101c94:	e8 c7 30 00 00       	call   80104d60 <memmove>
    log_write(bp);
80101c99:	89 3c 24             	mov    %edi,(%esp)
80101c9c:	e8 2f 12 00 00       	call   80102ed0 <log_write>
    brelse(bp);
80101ca1:	89 3c 24             	mov    %edi,(%esp)
80101ca4:	e8 37 e5 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ca9:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101cac:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101caf:	83 c4 10             	add    $0x10,%esp
80101cb2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101cb5:	39 55 e0             	cmp    %edx,-0x20(%ebp)
80101cb8:	77 96                	ja     80101c50 <writei+0x60>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80101cba:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101cbd:	3b 70 58             	cmp    0x58(%eax),%esi
80101cc0:	77 36                	ja     80101cf8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101cc2:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101cc5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cc8:	5b                   	pop    %ebx
80101cc9:	5e                   	pop    %esi
80101cca:	5f                   	pop    %edi
80101ccb:	5d                   	pop    %ebp
80101ccc:	c3                   	ret    
80101ccd:	8d 76 00             	lea    0x0(%esi),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101cd0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101cd4:	66 83 f8 09          	cmp    $0x9,%ax
80101cd8:	77 36                	ja     80101d10 <writei+0x120>
80101cda:	8b 04 c5 84 29 11 80 	mov    -0x7feed67c(,%eax,8),%eax
80101ce1:	85 c0                	test   %eax,%eax
80101ce3:	74 2b                	je     80101d10 <writei+0x120>
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101ce5:	89 7d 10             	mov    %edi,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101ce8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ceb:	5b                   	pop    %ebx
80101cec:	5e                   	pop    %esi
80101ced:	5f                   	pop    %edi
80101cee:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101cef:	ff e0                	jmp    *%eax
80101cf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101cf8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101cfb:	83 ec 0c             	sub    $0xc,%esp
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101cfe:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101d01:	50                   	push   %eax
80101d02:	e8 59 fa ff ff       	call   80101760 <iupdate>
80101d07:	83 c4 10             	add    $0x10,%esp
80101d0a:	eb b6                	jmp    80101cc2 <writei+0xd2>
80101d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
80101d10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101d15:	eb ae                	jmp    80101cc5 <writei+0xd5>
80101d17:	89 f6                	mov    %esi,%esi
80101d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101d20 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101d20:	55                   	push   %ebp
80101d21:	89 e5                	mov    %esp,%ebp
80101d23:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101d26:	6a 0e                	push   $0xe
80101d28:	ff 75 0c             	pushl  0xc(%ebp)
80101d2b:	ff 75 08             	pushl  0x8(%ebp)
80101d2e:	e8 ad 30 00 00       	call   80104de0 <strncmp>
}
80101d33:	c9                   	leave  
80101d34:	c3                   	ret    
80101d35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101d40 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101d40:	55                   	push   %ebp
80101d41:	89 e5                	mov    %esp,%ebp
80101d43:	57                   	push   %edi
80101d44:	56                   	push   %esi
80101d45:	53                   	push   %ebx
80101d46:	83 ec 1c             	sub    $0x1c,%esp
80101d49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101d4c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101d51:	0f 85 80 00 00 00    	jne    80101dd7 <dirlookup+0x97>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101d57:	8b 53 58             	mov    0x58(%ebx),%edx
80101d5a:	31 ff                	xor    %edi,%edi
80101d5c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101d5f:	85 d2                	test   %edx,%edx
80101d61:	75 0d                	jne    80101d70 <dirlookup+0x30>
80101d63:	eb 5b                	jmp    80101dc0 <dirlookup+0x80>
80101d65:	8d 76 00             	lea    0x0(%esi),%esi
80101d68:	83 c7 10             	add    $0x10,%edi
80101d6b:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101d6e:	76 50                	jbe    80101dc0 <dirlookup+0x80>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d70:	6a 10                	push   $0x10
80101d72:	57                   	push   %edi
80101d73:	56                   	push   %esi
80101d74:	53                   	push   %ebx
80101d75:	e8 76 fd ff ff       	call   80101af0 <readi>
80101d7a:	83 c4 10             	add    $0x10,%esp
80101d7d:	83 f8 10             	cmp    $0x10,%eax
80101d80:	75 48                	jne    80101dca <dirlookup+0x8a>
      panic("dirlookup read");
    if(de.inum == 0)
80101d82:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d87:	74 df                	je     80101d68 <dirlookup+0x28>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
80101d89:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d8c:	83 ec 04             	sub    $0x4,%esp
80101d8f:	6a 0e                	push   $0xe
80101d91:	50                   	push   %eax
80101d92:	ff 75 0c             	pushl  0xc(%ebp)
80101d95:	e8 46 30 00 00       	call   80104de0 <strncmp>
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
80101d9a:	83 c4 10             	add    $0x10,%esp
80101d9d:	85 c0                	test   %eax,%eax
80101d9f:	75 c7                	jne    80101d68 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101da1:	8b 45 10             	mov    0x10(%ebp),%eax
80101da4:	85 c0                	test   %eax,%eax
80101da6:	74 05                	je     80101dad <dirlookup+0x6d>
        *poff = off;
80101da8:	8b 45 10             	mov    0x10(%ebp),%eax
80101dab:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
      return iget(dp->dev, inum);
80101dad:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
80101db1:	8b 03                	mov    (%ebx),%eax
80101db3:	e8 f8 f5 ff ff       	call   801013b0 <iget>
    }
  }

  return 0;
}
80101db8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dbb:	5b                   	pop    %ebx
80101dbc:	5e                   	pop    %esi
80101dbd:	5f                   	pop    %edi
80101dbe:	5d                   	pop    %ebp
80101dbf:	c3                   	ret    
80101dc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101dc3:	31 c0                	xor    %eax,%eax
}
80101dc5:	5b                   	pop    %ebx
80101dc6:	5e                   	pop    %esi
80101dc7:	5f                   	pop    %edi
80101dc8:	5d                   	pop    %ebp
80101dc9:	c3                   	ret    
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
80101dca:	83 ec 0c             	sub    $0xc,%esp
80101dcd:	68 d9 82 10 80       	push   $0x801082d9
80101dd2:	e8 99 e5 ff ff       	call   80100370 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101dd7:	83 ec 0c             	sub    $0xc,%esp
80101dda:	68 c7 82 10 80       	push   $0x801082c7
80101ddf:	e8 8c e5 ff ff       	call   80100370 <panic>
80101de4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101dea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101df0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101df0:	55                   	push   %ebp
80101df1:	89 e5                	mov    %esp,%ebp
80101df3:	57                   	push   %edi
80101df4:	56                   	push   %esi
80101df5:	53                   	push   %ebx
80101df6:	89 cf                	mov    %ecx,%edi
80101df8:	89 c3                	mov    %eax,%ebx
80101dfa:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101dfd:	80 38 2f             	cmpb   $0x2f,(%eax)
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101e00:	89 55 e0             	mov    %edx,-0x20(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101e03:	0f 84 53 01 00 00    	je     80101f5c <namex+0x16c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101e09:	e8 42 1b 00 00       	call   80103950 <myproc>
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101e0e:	83 ec 0c             	sub    $0xc,%esp
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101e11:	8b 70 68             	mov    0x68(%eax),%esi
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101e14:	68 00 2a 11 80       	push   $0x80112a00
80101e19:	e8 12 2c 00 00       	call   80104a30 <acquire>
  ip->ref++;
80101e1e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101e22:	c7 04 24 00 2a 11 80 	movl   $0x80112a00,(%esp)
80101e29:	e8 b2 2c 00 00       	call   80104ae0 <release>
80101e2e:	83 c4 10             	add    $0x10,%esp
80101e31:	eb 08                	jmp    80101e3b <namex+0x4b>
80101e33:	90                   	nop
80101e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  char *s;
  int len;

  while(*path == '/')
    path++;
80101e38:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80101e3b:	0f b6 03             	movzbl (%ebx),%eax
80101e3e:	3c 2f                	cmp    $0x2f,%al
80101e40:	74 f6                	je     80101e38 <namex+0x48>
    path++;
  if(*path == 0)
80101e42:	84 c0                	test   %al,%al
80101e44:	0f 84 e3 00 00 00    	je     80101f2d <namex+0x13d>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101e4a:	0f b6 03             	movzbl (%ebx),%eax
80101e4d:	89 da                	mov    %ebx,%edx
80101e4f:	84 c0                	test   %al,%al
80101e51:	0f 84 ac 00 00 00    	je     80101f03 <namex+0x113>
80101e57:	3c 2f                	cmp    $0x2f,%al
80101e59:	75 09                	jne    80101e64 <namex+0x74>
80101e5b:	e9 a3 00 00 00       	jmp    80101f03 <namex+0x113>
80101e60:	84 c0                	test   %al,%al
80101e62:	74 0a                	je     80101e6e <namex+0x7e>
    path++;
80101e64:	83 c2 01             	add    $0x1,%edx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101e67:	0f b6 02             	movzbl (%edx),%eax
80101e6a:	3c 2f                	cmp    $0x2f,%al
80101e6c:	75 f2                	jne    80101e60 <namex+0x70>
80101e6e:	89 d1                	mov    %edx,%ecx
80101e70:	29 d9                	sub    %ebx,%ecx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
80101e72:	83 f9 0d             	cmp    $0xd,%ecx
80101e75:	0f 8e 8d 00 00 00    	jle    80101f08 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101e7b:	83 ec 04             	sub    $0x4,%esp
80101e7e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101e81:	6a 0e                	push   $0xe
80101e83:	53                   	push   %ebx
80101e84:	57                   	push   %edi
80101e85:	e8 d6 2e 00 00       	call   80104d60 <memmove>
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101e8a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
80101e8d:	83 c4 10             	add    $0x10,%esp
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101e90:	89 d3                	mov    %edx,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101e92:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101e95:	75 11                	jne    80101ea8 <namex+0xb8>
80101e97:	89 f6                	mov    %esi,%esi
80101e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101ea0:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101ea3:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101ea6:	74 f8                	je     80101ea0 <namex+0xb0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101ea8:	83 ec 0c             	sub    $0xc,%esp
80101eab:	56                   	push   %esi
80101eac:	e8 5f f9 ff ff       	call   80101810 <ilock>
    if(ip->type != T_DIR){
80101eb1:	83 c4 10             	add    $0x10,%esp
80101eb4:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101eb9:	0f 85 7f 00 00 00    	jne    80101f3e <namex+0x14e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101ebf:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101ec2:	85 d2                	test   %edx,%edx
80101ec4:	74 09                	je     80101ecf <namex+0xdf>
80101ec6:	80 3b 00             	cmpb   $0x0,(%ebx)
80101ec9:	0f 84 a3 00 00 00    	je     80101f72 <namex+0x182>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101ecf:	83 ec 04             	sub    $0x4,%esp
80101ed2:	6a 00                	push   $0x0
80101ed4:	57                   	push   %edi
80101ed5:	56                   	push   %esi
80101ed6:	e8 65 fe ff ff       	call   80101d40 <dirlookup>
80101edb:	83 c4 10             	add    $0x10,%esp
80101ede:	85 c0                	test   %eax,%eax
80101ee0:	74 5c                	je     80101f3e <namex+0x14e>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101ee2:	83 ec 0c             	sub    $0xc,%esp
80101ee5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101ee8:	56                   	push   %esi
80101ee9:	e8 02 fa ff ff       	call   801018f0 <iunlock>
  iput(ip);
80101eee:	89 34 24             	mov    %esi,(%esp)
80101ef1:	e8 4a fa ff ff       	call   80101940 <iput>
80101ef6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101ef9:	83 c4 10             	add    $0x10,%esp
80101efc:	89 c6                	mov    %eax,%esi
80101efe:	e9 38 ff ff ff       	jmp    80101e3b <namex+0x4b>
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101f03:	31 c9                	xor    %ecx,%ecx
80101f05:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80101f08:	83 ec 04             	sub    $0x4,%esp
80101f0b:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101f0e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101f11:	51                   	push   %ecx
80101f12:	53                   	push   %ebx
80101f13:	57                   	push   %edi
80101f14:	e8 47 2e 00 00       	call   80104d60 <memmove>
    name[len] = 0;
80101f19:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101f1c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101f1f:	83 c4 10             	add    $0x10,%esp
80101f22:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101f26:	89 d3                	mov    %edx,%ebx
80101f28:	e9 65 ff ff ff       	jmp    80101e92 <namex+0xa2>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101f2d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101f30:	85 c0                	test   %eax,%eax
80101f32:	75 54                	jne    80101f88 <namex+0x198>
80101f34:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101f36:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f39:	5b                   	pop    %ebx
80101f3a:	5e                   	pop    %esi
80101f3b:	5f                   	pop    %edi
80101f3c:	5d                   	pop    %ebp
80101f3d:	c3                   	ret    

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101f3e:	83 ec 0c             	sub    $0xc,%esp
80101f41:	56                   	push   %esi
80101f42:	e8 a9 f9 ff ff       	call   801018f0 <iunlock>
  iput(ip);
80101f47:	89 34 24             	mov    %esi,(%esp)
80101f4a:	e8 f1 f9 ff ff       	call   80101940 <iput>
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101f4f:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101f52:	8d 65 f4             	lea    -0xc(%ebp),%esp
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101f55:	31 c0                	xor    %eax,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101f57:	5b                   	pop    %ebx
80101f58:	5e                   	pop    %esi
80101f59:	5f                   	pop    %edi
80101f5a:	5d                   	pop    %ebp
80101f5b:	c3                   	ret    
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
80101f5c:	ba 01 00 00 00       	mov    $0x1,%edx
80101f61:	b8 01 00 00 00       	mov    $0x1,%eax
80101f66:	e8 45 f4 ff ff       	call   801013b0 <iget>
80101f6b:	89 c6                	mov    %eax,%esi
80101f6d:	e9 c9 fe ff ff       	jmp    80101e3b <namex+0x4b>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
80101f72:	83 ec 0c             	sub    $0xc,%esp
80101f75:	56                   	push   %esi
80101f76:	e8 75 f9 ff ff       	call   801018f0 <iunlock>
      return ip;
80101f7b:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101f7e:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
      return ip;
80101f81:	89 f0                	mov    %esi,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101f83:	5b                   	pop    %ebx
80101f84:	5e                   	pop    %esi
80101f85:	5f                   	pop    %edi
80101f86:	5d                   	pop    %ebp
80101f87:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
80101f88:	83 ec 0c             	sub    $0xc,%esp
80101f8b:	56                   	push   %esi
80101f8c:	e8 af f9 ff ff       	call   80101940 <iput>
    return 0;
80101f91:	83 c4 10             	add    $0x10,%esp
80101f94:	31 c0                	xor    %eax,%eax
80101f96:	eb 9e                	jmp    80101f36 <namex+0x146>
80101f98:	90                   	nop
80101f99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101fa0 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80101fa0:	55                   	push   %ebp
80101fa1:	89 e5                	mov    %esp,%ebp
80101fa3:	57                   	push   %edi
80101fa4:	56                   	push   %esi
80101fa5:	53                   	push   %ebx
80101fa6:	83 ec 20             	sub    $0x20,%esp
80101fa9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80101fac:	6a 00                	push   $0x0
80101fae:	ff 75 0c             	pushl  0xc(%ebp)
80101fb1:	53                   	push   %ebx
80101fb2:	e8 89 fd ff ff       	call   80101d40 <dirlookup>
80101fb7:	83 c4 10             	add    $0x10,%esp
80101fba:	85 c0                	test   %eax,%eax
80101fbc:	75 67                	jne    80102025 <dirlink+0x85>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80101fbe:	8b 7b 58             	mov    0x58(%ebx),%edi
80101fc1:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fc4:	85 ff                	test   %edi,%edi
80101fc6:	74 29                	je     80101ff1 <dirlink+0x51>
80101fc8:	31 ff                	xor    %edi,%edi
80101fca:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fcd:	eb 09                	jmp    80101fd8 <dirlink+0x38>
80101fcf:	90                   	nop
80101fd0:	83 c7 10             	add    $0x10,%edi
80101fd3:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101fd6:	76 19                	jbe    80101ff1 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fd8:	6a 10                	push   $0x10
80101fda:	57                   	push   %edi
80101fdb:	56                   	push   %esi
80101fdc:	53                   	push   %ebx
80101fdd:	e8 0e fb ff ff       	call   80101af0 <readi>
80101fe2:	83 c4 10             	add    $0x10,%esp
80101fe5:	83 f8 10             	cmp    $0x10,%eax
80101fe8:	75 4e                	jne    80102038 <dirlink+0x98>
      panic("dirlink read");
    if(de.inum == 0)
80101fea:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101fef:	75 df                	jne    80101fd0 <dirlink+0x30>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80101ff1:	8d 45 da             	lea    -0x26(%ebp),%eax
80101ff4:	83 ec 04             	sub    $0x4,%esp
80101ff7:	6a 0e                	push   $0xe
80101ff9:	ff 75 0c             	pushl  0xc(%ebp)
80101ffc:	50                   	push   %eax
80101ffd:	e8 4e 2e 00 00       	call   80104e50 <strncpy>
  de.inum = inum;
80102002:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102005:	6a 10                	push   $0x10
80102007:	57                   	push   %edi
80102008:	56                   	push   %esi
80102009:	53                   	push   %ebx
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
8010200a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010200e:	e8 dd fb ff ff       	call   80101bf0 <writei>
80102013:	83 c4 20             	add    $0x20,%esp
80102016:	83 f8 10             	cmp    $0x10,%eax
80102019:	75 2a                	jne    80102045 <dirlink+0xa5>
    panic("dirlink");

  return 0;
8010201b:	31 c0                	xor    %eax,%eax
}
8010201d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102020:	5b                   	pop    %ebx
80102021:	5e                   	pop    %esi
80102022:	5f                   	pop    %edi
80102023:	5d                   	pop    %ebp
80102024:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
80102025:	83 ec 0c             	sub    $0xc,%esp
80102028:	50                   	push   %eax
80102029:	e8 12 f9 ff ff       	call   80101940 <iput>
    return -1;
8010202e:	83 c4 10             	add    $0x10,%esp
80102031:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102036:	eb e5                	jmp    8010201d <dirlink+0x7d>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80102038:	83 ec 0c             	sub    $0xc,%esp
8010203b:	68 e8 82 10 80       	push   $0x801082e8
80102040:	e8 2b e3 ff ff       	call   80100370 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80102045:	83 ec 0c             	sub    $0xc,%esp
80102048:	68 7a 8d 10 80       	push   $0x80108d7a
8010204d:	e8 1e e3 ff ff       	call   80100370 <panic>
80102052:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102059:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102060 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
80102060:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102061:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
80102063:	89 e5                	mov    %esp,%ebp
80102065:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102068:	8b 45 08             	mov    0x8(%ebp),%eax
8010206b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010206e:	e8 7d fd ff ff       	call   80101df0 <namex>
}
80102073:	c9                   	leave  
80102074:	c3                   	ret    
80102075:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102079:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102080 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102080:	55                   	push   %ebp
  return namex(path, 1, name);
80102081:	ba 01 00 00 00       	mov    $0x1,%edx
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
80102086:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102088:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010208b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010208e:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
8010208f:	e9 5c fd ff ff       	jmp    80101df0 <namex>
80102094:	66 90                	xchg   %ax,%ax
80102096:	66 90                	xchg   %ax,%ax
80102098:	66 90                	xchg   %ax,%ax
8010209a:	66 90                	xchg   %ax,%ax
8010209c:	66 90                	xchg   %ax,%ax
8010209e:	66 90                	xchg   %ax,%ax

801020a0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801020a0:	55                   	push   %ebp
  if(b == 0)
801020a1:	85 c0                	test   %eax,%eax
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801020a3:	89 e5                	mov    %esp,%ebp
801020a5:	56                   	push   %esi
801020a6:	53                   	push   %ebx
  if(b == 0)
801020a7:	0f 84 ad 00 00 00    	je     8010215a <idestart+0xba>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801020ad:	8b 58 08             	mov    0x8(%eax),%ebx
801020b0:	89 c1                	mov    %eax,%ecx
801020b2:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
801020b8:	0f 87 8f 00 00 00    	ja     8010214d <idestart+0xad>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020be:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020c3:	90                   	nop
801020c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801020c8:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020c9:	83 e0 c0             	and    $0xffffffc0,%eax
801020cc:	3c 40                	cmp    $0x40,%al
801020ce:	75 f8                	jne    801020c8 <idestart+0x28>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801020d0:	31 f6                	xor    %esi,%esi
801020d2:	ba f6 03 00 00       	mov    $0x3f6,%edx
801020d7:	89 f0                	mov    %esi,%eax
801020d9:	ee                   	out    %al,(%dx)
801020da:	ba f2 01 00 00       	mov    $0x1f2,%edx
801020df:	b8 01 00 00 00       	mov    $0x1,%eax
801020e4:	ee                   	out    %al,(%dx)
801020e5:	ba f3 01 00 00       	mov    $0x1f3,%edx
801020ea:	89 d8                	mov    %ebx,%eax
801020ec:	ee                   	out    %al,(%dx)
801020ed:	89 d8                	mov    %ebx,%eax
801020ef:	ba f4 01 00 00       	mov    $0x1f4,%edx
801020f4:	c1 f8 08             	sar    $0x8,%eax
801020f7:	ee                   	out    %al,(%dx)
801020f8:	ba f5 01 00 00       	mov    $0x1f5,%edx
801020fd:	89 f0                	mov    %esi,%eax
801020ff:	ee                   	out    %al,(%dx)
80102100:	0f b6 41 04          	movzbl 0x4(%ecx),%eax
80102104:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102109:	83 e0 01             	and    $0x1,%eax
8010210c:	c1 e0 04             	shl    $0x4,%eax
8010210f:	83 c8 e0             	or     $0xffffffe0,%eax
80102112:	ee                   	out    %al,(%dx)
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
80102113:	f6 01 04             	testb  $0x4,(%ecx)
80102116:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010211b:	75 13                	jne    80102130 <idestart+0x90>
8010211d:	b8 20 00 00 00       	mov    $0x20,%eax
80102122:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80102123:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102126:	5b                   	pop    %ebx
80102127:	5e                   	pop    %esi
80102128:	5d                   	pop    %ebp
80102129:	c3                   	ret    
8010212a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102130:	b8 30 00 00 00       	mov    $0x30,%eax
80102135:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
80102136:	ba f0 01 00 00       	mov    $0x1f0,%edx
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
8010213b:	8d 71 5c             	lea    0x5c(%ecx),%esi
8010213e:	b9 80 00 00 00       	mov    $0x80,%ecx
80102143:	fc                   	cld    
80102144:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80102146:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102149:	5b                   	pop    %ebx
8010214a:	5e                   	pop    %esi
8010214b:	5d                   	pop    %ebp
8010214c:	c3                   	ret    
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  if(b->blockno >= FSSIZE)
    panic("incorrect blockno");
8010214d:	83 ec 0c             	sub    $0xc,%esp
80102150:	68 54 83 10 80       	push   $0x80108354
80102155:	e8 16 e2 ff ff       	call   80100370 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
8010215a:	83 ec 0c             	sub    $0xc,%esp
8010215d:	68 4b 83 10 80       	push   $0x8010834b
80102162:	e8 09 e2 ff ff       	call   80100370 <panic>
80102167:	89 f6                	mov    %esi,%esi
80102169:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102170 <ideinit>:
  return 0;
}

void
ideinit(void)
{
80102170:	55                   	push   %ebp
80102171:	89 e5                	mov    %esp,%ebp
80102173:	83 ec 10             	sub    $0x10,%esp
  int i;

  initlock(&idelock, "ide");
80102176:	68 66 83 10 80       	push   $0x80108366
8010217b:	68 80 c5 10 80       	push   $0x8010c580
80102180:	e8 4b 27 00 00       	call   801048d0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102185:	58                   	pop    %eax
80102186:	a1 20 4d 11 80       	mov    0x80114d20,%eax
8010218b:	5a                   	pop    %edx
8010218c:	83 e8 01             	sub    $0x1,%eax
8010218f:	50                   	push   %eax
80102190:	6a 0e                	push   $0xe
80102192:	e8 a9 02 00 00       	call   80102440 <ioapicenable>
80102197:	83 c4 10             	add    $0x10,%esp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010219a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010219f:	90                   	nop
801021a0:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021a1:	83 e0 c0             	and    $0xffffffc0,%eax
801021a4:	3c 40                	cmp    $0x40,%al
801021a6:	75 f8                	jne    801021a0 <ideinit+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021a8:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021ad:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801021b2:	ee                   	out    %al,(%dx)
801021b3:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021b8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021bd:	eb 06                	jmp    801021c5 <ideinit+0x55>
801021bf:	90                   	nop
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
801021c0:	83 e9 01             	sub    $0x1,%ecx
801021c3:	74 0f                	je     801021d4 <ideinit+0x64>
801021c5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801021c6:	84 c0                	test   %al,%al
801021c8:	74 f6                	je     801021c0 <ideinit+0x50>
      havedisk1 = 1;
801021ca:	c7 05 60 c5 10 80 01 	movl   $0x1,0x8010c560
801021d1:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021d4:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021d9:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801021de:	ee                   	out    %al,(%dx)
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
801021df:	c9                   	leave  
801021e0:	c3                   	ret    
801021e1:	eb 0d                	jmp    801021f0 <ideintr>
801021e3:	90                   	nop
801021e4:	90                   	nop
801021e5:	90                   	nop
801021e6:	90                   	nop
801021e7:	90                   	nop
801021e8:	90                   	nop
801021e9:	90                   	nop
801021ea:	90                   	nop
801021eb:	90                   	nop
801021ec:	90                   	nop
801021ed:	90                   	nop
801021ee:	90                   	nop
801021ef:	90                   	nop

801021f0 <ideintr>:
}

// Interrupt handler.
void
ideintr(void)
{
801021f0:	55                   	push   %ebp
801021f1:	89 e5                	mov    %esp,%ebp
801021f3:	57                   	push   %edi
801021f4:	56                   	push   %esi
801021f5:	53                   	push   %ebx
801021f6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801021f9:	68 80 c5 10 80       	push   $0x8010c580
801021fe:	e8 2d 28 00 00       	call   80104a30 <acquire>

  if((b = idequeue) == 0){
80102203:	8b 1d 64 c5 10 80    	mov    0x8010c564,%ebx
80102209:	83 c4 10             	add    $0x10,%esp
8010220c:	85 db                	test   %ebx,%ebx
8010220e:	74 34                	je     80102244 <ideintr+0x54>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102210:	8b 43 58             	mov    0x58(%ebx),%eax
80102213:	a3 64 c5 10 80       	mov    %eax,0x8010c564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102218:	8b 33                	mov    (%ebx),%esi
8010221a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102220:	74 3e                	je     80102260 <ideintr+0x70>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102222:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102225:	83 ec 0c             	sub    $0xc,%esp
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102228:	83 ce 02             	or     $0x2,%esi
8010222b:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010222d:	53                   	push   %ebx
8010222e:	e8 9d 1e 00 00       	call   801040d0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102233:	a1 64 c5 10 80       	mov    0x8010c564,%eax
80102238:	83 c4 10             	add    $0x10,%esp
8010223b:	85 c0                	test   %eax,%eax
8010223d:	74 05                	je     80102244 <ideintr+0x54>
    idestart(idequeue);
8010223f:	e8 5c fe ff ff       	call   801020a0 <idestart>

  // First queued buffer is the active request.
  acquire(&idelock);

  if((b = idequeue) == 0){
    release(&idelock);
80102244:	83 ec 0c             	sub    $0xc,%esp
80102247:	68 80 c5 10 80       	push   $0x8010c580
8010224c:	e8 8f 28 00 00       	call   80104ae0 <release>
  // Start disk on next buf in queue.
  if(idequeue != 0)
    idestart(idequeue);

  release(&idelock);
}
80102251:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102254:	5b                   	pop    %ebx
80102255:	5e                   	pop    %esi
80102256:	5f                   	pop    %edi
80102257:	5d                   	pop    %ebp
80102258:	c3                   	ret    
80102259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102260:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102265:	8d 76 00             	lea    0x0(%esi),%esi
80102268:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102269:	89 c1                	mov    %eax,%ecx
8010226b:	83 e1 c0             	and    $0xffffffc0,%ecx
8010226e:	80 f9 40             	cmp    $0x40,%cl
80102271:	75 f5                	jne    80102268 <ideintr+0x78>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102273:	a8 21                	test   $0x21,%al
80102275:	75 ab                	jne    80102222 <ideintr+0x32>
  }
  idequeue = b->qnext;

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);
80102277:	8d 7b 5c             	lea    0x5c(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
8010227a:	b9 80 00 00 00       	mov    $0x80,%ecx
8010227f:	ba f0 01 00 00       	mov    $0x1f0,%edx
80102284:	fc                   	cld    
80102285:	f3 6d                	rep insl (%dx),%es:(%edi)
80102287:	8b 33                	mov    (%ebx),%esi
80102289:	eb 97                	jmp    80102222 <ideintr+0x32>
8010228b:	90                   	nop
8010228c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102290 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102290:	55                   	push   %ebp
80102291:	89 e5                	mov    %esp,%ebp
80102293:	53                   	push   %ebx
80102294:	83 ec 10             	sub    $0x10,%esp
80102297:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010229a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010229d:	50                   	push   %eax
8010229e:	e8 dd 25 00 00       	call   80104880 <holdingsleep>
801022a3:	83 c4 10             	add    $0x10,%esp
801022a6:	85 c0                	test   %eax,%eax
801022a8:	0f 84 ad 00 00 00    	je     8010235b <iderw+0xcb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801022ae:	8b 03                	mov    (%ebx),%eax
801022b0:	83 e0 06             	and    $0x6,%eax
801022b3:	83 f8 02             	cmp    $0x2,%eax
801022b6:	0f 84 b9 00 00 00    	je     80102375 <iderw+0xe5>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801022bc:	8b 53 04             	mov    0x4(%ebx),%edx
801022bf:	85 d2                	test   %edx,%edx
801022c1:	74 0d                	je     801022d0 <iderw+0x40>
801022c3:	a1 60 c5 10 80       	mov    0x8010c560,%eax
801022c8:	85 c0                	test   %eax,%eax
801022ca:	0f 84 98 00 00 00    	je     80102368 <iderw+0xd8>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801022d0:	83 ec 0c             	sub    $0xc,%esp
801022d3:	68 80 c5 10 80       	push   $0x8010c580
801022d8:	e8 53 27 00 00       	call   80104a30 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801022dd:	8b 15 64 c5 10 80    	mov    0x8010c564,%edx
801022e3:	83 c4 10             	add    $0x10,%esp
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
801022e6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801022ed:	85 d2                	test   %edx,%edx
801022ef:	75 09                	jne    801022fa <iderw+0x6a>
801022f1:	eb 58                	jmp    8010234b <iderw+0xbb>
801022f3:	90                   	nop
801022f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801022f8:	89 c2                	mov    %eax,%edx
801022fa:	8b 42 58             	mov    0x58(%edx),%eax
801022fd:	85 c0                	test   %eax,%eax
801022ff:	75 f7                	jne    801022f8 <iderw+0x68>
80102301:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102304:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102306:	3b 1d 64 c5 10 80    	cmp    0x8010c564,%ebx
8010230c:	74 44                	je     80102352 <iderw+0xc2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010230e:	8b 03                	mov    (%ebx),%eax
80102310:	83 e0 06             	and    $0x6,%eax
80102313:	83 f8 02             	cmp    $0x2,%eax
80102316:	74 23                	je     8010233b <iderw+0xab>
80102318:	90                   	nop
80102319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102320:	83 ec 08             	sub    $0x8,%esp
80102323:	68 80 c5 10 80       	push   $0x8010c580
80102328:	53                   	push   %ebx
80102329:	e8 e2 1b 00 00       	call   80103f10 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010232e:	8b 03                	mov    (%ebx),%eax
80102330:	83 c4 10             	add    $0x10,%esp
80102333:	83 e0 06             	and    $0x6,%eax
80102336:	83 f8 02             	cmp    $0x2,%eax
80102339:	75 e5                	jne    80102320 <iderw+0x90>
    sleep(b, &idelock);
  }


  release(&idelock);
8010233b:	c7 45 08 80 c5 10 80 	movl   $0x8010c580,0x8(%ebp)
}
80102342:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102345:	c9                   	leave  
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }


  release(&idelock);
80102346:	e9 95 27 00 00       	jmp    80104ae0 <release>

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010234b:	ba 64 c5 10 80       	mov    $0x8010c564,%edx
80102350:	eb b2                	jmp    80102304 <iderw+0x74>
    ;
  *pp = b;

  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
80102352:	89 d8                	mov    %ebx,%eax
80102354:	e8 47 fd ff ff       	call   801020a0 <idestart>
80102359:	eb b3                	jmp    8010230e <iderw+0x7e>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
8010235b:	83 ec 0c             	sub    $0xc,%esp
8010235e:	68 6a 83 10 80       	push   $0x8010836a
80102363:	e8 08 e0 ff ff       	call   80100370 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
80102368:	83 ec 0c             	sub    $0xc,%esp
8010236b:	68 95 83 10 80       	push   $0x80108395
80102370:	e8 fb df ff ff       	call   80100370 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
80102375:	83 ec 0c             	sub    $0xc,%esp
80102378:	68 80 83 10 80       	push   $0x80108380
8010237d:	e8 ee df ff ff       	call   80100370 <panic>
80102382:	66 90                	xchg   %ax,%ax
80102384:	66 90                	xchg   %ax,%ax
80102386:	66 90                	xchg   %ax,%ax
80102388:	66 90                	xchg   %ax,%ax
8010238a:	66 90                	xchg   %ax,%ax
8010238c:	66 90                	xchg   %ax,%ax
8010238e:	66 90                	xchg   %ax,%ax

80102390 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102390:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102391:	c7 05 54 46 11 80 00 	movl   $0xfec00000,0x80114654
80102398:	00 c0 fe 
  ioapic->data = data;
}

void
ioapicinit(void)
{
8010239b:	89 e5                	mov    %esp,%ebp
8010239d:	56                   	push   %esi
8010239e:	53                   	push   %ebx
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
8010239f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801023a6:	00 00 00 
  return ioapic->data;
801023a9:	8b 15 54 46 11 80    	mov    0x80114654,%edx
801023af:	8b 72 10             	mov    0x10(%edx),%esi
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
801023b2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801023b8:	8b 0d 54 46 11 80    	mov    0x80114654,%ecx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023be:	0f b6 15 80 47 11 80 	movzbl 0x80114780,%edx
ioapicinit(void)
{
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801023c5:	89 f0                	mov    %esi,%eax
801023c7:	c1 e8 10             	shr    $0x10,%eax
801023ca:	0f b6 f0             	movzbl %al,%esi

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  return ioapic->data;
801023cd:	8b 41 10             	mov    0x10(%ecx),%eax
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023d0:	c1 e8 18             	shr    $0x18,%eax
801023d3:	39 d0                	cmp    %edx,%eax
801023d5:	74 16                	je     801023ed <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801023d7:	83 ec 0c             	sub    $0xc,%esp
801023da:	68 b4 83 10 80       	push   $0x801083b4
801023df:	e8 fc e2 ff ff       	call   801006e0 <cprintf>
801023e4:	8b 0d 54 46 11 80    	mov    0x80114654,%ecx
801023ea:	83 c4 10             	add    $0x10,%esp
801023ed:	83 c6 21             	add    $0x21,%esi
  ioapic->data = data;
}

void
ioapicinit(void)
{
801023f0:	ba 10 00 00 00       	mov    $0x10,%edx
801023f5:	b8 20 00 00 00       	mov    $0x20,%eax
801023fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102400:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102402:	8b 0d 54 46 11 80    	mov    0x80114654,%ecx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102408:	89 c3                	mov    %eax,%ebx
8010240a:	81 cb 00 00 01 00    	or     $0x10000,%ebx
80102410:	83 c0 01             	add    $0x1,%eax

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102413:	89 59 10             	mov    %ebx,0x10(%ecx)
80102416:	8d 5a 01             	lea    0x1(%edx),%ebx
80102419:	83 c2 02             	add    $0x2,%edx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010241c:	39 f0                	cmp    %esi,%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010241e:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
80102420:	8b 0d 54 46 11 80    	mov    0x80114654,%ecx
80102426:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010242d:	75 d1                	jne    80102400 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010242f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102432:	5b                   	pop    %ebx
80102433:	5e                   	pop    %esi
80102434:	5d                   	pop    %ebp
80102435:	c3                   	ret    
80102436:	8d 76 00             	lea    0x0(%esi),%esi
80102439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102440 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102440:	55                   	push   %ebp
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102441:	8b 0d 54 46 11 80    	mov    0x80114654,%ecx
  }
}

void
ioapicenable(int irq, int cpunum)
{
80102447:	89 e5                	mov    %esp,%ebp
80102449:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010244c:	8d 50 20             	lea    0x20(%eax),%edx
8010244f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102453:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102455:	8b 0d 54 46 11 80    	mov    0x80114654,%ecx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010245b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010245e:	89 51 10             	mov    %edx,0x10(%ecx)
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102461:	8b 55 0c             	mov    0xc(%ebp),%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102464:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102466:	a1 54 46 11 80       	mov    0x80114654,%eax
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010246b:	c1 e2 18             	shl    $0x18,%edx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
8010246e:	89 50 10             	mov    %edx,0x10(%eax)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
80102471:	5d                   	pop    %ebp
80102472:	c3                   	ret    
80102473:	66 90                	xchg   %ax,%ax
80102475:	66 90                	xchg   %ax,%ax
80102477:	66 90                	xchg   %ax,%ax
80102479:	66 90                	xchg   %ax,%ax
8010247b:	66 90                	xchg   %ax,%ax
8010247d:	66 90                	xchg   %ax,%ax
8010247f:	90                   	nop

80102480 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102480:	55                   	push   %ebp
80102481:	89 e5                	mov    %esp,%ebp
80102483:	53                   	push   %ebx
80102484:	83 ec 04             	sub    $0x4,%esp
80102487:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010248a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102490:	75 70                	jne    80102502 <kfree+0x82>
80102492:	81 fb 28 ee 12 80    	cmp    $0x8012ee28,%ebx
80102498:	72 68                	jb     80102502 <kfree+0x82>
8010249a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801024a0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801024a5:	77 5b                	ja     80102502 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801024a7:	83 ec 04             	sub    $0x4,%esp
801024aa:	68 00 10 00 00       	push   $0x1000
801024af:	6a 01                	push   $0x1
801024b1:	53                   	push   %ebx
801024b2:	e8 f9 27 00 00       	call   80104cb0 <memset>

  if(kmem.use_lock)
801024b7:	8b 15 94 46 11 80    	mov    0x80114694,%edx
801024bd:	83 c4 10             	add    $0x10,%esp
801024c0:	85 d2                	test   %edx,%edx
801024c2:	75 2c                	jne    801024f0 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801024c4:	a1 98 46 11 80       	mov    0x80114698,%eax
801024c9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801024cb:	a1 94 46 11 80       	mov    0x80114694,%eax

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
801024d0:	89 1d 98 46 11 80    	mov    %ebx,0x80114698
  if(kmem.use_lock)
801024d6:	85 c0                	test   %eax,%eax
801024d8:	75 06                	jne    801024e0 <kfree+0x60>
    release(&kmem.lock);
}
801024da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024dd:	c9                   	leave  
801024de:	c3                   	ret    
801024df:	90                   	nop
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
801024e0:	c7 45 08 60 46 11 80 	movl   $0x80114660,0x8(%ebp)
}
801024e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024ea:	c9                   	leave  
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
801024eb:	e9 f0 25 00 00       	jmp    80104ae0 <release>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
801024f0:	83 ec 0c             	sub    $0xc,%esp
801024f3:	68 60 46 11 80       	push   $0x80114660
801024f8:	e8 33 25 00 00       	call   80104a30 <acquire>
801024fd:	83 c4 10             	add    $0x10,%esp
80102500:	eb c2                	jmp    801024c4 <kfree+0x44>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
80102502:	83 ec 0c             	sub    $0xc,%esp
80102505:	68 e6 83 10 80       	push   $0x801083e6
8010250a:	e8 61 de ff ff       	call   80100370 <panic>
8010250f:	90                   	nop

80102510 <freerange>:
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102510:	55                   	push   %ebp
80102511:	89 e5                	mov    %esp,%ebp
80102513:	56                   	push   %esi
80102514:	53                   	push   %ebx
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102515:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102518:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010251b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102521:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102527:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010252d:	39 de                	cmp    %ebx,%esi
8010252f:	72 23                	jb     80102554 <freerange+0x44>
80102531:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102538:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010253e:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102541:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102547:	50                   	push   %eax
80102548:	e8 33 ff ff ff       	call   80102480 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010254d:	83 c4 10             	add    $0x10,%esp
80102550:	39 f3                	cmp    %esi,%ebx
80102552:	76 e4                	jbe    80102538 <freerange+0x28>
    kfree(p);
}
80102554:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102557:	5b                   	pop    %ebx
80102558:	5e                   	pop    %esi
80102559:	5d                   	pop    %ebp
8010255a:	c3                   	ret    
8010255b:	90                   	nop
8010255c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102560 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102560:	55                   	push   %ebp
80102561:	89 e5                	mov    %esp,%ebp
80102563:	56                   	push   %esi
80102564:	53                   	push   %ebx
80102565:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102568:	83 ec 08             	sub    $0x8,%esp
8010256b:	68 ec 83 10 80       	push   $0x801083ec
80102570:	68 60 46 11 80       	push   $0x80114660
80102575:	e8 56 23 00 00       	call   801048d0 <initlock>

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010257a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010257d:	83 c4 10             	add    $0x10,%esp
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
80102580:	c7 05 94 46 11 80 00 	movl   $0x0,0x80114694
80102587:	00 00 00 

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010258a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102590:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102596:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010259c:	39 de                	cmp    %ebx,%esi
8010259e:	72 1c                	jb     801025bc <kinit1+0x5c>
    kfree(p);
801025a0:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801025a6:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025a9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025af:	50                   	push   %eax
801025b0:	e8 cb fe ff ff       	call   80102480 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025b5:	83 c4 10             	add    $0x10,%esp
801025b8:	39 de                	cmp    %ebx,%esi
801025ba:	73 e4                	jae    801025a0 <kinit1+0x40>
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}
801025bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025bf:	5b                   	pop    %ebx
801025c0:	5e                   	pop    %esi
801025c1:	5d                   	pop    %ebp
801025c2:	c3                   	ret    
801025c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801025c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801025d0 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
801025d0:	55                   	push   %ebp
801025d1:	89 e5                	mov    %esp,%ebp
801025d3:	56                   	push   %esi
801025d4:	53                   	push   %ebx

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801025d5:	8b 45 08             	mov    0x8(%ebp),%eax
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
801025d8:	8b 75 0c             	mov    0xc(%ebp),%esi

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801025db:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025e1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025e7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025ed:	39 de                	cmp    %ebx,%esi
801025ef:	72 23                	jb     80102614 <kinit2+0x44>
801025f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025f8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801025fe:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102601:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102607:	50                   	push   %eax
80102608:	e8 73 fe ff ff       	call   80102480 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010260d:	83 c4 10             	add    $0x10,%esp
80102610:	39 de                	cmp    %ebx,%esi
80102612:	73 e4                	jae    801025f8 <kinit2+0x28>

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
80102614:	c7 05 94 46 11 80 01 	movl   $0x1,0x80114694
8010261b:	00 00 00 
}
8010261e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102621:	5b                   	pop    %ebx
80102622:	5e                   	pop    %esi
80102623:	5d                   	pop    %ebp
80102624:	c3                   	ret    
80102625:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102630 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102630:	55                   	push   %ebp
80102631:	89 e5                	mov    %esp,%ebp
80102633:	53                   	push   %ebx
80102634:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102637:	a1 94 46 11 80       	mov    0x80114694,%eax
8010263c:	85 c0                	test   %eax,%eax
8010263e:	75 30                	jne    80102670 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102640:	8b 1d 98 46 11 80    	mov    0x80114698,%ebx
  if(r)
80102646:	85 db                	test   %ebx,%ebx
80102648:	74 1c                	je     80102666 <kalloc+0x36>
    kmem.freelist = r->next;
8010264a:	8b 13                	mov    (%ebx),%edx
8010264c:	89 15 98 46 11 80    	mov    %edx,0x80114698
  if(kmem.use_lock)
80102652:	85 c0                	test   %eax,%eax
80102654:	74 10                	je     80102666 <kalloc+0x36>
    release(&kmem.lock);
80102656:	83 ec 0c             	sub    $0xc,%esp
80102659:	68 60 46 11 80       	push   $0x80114660
8010265e:	e8 7d 24 00 00       	call   80104ae0 <release>
80102663:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
}
80102666:	89 d8                	mov    %ebx,%eax
80102668:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010266b:	c9                   	leave  
8010266c:	c3                   	ret    
8010266d:	8d 76 00             	lea    0x0(%esi),%esi
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102670:	83 ec 0c             	sub    $0xc,%esp
80102673:	68 60 46 11 80       	push   $0x80114660
80102678:	e8 b3 23 00 00       	call   80104a30 <acquire>
  r = kmem.freelist;
8010267d:	8b 1d 98 46 11 80    	mov    0x80114698,%ebx
  if(r)
80102683:	83 c4 10             	add    $0x10,%esp
80102686:	a1 94 46 11 80       	mov    0x80114694,%eax
8010268b:	85 db                	test   %ebx,%ebx
8010268d:	75 bb                	jne    8010264a <kalloc+0x1a>
8010268f:	eb c1                	jmp    80102652 <kalloc+0x22>
80102691:	66 90                	xchg   %ax,%ax
80102693:	66 90                	xchg   %ax,%ax
80102695:	66 90                	xchg   %ax,%ax
80102697:	66 90                	xchg   %ax,%ax
80102699:	66 90                	xchg   %ax,%ax
8010269b:	66 90                	xchg   %ax,%ax
8010269d:	66 90                	xchg   %ax,%ax
8010269f:	90                   	nop

801026a0 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
801026a0:	55                   	push   %ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026a1:	ba 64 00 00 00       	mov    $0x64,%edx
801026a6:	89 e5                	mov    %esp,%ebp
801026a8:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801026a9:	a8 01                	test   $0x1,%al
801026ab:	0f 84 af 00 00 00    	je     80102760 <kbdgetc+0xc0>
801026b1:	ba 60 00 00 00       	mov    $0x60,%edx
801026b6:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
801026b7:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
801026ba:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
801026c0:	74 7e                	je     80102740 <kbdgetc+0xa0>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801026c2:	84 c0                	test   %al,%al
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
801026c4:	8b 0d b4 c5 10 80    	mov    0x8010c5b4,%ecx
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801026ca:	79 24                	jns    801026f0 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
801026cc:	f6 c1 40             	test   $0x40,%cl
801026cf:	75 05                	jne    801026d6 <kbdgetc+0x36>
801026d1:	89 c2                	mov    %eax,%edx
801026d3:	83 e2 7f             	and    $0x7f,%edx
    shift &= ~(shiftcode[data] | E0ESC);
801026d6:	0f b6 82 20 85 10 80 	movzbl -0x7fef7ae0(%edx),%eax
801026dd:	83 c8 40             	or     $0x40,%eax
801026e0:	0f b6 c0             	movzbl %al,%eax
801026e3:	f7 d0                	not    %eax
801026e5:	21 c8                	and    %ecx,%eax
801026e7:	a3 b4 c5 10 80       	mov    %eax,0x8010c5b4
    return 0;
801026ec:	31 c0                	xor    %eax,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801026ee:	5d                   	pop    %ebp
801026ef:	c3                   	ret    
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801026f0:	f6 c1 40             	test   $0x40,%cl
801026f3:	74 09                	je     801026fe <kbdgetc+0x5e>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801026f5:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801026f8:	83 e1 bf             	and    $0xffffffbf,%ecx
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801026fb:	0f b6 d0             	movzbl %al,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
801026fe:	0f b6 82 20 85 10 80 	movzbl -0x7fef7ae0(%edx),%eax
80102705:	09 c1                	or     %eax,%ecx
80102707:	0f b6 82 20 84 10 80 	movzbl -0x7fef7be0(%edx),%eax
8010270e:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102710:	89 c8                	mov    %ecx,%eax
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
80102712:	89 0d b4 c5 10 80    	mov    %ecx,0x8010c5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102718:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010271b:	83 e1 08             	and    $0x8,%ecx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
8010271e:	8b 04 85 00 84 10 80 	mov    -0x7fef7c00(,%eax,4),%eax
80102725:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102729:	74 c3                	je     801026ee <kbdgetc+0x4e>
    if('a' <= c && c <= 'z')
8010272b:	8d 50 9f             	lea    -0x61(%eax),%edx
8010272e:	83 fa 19             	cmp    $0x19,%edx
80102731:	77 1d                	ja     80102750 <kbdgetc+0xb0>
      c += 'A' - 'a';
80102733:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102736:	5d                   	pop    %ebp
80102737:	c3                   	ret    
80102738:	90                   	nop
80102739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
80102740:	31 c0                	xor    %eax,%eax
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102742:	83 0d b4 c5 10 80 40 	orl    $0x40,0x8010c5b4
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102749:	5d                   	pop    %ebp
8010274a:	c3                   	ret    
8010274b:	90                   	nop
8010274c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
80102750:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102753:	8d 50 20             	lea    0x20(%eax),%edx
  }
  return c;
}
80102756:	5d                   	pop    %ebp
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
80102757:	83 f9 19             	cmp    $0x19,%ecx
8010275a:	0f 46 c2             	cmovbe %edx,%eax
  }
  return c;
}
8010275d:	c3                   	ret    
8010275e:	66 90                	xchg   %ax,%ax
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
80102760:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102765:	5d                   	pop    %ebp
80102766:	c3                   	ret    
80102767:	89 f6                	mov    %esi,%esi
80102769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102770 <kbdintr>:

void
kbdintr(void)
{
80102770:	55                   	push   %ebp
80102771:	89 e5                	mov    %esp,%ebp
80102773:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102776:	68 a0 26 10 80       	push   $0x801026a0
8010277b:	e8 f0 e0 ff ff       	call   80100870 <consoleintr>
}
80102780:	83 c4 10             	add    $0x10,%esp
80102783:	c9                   	leave  
80102784:	c3                   	ret    
80102785:	66 90                	xchg   %ax,%ax
80102787:	66 90                	xchg   %ax,%ax
80102789:	66 90                	xchg   %ax,%ax
8010278b:	66 90                	xchg   %ax,%ax
8010278d:	66 90                	xchg   %ax,%ax
8010278f:	90                   	nop

80102790 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102790:	a1 9c 46 11 80       	mov    0x8011469c,%eax
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
80102795:	55                   	push   %ebp
80102796:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102798:	85 c0                	test   %eax,%eax
8010279a:	0f 84 c8 00 00 00    	je     80102868 <lapicinit+0xd8>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027a0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801027a7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027aa:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027ad:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801027b4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027b7:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027ba:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801027c1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801027c4:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027c7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801027ce:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801027d1:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027d4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801027db:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801027de:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027e1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801027e8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801027eb:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801027ee:	8b 50 30             	mov    0x30(%eax),%edx
801027f1:	c1 ea 10             	shr    $0x10,%edx
801027f4:	80 fa 03             	cmp    $0x3,%dl
801027f7:	77 77                	ja     80102870 <lapicinit+0xe0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027f9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102800:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102803:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102806:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010280d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102810:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102813:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010281a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010281d:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102820:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102827:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010282a:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010282d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102834:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102837:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010283a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102841:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102844:	8b 50 20             	mov    0x20(%eax),%edx
80102847:	89 f6                	mov    %esi,%esi
80102849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102850:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102856:	80 e6 10             	and    $0x10,%dh
80102859:	75 f5                	jne    80102850 <lapicinit+0xc0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010285b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102862:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102865:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102868:	5d                   	pop    %ebp
80102869:	c3                   	ret    
8010286a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102870:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102877:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010287a:	8b 50 20             	mov    0x20(%eax),%edx
8010287d:	e9 77 ff ff ff       	jmp    801027f9 <lapicinit+0x69>
80102882:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102890 <lapicid>:
}

int
lapicid(void)
{
  if (!lapic)
80102890:	a1 9c 46 11 80       	mov    0x8011469c,%eax
  lapicw(TPR, 0);
}

int
lapicid(void)
{
80102895:	55                   	push   %ebp
80102896:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102898:	85 c0                	test   %eax,%eax
8010289a:	74 0c                	je     801028a8 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
8010289c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010289f:	5d                   	pop    %ebp
int
lapicid(void)
{
  if (!lapic)
    return 0;
  return lapic[ID] >> 24;
801028a0:	c1 e8 18             	shr    $0x18,%eax
}
801028a3:	c3                   	ret    
801028a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

int
lapicid(void)
{
  if (!lapic)
    return 0;
801028a8:	31 c0                	xor    %eax,%eax
  return lapic[ID] >> 24;
}
801028aa:	5d                   	pop    %ebp
801028ab:	c3                   	ret    
801028ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801028b0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
801028b0:	a1 9c 46 11 80       	mov    0x8011469c,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
801028b5:	55                   	push   %ebp
801028b6:	89 e5                	mov    %esp,%ebp
  if(lapic)
801028b8:	85 c0                	test   %eax,%eax
801028ba:	74 0d                	je     801028c9 <lapiceoi+0x19>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801028bc:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801028c3:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028c6:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
801028c9:	5d                   	pop    %ebp
801028ca:	c3                   	ret    
801028cb:	90                   	nop
801028cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801028d0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801028d0:	55                   	push   %ebp
801028d1:	89 e5                	mov    %esp,%ebp
}
801028d3:	5d                   	pop    %ebp
801028d4:	c3                   	ret    
801028d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801028e0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801028e0:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028e1:	ba 70 00 00 00       	mov    $0x70,%edx
801028e6:	b8 0f 00 00 00       	mov    $0xf,%eax
801028eb:	89 e5                	mov    %esp,%ebp
801028ed:	53                   	push   %ebx
801028ee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801028f1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801028f4:	ee                   	out    %al,(%dx)
801028f5:	ba 71 00 00 00       	mov    $0x71,%edx
801028fa:	b8 0a 00 00 00       	mov    $0xa,%eax
801028ff:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102900:	31 c0                	xor    %eax,%eax

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102902:	c1 e3 18             	shl    $0x18,%ebx
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102905:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010290b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010290d:	c1 e9 0c             	shr    $0xc,%ecx
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
80102910:	c1 e8 04             	shr    $0x4,%eax

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102913:	89 da                	mov    %ebx,%edx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102915:	80 cd 06             	or     $0x6,%ch
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
80102918:	66 a3 69 04 00 80    	mov    %ax,0x80000469

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010291e:	a1 9c 46 11 80       	mov    0x8011469c,%eax
80102923:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102929:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010292c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102933:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102936:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102939:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102940:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102943:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102946:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010294c:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010294f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102955:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102958:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010295e:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102961:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102967:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
8010296a:	5b                   	pop    %ebx
8010296b:	5d                   	pop    %ebp
8010296c:	c3                   	ret    
8010296d:	8d 76 00             	lea    0x0(%esi),%esi

80102970 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102970:	55                   	push   %ebp
80102971:	ba 70 00 00 00       	mov    $0x70,%edx
80102976:	b8 0b 00 00 00       	mov    $0xb,%eax
8010297b:	89 e5                	mov    %esp,%ebp
8010297d:	57                   	push   %edi
8010297e:	56                   	push   %esi
8010297f:	53                   	push   %ebx
80102980:	83 ec 4c             	sub    $0x4c,%esp
80102983:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102984:	ba 71 00 00 00       	mov    $0x71,%edx
80102989:	ec                   	in     (%dx),%al
8010298a:	83 e0 04             	and    $0x4,%eax
8010298d:	8d 75 d0             	lea    -0x30(%ebp),%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102990:	31 db                	xor    %ebx,%ebx
80102992:	88 45 b7             	mov    %al,-0x49(%ebp)
80102995:	bf 70 00 00 00       	mov    $0x70,%edi
8010299a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801029a0:	89 d8                	mov    %ebx,%eax
801029a2:	89 fa                	mov    %edi,%edx
801029a4:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029a5:	b9 71 00 00 00       	mov    $0x71,%ecx
801029aa:	89 ca                	mov    %ecx,%edx
801029ac:	ec                   	in     (%dx),%al
}

static void
fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
801029ad:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029b0:	89 fa                	mov    %edi,%edx
801029b2:	89 45 b8             	mov    %eax,-0x48(%ebp)
801029b5:	b8 02 00 00 00       	mov    $0x2,%eax
801029ba:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029bb:	89 ca                	mov    %ecx,%edx
801029bd:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
801029be:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029c1:	89 fa                	mov    %edi,%edx
801029c3:	89 45 bc             	mov    %eax,-0x44(%ebp)
801029c6:	b8 04 00 00 00       	mov    $0x4,%eax
801029cb:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029cc:	89 ca                	mov    %ecx,%edx
801029ce:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
801029cf:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029d2:	89 fa                	mov    %edi,%edx
801029d4:	89 45 c0             	mov    %eax,-0x40(%ebp)
801029d7:	b8 07 00 00 00       	mov    $0x7,%eax
801029dc:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029dd:	89 ca                	mov    %ecx,%edx
801029df:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
801029e0:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029e3:	89 fa                	mov    %edi,%edx
801029e5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801029e8:	b8 08 00 00 00       	mov    $0x8,%eax
801029ed:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029ee:	89 ca                	mov    %ecx,%edx
801029f0:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
801029f1:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029f4:	89 fa                	mov    %edi,%edx
801029f6:	89 45 c8             	mov    %eax,-0x38(%ebp)
801029f9:	b8 09 00 00 00       	mov    $0x9,%eax
801029fe:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029ff:	89 ca                	mov    %ecx,%edx
80102a01:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
80102a02:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a05:	89 fa                	mov    %edi,%edx
80102a07:	89 45 cc             	mov    %eax,-0x34(%ebp)
80102a0a:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a0f:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a10:	89 ca                	mov    %ecx,%edx
80102a12:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a13:	84 c0                	test   %al,%al
80102a15:	78 89                	js     801029a0 <cmostime+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a17:	89 d8                	mov    %ebx,%eax
80102a19:	89 fa                	mov    %edi,%edx
80102a1b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a1c:	89 ca                	mov    %ecx,%edx
80102a1e:	ec                   	in     (%dx),%al
}

static void
fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
80102a1f:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a22:	89 fa                	mov    %edi,%edx
80102a24:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102a27:	b8 02 00 00 00       	mov    $0x2,%eax
80102a2c:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a2d:	89 ca                	mov    %ecx,%edx
80102a2f:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
80102a30:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a33:	89 fa                	mov    %edi,%edx
80102a35:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102a38:	b8 04 00 00 00       	mov    $0x4,%eax
80102a3d:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a3e:	89 ca                	mov    %ecx,%edx
80102a40:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
80102a41:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a44:	89 fa                	mov    %edi,%edx
80102a46:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102a49:	b8 07 00 00 00       	mov    $0x7,%eax
80102a4e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a4f:	89 ca                	mov    %ecx,%edx
80102a51:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
80102a52:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a55:	89 fa                	mov    %edi,%edx
80102a57:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102a5a:	b8 08 00 00 00       	mov    $0x8,%eax
80102a5f:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a60:	89 ca                	mov    %ecx,%edx
80102a62:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
80102a63:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a66:	89 fa                	mov    %edi,%edx
80102a68:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102a6b:	b8 09 00 00 00       	mov    $0x9,%eax
80102a70:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a71:	89 ca                	mov    %ecx,%edx
80102a73:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
80102a74:	0f b6 c0             	movzbl %al,%eax
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102a77:	83 ec 04             	sub    $0x4,%esp
  r->second = cmos_read(SECS);
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
80102a7a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102a7d:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102a80:	6a 18                	push   $0x18
80102a82:	56                   	push   %esi
80102a83:	50                   	push   %eax
80102a84:	e8 77 22 00 00       	call   80104d00 <memcmp>
80102a89:	83 c4 10             	add    $0x10,%esp
80102a8c:	85 c0                	test   %eax,%eax
80102a8e:	0f 85 0c ff ff ff    	jne    801029a0 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102a94:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
80102a98:	75 78                	jne    80102b12 <cmostime+0x1a2>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102a9a:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102a9d:	89 c2                	mov    %eax,%edx
80102a9f:	83 e0 0f             	and    $0xf,%eax
80102aa2:	c1 ea 04             	shr    $0x4,%edx
80102aa5:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102aa8:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102aab:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102aae:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102ab1:	89 c2                	mov    %eax,%edx
80102ab3:	83 e0 0f             	and    $0xf,%eax
80102ab6:	c1 ea 04             	shr    $0x4,%edx
80102ab9:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102abc:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102abf:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102ac2:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102ac5:	89 c2                	mov    %eax,%edx
80102ac7:	83 e0 0f             	and    $0xf,%eax
80102aca:	c1 ea 04             	shr    $0x4,%edx
80102acd:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ad0:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ad3:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102ad6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102ad9:	89 c2                	mov    %eax,%edx
80102adb:	83 e0 0f             	and    $0xf,%eax
80102ade:	c1 ea 04             	shr    $0x4,%edx
80102ae1:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ae4:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ae7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102aea:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102aed:	89 c2                	mov    %eax,%edx
80102aef:	83 e0 0f             	and    $0xf,%eax
80102af2:	c1 ea 04             	shr    $0x4,%edx
80102af5:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102af8:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102afb:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102afe:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b01:	89 c2                	mov    %eax,%edx
80102b03:	83 e0 0f             	and    $0xf,%eax
80102b06:	c1 ea 04             	shr    $0x4,%edx
80102b09:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b0c:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b0f:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102b12:	8b 75 08             	mov    0x8(%ebp),%esi
80102b15:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b18:	89 06                	mov    %eax,(%esi)
80102b1a:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b1d:	89 46 04             	mov    %eax,0x4(%esi)
80102b20:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b23:	89 46 08             	mov    %eax,0x8(%esi)
80102b26:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b29:	89 46 0c             	mov    %eax,0xc(%esi)
80102b2c:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b2f:	89 46 10             	mov    %eax,0x10(%esi)
80102b32:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b35:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102b38:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102b3f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b42:	5b                   	pop    %ebx
80102b43:	5e                   	pop    %esi
80102b44:	5f                   	pop    %edi
80102b45:	5d                   	pop    %ebp
80102b46:	c3                   	ret    
80102b47:	66 90                	xchg   %ax,%ax
80102b49:	66 90                	xchg   %ax,%ax
80102b4b:	66 90                	xchg   %ax,%ax
80102b4d:	66 90                	xchg   %ax,%ax
80102b4f:	90                   	nop

80102b50 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102b50:	8b 0d e8 46 11 80    	mov    0x801146e8,%ecx
80102b56:	85 c9                	test   %ecx,%ecx
80102b58:	0f 8e 85 00 00 00    	jle    80102be3 <install_trans+0x93>
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102b5e:	55                   	push   %ebp
80102b5f:	89 e5                	mov    %esp,%ebp
80102b61:	57                   	push   %edi
80102b62:	56                   	push   %esi
80102b63:	53                   	push   %ebx
80102b64:	31 db                	xor    %ebx,%ebx
80102b66:	83 ec 0c             	sub    $0xc,%esp
80102b69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102b70:	a1 d4 46 11 80       	mov    0x801146d4,%eax
80102b75:	83 ec 08             	sub    $0x8,%esp
80102b78:	01 d8                	add    %ebx,%eax
80102b7a:	83 c0 01             	add    $0x1,%eax
80102b7d:	50                   	push   %eax
80102b7e:	ff 35 e4 46 11 80    	pushl  0x801146e4
80102b84:	e8 47 d5 ff ff       	call   801000d0 <bread>
80102b89:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102b8b:	58                   	pop    %eax
80102b8c:	5a                   	pop    %edx
80102b8d:	ff 34 9d ec 46 11 80 	pushl  -0x7feeb914(,%ebx,4)
80102b94:	ff 35 e4 46 11 80    	pushl  0x801146e4
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102b9a:	83 c3 01             	add    $0x1,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102b9d:	e8 2e d5 ff ff       	call   801000d0 <bread>
80102ba2:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102ba4:	8d 47 5c             	lea    0x5c(%edi),%eax
80102ba7:	83 c4 0c             	add    $0xc,%esp
80102baa:	68 00 02 00 00       	push   $0x200
80102baf:	50                   	push   %eax
80102bb0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102bb3:	50                   	push   %eax
80102bb4:	e8 a7 21 00 00       	call   80104d60 <memmove>
    bwrite(dbuf);  // write dst to disk
80102bb9:	89 34 24             	mov    %esi,(%esp)
80102bbc:	e8 df d5 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102bc1:	89 3c 24             	mov    %edi,(%esp)
80102bc4:	e8 17 d6 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102bc9:	89 34 24             	mov    %esi,(%esp)
80102bcc:	e8 0f d6 ff ff       	call   801001e0 <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102bd1:	83 c4 10             	add    $0x10,%esp
80102bd4:	39 1d e8 46 11 80    	cmp    %ebx,0x801146e8
80102bda:	7f 94                	jg     80102b70 <install_trans+0x20>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
80102bdc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102bdf:	5b                   	pop    %ebx
80102be0:	5e                   	pop    %esi
80102be1:	5f                   	pop    %edi
80102be2:	5d                   	pop    %ebp
80102be3:	f3 c3                	repz ret 
80102be5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102bf0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102bf0:	55                   	push   %ebp
80102bf1:	89 e5                	mov    %esp,%ebp
80102bf3:	53                   	push   %ebx
80102bf4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102bf7:	ff 35 d4 46 11 80    	pushl  0x801146d4
80102bfd:	ff 35 e4 46 11 80    	pushl  0x801146e4
80102c03:	e8 c8 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102c08:	8b 0d e8 46 11 80    	mov    0x801146e8,%ecx
  for (i = 0; i < log.lh.n; i++) {
80102c0e:	83 c4 10             	add    $0x10,%esp
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102c11:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102c13:	85 c9                	test   %ecx,%ecx
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102c15:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102c18:	7e 1f                	jle    80102c39 <write_head+0x49>
80102c1a:	8d 04 8d 00 00 00 00 	lea    0x0(,%ecx,4),%eax
80102c21:	31 d2                	xor    %edx,%edx
80102c23:	90                   	nop
80102c24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102c28:	8b 8a ec 46 11 80    	mov    -0x7feeb914(%edx),%ecx
80102c2e:	89 4c 13 60          	mov    %ecx,0x60(%ebx,%edx,1)
80102c32:	83 c2 04             	add    $0x4,%edx
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102c35:	39 c2                	cmp    %eax,%edx
80102c37:	75 ef                	jne    80102c28 <write_head+0x38>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80102c39:	83 ec 0c             	sub    $0xc,%esp
80102c3c:	53                   	push   %ebx
80102c3d:	e8 5e d5 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102c42:	89 1c 24             	mov    %ebx,(%esp)
80102c45:	e8 96 d5 ff ff       	call   801001e0 <brelse>
}
80102c4a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c4d:	c9                   	leave  
80102c4e:	c3                   	ret    
80102c4f:	90                   	nop

80102c50 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102c50:	55                   	push   %ebp
80102c51:	89 e5                	mov    %esp,%ebp
80102c53:	53                   	push   %ebx
80102c54:	83 ec 2c             	sub    $0x2c,%esp
80102c57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102c5a:	68 20 86 10 80       	push   $0x80108620
80102c5f:	68 a0 46 11 80       	push   $0x801146a0
80102c64:	e8 67 1c 00 00       	call   801048d0 <initlock>
  readsb(dev, &sb);
80102c69:	58                   	pop    %eax
80102c6a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102c6d:	5a                   	pop    %edx
80102c6e:	50                   	push   %eax
80102c6f:	53                   	push   %ebx
80102c70:	e8 db e8 ff ff       	call   80101550 <readsb>
  log.start = sb.logstart;
  log.size = sb.nlog;
80102c75:	8b 55 e8             	mov    -0x18(%ebp),%edx
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102c78:	8b 45 ec             	mov    -0x14(%ebp),%eax

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102c7b:	59                   	pop    %ecx
  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
80102c7c:	89 1d e4 46 11 80    	mov    %ebx,0x801146e4

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
80102c82:	89 15 d8 46 11 80    	mov    %edx,0x801146d8
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102c88:	a3 d4 46 11 80       	mov    %eax,0x801146d4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102c8d:	5a                   	pop    %edx
80102c8e:	50                   	push   %eax
80102c8f:	53                   	push   %ebx
80102c90:	e8 3b d4 ff ff       	call   801000d0 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102c95:	8b 48 5c             	mov    0x5c(%eax),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102c98:	83 c4 10             	add    $0x10,%esp
80102c9b:	85 c9                	test   %ecx,%ecx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102c9d:	89 0d e8 46 11 80    	mov    %ecx,0x801146e8
  for (i = 0; i < log.lh.n; i++) {
80102ca3:	7e 1c                	jle    80102cc1 <initlog+0x71>
80102ca5:	8d 1c 8d 00 00 00 00 	lea    0x0(,%ecx,4),%ebx
80102cac:	31 d2                	xor    %edx,%edx
80102cae:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102cb0:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102cb4:	83 c2 04             	add    $0x4,%edx
80102cb7:	89 8a e8 46 11 80    	mov    %ecx,-0x7feeb918(%edx)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102cbd:	39 da                	cmp    %ebx,%edx
80102cbf:	75 ef                	jne    80102cb0 <initlog+0x60>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80102cc1:	83 ec 0c             	sub    $0xc,%esp
80102cc4:	50                   	push   %eax
80102cc5:	e8 16 d5 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102cca:	e8 81 fe ff ff       	call   80102b50 <install_trans>
  log.lh.n = 0;
80102ccf:	c7 05 e8 46 11 80 00 	movl   $0x0,0x801146e8
80102cd6:	00 00 00 
  write_head(); // clear the log
80102cd9:	e8 12 ff ff ff       	call   80102bf0 <write_head>
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
  recover_from_log();
}
80102cde:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ce1:	c9                   	leave  
80102ce2:	c3                   	ret    
80102ce3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102ce9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102cf0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102cf0:	55                   	push   %ebp
80102cf1:	89 e5                	mov    %esp,%ebp
80102cf3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102cf6:	68 a0 46 11 80       	push   $0x801146a0
80102cfb:	e8 30 1d 00 00       	call   80104a30 <acquire>
80102d00:	83 c4 10             	add    $0x10,%esp
80102d03:	eb 18                	jmp    80102d1d <begin_op+0x2d>
80102d05:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d08:	83 ec 08             	sub    $0x8,%esp
80102d0b:	68 a0 46 11 80       	push   $0x801146a0
80102d10:	68 a0 46 11 80       	push   $0x801146a0
80102d15:	e8 f6 11 00 00       	call   80103f10 <sleep>
80102d1a:	83 c4 10             	add    $0x10,%esp
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
80102d1d:	a1 e0 46 11 80       	mov    0x801146e0,%eax
80102d22:	85 c0                	test   %eax,%eax
80102d24:	75 e2                	jne    80102d08 <begin_op+0x18>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102d26:	a1 dc 46 11 80       	mov    0x801146dc,%eax
80102d2b:	8b 15 e8 46 11 80    	mov    0x801146e8,%edx
80102d31:	83 c0 01             	add    $0x1,%eax
80102d34:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102d37:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102d3a:	83 fa 1e             	cmp    $0x1e,%edx
80102d3d:	7f c9                	jg     80102d08 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102d3f:	83 ec 0c             	sub    $0xc,%esp
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80102d42:	a3 dc 46 11 80       	mov    %eax,0x801146dc
      release(&log.lock);
80102d47:	68 a0 46 11 80       	push   $0x801146a0
80102d4c:	e8 8f 1d 00 00       	call   80104ae0 <release>
      break;
    }
  }
}
80102d51:	83 c4 10             	add    $0x10,%esp
80102d54:	c9                   	leave  
80102d55:	c3                   	ret    
80102d56:	8d 76 00             	lea    0x0(%esi),%esi
80102d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102d60 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102d60:	55                   	push   %ebp
80102d61:	89 e5                	mov    %esp,%ebp
80102d63:	57                   	push   %edi
80102d64:	56                   	push   %esi
80102d65:	53                   	push   %ebx
80102d66:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102d69:	68 a0 46 11 80       	push   $0x801146a0
80102d6e:	e8 bd 1c 00 00       	call   80104a30 <acquire>
  log.outstanding -= 1;
80102d73:	a1 dc 46 11 80       	mov    0x801146dc,%eax
  if(log.committing)
80102d78:	8b 1d e0 46 11 80    	mov    0x801146e0,%ebx
80102d7e:	83 c4 10             	add    $0x10,%esp
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102d81:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102d84:	85 db                	test   %ebx,%ebx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102d86:	a3 dc 46 11 80       	mov    %eax,0x801146dc
  if(log.committing)
80102d8b:	0f 85 23 01 00 00    	jne    80102eb4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102d91:	85 c0                	test   %eax,%eax
80102d93:	0f 85 f7 00 00 00    	jne    80102e90 <end_op+0x130>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102d99:	83 ec 0c             	sub    $0xc,%esp
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
80102d9c:	c7 05 e0 46 11 80 01 	movl   $0x1,0x801146e0
80102da3:	00 00 00 
}

static void
commit()
{
  if (log.lh.n > 0) {
80102da6:	31 db                	xor    %ebx,%ebx
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102da8:	68 a0 46 11 80       	push   $0x801146a0
80102dad:	e8 2e 1d 00 00       	call   80104ae0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102db2:	8b 0d e8 46 11 80    	mov    0x801146e8,%ecx
80102db8:	83 c4 10             	add    $0x10,%esp
80102dbb:	85 c9                	test   %ecx,%ecx
80102dbd:	0f 8e 8a 00 00 00    	jle    80102e4d <end_op+0xed>
80102dc3:	90                   	nop
80102dc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102dc8:	a1 d4 46 11 80       	mov    0x801146d4,%eax
80102dcd:	83 ec 08             	sub    $0x8,%esp
80102dd0:	01 d8                	add    %ebx,%eax
80102dd2:	83 c0 01             	add    $0x1,%eax
80102dd5:	50                   	push   %eax
80102dd6:	ff 35 e4 46 11 80    	pushl  0x801146e4
80102ddc:	e8 ef d2 ff ff       	call   801000d0 <bread>
80102de1:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102de3:	58                   	pop    %eax
80102de4:	5a                   	pop    %edx
80102de5:	ff 34 9d ec 46 11 80 	pushl  -0x7feeb914(,%ebx,4)
80102dec:	ff 35 e4 46 11 80    	pushl  0x801146e4
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102df2:	83 c3 01             	add    $0x1,%ebx
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102df5:	e8 d6 d2 ff ff       	call   801000d0 <bread>
80102dfa:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102dfc:	8d 40 5c             	lea    0x5c(%eax),%eax
80102dff:	83 c4 0c             	add    $0xc,%esp
80102e02:	68 00 02 00 00       	push   $0x200
80102e07:	50                   	push   %eax
80102e08:	8d 46 5c             	lea    0x5c(%esi),%eax
80102e0b:	50                   	push   %eax
80102e0c:	e8 4f 1f 00 00       	call   80104d60 <memmove>
    bwrite(to);  // write the log
80102e11:	89 34 24             	mov    %esi,(%esp)
80102e14:	e8 87 d3 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102e19:	89 3c 24             	mov    %edi,(%esp)
80102e1c:	e8 bf d3 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102e21:	89 34 24             	mov    %esi,(%esp)
80102e24:	e8 b7 d3 ff ff       	call   801001e0 <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102e29:	83 c4 10             	add    $0x10,%esp
80102e2c:	3b 1d e8 46 11 80    	cmp    0x801146e8,%ebx
80102e32:	7c 94                	jl     80102dc8 <end_op+0x68>
static void
commit()
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102e34:	e8 b7 fd ff ff       	call   80102bf0 <write_head>
    install_trans(); // Now install writes to home locations
80102e39:	e8 12 fd ff ff       	call   80102b50 <install_trans>
    log.lh.n = 0;
80102e3e:	c7 05 e8 46 11 80 00 	movl   $0x0,0x801146e8
80102e45:	00 00 00 
    write_head();    // Erase the transaction from the log
80102e48:	e8 a3 fd ff ff       	call   80102bf0 <write_head>

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
80102e4d:	83 ec 0c             	sub    $0xc,%esp
80102e50:	68 a0 46 11 80       	push   $0x801146a0
80102e55:	e8 d6 1b 00 00       	call   80104a30 <acquire>
    log.committing = 0;
    wakeup(&log);
80102e5a:	c7 04 24 a0 46 11 80 	movl   $0x801146a0,(%esp)
  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
    log.committing = 0;
80102e61:	c7 05 e0 46 11 80 00 	movl   $0x0,0x801146e0
80102e68:	00 00 00 
    wakeup(&log);
80102e6b:	e8 60 12 00 00       	call   801040d0 <wakeup>
    release(&log.lock);
80102e70:	c7 04 24 a0 46 11 80 	movl   $0x801146a0,(%esp)
80102e77:	e8 64 1c 00 00       	call   80104ae0 <release>
80102e7c:	83 c4 10             	add    $0x10,%esp
  }
}
80102e7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e82:	5b                   	pop    %ebx
80102e83:	5e                   	pop    %esi
80102e84:	5f                   	pop    %edi
80102e85:	5d                   	pop    %ebp
80102e86:	c3                   	ret    
80102e87:	89 f6                	mov    %esi,%esi
80102e89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
80102e90:	83 ec 0c             	sub    $0xc,%esp
80102e93:	68 a0 46 11 80       	push   $0x801146a0
80102e98:	e8 33 12 00 00       	call   801040d0 <wakeup>
  }
  release(&log.lock);
80102e9d:	c7 04 24 a0 46 11 80 	movl   $0x801146a0,(%esp)
80102ea4:	e8 37 1c 00 00       	call   80104ae0 <release>
80102ea9:	83 c4 10             	add    $0x10,%esp
    acquire(&log.lock);
    log.committing = 0;
    wakeup(&log);
    release(&log.lock);
  }
}
80102eac:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102eaf:	5b                   	pop    %ebx
80102eb0:	5e                   	pop    %esi
80102eb1:	5f                   	pop    %edi
80102eb2:	5d                   	pop    %ebp
80102eb3:	c3                   	ret    
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
80102eb4:	83 ec 0c             	sub    $0xc,%esp
80102eb7:	68 24 86 10 80       	push   $0x80108624
80102ebc:	e8 af d4 ff ff       	call   80100370 <panic>
80102ec1:	eb 0d                	jmp    80102ed0 <log_write>
80102ec3:	90                   	nop
80102ec4:	90                   	nop
80102ec5:	90                   	nop
80102ec6:	90                   	nop
80102ec7:	90                   	nop
80102ec8:	90                   	nop
80102ec9:	90                   	nop
80102eca:	90                   	nop
80102ecb:	90                   	nop
80102ecc:	90                   	nop
80102ecd:	90                   	nop
80102ece:	90                   	nop
80102ecf:	90                   	nop

80102ed0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102ed0:	55                   	push   %ebp
80102ed1:	89 e5                	mov    %esp,%ebp
80102ed3:	53                   	push   %ebx
80102ed4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102ed7:	8b 15 e8 46 11 80    	mov    0x801146e8,%edx
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102edd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102ee0:	83 fa 1d             	cmp    $0x1d,%edx
80102ee3:	0f 8f 97 00 00 00    	jg     80102f80 <log_write+0xb0>
80102ee9:	a1 d8 46 11 80       	mov    0x801146d8,%eax
80102eee:	83 e8 01             	sub    $0x1,%eax
80102ef1:	39 c2                	cmp    %eax,%edx
80102ef3:	0f 8d 87 00 00 00    	jge    80102f80 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102ef9:	a1 dc 46 11 80       	mov    0x801146dc,%eax
80102efe:	85 c0                	test   %eax,%eax
80102f00:	0f 8e 87 00 00 00    	jle    80102f8d <log_write+0xbd>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f06:	83 ec 0c             	sub    $0xc,%esp
80102f09:	68 a0 46 11 80       	push   $0x801146a0
80102f0e:	e8 1d 1b 00 00       	call   80104a30 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102f13:	8b 15 e8 46 11 80    	mov    0x801146e8,%edx
80102f19:	83 c4 10             	add    $0x10,%esp
80102f1c:	83 fa 00             	cmp    $0x0,%edx
80102f1f:	7e 50                	jle    80102f71 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f21:	8b 4b 08             	mov    0x8(%ebx),%ecx
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102f24:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f26:	3b 0d ec 46 11 80    	cmp    0x801146ec,%ecx
80102f2c:	75 0b                	jne    80102f39 <log_write+0x69>
80102f2e:	eb 38                	jmp    80102f68 <log_write+0x98>
80102f30:	39 0c 85 ec 46 11 80 	cmp    %ecx,-0x7feeb914(,%eax,4)
80102f37:	74 2f                	je     80102f68 <log_write+0x98>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102f39:	83 c0 01             	add    $0x1,%eax
80102f3c:	39 d0                	cmp    %edx,%eax
80102f3e:	75 f0                	jne    80102f30 <log_write+0x60>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102f40:	89 0c 95 ec 46 11 80 	mov    %ecx,-0x7feeb914(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102f47:	83 c2 01             	add    $0x1,%edx
80102f4a:	89 15 e8 46 11 80    	mov    %edx,0x801146e8
  b->flags |= B_DIRTY; // prevent eviction
80102f50:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102f53:	c7 45 08 a0 46 11 80 	movl   $0x801146a0,0x8(%ebp)
}
80102f5a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102f5d:	c9                   	leave  
  }
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
80102f5e:	e9 7d 1b 00 00       	jmp    80104ae0 <release>
80102f63:	90                   	nop
80102f64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102f68:	89 0c 85 ec 46 11 80 	mov    %ecx,-0x7feeb914(,%eax,4)
80102f6f:	eb df                	jmp    80102f50 <log_write+0x80>
80102f71:	8b 43 08             	mov    0x8(%ebx),%eax
80102f74:	a3 ec 46 11 80       	mov    %eax,0x801146ec
  if (i == log.lh.n)
80102f79:	75 d5                	jne    80102f50 <log_write+0x80>
80102f7b:	eb ca                	jmp    80102f47 <log_write+0x77>
80102f7d:	8d 76 00             	lea    0x0(%esi),%esi
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
80102f80:	83 ec 0c             	sub    $0xc,%esp
80102f83:	68 33 86 10 80       	push   $0x80108633
80102f88:	e8 e3 d3 ff ff       	call   80100370 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
80102f8d:	83 ec 0c             	sub    $0xc,%esp
80102f90:	68 49 86 10 80       	push   $0x80108649
80102f95:	e8 d6 d3 ff ff       	call   80100370 <panic>
80102f9a:	66 90                	xchg   %ax,%ax
80102f9c:	66 90                	xchg   %ax,%ax
80102f9e:	66 90                	xchg   %ax,%ax

80102fa0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102fa0:	55                   	push   %ebp
80102fa1:	89 e5                	mov    %esp,%ebp
80102fa3:	53                   	push   %ebx
80102fa4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102fa7:	e8 84 09 00 00       	call   80103930 <cpuid>
80102fac:	89 c3                	mov    %eax,%ebx
80102fae:	e8 7d 09 00 00       	call   80103930 <cpuid>
80102fb3:	83 ec 04             	sub    $0x4,%esp
80102fb6:	53                   	push   %ebx
80102fb7:	50                   	push   %eax
80102fb8:	68 64 86 10 80       	push   $0x80108664
80102fbd:	e8 1e d7 ff ff       	call   801006e0 <cprintf>
  idtinit();       // load idt register
80102fc2:	e8 c9 39 00 00       	call   80106990 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102fc7:	e8 e4 08 00 00       	call   801038b0 <mycpu>
80102fcc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102fce:	b8 01 00 00 00       	mov    $0x1,%eax
80102fd3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102fda:	e8 31 0c 00 00       	call   80103c10 <scheduler>
80102fdf:	90                   	nop

80102fe0 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80102fe0:	55                   	push   %ebp
80102fe1:	89 e5                	mov    %esp,%ebp
80102fe3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102fe6:	e8 c5 4a 00 00       	call   80107ab0 <switchkvm>
  seginit();
80102feb:	e8 c0 49 00 00       	call   801079b0 <seginit>
  lapicinit();
80102ff0:	e8 9b f7 ff ff       	call   80102790 <lapicinit>
  mpmain();
80102ff5:	e8 a6 ff ff ff       	call   80102fa0 <mpmain>
80102ffa:	66 90                	xchg   %ax,%ax
80102ffc:	66 90                	xchg   %ax,%ax
80102ffe:	66 90                	xchg   %ax,%ax

80103000 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80103000:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103004:	83 e4 f0             	and    $0xfffffff0,%esp
80103007:	ff 71 fc             	pushl  -0x4(%ecx)
8010300a:	55                   	push   %ebp
8010300b:	89 e5                	mov    %esp,%ebp
8010300d:	53                   	push   %ebx
8010300e:	51                   	push   %ecx
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
8010300f:	bb a0 47 11 80       	mov    $0x801147a0,%ebx
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103014:	83 ec 08             	sub    $0x8,%esp
80103017:	68 00 00 40 80       	push   $0x80400000
8010301c:	68 28 ee 12 80       	push   $0x8012ee28
80103021:	e8 3a f5 ff ff       	call   80102560 <kinit1>
  kvmalloc();      // kernel page table
80103026:	e8 25 4f 00 00       	call   80107f50 <kvmalloc>
  mpinit();        // detect other processors
8010302b:	e8 70 01 00 00       	call   801031a0 <mpinit>
  lapicinit();     // interrupt controller
80103030:	e8 5b f7 ff ff       	call   80102790 <lapicinit>
  seginit();       // segment descriptors
80103035:	e8 76 49 00 00       	call   801079b0 <seginit>
  picinit();       // disable pic
8010303a:	e8 31 03 00 00       	call   80103370 <picinit>
  ioapicinit();    // another interrupt controller
8010303f:	e8 4c f3 ff ff       	call   80102390 <ioapicinit>
  consoleinit();   // console hardware
80103044:	e8 f7 da ff ff       	call   80100b40 <consoleinit>
  uartinit();      // serial port
80103049:	e8 32 3c 00 00       	call   80106c80 <uartinit>
  pinit();         // process table
8010304e:	e8 3d 08 00 00       	call   80103890 <pinit>
  tvinit();        // trap vectors
80103053:	e8 98 38 00 00       	call   801068f0 <tvinit>
  binit();         // buffer cache
80103058:	e8 e3 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
8010305d:	e8 8e de ff ff       	call   80100ef0 <fileinit>
  ideinit();       // disk 
80103062:	e8 09 f1 ff ff       	call   80102170 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103067:	83 c4 0c             	add    $0xc,%esp
8010306a:	68 8a 00 00 00       	push   $0x8a
8010306f:	68 8c c4 10 80       	push   $0x8010c48c
80103074:	68 00 70 00 80       	push   $0x80007000
80103079:	e8 e2 1c 00 00       	call   80104d60 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010307e:	69 05 20 4d 11 80 b0 	imul   $0xb0,0x80114d20,%eax
80103085:	00 00 00 
80103088:	83 c4 10             	add    $0x10,%esp
8010308b:	05 a0 47 11 80       	add    $0x801147a0,%eax
80103090:	39 d8                	cmp    %ebx,%eax
80103092:	76 6f                	jbe    80103103 <main+0x103>
80103094:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
80103098:	e8 13 08 00 00       	call   801038b0 <mycpu>
8010309d:	39 d8                	cmp    %ebx,%eax
8010309f:	74 49                	je     801030ea <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801030a1:	e8 8a f5 ff ff       	call   80102630 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
801030a6:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
801030ab:	c7 05 f8 6f 00 80 e0 	movl   $0x80102fe0,0x80006ff8
801030b2:	2f 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801030b5:	c7 05 f4 6f 00 80 00 	movl   $0x10b000,0x80006ff4
801030bc:	b0 10 00 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
801030bf:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801030c4:	0f b6 03             	movzbl (%ebx),%eax
801030c7:	83 ec 08             	sub    $0x8,%esp
801030ca:	68 00 70 00 00       	push   $0x7000
801030cf:	50                   	push   %eax
801030d0:	e8 0b f8 ff ff       	call   801028e0 <lapicstartap>
801030d5:	83 c4 10             	add    $0x10,%esp
801030d8:	90                   	nop
801030d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801030e0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801030e6:	85 c0                	test   %eax,%eax
801030e8:	74 f6                	je     801030e0 <main+0xe0>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
801030ea:	69 05 20 4d 11 80 b0 	imul   $0xb0,0x80114d20,%eax
801030f1:	00 00 00 
801030f4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801030fa:	05 a0 47 11 80       	add    $0x801147a0,%eax
801030ff:	39 c3                	cmp    %eax,%ebx
80103101:	72 95                	jb     80103098 <main+0x98>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk 
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103103:	83 ec 08             	sub    $0x8,%esp
80103106:	68 00 00 00 8e       	push   $0x8e000000
8010310b:	68 00 00 40 80       	push   $0x80400000
80103110:	e8 bb f4 ff ff       	call   801025d0 <kinit2>
  userinit();      // first user process
80103115:	e8 66 08 00 00       	call   80103980 <userinit>
  mpmain();        // finish this processor's setup
8010311a:	e8 81 fe ff ff       	call   80102fa0 <mpmain>
8010311f:	90                   	nop

80103120 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103120:	55                   	push   %ebp
80103121:	89 e5                	mov    %esp,%ebp
80103123:	57                   	push   %edi
80103124:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103125:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
8010312b:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
8010312c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
8010312f:	83 ec 0c             	sub    $0xc,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103132:	39 de                	cmp    %ebx,%esi
80103134:	73 48                	jae    8010317e <mpsearch1+0x5e>
80103136:	8d 76 00             	lea    0x0(%esi),%esi
80103139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103140:	83 ec 04             	sub    $0x4,%esp
80103143:	8d 7e 10             	lea    0x10(%esi),%edi
80103146:	6a 04                	push   $0x4
80103148:	68 78 86 10 80       	push   $0x80108678
8010314d:	56                   	push   %esi
8010314e:	e8 ad 1b 00 00       	call   80104d00 <memcmp>
80103153:	83 c4 10             	add    $0x10,%esp
80103156:	85 c0                	test   %eax,%eax
80103158:	75 1e                	jne    80103178 <mpsearch1+0x58>
8010315a:	8d 7e 10             	lea    0x10(%esi),%edi
8010315d:	89 f2                	mov    %esi,%edx
8010315f:	31 c9                	xor    %ecx,%ecx
80103161:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
80103168:	0f b6 02             	movzbl (%edx),%eax
8010316b:	83 c2 01             	add    $0x1,%edx
8010316e:	01 c1                	add    %eax,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103170:	39 fa                	cmp    %edi,%edx
80103172:	75 f4                	jne    80103168 <mpsearch1+0x48>
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103174:	84 c9                	test   %cl,%cl
80103176:	74 10                	je     80103188 <mpsearch1+0x68>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103178:	39 fb                	cmp    %edi,%ebx
8010317a:	89 fe                	mov    %edi,%esi
8010317c:	77 c2                	ja     80103140 <mpsearch1+0x20>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
8010317e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103181:	31 c0                	xor    %eax,%eax
}
80103183:	5b                   	pop    %ebx
80103184:	5e                   	pop    %esi
80103185:	5f                   	pop    %edi
80103186:	5d                   	pop    %ebp
80103187:	c3                   	ret    
80103188:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010318b:	89 f0                	mov    %esi,%eax
8010318d:	5b                   	pop    %ebx
8010318e:	5e                   	pop    %esi
8010318f:	5f                   	pop    %edi
80103190:	5d                   	pop    %ebp
80103191:	c3                   	ret    
80103192:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801031a0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801031a0:	55                   	push   %ebp
801031a1:	89 e5                	mov    %esp,%ebp
801031a3:	57                   	push   %edi
801031a4:	56                   	push   %esi
801031a5:	53                   	push   %ebx
801031a6:	83 ec 1c             	sub    $0x1c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801031a9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801031b0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801031b7:	c1 e0 08             	shl    $0x8,%eax
801031ba:	09 d0                	or     %edx,%eax
801031bc:	c1 e0 04             	shl    $0x4,%eax
801031bf:	85 c0                	test   %eax,%eax
801031c1:	75 1b                	jne    801031de <mpinit+0x3e>
    if((mp = mpsearch1(p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
801031c3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801031ca:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801031d1:	c1 e0 08             	shl    $0x8,%eax
801031d4:	09 d0                	or     %edx,%eax
801031d6:	c1 e0 0a             	shl    $0xa,%eax
801031d9:	2d 00 04 00 00       	sub    $0x400,%eax
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
    if((mp = mpsearch1(p, 1024)))
801031de:	ba 00 04 00 00       	mov    $0x400,%edx
801031e3:	e8 38 ff ff ff       	call   80103120 <mpsearch1>
801031e8:	85 c0                	test   %eax,%eax
801031ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801031ed:	0f 84 37 01 00 00    	je     8010332a <mpinit+0x18a>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801031f6:	8b 58 04             	mov    0x4(%eax),%ebx
801031f9:	85 db                	test   %ebx,%ebx
801031fb:	0f 84 43 01 00 00    	je     80103344 <mpinit+0x1a4>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103201:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103207:	83 ec 04             	sub    $0x4,%esp
8010320a:	6a 04                	push   $0x4
8010320c:	68 7d 86 10 80       	push   $0x8010867d
80103211:	56                   	push   %esi
80103212:	e8 e9 1a 00 00       	call   80104d00 <memcmp>
80103217:	83 c4 10             	add    $0x10,%esp
8010321a:	85 c0                	test   %eax,%eax
8010321c:	0f 85 22 01 00 00    	jne    80103344 <mpinit+0x1a4>
    return 0;
  if(conf->version != 1 && conf->version != 4)
80103222:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103229:	3c 01                	cmp    $0x1,%al
8010322b:	74 08                	je     80103235 <mpinit+0x95>
8010322d:	3c 04                	cmp    $0x4,%al
8010322f:	0f 85 0f 01 00 00    	jne    80103344 <mpinit+0x1a4>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103235:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
8010323c:	85 ff                	test   %edi,%edi
8010323e:	74 21                	je     80103261 <mpinit+0xc1>
80103240:	31 d2                	xor    %edx,%edx
80103242:	31 c0                	xor    %eax,%eax
80103244:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103248:	0f b6 8c 03 00 00 00 	movzbl -0x80000000(%ebx,%eax,1),%ecx
8010324f:	80 
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103250:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103253:	01 ca                	add    %ecx,%edx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103255:	39 c7                	cmp    %eax,%edi
80103257:	75 ef                	jne    80103248 <mpinit+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103259:	84 d2                	test   %dl,%dl
8010325b:	0f 85 e3 00 00 00    	jne    80103344 <mpinit+0x1a4>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103261:	85 f6                	test   %esi,%esi
80103263:	0f 84 db 00 00 00    	je     80103344 <mpinit+0x1a4>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103269:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
8010326f:	a3 9c 46 11 80       	mov    %eax,0x8011469c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103274:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
8010327b:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
80103281:	bb 01 00 00 00       	mov    $0x1,%ebx
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103286:	01 d6                	add    %edx,%esi
80103288:	90                   	nop
80103289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103290:	39 c6                	cmp    %eax,%esi
80103292:	76 23                	jbe    801032b7 <mpinit+0x117>
80103294:	0f b6 10             	movzbl (%eax),%edx
    switch(*p){
80103297:	80 fa 04             	cmp    $0x4,%dl
8010329a:	0f 87 c0 00 00 00    	ja     80103360 <mpinit+0x1c0>
801032a0:	ff 24 95 bc 86 10 80 	jmp    *-0x7fef7944(,%edx,4)
801032a7:	89 f6                	mov    %esi,%esi
801032a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801032b0:	83 c0 08             	add    $0x8,%eax

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032b3:	39 c6                	cmp    %eax,%esi
801032b5:	77 dd                	ja     80103294 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801032b7:	85 db                	test   %ebx,%ebx
801032b9:	0f 84 92 00 00 00    	je     80103351 <mpinit+0x1b1>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801032bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801032c2:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
801032c6:	74 15                	je     801032dd <mpinit+0x13d>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032c8:	ba 22 00 00 00       	mov    $0x22,%edx
801032cd:	b8 70 00 00 00       	mov    $0x70,%eax
801032d2:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032d3:	ba 23 00 00 00       	mov    $0x23,%edx
801032d8:	ec                   	in     (%dx),%al
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032d9:	83 c8 01             	or     $0x1,%eax
801032dc:	ee                   	out    %al,(%dx)
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
801032dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801032e0:	5b                   	pop    %ebx
801032e1:	5e                   	pop    %esi
801032e2:	5f                   	pop    %edi
801032e3:	5d                   	pop    %ebp
801032e4:	c3                   	ret    
801032e5:	8d 76 00             	lea    0x0(%esi),%esi
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
801032e8:	8b 0d 20 4d 11 80    	mov    0x80114d20,%ecx
801032ee:	83 f9 07             	cmp    $0x7,%ecx
801032f1:	7f 19                	jg     8010330c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801032f3:	0f b6 50 01          	movzbl 0x1(%eax),%edx
801032f7:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
801032fd:	83 c1 01             	add    $0x1,%ecx
80103300:	89 0d 20 4d 11 80    	mov    %ecx,0x80114d20
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103306:	88 97 a0 47 11 80    	mov    %dl,-0x7feeb860(%edi)
        ncpu++;
      }
      p += sizeof(struct mpproc);
8010330c:	83 c0 14             	add    $0x14,%eax
      continue;
8010330f:	e9 7c ff ff ff       	jmp    80103290 <mpinit+0xf0>
80103314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
80103318:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010331c:	83 c0 08             	add    $0x8,%eax
      }
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
8010331f:	88 15 80 47 11 80    	mov    %dl,0x80114780
      p += sizeof(struct mpioapic);
      continue;
80103325:	e9 66 ff ff ff       	jmp    80103290 <mpinit+0xf0>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
8010332a:	ba 00 00 01 00       	mov    $0x10000,%edx
8010332f:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80103334:	e8 e7 fd ff ff       	call   80103120 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103339:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
8010333b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010333e:	0f 85 af fe ff ff    	jne    801031f3 <mpinit+0x53>
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
80103344:	83 ec 0c             	sub    $0xc,%esp
80103347:	68 82 86 10 80       	push   $0x80108682
8010334c:	e8 1f d0 ff ff       	call   80100370 <panic>
      ismp = 0;
      break;
    }
  }
  if(!ismp)
    panic("Didn't find a suitable machine");
80103351:	83 ec 0c             	sub    $0xc,%esp
80103354:	68 9c 86 10 80       	push   $0x8010869c
80103359:	e8 12 d0 ff ff       	call   80100370 <panic>
8010335e:	66 90                	xchg   %ax,%ax
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
80103360:	31 db                	xor    %ebx,%ebx
80103362:	e9 30 ff ff ff       	jmp    80103297 <mpinit+0xf7>
80103367:	66 90                	xchg   %ax,%ax
80103369:	66 90                	xchg   %ax,%ax
8010336b:	66 90                	xchg   %ax,%ax
8010336d:	66 90                	xchg   %ax,%ax
8010336f:	90                   	nop

80103370 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103370:	55                   	push   %ebp
80103371:	ba 21 00 00 00       	mov    $0x21,%edx
80103376:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010337b:	89 e5                	mov    %esp,%ebp
8010337d:	ee                   	out    %al,(%dx)
8010337e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103383:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103384:	5d                   	pop    %ebp
80103385:	c3                   	ret    
80103386:	66 90                	xchg   %ax,%ax
80103388:	66 90                	xchg   %ax,%ax
8010338a:	66 90                	xchg   %ax,%ax
8010338c:	66 90                	xchg   %ax,%ax
8010338e:	66 90                	xchg   %ax,%ax

80103390 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103390:	55                   	push   %ebp
80103391:	89 e5                	mov    %esp,%ebp
80103393:	57                   	push   %edi
80103394:	56                   	push   %esi
80103395:	53                   	push   %ebx
80103396:	83 ec 0c             	sub    $0xc,%esp
80103399:	8b 75 08             	mov    0x8(%ebp),%esi
8010339c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010339f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801033a5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801033ab:	e8 60 db ff ff       	call   80100f10 <filealloc>
801033b0:	85 c0                	test   %eax,%eax
801033b2:	89 06                	mov    %eax,(%esi)
801033b4:	0f 84 a8 00 00 00    	je     80103462 <pipealloc+0xd2>
801033ba:	e8 51 db ff ff       	call   80100f10 <filealloc>
801033bf:	85 c0                	test   %eax,%eax
801033c1:	89 03                	mov    %eax,(%ebx)
801033c3:	0f 84 87 00 00 00    	je     80103450 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801033c9:	e8 62 f2 ff ff       	call   80102630 <kalloc>
801033ce:	85 c0                	test   %eax,%eax
801033d0:	89 c7                	mov    %eax,%edi
801033d2:	0f 84 b0 00 00 00    	je     80103488 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
801033d8:	83 ec 08             	sub    $0x8,%esp
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
  p->readopen = 1;
801033db:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801033e2:	00 00 00 
  p->writeopen = 1;
801033e5:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801033ec:	00 00 00 
  p->nwrite = 0;
801033ef:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801033f6:	00 00 00 
  p->nread = 0;
801033f9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103400:	00 00 00 
  initlock(&p->lock, "pipe");
80103403:	68 b5 8a 10 80       	push   $0x80108ab5
80103408:	50                   	push   %eax
80103409:	e8 c2 14 00 00       	call   801048d0 <initlock>
  (*f0)->type = FD_PIPE;
8010340e:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103410:	83 c4 10             	add    $0x10,%esp
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
  (*f0)->type = FD_PIPE;
80103413:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103419:	8b 06                	mov    (%esi),%eax
8010341b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010341f:	8b 06                	mov    (%esi),%eax
80103421:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103425:	8b 06                	mov    (%esi),%eax
80103427:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010342a:	8b 03                	mov    (%ebx),%eax
8010342c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103432:	8b 03                	mov    (%ebx),%eax
80103434:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103438:	8b 03                	mov    (%ebx),%eax
8010343a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010343e:	8b 03                	mov    (%ebx),%eax
80103440:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103443:	8d 65 f4             	lea    -0xc(%ebp),%esp
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103446:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103448:	5b                   	pop    %ebx
80103449:	5e                   	pop    %esi
8010344a:	5f                   	pop    %edi
8010344b:	5d                   	pop    %ebp
8010344c:	c3                   	ret    
8010344d:	8d 76 00             	lea    0x0(%esi),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103450:	8b 06                	mov    (%esi),%eax
80103452:	85 c0                	test   %eax,%eax
80103454:	74 1e                	je     80103474 <pipealloc+0xe4>
    fileclose(*f0);
80103456:	83 ec 0c             	sub    $0xc,%esp
80103459:	50                   	push   %eax
8010345a:	e8 71 db ff ff       	call   80100fd0 <fileclose>
8010345f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103462:	8b 03                	mov    (%ebx),%eax
80103464:	85 c0                	test   %eax,%eax
80103466:	74 0c                	je     80103474 <pipealloc+0xe4>
    fileclose(*f1);
80103468:	83 ec 0c             	sub    $0xc,%esp
8010346b:	50                   	push   %eax
8010346c:	e8 5f db ff ff       	call   80100fd0 <fileclose>
80103471:	83 c4 10             	add    $0x10,%esp
  return -1;
}
80103474:	8d 65 f4             	lea    -0xc(%ebp),%esp
    kfree((char*)p);
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
80103477:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010347c:	5b                   	pop    %ebx
8010347d:	5e                   	pop    %esi
8010347e:	5f                   	pop    %edi
8010347f:	5d                   	pop    %ebp
80103480:	c3                   	ret    
80103481:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103488:	8b 06                	mov    (%esi),%eax
8010348a:	85 c0                	test   %eax,%eax
8010348c:	75 c8                	jne    80103456 <pipealloc+0xc6>
8010348e:	eb d2                	jmp    80103462 <pipealloc+0xd2>

80103490 <pipeclose>:
  return -1;
}

void
pipeclose(struct pipe *p, int writable)
{
80103490:	55                   	push   %ebp
80103491:	89 e5                	mov    %esp,%ebp
80103493:	56                   	push   %esi
80103494:	53                   	push   %ebx
80103495:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103498:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010349b:	83 ec 0c             	sub    $0xc,%esp
8010349e:	53                   	push   %ebx
8010349f:	e8 8c 15 00 00       	call   80104a30 <acquire>
  if(writable){
801034a4:	83 c4 10             	add    $0x10,%esp
801034a7:	85 f6                	test   %esi,%esi
801034a9:	74 45                	je     801034f0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
801034ab:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801034b1:	83 ec 0c             	sub    $0xc,%esp
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
801034b4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801034bb:	00 00 00 
    wakeup(&p->nread);
801034be:	50                   	push   %eax
801034bf:	e8 0c 0c 00 00       	call   801040d0 <wakeup>
801034c4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801034c7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801034cd:	85 d2                	test   %edx,%edx
801034cf:	75 0a                	jne    801034db <pipeclose+0x4b>
801034d1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801034d7:	85 c0                	test   %eax,%eax
801034d9:	74 35                	je     80103510 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801034db:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801034de:	8d 65 f8             	lea    -0x8(%ebp),%esp
801034e1:	5b                   	pop    %ebx
801034e2:	5e                   	pop    %esi
801034e3:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801034e4:	e9 f7 15 00 00       	jmp    80104ae0 <release>
801034e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
801034f0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801034f6:	83 ec 0c             	sub    $0xc,%esp
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
801034f9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103500:	00 00 00 
    wakeup(&p->nwrite);
80103503:	50                   	push   %eax
80103504:	e8 c7 0b 00 00       	call   801040d0 <wakeup>
80103509:	83 c4 10             	add    $0x10,%esp
8010350c:	eb b9                	jmp    801034c7 <pipeclose+0x37>
8010350e:	66 90                	xchg   %ax,%ax
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
80103510:	83 ec 0c             	sub    $0xc,%esp
80103513:	53                   	push   %ebx
80103514:	e8 c7 15 00 00       	call   80104ae0 <release>
    kfree((char*)p);
80103519:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010351c:	83 c4 10             	add    $0x10,%esp
  } else
    release(&p->lock);
}
8010351f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103522:	5b                   	pop    %ebx
80103523:	5e                   	pop    %esi
80103524:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
80103525:	e9 56 ef ff ff       	jmp    80102480 <kfree>
8010352a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103530 <pipewrite>:
}

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103530:	55                   	push   %ebp
80103531:	89 e5                	mov    %esp,%ebp
80103533:	57                   	push   %edi
80103534:	56                   	push   %esi
80103535:	53                   	push   %ebx
80103536:	83 ec 28             	sub    $0x28,%esp
80103539:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010353c:	53                   	push   %ebx
8010353d:	e8 ee 14 00 00       	call   80104a30 <acquire>
  for(i = 0; i < n; i++){
80103542:	8b 45 10             	mov    0x10(%ebp),%eax
80103545:	83 c4 10             	add    $0x10,%esp
80103548:	85 c0                	test   %eax,%eax
8010354a:	0f 8e b9 00 00 00    	jle    80103609 <pipewrite+0xd9>
80103550:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103553:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103559:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010355f:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103565:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103568:	03 4d 10             	add    0x10(%ebp),%ecx
8010356b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010356e:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80103574:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
8010357a:	39 d0                	cmp    %edx,%eax
8010357c:	74 38                	je     801035b6 <pipewrite+0x86>
8010357e:	eb 59                	jmp    801035d9 <pipewrite+0xa9>
      if(p->readopen == 0 || myproc()->killed){
80103580:	e8 cb 03 00 00       	call   80103950 <myproc>
80103585:	8b 48 24             	mov    0x24(%eax),%ecx
80103588:	85 c9                	test   %ecx,%ecx
8010358a:	75 34                	jne    801035c0 <pipewrite+0x90>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
8010358c:	83 ec 0c             	sub    $0xc,%esp
8010358f:	57                   	push   %edi
80103590:	e8 3b 0b 00 00       	call   801040d0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103595:	58                   	pop    %eax
80103596:	5a                   	pop    %edx
80103597:	53                   	push   %ebx
80103598:	56                   	push   %esi
80103599:	e8 72 09 00 00       	call   80103f10 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010359e:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801035a4:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801035aa:	83 c4 10             	add    $0x10,%esp
801035ad:	05 00 02 00 00       	add    $0x200,%eax
801035b2:	39 c2                	cmp    %eax,%edx
801035b4:	75 2a                	jne    801035e0 <pipewrite+0xb0>
      if(p->readopen == 0 || myproc()->killed){
801035b6:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801035bc:	85 c0                	test   %eax,%eax
801035be:	75 c0                	jne    80103580 <pipewrite+0x50>
        release(&p->lock);
801035c0:	83 ec 0c             	sub    $0xc,%esp
801035c3:	53                   	push   %ebx
801035c4:	e8 17 15 00 00       	call   80104ae0 <release>
        return -1;
801035c9:	83 c4 10             	add    $0x10,%esp
801035cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801035d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035d4:	5b                   	pop    %ebx
801035d5:	5e                   	pop    %esi
801035d6:	5f                   	pop    %edi
801035d7:	5d                   	pop    %ebp
801035d8:	c3                   	ret    
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035d9:	89 c2                	mov    %eax,%edx
801035db:	90                   	nop
801035dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801035e0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801035e3:	8d 42 01             	lea    0x1(%edx),%eax
801035e6:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801035ea:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801035f0:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801035f6:	0f b6 09             	movzbl (%ecx),%ecx
801035f9:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
801035fd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80103600:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
80103603:	0f 85 65 ff ff ff    	jne    8010356e <pipewrite+0x3e>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103609:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010360f:	83 ec 0c             	sub    $0xc,%esp
80103612:	50                   	push   %eax
80103613:	e8 b8 0a 00 00       	call   801040d0 <wakeup>
  release(&p->lock);
80103618:	89 1c 24             	mov    %ebx,(%esp)
8010361b:	e8 c0 14 00 00       	call   80104ae0 <release>
  return n;
80103620:	83 c4 10             	add    $0x10,%esp
80103623:	8b 45 10             	mov    0x10(%ebp),%eax
80103626:	eb a9                	jmp    801035d1 <pipewrite+0xa1>
80103628:	90                   	nop
80103629:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103630 <piperead>:
}

int
piperead(struct pipe *p, char *addr, int n)
{
80103630:	55                   	push   %ebp
80103631:	89 e5                	mov    %esp,%ebp
80103633:	57                   	push   %edi
80103634:	56                   	push   %esi
80103635:	53                   	push   %ebx
80103636:	83 ec 18             	sub    $0x18,%esp
80103639:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010363c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010363f:	53                   	push   %ebx
80103640:	e8 eb 13 00 00       	call   80104a30 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103645:	83 c4 10             	add    $0x10,%esp
80103648:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010364e:	39 83 38 02 00 00    	cmp    %eax,0x238(%ebx)
80103654:	75 6a                	jne    801036c0 <piperead+0x90>
80103656:	8b b3 40 02 00 00    	mov    0x240(%ebx),%esi
8010365c:	85 f6                	test   %esi,%esi
8010365e:	0f 84 cc 00 00 00    	je     80103730 <piperead+0x100>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103664:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
8010366a:	eb 2d                	jmp    80103699 <piperead+0x69>
8010366c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103670:	83 ec 08             	sub    $0x8,%esp
80103673:	53                   	push   %ebx
80103674:	56                   	push   %esi
80103675:	e8 96 08 00 00       	call   80103f10 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010367a:	83 c4 10             	add    $0x10,%esp
8010367d:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80103683:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
80103689:	75 35                	jne    801036c0 <piperead+0x90>
8010368b:	8b 93 40 02 00 00    	mov    0x240(%ebx),%edx
80103691:	85 d2                	test   %edx,%edx
80103693:	0f 84 97 00 00 00    	je     80103730 <piperead+0x100>
    if(myproc()->killed){
80103699:	e8 b2 02 00 00       	call   80103950 <myproc>
8010369e:	8b 48 24             	mov    0x24(%eax),%ecx
801036a1:	85 c9                	test   %ecx,%ecx
801036a3:	74 cb                	je     80103670 <piperead+0x40>
      release(&p->lock);
801036a5:	83 ec 0c             	sub    $0xc,%esp
801036a8:	53                   	push   %ebx
801036a9:	e8 32 14 00 00       	call   80104ae0 <release>
      return -1;
801036ae:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801036b1:	8d 65 f4             	lea    -0xc(%ebp),%esp

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(myproc()->killed){
      release(&p->lock);
      return -1;
801036b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801036b9:	5b                   	pop    %ebx
801036ba:	5e                   	pop    %esi
801036bb:	5f                   	pop    %edi
801036bc:	5d                   	pop    %ebp
801036bd:	c3                   	ret    
801036be:	66 90                	xchg   %ax,%ax
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801036c0:	8b 45 10             	mov    0x10(%ebp),%eax
801036c3:	85 c0                	test   %eax,%eax
801036c5:	7e 69                	jle    80103730 <piperead+0x100>
    if(p->nread == p->nwrite)
801036c7:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801036cd:	31 c9                	xor    %ecx,%ecx
801036cf:	eb 15                	jmp    801036e6 <piperead+0xb6>
801036d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036d8:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801036de:	3b 83 38 02 00 00    	cmp    0x238(%ebx),%eax
801036e4:	74 5a                	je     80103740 <piperead+0x110>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801036e6:	8d 70 01             	lea    0x1(%eax),%esi
801036e9:	25 ff 01 00 00       	and    $0x1ff,%eax
801036ee:	89 b3 34 02 00 00    	mov    %esi,0x234(%ebx)
801036f4:	0f b6 44 03 34       	movzbl 0x34(%ebx,%eax,1),%eax
801036f9:	88 04 0f             	mov    %al,(%edi,%ecx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801036fc:	83 c1 01             	add    $0x1,%ecx
801036ff:	39 4d 10             	cmp    %ecx,0x10(%ebp)
80103702:	75 d4                	jne    801036d8 <piperead+0xa8>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103704:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
8010370a:	83 ec 0c             	sub    $0xc,%esp
8010370d:	50                   	push   %eax
8010370e:	e8 bd 09 00 00       	call   801040d0 <wakeup>
  release(&p->lock);
80103713:	89 1c 24             	mov    %ebx,(%esp)
80103716:	e8 c5 13 00 00       	call   80104ae0 <release>
  return i;
8010371b:	8b 45 10             	mov    0x10(%ebp),%eax
8010371e:	83 c4 10             	add    $0x10,%esp
}
80103721:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103724:	5b                   	pop    %ebx
80103725:	5e                   	pop    %esi
80103726:	5f                   	pop    %edi
80103727:	5d                   	pop    %ebp
80103728:	c3                   	ret    
80103729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103730:	c7 45 10 00 00 00 00 	movl   $0x0,0x10(%ebp)
80103737:	eb cb                	jmp    80103704 <piperead+0xd4>
80103739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103740:	89 4d 10             	mov    %ecx,0x10(%ebp)
80103743:	eb bf                	jmp    80103704 <piperead+0xd4>
80103745:	66 90                	xchg   %ax,%ax
80103747:	66 90                	xchg   %ax,%ax
80103749:	66 90                	xchg   %ax,%ax
8010374b:	66 90                	xchg   %ax,%ax
8010374d:	66 90                	xchg   %ax,%ax
8010374f:	90                   	nop

80103750 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103750:	55                   	push   %ebp
80103751:	89 e5                	mov    %esp,%ebp
80103753:	53                   	push   %ebx
  char *sp;
  int i;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103754:	bb 74 4d 11 80       	mov    $0x80114d74,%ebx
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103759:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  char *sp;
  int i;

  acquire(&ptable.lock);
8010375c:	68 40 4d 11 80       	push   $0x80114d40
80103761:	e8 ca 12 00 00       	call   80104a30 <acquire>
80103766:	83 c4 10             	add    $0x10,%esp
80103769:	eb 17                	jmp    80103782 <allocproc+0x32>
8010376b:	90                   	nop
8010376c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103770:	81 c3 60 06 00 00    	add    $0x660,%ebx
80103776:	81 fb 74 e5 12 80    	cmp    $0x8012e574,%ebx
8010377c:	0f 84 96 00 00 00    	je     80103818 <allocproc+0xc8>
    if(p->state == UNUSED)
80103782:	8b 43 0c             	mov    0xc(%ebx),%eax
80103785:	85 c0                	test   %eax,%eax
80103787:	75 e7                	jne    80103770 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103789:	a1 04 c0 10 80       	mov    0x8010c004,%eax

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
8010378e:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103795:	8d 50 01             	lea    0x1(%eax),%edx
80103798:	89 43 10             	mov    %eax,0x10(%ebx)
8010379b:	8d 83 60 06 00 00    	lea    0x660(%ebx),%eax
801037a1:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
801037a7:	8d 53 7c             	lea    0x7c(%ebx),%edx
801037aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for (i = 0; i < 29; ++i)
  {
    p->syscalls[i].count = 0;
801037b0:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
801037b6:	83 c2 34             	add    $0x34,%edx
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
  for (i = 0; i < 29; ++i)
801037b9:	39 c2                	cmp    %eax,%edx
801037bb:	75 f3                	jne    801037b0 <allocproc+0x60>
  {
    p->syscalls[i].count = 0;
  }

  release(&ptable.lock);
801037bd:	83 ec 0c             	sub    $0xc,%esp
801037c0:	68 40 4d 11 80       	push   $0x80114d40
801037c5:	e8 16 13 00 00       	call   80104ae0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801037ca:	e8 61 ee ff ff       	call   80102630 <kalloc>
801037cf:	83 c4 10             	add    $0x10,%esp
801037d2:	85 c0                	test   %eax,%eax
801037d4:	89 43 08             	mov    %eax,0x8(%ebx)
801037d7:	74 56                	je     8010382f <allocproc+0xdf>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801037d9:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801037df:	83 ec 04             	sub    $0x4,%esp
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
801037e2:	05 9c 0f 00 00       	add    $0xf9c,%eax
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801037e7:	89 53 18             	mov    %edx,0x18(%ebx)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
801037ea:	c7 40 14 d7 68 10 80 	movl   $0x801068d7,0x14(%eax)

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801037f1:	6a 14                	push   $0x14
801037f3:	6a 00                	push   $0x0
801037f5:	50                   	push   %eax
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
801037f6:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801037f9:	e8 b2 14 00 00       	call   80104cb0 <memset>
  p->context->eip = (uint)forkret;
801037fe:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103801:	83 c4 10             	add    $0x10,%esp
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;
80103804:	c7 40 10 40 38 10 80 	movl   $0x80103840,0x10(%eax)

  return p;
8010380b:	89 d8                	mov    %ebx,%eax
}
8010380d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103810:	c9                   	leave  
80103811:	c3                   	ret    
80103812:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
80103818:	83 ec 0c             	sub    $0xc,%esp
8010381b:	68 40 4d 11 80       	push   $0x80114d40
80103820:	e8 bb 12 00 00       	call   80104ae0 <release>
  return 0;
80103825:	83 c4 10             	add    $0x10,%esp
80103828:	31 c0                	xor    %eax,%eax
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
8010382a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010382d:	c9                   	leave  
8010382e:	c3                   	ret    

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
8010382f:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103836:	eb d5                	jmp    8010380d <allocproc+0xbd>
80103838:	90                   	nop
80103839:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103840 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103840:	55                   	push   %ebp
80103841:	89 e5                	mov    %esp,%ebp
80103843:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103846:	68 40 4d 11 80       	push   $0x80114d40
8010384b:	e8 90 12 00 00       	call   80104ae0 <release>

  if (first) {
80103850:	a1 00 c0 10 80       	mov    0x8010c000,%eax
80103855:	83 c4 10             	add    $0x10,%esp
80103858:	85 c0                	test   %eax,%eax
8010385a:	75 04                	jne    80103860 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010385c:	c9                   	leave  
8010385d:	c3                   	ret    
8010385e:	66 90                	xchg   %ax,%ax
  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
80103860:	83 ec 0c             	sub    $0xc,%esp

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80103863:	c7 05 00 c0 10 80 00 	movl   $0x0,0x8010c000
8010386a:	00 00 00 
    iinit(ROOTDEV);
8010386d:	6a 01                	push   $0x1
8010386f:	e8 9c dd ff ff       	call   80101610 <iinit>
    initlog(ROOTDEV);
80103874:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010387b:	e8 d0 f3 ff ff       	call   80102c50 <initlog>
80103880:	83 c4 10             	add    $0x10,%esp
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103883:	c9                   	leave  
80103884:	c3                   	ret    
80103885:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103890 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80103890:	55                   	push   %ebp
80103891:	89 e5                	mov    %esp,%ebp
80103893:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103896:	68 d0 86 10 80       	push   $0x801086d0
8010389b:	68 40 4d 11 80       	push   $0x80114d40
801038a0:	e8 2b 10 00 00       	call   801048d0 <initlock>
}
801038a5:	83 c4 10             	add    $0x10,%esp
801038a8:	c9                   	leave  
801038a9:	c3                   	ret    
801038aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801038b0 <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
801038b0:	55                   	push   %ebp
801038b1:	89 e5                	mov    %esp,%ebp
801038b3:	56                   	push   %esi
801038b4:	53                   	push   %ebx

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801038b5:	9c                   	pushf  
801038b6:	58                   	pop    %eax
  int apicid, i;
  
  if(readeflags()&FL_IF)
801038b7:	f6 c4 02             	test   $0x2,%ah
801038ba:	75 5b                	jne    80103917 <mycpu+0x67>
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
801038bc:	e8 cf ef ff ff       	call   80102890 <lapicid>
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
801038c1:	8b 35 20 4d 11 80    	mov    0x80114d20,%esi
801038c7:	85 f6                	test   %esi,%esi
801038c9:	7e 3f                	jle    8010390a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
801038cb:	0f b6 15 a0 47 11 80 	movzbl 0x801147a0,%edx
801038d2:	39 d0                	cmp    %edx,%eax
801038d4:	74 30                	je     80103906 <mycpu+0x56>
801038d6:	b9 50 48 11 80       	mov    $0x80114850,%ecx
801038db:	31 d2                	xor    %edx,%edx
801038dd:	8d 76 00             	lea    0x0(%esi),%esi
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
801038e0:	83 c2 01             	add    $0x1,%edx
801038e3:	39 f2                	cmp    %esi,%edx
801038e5:	74 23                	je     8010390a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
801038e7:	0f b6 19             	movzbl (%ecx),%ebx
801038ea:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
801038f0:	39 d8                	cmp    %ebx,%eax
801038f2:	75 ec                	jne    801038e0 <mycpu+0x30>
      return &cpus[i];
801038f4:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
  }
  panic("unknown apicid\n");
}
801038fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
801038fd:	5b                   	pop    %ebx
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
801038fe:	05 a0 47 11 80       	add    $0x801147a0,%eax
  }
  panic("unknown apicid\n");
}
80103903:	5e                   	pop    %esi
80103904:	5d                   	pop    %ebp
80103905:	c3                   	ret    
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103906:	31 d2                	xor    %edx,%edx
80103908:	eb ea                	jmp    801038f4 <mycpu+0x44>
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
8010390a:	83 ec 0c             	sub    $0xc,%esp
8010390d:	68 d7 86 10 80       	push   $0x801086d7
80103912:	e8 59 ca ff ff       	call   80100370 <panic>
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
80103917:	83 ec 0c             	sub    $0xc,%esp
8010391a:	68 9c 88 10 80       	push   $0x8010889c
8010391f:	e8 4c ca ff ff       	call   80100370 <panic>
80103924:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010392a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103930 <cpuid>:
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
80103930:	55                   	push   %ebp
80103931:	89 e5                	mov    %esp,%ebp
80103933:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103936:	e8 75 ff ff ff       	call   801038b0 <mycpu>
8010393b:	2d a0 47 11 80       	sub    $0x801147a0,%eax
}
80103940:	c9                   	leave  
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
80103941:	c1 f8 04             	sar    $0x4,%eax
80103944:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010394a:	c3                   	ret    
8010394b:	90                   	nop
8010394c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103950 <myproc>:
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
80103950:	55                   	push   %ebp
80103951:	89 e5                	mov    %esp,%ebp
80103953:	53                   	push   %ebx
80103954:	83 ec 04             	sub    $0x4,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
80103957:	e8 f4 0f 00 00       	call   80104950 <pushcli>
  c = mycpu();
8010395c:	e8 4f ff ff ff       	call   801038b0 <mycpu>
  p = c->proc;
80103961:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103967:	e8 24 10 00 00       	call   80104990 <popcli>
  return p;
}
8010396c:	83 c4 04             	add    $0x4,%esp
8010396f:	89 d8                	mov    %ebx,%eax
80103971:	5b                   	pop    %ebx
80103972:	5d                   	pop    %ebp
80103973:	c3                   	ret    
80103974:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010397a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103980 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80103980:	55                   	push   %ebp
80103981:	89 e5                	mov    %esp,%ebp
80103983:	53                   	push   %ebx
80103984:	83 ec 04             	sub    $0x4,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
80103987:	e8 c4 fd ff ff       	call   80103750 <allocproc>
8010398c:	89 c3                	mov    %eax,%ebx
  
  initproc = p;
8010398e:	a3 b8 c5 10 80       	mov    %eax,0x8010c5b8
  if((p->pgdir = setupkvm()) == 0)
80103993:	e8 38 45 00 00       	call   80107ed0 <setupkvm>
80103998:	85 c0                	test   %eax,%eax
8010399a:	89 43 04             	mov    %eax,0x4(%ebx)
8010399d:	0f 84 bd 00 00 00    	je     80103a60 <userinit+0xe0>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801039a3:	83 ec 04             	sub    $0x4,%esp
801039a6:	68 2c 00 00 00       	push   $0x2c
801039ab:	68 60 c4 10 80       	push   $0x8010c460
801039b0:	50                   	push   %eax
801039b1:	e8 2a 42 00 00       	call   80107be0 <inituvm>
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
801039b6:	83 c4 0c             	add    $0xc,%esp
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
801039b9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801039bf:	6a 4c                	push   $0x4c
801039c1:	6a 00                	push   $0x0
801039c3:	ff 73 18             	pushl  0x18(%ebx)
801039c6:	e8 e5 12 00 00       	call   80104cb0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801039cb:	8b 43 18             	mov    0x18(%ebx),%eax
801039ce:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801039d3:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
801039d8:	83 c4 0c             	add    $0xc,%esp
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801039db:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801039df:	8b 43 18             	mov    0x18(%ebx),%eax
801039e2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
801039e6:	8b 43 18             	mov    0x18(%ebx),%eax
801039e9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801039ed:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801039f1:	8b 43 18             	mov    0x18(%ebx),%eax
801039f4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801039f8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801039fc:	8b 43 18             	mov    0x18(%ebx),%eax
801039ff:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103a06:	8b 43 18             	mov    0x18(%ebx),%eax
80103a09:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103a10:	8b 43 18             	mov    0x18(%ebx),%eax
80103a13:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a1a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103a1d:	6a 10                	push   $0x10
80103a1f:	68 00 87 10 80       	push   $0x80108700
80103a24:	50                   	push   %eax
80103a25:	e8 86 14 00 00       	call   80104eb0 <safestrcpy>
  p->cwd = namei("/");
80103a2a:	c7 04 24 09 87 10 80 	movl   $0x80108709,(%esp)
80103a31:	e8 2a e6 ff ff       	call   80102060 <namei>
80103a36:	89 43 68             	mov    %eax,0x68(%ebx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
80103a39:	c7 04 24 40 4d 11 80 	movl   $0x80114d40,(%esp)
80103a40:	e8 eb 0f 00 00       	call   80104a30 <acquire>

  p->state = RUNNABLE;
80103a45:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
80103a4c:	c7 04 24 40 4d 11 80 	movl   $0x80114d40,(%esp)
80103a53:	e8 88 10 00 00       	call   80104ae0 <release>
}
80103a58:	83 c4 10             	add    $0x10,%esp
80103a5b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a5e:	c9                   	leave  
80103a5f:	c3                   	ret    

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
80103a60:	83 ec 0c             	sub    $0xc,%esp
80103a63:	68 e7 86 10 80       	push   $0x801086e7
80103a68:	e8 03 c9 ff ff       	call   80100370 <panic>
80103a6d:	8d 76 00             	lea    0x0(%esi),%esi

80103a70 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80103a70:	55                   	push   %ebp
80103a71:	89 e5                	mov    %esp,%ebp
80103a73:	56                   	push   %esi
80103a74:	53                   	push   %ebx
80103a75:	8b 75 08             	mov    0x8(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103a78:	e8 d3 0e 00 00       	call   80104950 <pushcli>
  c = mycpu();
80103a7d:	e8 2e fe ff ff       	call   801038b0 <mycpu>
  p = c->proc;
80103a82:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a88:	e8 03 0f 00 00       	call   80104990 <popcli>
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
80103a8d:	83 fe 00             	cmp    $0x0,%esi
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
80103a90:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103a92:	7e 34                	jle    80103ac8 <growproc+0x58>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103a94:	83 ec 04             	sub    $0x4,%esp
80103a97:	01 c6                	add    %eax,%esi
80103a99:	56                   	push   %esi
80103a9a:	50                   	push   %eax
80103a9b:	ff 73 04             	pushl  0x4(%ebx)
80103a9e:	e8 7d 42 00 00       	call   80107d20 <allocuvm>
80103aa3:	83 c4 10             	add    $0x10,%esp
80103aa6:	85 c0                	test   %eax,%eax
80103aa8:	74 36                	je     80103ae0 <growproc+0x70>
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
80103aaa:	83 ec 0c             	sub    $0xc,%esp
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
80103aad:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103aaf:	53                   	push   %ebx
80103ab0:	e8 1b 40 00 00       	call   80107ad0 <switchuvm>
  return 0;
80103ab5:	83 c4 10             	add    $0x10,%esp
80103ab8:	31 c0                	xor    %eax,%eax
}
80103aba:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103abd:	5b                   	pop    %ebx
80103abe:	5e                   	pop    %esi
80103abf:	5d                   	pop    %ebp
80103ac0:	c3                   	ret    
80103ac1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
80103ac8:	74 e0                	je     80103aaa <growproc+0x3a>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103aca:	83 ec 04             	sub    $0x4,%esp
80103acd:	01 c6                	add    %eax,%esi
80103acf:	56                   	push   %esi
80103ad0:	50                   	push   %eax
80103ad1:	ff 73 04             	pushl  0x4(%ebx)
80103ad4:	e8 47 43 00 00       	call   80107e20 <deallocuvm>
80103ad9:	83 c4 10             	add    $0x10,%esp
80103adc:	85 c0                	test   %eax,%eax
80103ade:	75 ca                	jne    80103aaa <growproc+0x3a>
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
80103ae0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103ae5:	eb d3                	jmp    80103aba <growproc+0x4a>
80103ae7:	89 f6                	mov    %esi,%esi
80103ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103af0 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80103af0:	55                   	push   %ebp
80103af1:	89 e5                	mov    %esp,%ebp
80103af3:	57                   	push   %edi
80103af4:	56                   	push   %esi
80103af5:	53                   	push   %ebx
80103af6:	83 ec 1c             	sub    $0x1c,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103af9:	e8 52 0e 00 00       	call   80104950 <pushcli>
  c = mycpu();
80103afe:	e8 ad fd ff ff       	call   801038b0 <mycpu>
  p = c->proc;
80103b03:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b09:	e8 82 0e 00 00       	call   80104990 <popcli>
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
80103b0e:	e8 3d fc ff ff       	call   80103750 <allocproc>
80103b13:	85 c0                	test   %eax,%eax
80103b15:	89 c7                	mov    %eax,%edi
80103b17:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103b1a:	0f 84 b5 00 00 00    	je     80103bd5 <fork+0xe5>
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103b20:	83 ec 08             	sub    $0x8,%esp
80103b23:	ff 33                	pushl  (%ebx)
80103b25:	ff 73 04             	pushl  0x4(%ebx)
80103b28:	e8 73 44 00 00       	call   80107fa0 <copyuvm>
80103b2d:	83 c4 10             	add    $0x10,%esp
80103b30:	85 c0                	test   %eax,%eax
80103b32:	89 47 04             	mov    %eax,0x4(%edi)
80103b35:	0f 84 a1 00 00 00    	je     80103bdc <fork+0xec>
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
80103b3b:	8b 03                	mov    (%ebx),%eax
80103b3d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103b40:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103b42:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103b45:	89 c8                	mov    %ecx,%eax
80103b47:	8b 79 18             	mov    0x18(%ecx),%edi
80103b4a:	8b 73 18             	mov    0x18(%ebx),%esi
80103b4d:	b9 13 00 00 00       	mov    $0x13,%ecx
80103b52:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103b54:	31 f6                	xor    %esi,%esi
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80103b56:	8b 40 18             	mov    0x18(%eax),%eax
80103b59:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
80103b60:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103b64:	85 c0                	test   %eax,%eax
80103b66:	74 13                	je     80103b7b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103b68:	83 ec 0c             	sub    $0xc,%esp
80103b6b:	50                   	push   %eax
80103b6c:	e8 0f d4 ff ff       	call   80100f80 <filedup>
80103b71:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103b74:	83 c4 10             	add    $0x10,%esp
80103b77:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103b7b:	83 c6 01             	add    $0x1,%esi
80103b7e:	83 fe 10             	cmp    $0x10,%esi
80103b81:	75 dd                	jne    80103b60 <fork+0x70>
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103b83:	83 ec 0c             	sub    $0xc,%esp
80103b86:	ff 73 68             	pushl  0x68(%ebx)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103b89:	83 c3 6c             	add    $0x6c,%ebx
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103b8c:	e8 4f dc ff ff       	call   801017e0 <idup>
80103b91:	8b 7d e4             	mov    -0x1c(%ebp),%edi

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103b94:	83 c4 0c             	add    $0xc,%esp
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103b97:	89 47 68             	mov    %eax,0x68(%edi)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103b9a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103b9d:	6a 10                	push   $0x10
80103b9f:	53                   	push   %ebx
80103ba0:	50                   	push   %eax
80103ba1:	e8 0a 13 00 00       	call   80104eb0 <safestrcpy>

  pid = np->pid;
80103ba6:	8b 5f 10             	mov    0x10(%edi),%ebx

  acquire(&ptable.lock);
80103ba9:	c7 04 24 40 4d 11 80 	movl   $0x80114d40,(%esp)
80103bb0:	e8 7b 0e 00 00       	call   80104a30 <acquire>

  np->state = RUNNABLE;
80103bb5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)

  release(&ptable.lock);
80103bbc:	c7 04 24 40 4d 11 80 	movl   $0x80114d40,(%esp)
80103bc3:	e8 18 0f 00 00       	call   80104ae0 <release>

  return pid;
80103bc8:	83 c4 10             	add    $0x10,%esp
80103bcb:	89 d8                	mov    %ebx,%eax
}
80103bcd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103bd0:	5b                   	pop    %ebx
80103bd1:	5e                   	pop    %esi
80103bd2:	5f                   	pop    %edi
80103bd3:	5d                   	pop    %ebp
80103bd4:	c3                   	ret    
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
80103bd5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103bda:	eb f1                	jmp    80103bcd <fork+0xdd>
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
80103bdc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103bdf:	83 ec 0c             	sub    $0xc,%esp
80103be2:	ff 77 08             	pushl  0x8(%edi)
80103be5:	e8 96 e8 ff ff       	call   80102480 <kfree>
    np->kstack = 0;
80103bea:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    np->state = UNUSED;
80103bf1:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
80103bf8:	83 c4 10             	add    $0x10,%esp
80103bfb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103c00:	eb cb                	jmp    80103bcd <fork+0xdd>
80103c02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103c10 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80103c10:	55                   	push   %ebp
80103c11:	89 e5                	mov    %esp,%ebp
80103c13:	57                   	push   %edi
80103c14:	56                   	push   %esi
80103c15:	53                   	push   %ebx
80103c16:	83 ec 0c             	sub    $0xc,%esp
  struct proc *p;
  struct cpu *c = mycpu();
80103c19:	e8 92 fc ff ff       	call   801038b0 <mycpu>
80103c1e:	8d 78 04             	lea    0x4(%eax),%edi
80103c21:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103c23:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103c2a:	00 00 00 
80103c2d:	8d 76 00             	lea    0x0(%esi),%esi
}

static inline void
sti(void)
{
  asm volatile("sti");
80103c30:	fb                   	sti    
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103c31:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c34:	bb 74 4d 11 80       	mov    $0x80114d74,%ebx
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103c39:	68 40 4d 11 80       	push   $0x80114d40
80103c3e:	e8 ed 0d 00 00       	call   80104a30 <acquire>
80103c43:	83 c4 10             	add    $0x10,%esp
80103c46:	eb 16                	jmp    80103c5e <scheduler+0x4e>
80103c48:	90                   	nop
80103c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c50:	81 c3 60 06 00 00    	add    $0x660,%ebx
80103c56:	81 fb 74 e5 12 80    	cmp    $0x8012e574,%ebx
80103c5c:	74 52                	je     80103cb0 <scheduler+0xa0>
      if(p->state != RUNNABLE)
80103c5e:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103c62:	75 ec                	jne    80103c50 <scheduler+0x40>

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
80103c64:	83 ec 0c             	sub    $0xc,%esp
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
80103c67:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103c6d:	53                   	push   %ebx
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c6e:	81 c3 60 06 00 00    	add    $0x660,%ebx

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
80103c74:	e8 57 3e 00 00       	call   80107ad0 <switchuvm>
      p->state = RUNNING;

      swtch(&(c->scheduler), p->context);
80103c79:	58                   	pop    %eax
80103c7a:	5a                   	pop    %edx
80103c7b:	ff b3 bc f9 ff ff    	pushl  -0x644(%ebx)
80103c81:	57                   	push   %edi
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;
80103c82:	c7 83 ac f9 ff ff 04 	movl   $0x4,-0x654(%ebx)
80103c89:	00 00 00 

      swtch(&(c->scheduler), p->context);
80103c8c:	e8 7a 12 00 00       	call   80104f0b <swtch>
      switchkvm();
80103c91:	e8 1a 3e 00 00       	call   80107ab0 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80103c96:	83 c4 10             	add    $0x10,%esp
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c99:	81 fb 74 e5 12 80    	cmp    $0x8012e574,%ebx
      swtch(&(c->scheduler), p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80103c9f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103ca6:	00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ca9:	75 b3                	jne    80103c5e <scheduler+0x4e>
80103cab:	90                   	nop
80103cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);
80103cb0:	83 ec 0c             	sub    $0xc,%esp
80103cb3:	68 40 4d 11 80       	push   $0x80114d40
80103cb8:	e8 23 0e 00 00       	call   80104ae0 <release>

  }
80103cbd:	83 c4 10             	add    $0x10,%esp
80103cc0:	e9 6b ff ff ff       	jmp    80103c30 <scheduler+0x20>
80103cc5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103cd0 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80103cd0:	55                   	push   %ebp
80103cd1:	89 e5                	mov    %esp,%ebp
80103cd3:	56                   	push   %esi
80103cd4:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103cd5:	e8 76 0c 00 00       	call   80104950 <pushcli>
  c = mycpu();
80103cda:	e8 d1 fb ff ff       	call   801038b0 <mycpu>
  p = c->proc;
80103cdf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ce5:	e8 a6 0c 00 00       	call   80104990 <popcli>
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
80103cea:	83 ec 0c             	sub    $0xc,%esp
80103ced:	68 40 4d 11 80       	push   $0x80114d40
80103cf2:	e8 09 0d 00 00       	call   80104a00 <holding>
80103cf7:	83 c4 10             	add    $0x10,%esp
80103cfa:	85 c0                	test   %eax,%eax
80103cfc:	74 4f                	je     80103d4d <sched+0x7d>
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
80103cfe:	e8 ad fb ff ff       	call   801038b0 <mycpu>
80103d03:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103d0a:	75 68                	jne    80103d74 <sched+0xa4>
    panic("sched locks");
  if(p->state == RUNNING)
80103d0c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103d10:	74 55                	je     80103d67 <sched+0x97>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103d12:	9c                   	pushf  
80103d13:	58                   	pop    %eax
    panic("sched running");
  if(readeflags()&FL_IF)
80103d14:	f6 c4 02             	test   $0x2,%ah
80103d17:	75 41                	jne    80103d5a <sched+0x8a>
    panic("sched interruptible");
  intena = mycpu()->intena;
80103d19:	e8 92 fb ff ff       	call   801038b0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103d1e:	83 c3 1c             	add    $0x1c,%ebx
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
80103d21:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103d27:	e8 84 fb ff ff       	call   801038b0 <mycpu>
80103d2c:	83 ec 08             	sub    $0x8,%esp
80103d2f:	ff 70 04             	pushl  0x4(%eax)
80103d32:	53                   	push   %ebx
80103d33:	e8 d3 11 00 00       	call   80104f0b <swtch>
  mycpu()->intena = intena;
80103d38:	e8 73 fb ff ff       	call   801038b0 <mycpu>
}
80103d3d:	83 c4 10             	add    $0x10,%esp
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
80103d40:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103d46:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d49:	5b                   	pop    %ebx
80103d4a:	5e                   	pop    %esi
80103d4b:	5d                   	pop    %ebp
80103d4c:	c3                   	ret    
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
80103d4d:	83 ec 0c             	sub    $0xc,%esp
80103d50:	68 0b 87 10 80       	push   $0x8010870b
80103d55:	e8 16 c6 ff ff       	call   80100370 <panic>
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
80103d5a:	83 ec 0c             	sub    $0xc,%esp
80103d5d:	68 37 87 10 80       	push   $0x80108737
80103d62:	e8 09 c6 ff ff       	call   80100370 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
80103d67:	83 ec 0c             	sub    $0xc,%esp
80103d6a:	68 29 87 10 80       	push   $0x80108729
80103d6f:	e8 fc c5 ff ff       	call   80100370 <panic>
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
80103d74:	83 ec 0c             	sub    $0xc,%esp
80103d77:	68 1d 87 10 80       	push   $0x8010871d
80103d7c:	e8 ef c5 ff ff       	call   80100370 <panic>
80103d81:	eb 0d                	jmp    80103d90 <exit>
80103d83:	90                   	nop
80103d84:	90                   	nop
80103d85:	90                   	nop
80103d86:	90                   	nop
80103d87:	90                   	nop
80103d88:	90                   	nop
80103d89:	90                   	nop
80103d8a:	90                   	nop
80103d8b:	90                   	nop
80103d8c:	90                   	nop
80103d8d:	90                   	nop
80103d8e:	90                   	nop
80103d8f:	90                   	nop

80103d90 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103d90:	55                   	push   %ebp
80103d91:	89 e5                	mov    %esp,%ebp
80103d93:	57                   	push   %edi
80103d94:	56                   	push   %esi
80103d95:	53                   	push   %ebx
80103d96:	83 ec 0c             	sub    $0xc,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103d99:	e8 b2 0b 00 00       	call   80104950 <pushcli>
  c = mycpu();
80103d9e:	e8 0d fb ff ff       	call   801038b0 <mycpu>
  p = c->proc;
80103da3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103da9:	e8 e2 0b 00 00       	call   80104990 <popcli>
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
80103dae:	39 35 b8 c5 10 80    	cmp    %esi,0x8010c5b8
80103db4:	8d 5e 28             	lea    0x28(%esi),%ebx
80103db7:	8d 7e 68             	lea    0x68(%esi),%edi
80103dba:	0f 84 f1 00 00 00    	je     80103eb1 <exit+0x121>
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
80103dc0:	8b 03                	mov    (%ebx),%eax
80103dc2:	85 c0                	test   %eax,%eax
80103dc4:	74 12                	je     80103dd8 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103dc6:	83 ec 0c             	sub    $0xc,%esp
80103dc9:	50                   	push   %eax
80103dca:	e8 01 d2 ff ff       	call   80100fd0 <fileclose>
      curproc->ofile[fd] = 0;
80103dcf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103dd5:	83 c4 10             	add    $0x10,%esp
80103dd8:	83 c3 04             	add    $0x4,%ebx

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80103ddb:	39 df                	cmp    %ebx,%edi
80103ddd:	75 e1                	jne    80103dc0 <exit+0x30>
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
80103ddf:	e8 0c ef ff ff       	call   80102cf0 <begin_op>
  iput(curproc->cwd);
80103de4:	83 ec 0c             	sub    $0xc,%esp
80103de7:	ff 76 68             	pushl  0x68(%esi)
80103dea:	e8 51 db ff ff       	call   80101940 <iput>
  end_op();
80103def:	e8 6c ef ff ff       	call   80102d60 <end_op>
  curproc->cwd = 0;
80103df4:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)

  acquire(&ptable.lock);
80103dfb:	c7 04 24 40 4d 11 80 	movl   $0x80114d40,(%esp)
80103e02:	e8 29 0c 00 00       	call   80104a30 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
80103e07:	8b 56 14             	mov    0x14(%esi),%edx
80103e0a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e0d:	b8 74 4d 11 80       	mov    $0x80114d74,%eax
80103e12:	eb 10                	jmp    80103e24 <exit+0x94>
80103e14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e18:	05 60 06 00 00       	add    $0x660,%eax
80103e1d:	3d 74 e5 12 80       	cmp    $0x8012e574,%eax
80103e22:	74 1e                	je     80103e42 <exit+0xb2>
    if(p->state == SLEEPING && p->chan == chan)
80103e24:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e28:	75 ee                	jne    80103e18 <exit+0x88>
80103e2a:	3b 50 20             	cmp    0x20(%eax),%edx
80103e2d:	75 e9                	jne    80103e18 <exit+0x88>
      p->state = RUNNABLE;
80103e2f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e36:	05 60 06 00 00       	add    $0x660,%eax
80103e3b:	3d 74 e5 12 80       	cmp    $0x8012e574,%eax
80103e40:	75 e2                	jne    80103e24 <exit+0x94>
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80103e42:	8b 0d b8 c5 10 80    	mov    0x8010c5b8,%ecx
80103e48:	ba 74 4d 11 80       	mov    $0x80114d74,%edx
80103e4d:	eb 0f                	jmp    80103e5e <exit+0xce>
80103e4f:	90                   	nop

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e50:	81 c2 60 06 00 00    	add    $0x660,%edx
80103e56:	81 fa 74 e5 12 80    	cmp    $0x8012e574,%edx
80103e5c:	74 3a                	je     80103e98 <exit+0x108>
    if(p->parent == curproc){
80103e5e:	39 72 14             	cmp    %esi,0x14(%edx)
80103e61:	75 ed                	jne    80103e50 <exit+0xc0>
      p->parent = initproc;
      if(p->state == ZOMBIE)
80103e63:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80103e67:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103e6a:	75 e4                	jne    80103e50 <exit+0xc0>
80103e6c:	b8 74 4d 11 80       	mov    $0x80114d74,%eax
80103e71:	eb 11                	jmp    80103e84 <exit+0xf4>
80103e73:	90                   	nop
80103e74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e78:	05 60 06 00 00       	add    $0x660,%eax
80103e7d:	3d 74 e5 12 80       	cmp    $0x8012e574,%eax
80103e82:	74 cc                	je     80103e50 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103e84:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e88:	75 ee                	jne    80103e78 <exit+0xe8>
80103e8a:	3b 48 20             	cmp    0x20(%eax),%ecx
80103e8d:	75 e9                	jne    80103e78 <exit+0xe8>
      p->state = RUNNABLE;
80103e8f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103e96:	eb e0                	jmp    80103e78 <exit+0xe8>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
80103e98:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103e9f:	e8 2c fe ff ff       	call   80103cd0 <sched>
  panic("zombie exit");
80103ea4:	83 ec 0c             	sub    $0xc,%esp
80103ea7:	68 58 87 10 80       	push   $0x80108758
80103eac:	e8 bf c4 ff ff       	call   80100370 <panic>
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");
80103eb1:	83 ec 0c             	sub    $0xc,%esp
80103eb4:	68 4b 87 10 80       	push   $0x8010874b
80103eb9:	e8 b2 c4 ff ff       	call   80100370 <panic>
80103ebe:	66 90                	xchg   %ax,%ax

80103ec0 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
80103ec0:	55                   	push   %ebp
80103ec1:	89 e5                	mov    %esp,%ebp
80103ec3:	53                   	push   %ebx
80103ec4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103ec7:	68 40 4d 11 80       	push   $0x80114d40
80103ecc:	e8 5f 0b 00 00       	call   80104a30 <acquire>
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103ed1:	e8 7a 0a 00 00       	call   80104950 <pushcli>
  c = mycpu();
80103ed6:	e8 d5 f9 ff ff       	call   801038b0 <mycpu>
  p = c->proc;
80103edb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ee1:	e8 aa 0a 00 00       	call   80104990 <popcli>
// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  myproc()->state = RUNNABLE;
80103ee6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80103eed:	e8 de fd ff ff       	call   80103cd0 <sched>
  release(&ptable.lock);
80103ef2:	c7 04 24 40 4d 11 80 	movl   $0x80114d40,(%esp)
80103ef9:	e8 e2 0b 00 00       	call   80104ae0 <release>
}
80103efe:	83 c4 10             	add    $0x10,%esp
80103f01:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f04:	c9                   	leave  
80103f05:	c3                   	ret    
80103f06:	8d 76 00             	lea    0x0(%esi),%esi
80103f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f10 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80103f10:	55                   	push   %ebp
80103f11:	89 e5                	mov    %esp,%ebp
80103f13:	57                   	push   %edi
80103f14:	56                   	push   %esi
80103f15:	53                   	push   %ebx
80103f16:	83 ec 0c             	sub    $0xc,%esp
80103f19:	8b 7d 08             	mov    0x8(%ebp),%edi
80103f1c:	8b 75 0c             	mov    0xc(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103f1f:	e8 2c 0a 00 00       	call   80104950 <pushcli>
  c = mycpu();
80103f24:	e8 87 f9 ff ff       	call   801038b0 <mycpu>
  p = c->proc;
80103f29:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f2f:	e8 5c 0a 00 00       	call   80104990 <popcli>
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
80103f34:	85 db                	test   %ebx,%ebx
80103f36:	0f 84 87 00 00 00    	je     80103fc3 <sleep+0xb3>
    panic("sleep");

  if(lk == 0)
80103f3c:	85 f6                	test   %esi,%esi
80103f3e:	74 76                	je     80103fb6 <sleep+0xa6>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103f40:	81 fe 40 4d 11 80    	cmp    $0x80114d40,%esi
80103f46:	74 50                	je     80103f98 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103f48:	83 ec 0c             	sub    $0xc,%esp
80103f4b:	68 40 4d 11 80       	push   $0x80114d40
80103f50:	e8 db 0a 00 00       	call   80104a30 <acquire>
    release(lk);
80103f55:	89 34 24             	mov    %esi,(%esp)
80103f58:	e8 83 0b 00 00       	call   80104ae0 <release>
  }
  // Go to sleep.
  p->chan = chan;
80103f5d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103f60:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)

  sched();
80103f67:	e8 64 fd ff ff       	call   80103cd0 <sched>

  // Tidy up.
  p->chan = 0;
80103f6c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
80103f73:	c7 04 24 40 4d 11 80 	movl   $0x80114d40,(%esp)
80103f7a:	e8 61 0b 00 00       	call   80104ae0 <release>
    acquire(lk);
80103f7f:	89 75 08             	mov    %esi,0x8(%ebp)
80103f82:	83 c4 10             	add    $0x10,%esp
  }
}
80103f85:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f88:	5b                   	pop    %ebx
80103f89:	5e                   	pop    %esi
80103f8a:	5f                   	pop    %edi
80103f8b:	5d                   	pop    %ebp
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
80103f8c:	e9 9f 0a 00 00       	jmp    80104a30 <acquire>
80103f91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
80103f98:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103f9b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)

  sched();
80103fa2:	e8 29 fd ff ff       	call   80103cd0 <sched>

  // Tidy up.
  p->chan = 0;
80103fa7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
80103fae:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103fb1:	5b                   	pop    %ebx
80103fb2:	5e                   	pop    %esi
80103fb3:	5f                   	pop    %edi
80103fb4:	5d                   	pop    %ebp
80103fb5:	c3                   	ret    
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
80103fb6:	83 ec 0c             	sub    $0xc,%esp
80103fb9:	68 64 87 10 80       	push   $0x80108764
80103fbe:	e8 ad c3 ff ff       	call   80100370 <panic>
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");
80103fc3:	83 ec 0c             	sub    $0xc,%esp
80103fc6:	68 09 8b 10 80       	push   $0x80108b09
80103fcb:	e8 a0 c3 ff ff       	call   80100370 <panic>

80103fd0 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80103fd0:	55                   	push   %ebp
80103fd1:	89 e5                	mov    %esp,%ebp
80103fd3:	56                   	push   %esi
80103fd4:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103fd5:	e8 76 09 00 00       	call   80104950 <pushcli>
  c = mycpu();
80103fda:	e8 d1 f8 ff ff       	call   801038b0 <mycpu>
  p = c->proc;
80103fdf:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103fe5:	e8 a6 09 00 00       	call   80104990 <popcli>
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
80103fea:	83 ec 0c             	sub    $0xc,%esp
80103fed:	68 40 4d 11 80       	push   $0x80114d40
80103ff2:	e8 39 0a 00 00       	call   80104a30 <acquire>
80103ff7:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80103ffa:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ffc:	bb 74 4d 11 80       	mov    $0x80114d74,%ebx
80104001:	eb 13                	jmp    80104016 <wait+0x46>
80104003:	90                   	nop
80104004:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104008:	81 c3 60 06 00 00    	add    $0x660,%ebx
8010400e:	81 fb 74 e5 12 80    	cmp    $0x8012e574,%ebx
80104014:	74 22                	je     80104038 <wait+0x68>
      if(p->parent != curproc)
80104016:	39 73 14             	cmp    %esi,0x14(%ebx)
80104019:	75 ed                	jne    80104008 <wait+0x38>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
8010401b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010401f:	74 35                	je     80104056 <wait+0x86>
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104021:	81 c3 60 06 00 00    	add    $0x660,%ebx
      if(p->parent != curproc)
        continue;
      havekids = 1;
80104027:	b8 01 00 00 00       	mov    $0x1,%eax
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010402c:	81 fb 74 e5 12 80    	cmp    $0x8012e574,%ebx
80104032:	75 e2                	jne    80104016 <wait+0x46>
80104034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80104038:	85 c0                	test   %eax,%eax
8010403a:	74 70                	je     801040ac <wait+0xdc>
8010403c:	8b 46 24             	mov    0x24(%esi),%eax
8010403f:	85 c0                	test   %eax,%eax
80104041:	75 69                	jne    801040ac <wait+0xdc>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104043:	83 ec 08             	sub    $0x8,%esp
80104046:	68 40 4d 11 80       	push   $0x80114d40
8010404b:	56                   	push   %esi
8010404c:	e8 bf fe ff ff       	call   80103f10 <sleep>
  }
80104051:	83 c4 10             	add    $0x10,%esp
80104054:	eb a4                	jmp    80103ffa <wait+0x2a>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
80104056:	83 ec 0c             	sub    $0xc,%esp
80104059:	ff 73 08             	pushl  0x8(%ebx)
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
8010405c:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
8010405f:	e8 1c e4 ff ff       	call   80102480 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
80104064:	5a                   	pop    %edx
80104065:	ff 73 04             	pushl  0x4(%ebx)
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
80104068:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
8010406f:	e8 dc 3d 00 00       	call   80107e50 <freevm>
        p->pid = 0;
80104074:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
8010407b:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104082:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104086:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
8010408d:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104094:	c7 04 24 40 4d 11 80 	movl   $0x80114d40,(%esp)
8010409b:	e8 40 0a 00 00       	call   80104ae0 <release>
        return pid;
801040a0:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
801040a3:	8d 65 f8             	lea    -0x8(%ebp),%esp
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
801040a6:	89 f0                	mov    %esi,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
801040a8:	5b                   	pop    %ebx
801040a9:	5e                   	pop    %esi
801040aa:	5d                   	pop    %ebp
801040ab:	c3                   	ret    
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
801040ac:	83 ec 0c             	sub    $0xc,%esp
801040af:	68 40 4d 11 80       	push   $0x80114d40
801040b4:	e8 27 0a 00 00       	call   80104ae0 <release>
      return -1;
801040b9:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
801040bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
801040bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
801040c4:	5b                   	pop    %ebx
801040c5:	5e                   	pop    %esi
801040c6:	5d                   	pop    %ebp
801040c7:	c3                   	ret    
801040c8:	90                   	nop
801040c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801040d0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801040d0:	55                   	push   %ebp
801040d1:	89 e5                	mov    %esp,%ebp
801040d3:	53                   	push   %ebx
801040d4:	83 ec 10             	sub    $0x10,%esp
801040d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801040da:	68 40 4d 11 80       	push   $0x80114d40
801040df:	e8 4c 09 00 00       	call   80104a30 <acquire>
801040e4:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040e7:	b8 74 4d 11 80       	mov    $0x80114d74,%eax
801040ec:	eb 0e                	jmp    801040fc <wakeup+0x2c>
801040ee:	66 90                	xchg   %ax,%ax
801040f0:	05 60 06 00 00       	add    $0x660,%eax
801040f5:	3d 74 e5 12 80       	cmp    $0x8012e574,%eax
801040fa:	74 1e                	je     8010411a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
801040fc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104100:	75 ee                	jne    801040f0 <wakeup+0x20>
80104102:	3b 58 20             	cmp    0x20(%eax),%ebx
80104105:	75 e9                	jne    801040f0 <wakeup+0x20>
      p->state = RUNNABLE;
80104107:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010410e:	05 60 06 00 00       	add    $0x660,%eax
80104113:	3d 74 e5 12 80       	cmp    $0x8012e574,%eax
80104118:	75 e2                	jne    801040fc <wakeup+0x2c>
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
8010411a:	c7 45 08 40 4d 11 80 	movl   $0x80114d40,0x8(%ebp)
}
80104121:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104124:	c9                   	leave  
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80104125:	e9 b6 09 00 00       	jmp    80104ae0 <release>
8010412a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104130 <invocation_log>:
}

int
invocation_log(int pid)
{
80104130:	55                   	push   %ebp
80104131:	89 e5                	mov    %esp,%ebp
80104133:	57                   	push   %edi
80104134:	56                   	push   %esi
80104135:	53                   	push   %ebx
  struct proc *p;
  int i, status = -1;
80104136:	be ff ff ff ff       	mov    $0xffffffff,%esi
  release(&ptable.lock);
}

int
invocation_log(int pid)
{
8010413b:	83 ec 38             	sub    $0x38,%esp
  struct proc *p;
  int i, status = -1;

  acquire(&ptable.lock);
8010413e:	68 40 4d 11 80       	push   $0x80114d40
80104143:	e8 e8 08 00 00       	call   80104a30 <acquire>
80104148:	c7 45 e0 fc 4d 11 80 	movl   $0x80114dfc,-0x20(%ebp)
8010414f:	83 c4 10             	add    $0x10,%esp
80104152:	89 f0                	mov    %esi,%eax
80104154:	eb 21                	jmp    80104177 <invocation_log+0x47>
80104156:	8d 76 00             	lea    0x0(%esi),%esi
80104159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104160:	81 45 e0 60 06 00 00 	addl   $0x660,-0x20(%ebp)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104167:	ba fc e5 12 80       	mov    $0x8012e5fc,%edx
8010416c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010416f:	39 ca                	cmp    %ecx,%edx
80104171:	0f 84 86 02 00 00    	je     801043fd <invocation_log+0x2cd>
  {
    if(p->pid == pid){
80104177:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010417a:	8b 55 08             	mov    0x8(%ebp),%edx
8010417d:	39 51 88             	cmp    %edx,-0x78(%ecx)
80104180:	75 de                	jne    80104160 <invocation_log+0x30>
80104182:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80104185:	31 ff                	xor    %edi,%edi
80104187:	89 f6                	mov    %esi,%esi
80104189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      for (i = 0; i < 29; ++i)
      {
        if (p->syscalls[i].count > 0)
80104190:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104193:	8d 77 01             	lea    0x1(%edi),%esi
80104196:	89 75 dc             	mov    %esi,-0x24(%ebp)
80104199:	8b 51 f4             	mov    -0xc(%ecx),%edx
8010419c:	85 d2                	test   %edx,%edx
8010419e:	0f 84 ce 01 00 00    	je     80104372 <invocation_log+0x242>
        {
          struct date* d = p->syscalls[i].datelist;
801041a4:	8b 59 f8             	mov    -0x8(%ecx),%ebx
          struct syscallarg* a = p->syscalls[i].arglist;
801041a7:	8b 71 20             	mov    0x20(%ecx),%esi
          for (; d != 0 && a != 0; d = d->next)
801041aa:	85 db                	test   %ebx,%ebx
801041ac:	0f 84 2e 02 00 00    	je     801043e0 <invocation_log+0x2b0>
801041b2:	85 f6                	test   %esi,%esi
801041b4:	0f 84 26 02 00 00    	je     801043e0 <invocation_log+0x2b0>
801041ba:	89 f9                	mov    %edi,%ecx
801041bc:	b8 07 24 00 18       	mov    $0x18002407,%eax
801041c1:	d3 e8                	shr    %cl,%eax
801041c3:	83 e0 01             	and    $0x1,%eax
801041c6:	83 f0 01             	xor    $0x1,%eax
801041c9:	83 ff 1c             	cmp    $0x1c,%edi
801041cc:	89 c1                	mov    %eax,%ecx
801041ce:	b8 01 00 00 00       	mov    $0x1,%eax
801041d3:	0f 47 c8             	cmova  %eax,%ecx
801041d6:	b8 20 1a 70 01       	mov    $0x1701a20,%eax
801041db:	88 4d da             	mov    %cl,-0x26(%ebp)
801041de:	89 f9                	mov    %edi,%ecx
801041e0:	d3 e8                	shr    %cl,%eax
801041e2:	83 e0 01             	and    $0x1,%eax
801041e5:	83 f0 01             	xor    $0x1,%eax
801041e8:	83 ff 18             	cmp    $0x18,%edi
801041eb:	89 c1                	mov    %eax,%ecx
801041ed:	b8 01 00 00 00       	mov    $0x1,%eax
801041f2:	0f 47 c8             	cmova  %eax,%ecx
                a->type[2],a->int_argv[1]);
            if (i == 6)
                cprintf("%d %s  (%s 0x%p, %s 0x%p)\n",p->pid, p->syscalls[i].name, a->type[0], a->str_argv[0], a->type[1], a->ptr_argv[0]);
            if (i == 14)
                cprintf("%d %s  (%s %s, %s %d)\n",p->pid, p->syscalls[i].name, a->type[0], a->str_argv[0], a->type[1], a->int_argv[0]);
            if (i == 17 || i == 19 || i == 8)
801041f5:	89 f8                	mov    %edi,%eax
801041f7:	83 e0 fd             	and    $0xfffffffd,%eax
801041fa:	88 4d db             	mov    %cl,-0x25(%ebp)
801041fd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80104200:	eb 6e                	jmp    80104270 <invocation_log+0x140>
80104202:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
              cprintf("%d %s  (%s %d, %s %d)\n",p->pid, p->syscalls[i].name,
                a->type[0],a->int_argv[0],
                a->type[1],a->int_argv[1]);
            if (i == 3)
              cprintf("%d %s  (%s 0x%p)\n",p->pid, p->syscalls[i].name, a->type[0], a->intptr_argv);
            if (i == 4 || i == 15)
80104208:	83 ff 0f             	cmp    $0xf,%edi
8010420b:	0f 84 e5 00 00 00    	je     801042f6 <invocation_log+0x1c6>
              cprintf("%d %s  (%s %d, %s 0x%p, %s %d)\n",p->pid, p->syscalls[i].name,
                a->type[0],a->int_argv[0],a->type[1],a->str_argv[0],
                a->type[2],a->int_argv[1]);
            if (i == 6)
80104211:	83 ff 06             	cmp    $0x6,%edi
80104214:	0f 84 19 01 00 00    	je     80104333 <invocation_log+0x203>
                cprintf("%d %s  (%s 0x%p, %s 0x%p)\n",p->pid, p->syscalls[i].name, a->type[0], a->str_argv[0], a->type[1], a->ptr_argv[0]);
            if (i == 14)
8010421a:	83 ff 0e             	cmp    $0xe,%edi
8010421d:	0f 84 5f 02 00 00    	je     80104482 <invocation_log+0x352>
                cprintf("%d %s  (%s %s, %s %d)\n",p->pid, p->syscalls[i].name, a->type[0], a->str_argv[0], a->type[1], a->int_argv[0]);
            if (i == 17 || i == 19 || i == 8)
80104223:	83 7d d4 11          	cmpl   $0x11,-0x2c(%ebp)
80104227:	0f 84 5a 01 00 00    	je     80104387 <invocation_log+0x257>
8010422d:	83 ff 08             	cmp    $0x8,%edi
80104230:	0f 84 51 01 00 00    	je     80104387 <invocation_log+0x257>
                cprintf("%d %s  (%s %s)\n",p->pid, p->syscalls[i].name, a->type[0], a->str_argv[0]);
            if (i == 18)
80104236:	83 ff 12             	cmp    $0x12,%edi
80104239:	0f 84 71 01 00 00    	je     801043b0 <invocation_log+0x280>
                cprintf("%d %s  (%s %s, %s %s)\n",p->pid, p->syscalls[i].name, a->type[0], a->str_argv[0], a->type[1], a->str_argv[1]);
            if (i == 7)
8010423f:	83 ff 07             	cmp    $0x7,%edi
80104242:	0f 84 a2 02 00 00    	je     801044ea <invocation_log+0x3ba>
                cprintf("%d %s  (%s %d, %s 0x%p)\n",p->pid, p->syscalls[i].name, a->type[0], a->int_argv[0], a->type[1], a->st);
            if (i == 16)
80104248:	83 ff 10             	cmp    $0x10,%edi
8010424b:	0f 84 60 02 00 00    	je     801044b1 <invocation_log+0x381>
      {
        if (p->syscalls[i].count > 0)
        {
          struct date* d = p->syscalls[i].datelist;
          struct syscallarg* a = p->syscalls[i].arglist;
          for (; d != 0 && a != 0; d = d->next)
80104251:	8b 5b 1c             	mov    0x1c(%ebx),%ebx
                cprintf("%d %s  (%s %d, %s 0x%p)\n",p->pid, p->syscalls[i].name, a->type[0], a->int_argv[0], a->type[1], a->st);
            if (i == 16)
                cprintf("%d %s  (%s %s, %s %d, %s %d)\n",p->pid, p->syscalls[i].name, a->type[0], a->str_argv[0], a->type[1], a->int_argv[0],
                  a->type[2], a->int_argv[1]);

            a = a->next;
80104254:	8b b6 58 01 00 00    	mov    0x158(%esi),%esi
      {
        if (p->syscalls[i].count > 0)
        {
          struct date* d = p->syscalls[i].datelist;
          struct syscallarg* a = p->syscalls[i].arglist;
          for (; d != 0 && a != 0; d = d->next)
8010425a:	85 db                	test   %ebx,%ebx
8010425c:	0f 84 0e 01 00 00    	je     80104370 <invocation_log+0x240>
80104262:	85 f6                	test   %esi,%esi
80104264:	0f 84 06 01 00 00    	je     80104370 <invocation_log+0x240>
8010426a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010426d:	8b 50 f4             	mov    -0xc(%eax),%edx
          {
            cprintf("%d syscall : ID :%d NAME:%s DATE: %d:%d:%d %d-%d-%d\n",p->syscalls[i].count, i+1,
80104270:	83 ec 08             	sub    $0x8,%esp
80104273:	ff 73 0c             	pushl  0xc(%ebx)
80104276:	ff 73 10             	pushl  0x10(%ebx)
80104279:	ff 73 14             	pushl  0x14(%ebx)
8010427c:	ff 33                	pushl  (%ebx)
8010427e:	ff 73 04             	pushl  0x4(%ebx)
80104281:	ff 73 08             	pushl  0x8(%ebx)
80104284:	ff 75 e4             	pushl  -0x1c(%ebp)
80104287:	ff 75 dc             	pushl  -0x24(%ebp)
8010428a:	52                   	push   %edx
8010428b:	68 c4 88 10 80       	push   $0x801088c4
80104290:	e8 4b c4 ff ff       	call   801006e0 <cprintf>
              p->syscalls[i].name, d->date.hour, d->date.minute, d->date.second, d->date.year,
              d->date.month, d->date.day);
            if (i == 0 || i == 1 || i == 2 || i == 13 || i == 10 || i == 27 || i == 28)
80104295:	83 c4 30             	add    $0x30,%esp
80104298:	80 7d da 00          	cmpb   $0x0,-0x26(%ebp)
8010429c:	75 17                	jne    801042b5 <invocation_log+0x185>
              cprintf("%d %s  (%s)\n",p->pid, p->syscalls[i].name, a->type[0]); 
8010429e:	8b 45 e0             	mov    -0x20(%ebp),%eax
801042a1:	56                   	push   %esi
801042a2:	ff 75 e4             	pushl  -0x1c(%ebp)
801042a5:	ff 70 88             	pushl  -0x78(%eax)
801042a8:	68 75 87 10 80       	push   $0x80108775
801042ad:	e8 2e c4 ff ff       	call   801006e0 <cprintf>
801042b2:	83 c4 10             	add    $0x10,%esp
            if (i == 21 || i == 22 || i == 24 || i == 5 || i == 11 || i == 12 || i == 9 || i == 20)
801042b5:	80 7d db 00          	cmpb   $0x0,-0x25(%ebp)
801042b9:	75 20                	jne    801042db <invocation_log+0x1ab>
              cprintf("%d %s  (%s %d)\n",p->pid, p->syscalls[i].name, a->type[0], a->int_argv[0]);
801042bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801042be:	83 ec 0c             	sub    $0xc,%esp
801042c1:	ff b6 f0 00 00 00    	pushl  0xf0(%esi)
801042c7:	56                   	push   %esi
801042c8:	ff 75 e4             	pushl  -0x1c(%ebp)
801042cb:	ff 70 88             	pushl  -0x78(%eax)
801042ce:	68 82 87 10 80       	push   $0x80108782
801042d3:	e8 08 c4 ff ff       	call   801006e0 <cprintf>
801042d8:	83 c4 20             	add    $0x20,%esp
            if (i == 23)
801042db:	83 ff 17             	cmp    $0x17,%edi
801042de:	0f 84 6f 01 00 00    	je     80104453 <invocation_log+0x323>
              cprintf("%d %s  (%s %d, %s %d)\n",p->pid, p->syscalls[i].name,
                a->type[0],a->int_argv[0],
                a->type[1],a->int_argv[1]);
            if (i == 3)
801042e4:	83 ff 03             	cmp    $0x3,%edi
801042e7:	0f 84 41 01 00 00    	je     8010442e <invocation_log+0x2fe>
              cprintf("%d %s  (%s 0x%p)\n",p->pid, p->syscalls[i].name, a->type[0], a->intptr_argv);
            if (i == 4 || i == 15)
801042ed:	83 ff 04             	cmp    $0x4,%edi
801042f0:	0f 85 12 ff ff ff    	jne    80104208 <invocation_log+0xd8>
              cprintf("%d %s  (%s %d, %s 0x%p, %s %d)\n",p->pid, p->syscalls[i].name,
                a->type[0],a->int_argv[0],a->type[1],a->str_argv[0],
                a->type[2],a->int_argv[1]);
801042f6:	8d 56 3c             	lea    0x3c(%esi),%edx
                a->type[0],a->int_argv[0],
                a->type[1],a->int_argv[1]);
            if (i == 3)
              cprintf("%d %s  (%s 0x%p)\n",p->pid, p->syscalls[i].name, a->type[0], a->intptr_argv);
            if (i == 4 || i == 15)
              cprintf("%d %s  (%s %d, %s 0x%p, %s %d)\n",p->pid, p->syscalls[i].name,
801042f9:	83 ec 0c             	sub    $0xc,%esp
801042fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
801042ff:	ff b6 f4 00 00 00    	pushl  0xf4(%esi)
80104305:	52                   	push   %edx
                a->type[0],a->int_argv[0],a->type[1],a->str_argv[0],
80104306:	8d 56 1e             	lea    0x1e(%esi),%edx
                a->type[0],a->int_argv[0],
                a->type[1],a->int_argv[1]);
            if (i == 3)
              cprintf("%d %s  (%s 0x%p)\n",p->pid, p->syscalls[i].name, a->type[0], a->intptr_argv);
            if (i == 4 || i == 15)
              cprintf("%d %s  (%s %d, %s 0x%p, %s %d)\n",p->pid, p->syscalls[i].name,
80104309:	ff b6 14 01 00 00    	pushl  0x114(%esi)
8010430f:	52                   	push   %edx
80104310:	ff b6 f0 00 00 00    	pushl  0xf0(%esi)
80104316:	56                   	push   %esi
80104317:	ff 75 e4             	pushl  -0x1c(%ebp)
8010431a:	ff 70 88             	pushl  -0x78(%eax)
8010431d:	68 fc 88 10 80       	push   $0x801088fc
80104322:	e8 b9 c3 ff ff       	call   801006e0 <cprintf>
80104327:	83 c4 30             	add    $0x30,%esp
                a->type[0],a->int_argv[0],a->type[1],a->str_argv[0],
                a->type[2],a->int_argv[1]);
            if (i == 6)
8010432a:	83 ff 06             	cmp    $0x6,%edi
8010432d:	0f 85 e7 fe ff ff    	jne    8010421a <invocation_log+0xea>
                cprintf("%d %s  (%s 0x%p, %s 0x%p)\n",p->pid, p->syscalls[i].name, a->type[0], a->str_argv[0], a->type[1], a->ptr_argv[0]);
80104333:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104336:	8d 56 1e             	lea    0x1e(%esi),%edx
80104339:	83 ec 04             	sub    $0x4,%esp
8010433c:	ff b6 34 01 00 00    	pushl  0x134(%esi)
80104342:	52                   	push   %edx
80104343:	ff b6 14 01 00 00    	pushl  0x114(%esi)
80104349:	56                   	push   %esi
8010434a:	ff 75 e4             	pushl  -0x1c(%ebp)
8010434d:	ff 70 88             	pushl  -0x78(%eax)
80104350:	68 bb 87 10 80       	push   $0x801087bb
80104355:	e8 86 c3 ff ff       	call   801006e0 <cprintf>
      {
        if (p->syscalls[i].count > 0)
        {
          struct date* d = p->syscalls[i].datelist;
          struct syscallarg* a = p->syscalls[i].arglist;
          for (; d != 0 && a != 0; d = d->next)
8010435a:	8b 5b 1c             	mov    0x1c(%ebx),%ebx
            if (i == 4 || i == 15)
              cprintf("%d %s  (%s %d, %s 0x%p, %s %d)\n",p->pid, p->syscalls[i].name,
                a->type[0],a->int_argv[0],a->type[1],a->str_argv[0],
                a->type[2],a->int_argv[1]);
            if (i == 6)
                cprintf("%d %s  (%s 0x%p, %s 0x%p)\n",p->pid, p->syscalls[i].name, a->type[0], a->str_argv[0], a->type[1], a->ptr_argv[0]);
8010435d:	83 c4 20             	add    $0x20,%esp
                cprintf("%d %s  (%s %d, %s 0x%p)\n",p->pid, p->syscalls[i].name, a->type[0], a->int_argv[0], a->type[1], a->st);
            if (i == 16)
                cprintf("%d %s  (%s %s, %s %d, %s %d)\n",p->pid, p->syscalls[i].name, a->type[0], a->str_argv[0], a->type[1], a->int_argv[0],
                  a->type[2], a->int_argv[1]);

            a = a->next;
80104360:	8b b6 58 01 00 00    	mov    0x158(%esi),%esi
      {
        if (p->syscalls[i].count > 0)
        {
          struct date* d = p->syscalls[i].datelist;
          struct syscallarg* a = p->syscalls[i].arglist;
          for (; d != 0 && a != 0; d = d->next)
80104366:	85 db                	test   %ebx,%ebx
80104368:	0f 85 f4 fe ff ff    	jne    80104262 <invocation_log+0x132>
8010436e:	66 90                	xchg   %ax,%ax
                cprintf("%d %s  (%s %s, %s %d, %s %d)\n",p->pid, p->syscalls[i].name, a->type[0], a->str_argv[0], a->type[1], a->int_argv[0],
                  a->type[2], a->int_argv[1]);

            a = a->next;
          }
          status = 0;
80104370:	31 c0                	xor    %eax,%eax
80104372:	8b 7d dc             	mov    -0x24(%ebp),%edi
80104375:	83 45 e4 34          	addl   $0x34,-0x1c(%ebp)

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if(p->pid == pid){
      for (i = 0; i < 29; ++i)
80104379:	83 ff 1d             	cmp    $0x1d,%edi
8010437c:	0f 85 0e fe ff ff    	jne    80104190 <invocation_log+0x60>
80104382:	e9 d9 fd ff ff       	jmp    80104160 <invocation_log+0x30>
            if (i == 6)
                cprintf("%d %s  (%s 0x%p, %s 0x%p)\n",p->pid, p->syscalls[i].name, a->type[0], a->str_argv[0], a->type[1], a->ptr_argv[0]);
            if (i == 14)
                cprintf("%d %s  (%s %s, %s %d)\n",p->pid, p->syscalls[i].name, a->type[0], a->str_argv[0], a->type[1], a->int_argv[0]);
            if (i == 17 || i == 19 || i == 8)
                cprintf("%d %s  (%s %s)\n",p->pid, p->syscalls[i].name, a->type[0], a->str_argv[0]);
80104387:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010438a:	83 ec 0c             	sub    $0xc,%esp
8010438d:	ff b6 14 01 00 00    	pushl  0x114(%esi)
80104393:	56                   	push   %esi
80104394:	ff 75 e4             	pushl  -0x1c(%ebp)
80104397:	ff 70 88             	pushl  -0x78(%eax)
8010439a:	68 ed 87 10 80       	push   $0x801087ed
8010439f:	e8 3c c3 ff ff       	call   801006e0 <cprintf>
801043a4:	83 c4 20             	add    $0x20,%esp
            if (i == 18)
801043a7:	83 ff 12             	cmp    $0x12,%edi
801043aa:	0f 85 8f fe ff ff    	jne    8010423f <invocation_log+0x10f>
                cprintf("%d %s  (%s %s, %s %s)\n",p->pid, p->syscalls[i].name, a->type[0], a->str_argv[0], a->type[1], a->str_argv[1]);
801043b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801043b3:	8d 56 1e             	lea    0x1e(%esi),%edx
801043b6:	83 ec 04             	sub    $0x4,%esp
801043b9:	ff b6 18 01 00 00    	pushl  0x118(%esi)
801043bf:	52                   	push   %edx
801043c0:	ff b6 14 01 00 00    	pushl  0x114(%esi)
801043c6:	56                   	push   %esi
801043c7:	ff 75 e4             	pushl  -0x1c(%ebp)
801043ca:	ff 70 88             	pushl  -0x78(%eax)
801043cd:	68 fd 87 10 80       	push   $0x801087fd
801043d2:	e8 09 c3 ff ff       	call   801006e0 <cprintf>
801043d7:	83 c4 20             	add    $0x20,%esp
801043da:	e9 72 fe ff ff       	jmp    80104251 <invocation_log+0x121>
801043df:	90                   	nop
801043e0:	8d 4f 01             	lea    0x1(%edi),%ecx
                cprintf("%d %s  (%s %s, %s %d, %s %d)\n",p->pid, p->syscalls[i].name, a->type[0], a->str_argv[0], a->type[1], a->int_argv[0],
                  a->type[2], a->int_argv[1]);

            a = a->next;
          }
          status = 0;
801043e3:	31 c0                	xor    %eax,%eax
801043e5:	83 45 e4 34          	addl   $0x34,-0x1c(%ebp)
801043e9:	89 4d dc             	mov    %ecx,-0x24(%ebp)
801043ec:	8b 7d dc             	mov    -0x24(%ebp),%edi

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if(p->pid == pid){
      for (i = 0; i < 29; ++i)
801043ef:	83 ff 1d             	cmp    $0x1d,%edi
801043f2:	0f 85 98 fd ff ff    	jne    80104190 <invocation_log+0x60>
801043f8:	e9 63 fd ff ff       	jmp    80104160 <invocation_log+0x30>
        } 
      }
    }
  }

  release(&ptable.lock);
801043fd:	83 ec 0c             	sub    $0xc,%esp
80104400:	89 c6                	mov    %eax,%esi
80104402:	68 40 4d 11 80       	push   $0x80114d40
80104407:	e8 d4 06 00 00       	call   80104ae0 <release>

  if (status == -1)
8010440c:	83 c4 10             	add    $0x10,%esp
8010440f:	83 fe ff             	cmp    $0xffffffff,%esi
80104412:	75 10                	jne    80104424 <invocation_log+0x2f4>
    cprintf("pid not found!\n");
80104414:	83 ec 0c             	sub    $0xc,%esp
80104417:	68 4b 88 10 80       	push   $0x8010884b
8010441c:	e8 bf c2 ff ff       	call   801006e0 <cprintf>
80104421:	83 c4 10             	add    $0x10,%esp

  return status;
}
80104424:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104427:	89 f0                	mov    %esi,%eax
80104429:	5b                   	pop    %ebx
8010442a:	5e                   	pop    %esi
8010442b:	5f                   	pop    %edi
8010442c:	5d                   	pop    %ebp
8010442d:	c3                   	ret    
            if (i == 23)
              cprintf("%d %s  (%s %d, %s %d)\n",p->pid, p->syscalls[i].name,
                a->type[0],a->int_argv[0],
                a->type[1],a->int_argv[1]);
            if (i == 3)
              cprintf("%d %s  (%s 0x%p)\n",p->pid, p->syscalls[i].name, a->type[0], a->intptr_argv);
8010442e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104431:	83 ec 0c             	sub    $0xc,%esp
80104434:	ff b6 10 01 00 00    	pushl  0x110(%esi)
8010443a:	56                   	push   %esi
8010443b:	ff 75 e4             	pushl  -0x1c(%ebp)
8010443e:	ff 70 88             	pushl  -0x78(%eax)
80104441:	68 a9 87 10 80       	push   $0x801087a9
80104446:	e8 95 c2 ff ff       	call   801006e0 <cprintf>
8010444b:	83 c4 20             	add    $0x20,%esp
8010444e:	e9 d0 fd ff ff       	jmp    80104223 <invocation_log+0xf3>
            if (i == 0 || i == 1 || i == 2 || i == 13 || i == 10 || i == 27 || i == 28)
              cprintf("%d %s  (%s)\n",p->pid, p->syscalls[i].name, a->type[0]); 
            if (i == 21 || i == 22 || i == 24 || i == 5 || i == 11 || i == 12 || i == 9 || i == 20)
              cprintf("%d %s  (%s %d)\n",p->pid, p->syscalls[i].name, a->type[0], a->int_argv[0]);
            if (i == 23)
              cprintf("%d %s  (%s %d, %s %d)\n",p->pid, p->syscalls[i].name,
80104453:	8b 45 e0             	mov    -0x20(%ebp),%eax
                a->type[0],a->int_argv[0],
                a->type[1],a->int_argv[1]);
80104456:	8d 56 1e             	lea    0x1e(%esi),%edx
            if (i == 0 || i == 1 || i == 2 || i == 13 || i == 10 || i == 27 || i == 28)
              cprintf("%d %s  (%s)\n",p->pid, p->syscalls[i].name, a->type[0]); 
            if (i == 21 || i == 22 || i == 24 || i == 5 || i == 11 || i == 12 || i == 9 || i == 20)
              cprintf("%d %s  (%s %d)\n",p->pid, p->syscalls[i].name, a->type[0], a->int_argv[0]);
            if (i == 23)
              cprintf("%d %s  (%s %d, %s %d)\n",p->pid, p->syscalls[i].name,
80104459:	83 ec 04             	sub    $0x4,%esp
8010445c:	ff b6 f4 00 00 00    	pushl  0xf4(%esi)
80104462:	52                   	push   %edx
80104463:	ff b6 f0 00 00 00    	pushl  0xf0(%esi)
80104469:	56                   	push   %esi
8010446a:	ff 75 e4             	pushl  -0x1c(%ebp)
8010446d:	ff 70 88             	pushl  -0x78(%eax)
80104470:	68 92 87 10 80       	push   $0x80108792
80104475:	e8 66 c2 ff ff       	call   801006e0 <cprintf>
8010447a:	83 c4 20             	add    $0x20,%esp
8010447d:	e9 a1 fd ff ff       	jmp    80104223 <invocation_log+0xf3>
                a->type[0],a->int_argv[0],a->type[1],a->str_argv[0],
                a->type[2],a->int_argv[1]);
            if (i == 6)
                cprintf("%d %s  (%s 0x%p, %s 0x%p)\n",p->pid, p->syscalls[i].name, a->type[0], a->str_argv[0], a->type[1], a->ptr_argv[0]);
            if (i == 14)
                cprintf("%d %s  (%s %s, %s %d)\n",p->pid, p->syscalls[i].name, a->type[0], a->str_argv[0], a->type[1], a->int_argv[0]);
80104482:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104485:	8d 56 1e             	lea    0x1e(%esi),%edx
80104488:	83 ec 04             	sub    $0x4,%esp
8010448b:	ff b6 f0 00 00 00    	pushl  0xf0(%esi)
80104491:	52                   	push   %edx
80104492:	ff b6 14 01 00 00    	pushl  0x114(%esi)
80104498:	56                   	push   %esi
80104499:	ff 75 e4             	pushl  -0x1c(%ebp)
8010449c:	ff 70 88             	pushl  -0x78(%eax)
8010449f:	68 d6 87 10 80       	push   $0x801087d6
801044a4:	e8 37 c2 ff ff       	call   801006e0 <cprintf>
801044a9:	83 c4 20             	add    $0x20,%esp
801044ac:	e9 a0 fd ff ff       	jmp    80104251 <invocation_log+0x121>
                cprintf("%d %s  (%s %s, %s %s)\n",p->pid, p->syscalls[i].name, a->type[0], a->str_argv[0], a->type[1], a->str_argv[1]);
            if (i == 7)
                cprintf("%d %s  (%s %d, %s 0x%p)\n",p->pid, p->syscalls[i].name, a->type[0], a->int_argv[0], a->type[1], a->st);
            if (i == 16)
                cprintf("%d %s  (%s %s, %s %d, %s %d)\n",p->pid, p->syscalls[i].name, a->type[0], a->str_argv[0], a->type[1], a->int_argv[0],
                  a->type[2], a->int_argv[1]);
801044b1:	8d 56 3c             	lea    0x3c(%esi),%edx
            if (i == 18)
                cprintf("%d %s  (%s %s, %s %s)\n",p->pid, p->syscalls[i].name, a->type[0], a->str_argv[0], a->type[1], a->str_argv[1]);
            if (i == 7)
                cprintf("%d %s  (%s %d, %s 0x%p)\n",p->pid, p->syscalls[i].name, a->type[0], a->int_argv[0], a->type[1], a->st);
            if (i == 16)
                cprintf("%d %s  (%s %s, %s %d, %s %d)\n",p->pid, p->syscalls[i].name, a->type[0], a->str_argv[0], a->type[1], a->int_argv[0],
801044b4:	83 ec 0c             	sub    $0xc,%esp
801044b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801044ba:	ff b6 f4 00 00 00    	pushl  0xf4(%esi)
801044c0:	52                   	push   %edx
801044c1:	8d 56 1e             	lea    0x1e(%esi),%edx
801044c4:	ff b6 f0 00 00 00    	pushl  0xf0(%esi)
801044ca:	52                   	push   %edx
801044cb:	ff b6 14 01 00 00    	pushl  0x114(%esi)
801044d1:	56                   	push   %esi
801044d2:	ff 75 e4             	pushl  -0x1c(%ebp)
801044d5:	ff 70 88             	pushl  -0x78(%eax)
801044d8:	68 2d 88 10 80       	push   $0x8010882d
801044dd:	e8 fe c1 ff ff       	call   801006e0 <cprintf>
801044e2:	83 c4 30             	add    $0x30,%esp
801044e5:	e9 67 fd ff ff       	jmp    80104251 <invocation_log+0x121>
            if (i == 17 || i == 19 || i == 8)
                cprintf("%d %s  (%s %s)\n",p->pid, p->syscalls[i].name, a->type[0], a->str_argv[0]);
            if (i == 18)
                cprintf("%d %s  (%s %s, %s %s)\n",p->pid, p->syscalls[i].name, a->type[0], a->str_argv[0], a->type[1], a->str_argv[1]);
            if (i == 7)
                cprintf("%d %s  (%s %d, %s 0x%p)\n",p->pid, p->syscalls[i].name, a->type[0], a->int_argv[0], a->type[1], a->st);
801044ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
801044ed:	8d 56 1e             	lea    0x1e(%esi),%edx
801044f0:	83 ec 04             	sub    $0x4,%esp
801044f3:	ff b6 54 01 00 00    	pushl  0x154(%esi)
801044f9:	52                   	push   %edx
801044fa:	ff b6 f0 00 00 00    	pushl  0xf0(%esi)
80104500:	56                   	push   %esi
80104501:	ff 75 e4             	pushl  -0x1c(%ebp)
80104504:	ff 70 88             	pushl  -0x78(%eax)
80104507:	68 14 88 10 80       	push   $0x80108814
8010450c:	e8 cf c1 ff ff       	call   801006e0 <cprintf>
80104511:	83 c4 20             	add    $0x20,%esp
80104514:	e9 38 fd ff ff       	jmp    80104251 <invocation_log+0x121>
80104519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104520 <get_syscall_count>:
  return status;
}

int
get_syscall_count(int pid, int sysnum)
{
80104520:	55                   	push   %ebp
80104521:	89 e5                	mov    %esp,%ebp
80104523:	56                   	push   %esi
80104524:	53                   	push   %ebx
  struct proc *p;
  int count = 0, status = -1;
80104525:	31 f6                	xor    %esi,%esi
  return status;
}

int
get_syscall_count(int pid, int sysnum)
{
80104527:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;
  int count = 0, status = -1;

  acquire(&ptable.lock);
8010452a:	83 ec 0c             	sub    $0xc,%esp
8010452d:	68 40 4d 11 80       	push   $0x80114d40
80104532:	e8 f9 04 00 00       	call   80104a30 <acquire>
80104537:	6b 4d 0c 34          	imul   $0x34,0xc(%ebp),%ecx
8010453b:	83 c4 10             	add    $0x10,%esp

int
get_syscall_count(int pid, int sysnum)
{
  struct proc *p;
  int count = 0, status = -1;
8010453e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104543:	ba 74 4d 11 80       	mov    $0x80114d74,%edx
80104548:	eb 14                	jmp    8010455e <get_syscall_count+0x3e>
8010454a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104550:	81 c2 60 06 00 00    	add    $0x660,%edx
80104556:	81 fa 74 e5 12 80    	cmp    $0x8012e574,%edx
8010455c:	74 19                	je     80104577 <get_syscall_count+0x57>
  {
     if (p->pid == pid)
8010455e:	39 5a 10             	cmp    %ebx,0x10(%edx)
80104561:	75 ed                	jne    80104550 <get_syscall_count+0x30>
     {
       count = p->syscalls[sysnum-1].count;
80104563:	8b 74 0a 48          	mov    0x48(%edx,%ecx,1),%esi
{
  struct proc *p;
  int count = 0, status = -1;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104567:	81 c2 60 06 00 00    	add    $0x660,%edx
  {
     if (p->pid == pid)
     {
       count = p->syscalls[sysnum-1].count;
       status = 0;
8010456d:	31 c0                	xor    %eax,%eax
{
  struct proc *p;
  int count = 0, status = -1;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010456f:	81 fa 74 e5 12 80    	cmp    $0x8012e574,%edx
80104575:	75 e7                	jne    8010455e <get_syscall_count+0x3e>
       count = p->syscalls[sysnum-1].count;
       status = 0;
     }
  }

  if(status == -1)
80104577:	83 f8 ff             	cmp    $0xffffffff,%eax
8010457a:	74 19                	je     80104595 <get_syscall_count+0x75>
  {
    cprintf("pid not found!\n");
    release(&ptable.lock);
    return -1;
  }
  release(&ptable.lock);
8010457c:	83 ec 0c             	sub    $0xc,%esp
8010457f:	68 40 4d 11 80       	push   $0x80114d40
80104584:	e8 57 05 00 00       	call   80104ae0 <release>
  return count;
80104589:	83 c4 10             	add    $0x10,%esp
8010458c:	89 f0                	mov    %esi,%eax
}
8010458e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104591:	5b                   	pop    %ebx
80104592:	5e                   	pop    %esi
80104593:	5d                   	pop    %ebp
80104594:	c3                   	ret    
     }
  }

  if(status == -1)
  {
    cprintf("pid not found!\n");
80104595:	83 ec 0c             	sub    $0xc,%esp
80104598:	68 4b 88 10 80       	push   $0x8010884b
8010459d:	e8 3e c1 ff ff       	call   801006e0 <cprintf>
    release(&ptable.lock);
801045a2:	c7 04 24 40 4d 11 80 	movl   $0x80114d40,(%esp)
801045a9:	e8 32 05 00 00       	call   80104ae0 <release>
    return -1;
801045ae:	83 c4 10             	add    $0x10,%esp
801045b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045b6:	eb d6                	jmp    8010458e <get_syscall_count+0x6e>
801045b8:	90                   	nop
801045b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801045c0 <log_syscalls>:
  return count;
}

void 
log_syscalls(struct node* first_proc)
{
801045c0:	55                   	push   %ebp
801045c1:	89 e5                	mov    %esp,%ebp
801045c3:	53                   	push   %ebx
801045c4:	83 ec 04             	sub    $0x4,%esp
801045c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  for(struct node* n = first_proc; n != 0; n = n->next){
801045ca:	85 db                	test   %ebx,%ebx
801045cc:	74 2f                	je     801045fd <log_syscalls+0x3d>
801045ce:	66 90                	xchg   %ax,%ax
    cprintf("Syscall name: %s @ DATE: %d:%d:%d %d-%d-%d by Process: %d\n", n -> name, n->date.hour, n->date.minute, n->date.second, n->date.year,
801045d0:	83 ec 0c             	sub    $0xc,%esp
801045d3:	ff 73 38             	pushl  0x38(%ebx)
801045d6:	ff 73 2c             	pushl  0x2c(%ebx)
801045d9:	ff 73 30             	pushl  0x30(%ebx)
801045dc:	ff 73 34             	pushl  0x34(%ebx)
801045df:	ff 73 20             	pushl  0x20(%ebx)
801045e2:	ff 73 24             	pushl  0x24(%ebx)
801045e5:	ff 73 28             	pushl  0x28(%ebx)
801045e8:	53                   	push   %ebx
801045e9:	68 1c 89 10 80       	push   $0x8010891c
801045ee:	e8 ed c0 ff ff       	call   801006e0 <cprintf>
}

void 
log_syscalls(struct node* first_proc)
{
  for(struct node* n = first_proc; n != 0; n = n->next){
801045f3:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801045f6:	83 c4 30             	add    $0x30,%esp
801045f9:	85 db                	test   %ebx,%ebx
801045fb:	75 d3                	jne    801045d0 <log_syscalls+0x10>
    cprintf("Syscall name: %s @ DATE: %d:%d:%d %d-%d-%d by Process: %d\n", n -> name, n->date.hour, n->date.minute, n->date.second, n->date.year,
      n->date.month, n->date.day, n -> pid);
  }
}
801045fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104600:	c9                   	leave  
80104601:	c3                   	ret    
80104602:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104610 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104610:	55                   	push   %ebp
80104611:	89 e5                	mov    %esp,%ebp
80104613:	53                   	push   %ebx
80104614:	83 ec 10             	sub    $0x10,%esp
80104617:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010461a:	68 40 4d 11 80       	push   $0x80114d40
8010461f:	e8 0c 04 00 00       	call   80104a30 <acquire>
80104624:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104627:	b8 74 4d 11 80       	mov    $0x80114d74,%eax
8010462c:	eb 0e                	jmp    8010463c <kill+0x2c>
8010462e:	66 90                	xchg   %ax,%ax
80104630:	05 60 06 00 00       	add    $0x660,%eax
80104635:	3d 74 e5 12 80       	cmp    $0x8012e574,%eax
8010463a:	74 3c                	je     80104678 <kill+0x68>
    if(p->pid == pid){
8010463c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010463f:	75 ef                	jne    80104630 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104641:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
80104645:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010464c:	74 1a                	je     80104668 <kill+0x58>
        p->state = RUNNABLE;
      release(&ptable.lock);
8010464e:	83 ec 0c             	sub    $0xc,%esp
80104651:	68 40 4d 11 80       	push   $0x80114d40
80104656:	e8 85 04 00 00       	call   80104ae0 <release>
      return 0;
8010465b:	83 c4 10             	add    $0x10,%esp
8010465e:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104660:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104663:	c9                   	leave  
80104664:	c3                   	ret    
80104665:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
80104668:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010466f:	eb dd                	jmp    8010464e <kill+0x3e>
80104671:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104678:	83 ec 0c             	sub    $0xc,%esp
8010467b:	68 40 4d 11 80       	push   $0x80114d40
80104680:	e8 5b 04 00 00       	call   80104ae0 <release>
  return -1;
80104685:	83 c4 10             	add    $0x10,%esp
80104688:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010468d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104690:	c9                   	leave  
80104691:	c3                   	ret    
80104692:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801046a0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801046a0:	55                   	push   %ebp
801046a1:	89 e5                	mov    %esp,%ebp
801046a3:	57                   	push   %edi
801046a4:	56                   	push   %esi
801046a5:	53                   	push   %ebx
801046a6:	bf e0 4d 11 80       	mov    $0x80114de0,%edi
  };
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  int count=0;
801046ab:	31 db                	xor    %ebx,%ebx
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801046ad:	83 ec 3c             	sub    $0x3c,%esp
  char *state;
  uint pc[10];
  int count=0;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
801046b0:	8b 47 a0             	mov    -0x60(%edi),%eax
801046b3:	85 c0                	test   %eax,%eax
801046b5:	74 5e                	je     80104715 <procdump+0x75>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801046b7:	83 f8 05             	cmp    $0x5,%eax
      state = states[p->state];
    else
      state = "???";
801046ba:	b9 5b 88 10 80       	mov    $0x8010885b,%ecx
  int count=0;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801046bf:	77 11                	ja     801046d2 <procdump+0x32>
801046c1:	8b 0c 85 58 89 10 80 	mov    -0x7fef76a8(,%eax,4),%ecx
      state = states[p->state];
    else
      state = "???";
801046c8:	b8 5b 88 10 80       	mov    $0x8010885b,%eax
801046cd:	85 c9                	test   %ecx,%ecx
801046cf:	0f 44 c8             	cmove  %eax,%ecx
801046d2:	8d 47 10             	lea    0x10(%edi),%eax
801046d5:	8d 97 f0 04 00 00    	lea    0x4f0(%edi),%edx
801046db:	90                   	nop
801046dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(i=0;i<24;i++)
      count += p->syscalls[i].count;
801046e0:	03 18                	add    (%eax),%ebx
801046e2:	83 c0 34             	add    $0x34,%eax
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    for(i=0;i<24;i++)
801046e5:	39 d0                	cmp    %edx,%eax
801046e7:	75 f7                	jne    801046e0 <procdump+0x40>
      count += p->syscalls[i].count;
    cprintf("%d %s %s count:%d", p->pid, state, p->name,count);
801046e9:	83 ec 0c             	sub    $0xc,%esp
801046ec:	53                   	push   %ebx
801046ed:	57                   	push   %edi
801046ee:	51                   	push   %ecx
801046ef:	ff 77 a4             	pushl  -0x5c(%edi)
801046f2:	68 5f 88 10 80       	push   $0x8010885f
801046f7:	e8 e4 bf ff ff       	call   801006e0 <cprintf>
    if(p->state == SLEEPING){
801046fc:	83 c4 20             	add    $0x20,%esp
801046ff:	83 7f a0 02          	cmpl   $0x2,-0x60(%edi)
80104703:	74 26                	je     8010472b <procdump+0x8b>
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104705:	83 ec 0c             	sub    $0xc,%esp
80104708:	68 59 88 10 80       	push   $0x80108859
8010470d:	e8 ce bf ff ff       	call   801006e0 <cprintf>
80104712:	83 c4 10             	add    $0x10,%esp
80104715:	81 c7 60 06 00 00    	add    $0x660,%edi
  struct proc *p;
  char *state;
  uint pc[10];
  int count=0;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010471b:	81 ff e0 e5 12 80    	cmp    $0x8012e5e0,%edi
80104721:	75 8d                	jne    801046b0 <procdump+0x10>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80104723:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104726:	5b                   	pop    %ebx
80104727:	5e                   	pop    %esi
80104728:	5f                   	pop    %edi
80104729:	5d                   	pop    %ebp
8010472a:	c3                   	ret    
      state = "???";
    for(i=0;i<24;i++)
      count += p->syscalls[i].count;
    cprintf("%d %s %s count:%d", p->pid, state, p->name,count);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
8010472b:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010472e:	83 ec 08             	sub    $0x8,%esp
80104731:	8d 75 c0             	lea    -0x40(%ebp),%esi
80104734:	50                   	push   %eax
80104735:	8b 47 b0             	mov    -0x50(%edi),%eax
80104738:	8b 40 0c             	mov    0xc(%eax),%eax
8010473b:	83 c0 08             	add    $0x8,%eax
8010473e:	50                   	push   %eax
8010473f:	e8 ac 01 00 00       	call   801048f0 <getcallerpcs>
80104744:	83 c4 10             	add    $0x10,%esp
80104747:	89 f6                	mov    %esi,%esi
80104749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      for(i=0; i<10 && pc[i] != 0; i++)
80104750:	8b 06                	mov    (%esi),%eax
80104752:	85 c0                	test   %eax,%eax
80104754:	74 af                	je     80104705 <procdump+0x65>
        cprintf(" %p", pc[i]);
80104756:	83 ec 08             	sub    $0x8,%esp
80104759:	83 c6 04             	add    $0x4,%esi
8010475c:	50                   	push   %eax
8010475d:	68 c1 81 10 80       	push   $0x801081c1
80104762:	e8 79 bf ff ff       	call   801006e0 <cprintf>
    for(i=0;i<24;i++)
      count += p->syscalls[i].count;
    cprintf("%d %s %s count:%d", p->pid, state, p->name,count);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104767:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010476a:	83 c4 10             	add    $0x10,%esp
8010476d:	39 c6                	cmp    %eax,%esi
8010476f:	75 df                	jne    80104750 <procdump+0xb0>
80104771:	eb 92                	jmp    80104705 <procdump+0x65>
80104773:	66 90                	xchg   %ax,%ax
80104775:	66 90                	xchg   %ax,%ax
80104777:	66 90                	xchg   %ax,%ax
80104779:	66 90                	xchg   %ax,%ax
8010477b:	66 90                	xchg   %ax,%ax
8010477d:	66 90                	xchg   %ax,%ax
8010477f:	90                   	nop

80104780 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104780:	55                   	push   %ebp
80104781:	89 e5                	mov    %esp,%ebp
80104783:	53                   	push   %ebx
80104784:	83 ec 0c             	sub    $0xc,%esp
80104787:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010478a:	68 70 89 10 80       	push   $0x80108970
8010478f:	8d 43 04             	lea    0x4(%ebx),%eax
80104792:	50                   	push   %eax
80104793:	e8 38 01 00 00       	call   801048d0 <initlock>
  lk->name = name;
80104798:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010479b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801047a1:	83 c4 10             	add    $0x10,%esp
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
  lk->locked = 0;
  lk->pid = 0;
801047a4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
801047ab:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
801047ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047b1:	c9                   	leave  
801047b2:	c3                   	ret    
801047b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801047b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801047c0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801047c0:	55                   	push   %ebp
801047c1:	89 e5                	mov    %esp,%ebp
801047c3:	56                   	push   %esi
801047c4:	53                   	push   %ebx
801047c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801047c8:	83 ec 0c             	sub    $0xc,%esp
801047cb:	8d 73 04             	lea    0x4(%ebx),%esi
801047ce:	56                   	push   %esi
801047cf:	e8 5c 02 00 00       	call   80104a30 <acquire>
  while (lk->locked) {
801047d4:	8b 13                	mov    (%ebx),%edx
801047d6:	83 c4 10             	add    $0x10,%esp
801047d9:	85 d2                	test   %edx,%edx
801047db:	74 16                	je     801047f3 <acquiresleep+0x33>
801047dd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801047e0:	83 ec 08             	sub    $0x8,%esp
801047e3:	56                   	push   %esi
801047e4:	53                   	push   %ebx
801047e5:	e8 26 f7 ff ff       	call   80103f10 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
801047ea:	8b 03                	mov    (%ebx),%eax
801047ec:	83 c4 10             	add    $0x10,%esp
801047ef:	85 c0                	test   %eax,%eax
801047f1:	75 ed                	jne    801047e0 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
801047f3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801047f9:	e8 52 f1 ff ff       	call   80103950 <myproc>
801047fe:	8b 40 10             	mov    0x10(%eax),%eax
80104801:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104804:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104807:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010480a:	5b                   	pop    %ebx
8010480b:	5e                   	pop    %esi
8010480c:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = myproc()->pid;
  release(&lk->lk);
8010480d:	e9 ce 02 00 00       	jmp    80104ae0 <release>
80104812:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104820 <releasesleep>:
}

void
releasesleep(struct sleeplock *lk)
{
80104820:	55                   	push   %ebp
80104821:	89 e5                	mov    %esp,%ebp
80104823:	57                   	push   %edi
80104824:	56                   	push   %esi
80104825:	53                   	push   %ebx
80104826:	83 ec 18             	sub    $0x18,%esp
80104829:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010482c:	8d 73 04             	lea    0x4(%ebx),%esi
8010482f:	56                   	push   %esi
80104830:	e8 fb 01 00 00       	call   80104a30 <acquire>
  if (lk->locked && (lk->pid == myproc()->pid)){
80104835:	8b 03                	mov    (%ebx),%eax
80104837:	83 c4 10             	add    $0x10,%esp
8010483a:	85 c0                	test   %eax,%eax
8010483c:	75 12                	jne    80104850 <releasesleep+0x30>
    lk->locked = 0;
    lk->pid = 0;
    wakeup(lk);
  }
  release(&lk->lk);
8010483e:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104841:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104844:	5b                   	pop    %ebx
80104845:	5e                   	pop    %esi
80104846:	5f                   	pop    %edi
80104847:	5d                   	pop    %ebp
  if (lk->locked && (lk->pid == myproc()->pid)){
    lk->locked = 0;
    lk->pid = 0;
    wakeup(lk);
  }
  release(&lk->lk);
80104848:	e9 93 02 00 00       	jmp    80104ae0 <release>
8010484d:	8d 76 00             	lea    0x0(%esi),%esi

void
releasesleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  if (lk->locked && (lk->pid == myproc()->pid)){
80104850:	8b 7b 3c             	mov    0x3c(%ebx),%edi
80104853:	e8 f8 f0 ff ff       	call   80103950 <myproc>
80104858:	3b 78 10             	cmp    0x10(%eax),%edi
8010485b:	75 e1                	jne    8010483e <releasesleep+0x1e>
    lk->locked = 0;
    lk->pid = 0;
    wakeup(lk);
8010485d:	83 ec 0c             	sub    $0xc,%esp
void
releasesleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  if (lk->locked && (lk->pid == myproc()->pid)){
    lk->locked = 0;
80104860:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
    lk->pid = 0;
80104866:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
    wakeup(lk);
8010486d:	53                   	push   %ebx
8010486e:	e8 5d f8 ff ff       	call   801040d0 <wakeup>
80104873:	83 c4 10             	add    $0x10,%esp
80104876:	eb c6                	jmp    8010483e <releasesleep+0x1e>
80104878:	90                   	nop
80104879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104880 <holdingsleep>:
  release(&lk->lk);
}

int
holdingsleep(struct sleeplock *lk)
{
80104880:	55                   	push   %ebp
80104881:	89 e5                	mov    %esp,%ebp
80104883:	57                   	push   %edi
80104884:	56                   	push   %esi
80104885:	53                   	push   %ebx
80104886:	31 ff                	xor    %edi,%edi
80104888:	83 ec 18             	sub    $0x18,%esp
8010488b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010488e:	8d 73 04             	lea    0x4(%ebx),%esi
80104891:	56                   	push   %esi
80104892:	e8 99 01 00 00       	call   80104a30 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104897:	8b 03                	mov    (%ebx),%eax
80104899:	83 c4 10             	add    $0x10,%esp
8010489c:	85 c0                	test   %eax,%eax
8010489e:	74 13                	je     801048b3 <holdingsleep+0x33>
801048a0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801048a3:	e8 a8 f0 ff ff       	call   80103950 <myproc>
801048a8:	39 58 10             	cmp    %ebx,0x10(%eax)
801048ab:	0f 94 c0             	sete   %al
801048ae:	0f b6 c0             	movzbl %al,%eax
801048b1:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
801048b3:	83 ec 0c             	sub    $0xc,%esp
801048b6:	56                   	push   %esi
801048b7:	e8 24 02 00 00       	call   80104ae0 <release>
  return r;
}
801048bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801048bf:	89 f8                	mov    %edi,%eax
801048c1:	5b                   	pop    %ebx
801048c2:	5e                   	pop    %esi
801048c3:	5f                   	pop    %edi
801048c4:	5d                   	pop    %ebp
801048c5:	c3                   	ret    
801048c6:	66 90                	xchg   %ax,%ax
801048c8:	66 90                	xchg   %ax,%ax
801048ca:	66 90                	xchg   %ax,%ax
801048cc:	66 90                	xchg   %ax,%ax
801048ce:	66 90                	xchg   %ax,%ax

801048d0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801048d0:	55                   	push   %ebp
801048d1:	89 e5                	mov    %esp,%ebp
801048d3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801048d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801048d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
801048df:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
801048e2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801048e9:	5d                   	pop    %ebp
801048ea:	c3                   	ret    
801048eb:	90                   	nop
801048ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801048f0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801048f0:	55                   	push   %ebp
801048f1:	89 e5                	mov    %esp,%ebp
801048f3:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801048f4:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801048f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801048fa:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
801048fd:	31 c0                	xor    %eax,%eax
801048ff:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104900:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104906:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010490c:	77 1a                	ja     80104928 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010490e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104911:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104914:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
80104917:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104919:	83 f8 0a             	cmp    $0xa,%eax
8010491c:	75 e2                	jne    80104900 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010491e:	5b                   	pop    %ebx
8010491f:	5d                   	pop    %ebp
80104920:	c3                   	ret    
80104921:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104928:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010492f:	83 c0 01             	add    $0x1,%eax
80104932:	83 f8 0a             	cmp    $0xa,%eax
80104935:	74 e7                	je     8010491e <getcallerpcs+0x2e>
    pcs[i] = 0;
80104937:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010493e:	83 c0 01             	add    $0x1,%eax
80104941:	83 f8 0a             	cmp    $0xa,%eax
80104944:	75 e2                	jne    80104928 <getcallerpcs+0x38>
80104946:	eb d6                	jmp    8010491e <getcallerpcs+0x2e>
80104948:	90                   	nop
80104949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104950 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104950:	55                   	push   %ebp
80104951:	89 e5                	mov    %esp,%ebp
80104953:	53                   	push   %ebx
80104954:	83 ec 04             	sub    $0x4,%esp
80104957:	9c                   	pushf  
80104958:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
80104959:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010495a:	e8 51 ef ff ff       	call   801038b0 <mycpu>
8010495f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104965:	85 c0                	test   %eax,%eax
80104967:	75 11                	jne    8010497a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104969:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010496f:	e8 3c ef ff ff       	call   801038b0 <mycpu>
80104974:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010497a:	e8 31 ef ff ff       	call   801038b0 <mycpu>
8010497f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104986:	83 c4 04             	add    $0x4,%esp
80104989:	5b                   	pop    %ebx
8010498a:	5d                   	pop    %ebp
8010498b:	c3                   	ret    
8010498c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104990 <popcli>:

void
popcli(void)
{
80104990:	55                   	push   %ebp
80104991:	89 e5                	mov    %esp,%ebp
80104993:	83 ec 08             	sub    $0x8,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104996:	9c                   	pushf  
80104997:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104998:	f6 c4 02             	test   $0x2,%ah
8010499b:	75 52                	jne    801049ef <popcli+0x5f>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010499d:	e8 0e ef ff ff       	call   801038b0 <mycpu>
801049a2:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
801049a8:	8d 51 ff             	lea    -0x1(%ecx),%edx
801049ab:	85 d2                	test   %edx,%edx
801049ad:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
801049b3:	78 2d                	js     801049e2 <popcli+0x52>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801049b5:	e8 f6 ee ff ff       	call   801038b0 <mycpu>
801049ba:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801049c0:	85 d2                	test   %edx,%edx
801049c2:	74 0c                	je     801049d0 <popcli+0x40>
    sti();
}
801049c4:	c9                   	leave  
801049c5:	c3                   	ret    
801049c6:	8d 76 00             	lea    0x0(%esi),%esi
801049c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801049d0:	e8 db ee ff ff       	call   801038b0 <mycpu>
801049d5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801049db:	85 c0                	test   %eax,%eax
801049dd:	74 e5                	je     801049c4 <popcli+0x34>
}

static inline void
sti(void)
{
  asm volatile("sti");
801049df:	fb                   	sti    
    sti();
}
801049e0:	c9                   	leave  
801049e1:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
801049e2:	83 ec 0c             	sub    $0xc,%esp
801049e5:	68 92 89 10 80       	push   $0x80108992
801049ea:	e8 81 b9 ff ff       	call   80100370 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
801049ef:	83 ec 0c             	sub    $0xc,%esp
801049f2:	68 7b 89 10 80       	push   $0x8010897b
801049f7:	e8 74 b9 ff ff       	call   80100370 <panic>
801049fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104a00 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104a00:	55                   	push   %ebp
80104a01:	89 e5                	mov    %esp,%ebp
80104a03:	56                   	push   %esi
80104a04:	53                   	push   %ebx
80104a05:	8b 75 08             	mov    0x8(%ebp),%esi
80104a08:	31 db                	xor    %ebx,%ebx
  int r;
  pushcli();
80104a0a:	e8 41 ff ff ff       	call   80104950 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104a0f:	8b 06                	mov    (%esi),%eax
80104a11:	85 c0                	test   %eax,%eax
80104a13:	74 10                	je     80104a25 <holding+0x25>
80104a15:	8b 5e 08             	mov    0x8(%esi),%ebx
80104a18:	e8 93 ee ff ff       	call   801038b0 <mycpu>
80104a1d:	39 c3                	cmp    %eax,%ebx
80104a1f:	0f 94 c3             	sete   %bl
80104a22:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104a25:	e8 66 ff ff ff       	call   80104990 <popcli>
  return r;
}
80104a2a:	89 d8                	mov    %ebx,%eax
80104a2c:	5b                   	pop    %ebx
80104a2d:	5e                   	pop    %esi
80104a2e:	5d                   	pop    %ebp
80104a2f:	c3                   	ret    

80104a30 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104a30:	55                   	push   %ebp
80104a31:	89 e5                	mov    %esp,%ebp
80104a33:	53                   	push   %ebx
80104a34:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104a37:	e8 14 ff ff ff       	call   80104950 <pushcli>
  if(holding(lk))
80104a3c:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104a3f:	83 ec 0c             	sub    $0xc,%esp
80104a42:	53                   	push   %ebx
80104a43:	e8 b8 ff ff ff       	call   80104a00 <holding>
80104a48:	83 c4 10             	add    $0x10,%esp
80104a4b:	85 c0                	test   %eax,%eax
80104a4d:	0f 85 7d 00 00 00    	jne    80104ad0 <acquire+0xa0>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104a53:	ba 01 00 00 00       	mov    $0x1,%edx
80104a58:	eb 09                	jmp    80104a63 <acquire+0x33>
80104a5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a60:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104a63:	89 d0                	mov    %edx,%eax
80104a65:	f0 87 03             	lock xchg %eax,(%ebx)
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80104a68:	85 c0                	test   %eax,%eax
80104a6a:	75 f4                	jne    80104a60 <acquire+0x30>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
80104a6c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80104a71:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104a74:	e8 37 ee ff ff       	call   801038b0 <mycpu>
getcallerpcs(void *v, uint pcs[])
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104a79:	89 ea                	mov    %ebp,%edx
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
80104a7b:	8d 4b 0c             	lea    0xc(%ebx),%ecx
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80104a7e:	89 43 08             	mov    %eax,0x8(%ebx)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104a81:	31 c0                	xor    %eax,%eax
80104a83:	90                   	nop
80104a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104a88:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104a8e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104a94:	77 1a                	ja     80104ab0 <acquire+0x80>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104a96:	8b 5a 04             	mov    0x4(%edx),%ebx
80104a99:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104a9c:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
80104a9f:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104aa1:	83 f8 0a             	cmp    $0xa,%eax
80104aa4:	75 e2                	jne    80104a88 <acquire+0x58>
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
}
80104aa6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104aa9:	c9                   	leave  
80104aaa:	c3                   	ret    
80104aab:	90                   	nop
80104aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104ab0:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104ab7:	83 c0 01             	add    $0x1,%eax
80104aba:	83 f8 0a             	cmp    $0xa,%eax
80104abd:	74 e7                	je     80104aa6 <acquire+0x76>
    pcs[i] = 0;
80104abf:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104ac6:	83 c0 01             	add    $0x1,%eax
80104ac9:	83 f8 0a             	cmp    $0xa,%eax
80104acc:	75 e2                	jne    80104ab0 <acquire+0x80>
80104ace:	eb d6                	jmp    80104aa6 <acquire+0x76>
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");
80104ad0:	83 ec 0c             	sub    $0xc,%esp
80104ad3:	68 99 89 10 80       	push   $0x80108999
80104ad8:	e8 93 b8 ff ff       	call   80100370 <panic>
80104add:	8d 76 00             	lea    0x0(%esi),%esi

80104ae0 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
80104ae0:	55                   	push   %ebp
80104ae1:	89 e5                	mov    %esp,%ebp
80104ae3:	53                   	push   %ebx
80104ae4:	83 ec 10             	sub    $0x10,%esp
80104ae7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104aea:	53                   	push   %ebx
80104aeb:	e8 10 ff ff ff       	call   80104a00 <holding>
80104af0:	83 c4 10             	add    $0x10,%esp
80104af3:	85 c0                	test   %eax,%eax
80104af5:	74 22                	je     80104b19 <release+0x39>
    panic("release");

  lk->pcs[0] = 0;
80104af7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104afe:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80104b05:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104b0a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)

  popcli();
}
80104b10:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b13:	c9                   	leave  
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
80104b14:	e9 77 fe ff ff       	jmp    80104990 <popcli>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
80104b19:	83 ec 0c             	sub    $0xc,%esp
80104b1c:	68 a1 89 10 80       	push   $0x801089a1
80104b21:	e8 4a b8 ff ff       	call   80100370 <panic>
80104b26:	66 90                	xchg   %ax,%ax
80104b28:	66 90                	xchg   %ax,%ax
80104b2a:	66 90                	xchg   %ax,%ax
80104b2c:	66 90                	xchg   %ax,%ax
80104b2e:	66 90                	xchg   %ax,%ax

80104b30 <init_ticket_lock>:
#include "mmu.h"
#include "proc.h"
#include "spinlock.h"
#include "ticket_lock.h"

void init_ticket_lock(struct ticket_lock* lk, char* name) {
80104b30:	55                   	push   %ebp
80104b31:	89 e5                	mov    %esp,%ebp
80104b33:	53                   	push   %ebx
80104b34:	83 ec 0c             	sub    $0xc,%esp
80104b37:	8b 5d 08             	mov    0x8(%ebp),%ebx
	initlock(&lk->lk, "ticket lock");
80104b3a:	68 a9 89 10 80       	push   $0x801089a9
80104b3f:	8d 43 0c             	lea    0xc(%ebx),%eax
80104b42:	50                   	push   %eax
80104b43:	e8 88 fd ff ff       	call   801048d0 <initlock>
	lk->name = name;
80104b48:	8b 45 0c             	mov    0xc(%ebp),%eax
	lk->pid = 0;
80104b4b:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	lk->ticket = 0;
	lk->turn = 0;
}
80104b52:	83 c4 10             	add    $0x10,%esp

void init_ticket_lock(struct ticket_lock* lk, char* name) {
	initlock(&lk->lk, "ticket lock");
	lk->name = name;
	lk->pid = 0;
	lk->ticket = 0;
80104b55:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	lk->turn = 0;
80104b5b:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
#include "spinlock.h"
#include "ticket_lock.h"

void init_ticket_lock(struct ticket_lock* lk, char* name) {
	initlock(&lk->lk, "ticket lock");
	lk->name = name;
80104b62:	89 43 40             	mov    %eax,0x40(%ebx)
	lk->pid = 0;
	lk->ticket = 0;
	lk->turn = 0;
}
80104b65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b68:	c9                   	leave  
80104b69:	c3                   	ret    
80104b6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b70 <ticket_acquire>:

void ticket_acquire(struct ticket_lock* lk) {
80104b70:	55                   	push   %ebp
80104b71:	89 e5                	mov    %esp,%ebp
80104b73:	57                   	push   %edi
80104b74:	56                   	push   %esi
80104b75:	53                   	push   %ebx
80104b76:	83 ec 18             	sub    $0x18,%esp
80104b79:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int me;
	acquire(&lk->lk);
80104b7c:	8d 7b 0c             	lea    0xc(%ebx),%edi
80104b7f:	57                   	push   %edi
80104b80:	e8 ab fe ff ff       	call   80104a30 <acquire>
	}
	release(&lk->lk);
}

int ticket_holding(struct ticket_lock* lk) {
	return (lk->ticket != lk->turn) && (lk->pid == myproc()->pid);
80104b85:	83 c4 10             	add    $0x10,%esp
80104b88:	8b 43 04             	mov    0x4(%ebx),%eax
80104b8b:	39 03                	cmp    %eax,(%ebx)
80104b8d:	74 0d                	je     80104b9c <ticket_acquire+0x2c>
80104b8f:	8b 73 08             	mov    0x8(%ebx),%esi
80104b92:	e8 b9 ed ff ff       	call   80103950 <myproc>
80104b97:	3b 70 10             	cmp    0x10(%eax),%esi
80104b9a:	74 44                	je     80104be0 <ticket_acquire+0x70>
}

static inline uint
read_and_increment(volatile uint* addr, uint val)
{
  asm volatile("lock; xaddl %%eax, %2;" :
80104b9c:	b8 01 00 00 00       	mov    $0x1,%eax
80104ba1:	f0 0f c1 03          	lock xadd %eax,(%ebx)
	//cprintf("before panic\n");
	if (ticket_holding(lk))
		panic("acquire");
	me = read_and_increment(&lk->ticket, 1);
	//cprintf("after inc %d %d\n", me, lk->ticket);
	while(lk->turn != me){
80104ba5:	3b 43 04             	cmp    0x4(%ebx),%eax
80104ba8:	89 c6                	mov    %eax,%esi
80104baa:	74 16                	je     80104bc2 <ticket_acquire+0x52>
80104bac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		sleep(lk, &lk->lk);
80104bb0:	83 ec 08             	sub    $0x8,%esp
80104bb3:	57                   	push   %edi
80104bb4:	53                   	push   %ebx
80104bb5:	e8 56 f3 ff ff       	call   80103f10 <sleep>
	//cprintf("before panic\n");
	if (ticket_holding(lk))
		panic("acquire");
	me = read_and_increment(&lk->ticket, 1);
	//cprintf("after inc %d %d\n", me, lk->ticket);
	while(lk->turn != me){
80104bba:	83 c4 10             	add    $0x10,%esp
80104bbd:	3b 73 04             	cmp    0x4(%ebx),%esi
80104bc0:	75 ee                	jne    80104bb0 <ticket_acquire+0x40>
		sleep(lk, &lk->lk);
		//cprintf("add to sleep queue\n");
	}
	lk->pid = myproc()->pid;
80104bc2:	e8 89 ed ff ff       	call   80103950 <myproc>
80104bc7:	8b 40 10             	mov    0x10(%eax),%eax
80104bca:	89 43 08             	mov    %eax,0x8(%ebx)
	release(&lk->lk);
80104bcd:	89 7d 08             	mov    %edi,0x8(%ebp)
}
80104bd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104bd3:	5b                   	pop    %ebx
80104bd4:	5e                   	pop    %esi
80104bd5:	5f                   	pop    %edi
80104bd6:	5d                   	pop    %ebp
	while(lk->turn != me){
		sleep(lk, &lk->lk);
		//cprintf("add to sleep queue\n");
	}
	lk->pid = myproc()->pid;
	release(&lk->lk);
80104bd7:	e9 04 ff ff ff       	jmp    80104ae0 <release>
80104bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
void ticket_acquire(struct ticket_lock* lk) {
	int me;
	acquire(&lk->lk);
	//cprintf("before panic\n");
	if (ticket_holding(lk))
		panic("acquire");
80104be0:	83 ec 0c             	sub    $0xc,%esp
80104be3:	68 99 89 10 80       	push   $0x80108999
80104be8:	e8 83 b7 ff ff       	call   80100370 <panic>
80104bed:	8d 76 00             	lea    0x0(%esi),%esi

80104bf0 <ticket_release>:
	}
	lk->pid = myproc()->pid;
	release(&lk->lk);
}

void ticket_release(struct ticket_lock* lk) {
80104bf0:	55                   	push   %ebp
80104bf1:	89 e5                	mov    %esp,%ebp
80104bf3:	57                   	push   %edi
80104bf4:	56                   	push   %esi
80104bf5:	53                   	push   %ebx
80104bf6:	83 ec 18             	sub    $0x18,%esp
80104bf9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	acquire(&lk->lk);
80104bfc:	8d 73 0c             	lea    0xc(%ebx),%esi
80104bff:	56                   	push   %esi
80104c00:	e8 2b fe ff ff       	call   80104a30 <acquire>
	}
	release(&lk->lk);
}

int ticket_holding(struct ticket_lock* lk) {
	return (lk->ticket != lk->turn) && (lk->pid == myproc()->pid);
80104c05:	83 c4 10             	add    $0x10,%esp
80104c08:	8b 43 04             	mov    0x4(%ebx),%eax
80104c0b:	39 03                	cmp    %eax,(%ebx)
80104c0d:	74 0d                	je     80104c1c <ticket_release+0x2c>
80104c0f:	8b 7b 08             	mov    0x8(%ebx),%edi
80104c12:	e8 39 ed ff ff       	call   80103950 <myproc>
80104c17:	3b 78 10             	cmp    0x10(%eax),%edi
80104c1a:	74 14                	je     80104c30 <ticket_release+0x40>
}

void ticket_release(struct ticket_lock* lk) {
	acquire(&lk->lk);
	if (!ticket_holding(lk))
		panic("release");
80104c1c:	83 ec 0c             	sub    $0xc,%esp
80104c1f:	68 a1 89 10 80       	push   $0x801089a1
80104c24:	e8 47 b7 ff ff       	call   80100370 <panic>
80104c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	if (/*(lk->ticket == lk->turn) &&*/ (lk->pid == myproc()->pid))
80104c30:	8b 7b 08             	mov    0x8(%ebx),%edi
80104c33:	e8 18 ed ff ff       	call   80103950 <myproc>
80104c38:	3b 78 10             	cmp    0x10(%eax),%edi
80104c3b:	74 13                	je     80104c50 <ticket_release+0x60>
	{
		lk->pid = 0;
		lk->turn += 1;
		wakeup(lk);
	}
	release(&lk->lk);
80104c3d:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104c40:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c43:	5b                   	pop    %ebx
80104c44:	5e                   	pop    %esi
80104c45:	5f                   	pop    %edi
80104c46:	5d                   	pop    %ebp
	{
		lk->pid = 0;
		lk->turn += 1;
		wakeup(lk);
	}
	release(&lk->lk);
80104c47:	e9 94 fe ff ff       	jmp    80104ae0 <release>
80104c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	if (!ticket_holding(lk))
		panic("release");
	if (/*(lk->ticket == lk->turn) &&*/ (lk->pid == myproc()->pid))
	{
		lk->pid = 0;
		lk->turn += 1;
80104c50:	83 43 04 01          	addl   $0x1,0x4(%ebx)
		wakeup(lk);
80104c54:	83 ec 0c             	sub    $0xc,%esp
	acquire(&lk->lk);
	if (!ticket_holding(lk))
		panic("release");
	if (/*(lk->ticket == lk->turn) &&*/ (lk->pid == myproc()->pid))
	{
		lk->pid = 0;
80104c57:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
		lk->turn += 1;
		wakeup(lk);
80104c5e:	53                   	push   %ebx
80104c5f:	e8 6c f4 ff ff       	call   801040d0 <wakeup>
	}
	release(&lk->lk);
80104c64:	89 75 08             	mov    %esi,0x8(%ebp)
		panic("release");
	if (/*(lk->ticket == lk->turn) &&*/ (lk->pid == myproc()->pid))
	{
		lk->pid = 0;
		lk->turn += 1;
		wakeup(lk);
80104c67:	83 c4 10             	add    $0x10,%esp
	}
	release(&lk->lk);
}
80104c6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c6d:	5b                   	pop    %ebx
80104c6e:	5e                   	pop    %esi
80104c6f:	5f                   	pop    %edi
80104c70:	5d                   	pop    %ebp
	{
		lk->pid = 0;
		lk->turn += 1;
		wakeup(lk);
	}
	release(&lk->lk);
80104c71:	e9 6a fe ff ff       	jmp    80104ae0 <release>
80104c76:	8d 76 00             	lea    0x0(%esi),%esi
80104c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c80 <ticket_holding>:
}

int ticket_holding(struct ticket_lock* lk) {
80104c80:	55                   	push   %ebp
80104c81:	31 c0                	xor    %eax,%eax
80104c83:	89 e5                	mov    %esp,%ebp
80104c85:	53                   	push   %ebx
80104c86:	83 ec 04             	sub    $0x4,%esp
80104c89:	8b 55 08             	mov    0x8(%ebp),%edx
	return (lk->ticket != lk->turn) && (lk->pid == myproc()->pid);
80104c8c:	8b 4a 04             	mov    0x4(%edx),%ecx
80104c8f:	39 0a                	cmp    %ecx,(%edx)
80104c91:	74 11                	je     80104ca4 <ticket_holding+0x24>
80104c93:	8b 5a 08             	mov    0x8(%edx),%ebx
80104c96:	e8 b5 ec ff ff       	call   80103950 <myproc>
80104c9b:	39 58 10             	cmp    %ebx,0x10(%eax)
80104c9e:	0f 94 c0             	sete   %al
80104ca1:	0f b6 c0             	movzbl %al,%eax
}
80104ca4:	83 c4 04             	add    $0x4,%esp
80104ca7:	5b                   	pop    %ebx
80104ca8:	5d                   	pop    %ebp
80104ca9:	c3                   	ret    
80104caa:	66 90                	xchg   %ax,%ax
80104cac:	66 90                	xchg   %ax,%ax
80104cae:	66 90                	xchg   %ax,%ax

80104cb0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104cb0:	55                   	push   %ebp
80104cb1:	89 e5                	mov    %esp,%ebp
80104cb3:	57                   	push   %edi
80104cb4:	53                   	push   %ebx
80104cb5:	8b 55 08             	mov    0x8(%ebp),%edx
80104cb8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104cbb:	f6 c2 03             	test   $0x3,%dl
80104cbe:	75 05                	jne    80104cc5 <memset+0x15>
80104cc0:	f6 c1 03             	test   $0x3,%cl
80104cc3:	74 13                	je     80104cd8 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
80104cc5:	89 d7                	mov    %edx,%edi
80104cc7:	8b 45 0c             	mov    0xc(%ebp),%eax
80104cca:	fc                   	cld    
80104ccb:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104ccd:	5b                   	pop    %ebx
80104cce:	89 d0                	mov    %edx,%eax
80104cd0:	5f                   	pop    %edi
80104cd1:	5d                   	pop    %ebp
80104cd2:	c3                   	ret    
80104cd3:	90                   	nop
80104cd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
80104cd8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
80104cdc:	c1 e9 02             	shr    $0x2,%ecx
80104cdf:	89 fb                	mov    %edi,%ebx
80104ce1:	89 f8                	mov    %edi,%eax
80104ce3:	c1 e3 18             	shl    $0x18,%ebx
80104ce6:	c1 e0 10             	shl    $0x10,%eax
80104ce9:	09 d8                	or     %ebx,%eax
80104ceb:	09 f8                	or     %edi,%eax
80104ced:	c1 e7 08             	shl    $0x8,%edi
80104cf0:	09 f8                	or     %edi,%eax
80104cf2:	89 d7                	mov    %edx,%edi
80104cf4:	fc                   	cld    
80104cf5:	f3 ab                	rep stos %eax,%es:(%edi)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104cf7:	5b                   	pop    %ebx
80104cf8:	89 d0                	mov    %edx,%eax
80104cfa:	5f                   	pop    %edi
80104cfb:	5d                   	pop    %ebp
80104cfc:	c3                   	ret    
80104cfd:	8d 76 00             	lea    0x0(%esi),%esi

80104d00 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104d00:	55                   	push   %ebp
80104d01:	89 e5                	mov    %esp,%ebp
80104d03:	57                   	push   %edi
80104d04:	56                   	push   %esi
80104d05:	8b 45 10             	mov    0x10(%ebp),%eax
80104d08:	53                   	push   %ebx
80104d09:	8b 75 0c             	mov    0xc(%ebp),%esi
80104d0c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104d0f:	85 c0                	test   %eax,%eax
80104d11:	74 29                	je     80104d3c <memcmp+0x3c>
    if(*s1 != *s2)
80104d13:	0f b6 13             	movzbl (%ebx),%edx
80104d16:	0f b6 0e             	movzbl (%esi),%ecx
80104d19:	38 d1                	cmp    %dl,%cl
80104d1b:	75 2b                	jne    80104d48 <memcmp+0x48>
80104d1d:	8d 78 ff             	lea    -0x1(%eax),%edi
80104d20:	31 c0                	xor    %eax,%eax
80104d22:	eb 14                	jmp    80104d38 <memcmp+0x38>
80104d24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d28:	0f b6 54 03 01       	movzbl 0x1(%ebx,%eax,1),%edx
80104d2d:	83 c0 01             	add    $0x1,%eax
80104d30:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104d34:	38 ca                	cmp    %cl,%dl
80104d36:	75 10                	jne    80104d48 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104d38:	39 f8                	cmp    %edi,%eax
80104d3a:	75 ec                	jne    80104d28 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104d3c:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80104d3d:	31 c0                	xor    %eax,%eax
}
80104d3f:	5e                   	pop    %esi
80104d40:	5f                   	pop    %edi
80104d41:	5d                   	pop    %ebp
80104d42:	c3                   	ret    
80104d43:	90                   	nop
80104d44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104d48:	0f b6 c2             	movzbl %dl,%eax
    s1++, s2++;
  }

  return 0;
}
80104d4b:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104d4c:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
80104d4e:	5e                   	pop    %esi
80104d4f:	5f                   	pop    %edi
80104d50:	5d                   	pop    %ebp
80104d51:	c3                   	ret    
80104d52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d60 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104d60:	55                   	push   %ebp
80104d61:	89 e5                	mov    %esp,%ebp
80104d63:	56                   	push   %esi
80104d64:	53                   	push   %ebx
80104d65:	8b 45 08             	mov    0x8(%ebp),%eax
80104d68:	8b 75 0c             	mov    0xc(%ebp),%esi
80104d6b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104d6e:	39 c6                	cmp    %eax,%esi
80104d70:	73 2e                	jae    80104da0 <memmove+0x40>
80104d72:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104d75:	39 c8                	cmp    %ecx,%eax
80104d77:	73 27                	jae    80104da0 <memmove+0x40>
    s += n;
    d += n;
    while(n-- > 0)
80104d79:	85 db                	test   %ebx,%ebx
80104d7b:	8d 53 ff             	lea    -0x1(%ebx),%edx
80104d7e:	74 17                	je     80104d97 <memmove+0x37>
      *--d = *--s;
80104d80:	29 d9                	sub    %ebx,%ecx
80104d82:	89 cb                	mov    %ecx,%ebx
80104d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d88:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104d8c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80104d8f:	83 ea 01             	sub    $0x1,%edx
80104d92:	83 fa ff             	cmp    $0xffffffff,%edx
80104d95:	75 f1                	jne    80104d88 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104d97:	5b                   	pop    %ebx
80104d98:	5e                   	pop    %esi
80104d99:	5d                   	pop    %ebp
80104d9a:	c3                   	ret    
80104d9b:	90                   	nop
80104d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104da0:	31 d2                	xor    %edx,%edx
80104da2:	85 db                	test   %ebx,%ebx
80104da4:	74 f1                	je     80104d97 <memmove+0x37>
80104da6:	8d 76 00             	lea    0x0(%esi),%esi
80104da9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      *d++ = *s++;
80104db0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104db4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104db7:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104dba:	39 d3                	cmp    %edx,%ebx
80104dbc:	75 f2                	jne    80104db0 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
80104dbe:	5b                   	pop    %ebx
80104dbf:	5e                   	pop    %esi
80104dc0:	5d                   	pop    %ebp
80104dc1:	c3                   	ret    
80104dc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104dd0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104dd0:	55                   	push   %ebp
80104dd1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104dd3:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104dd4:	eb 8a                	jmp    80104d60 <memmove>
80104dd6:	8d 76 00             	lea    0x0(%esi),%esi
80104dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104de0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104de0:	55                   	push   %ebp
80104de1:	89 e5                	mov    %esp,%ebp
80104de3:	57                   	push   %edi
80104de4:	56                   	push   %esi
80104de5:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104de8:	53                   	push   %ebx
80104de9:	8b 7d 08             	mov    0x8(%ebp),%edi
80104dec:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104def:	85 c9                	test   %ecx,%ecx
80104df1:	74 37                	je     80104e2a <strncmp+0x4a>
80104df3:	0f b6 17             	movzbl (%edi),%edx
80104df6:	0f b6 1e             	movzbl (%esi),%ebx
80104df9:	84 d2                	test   %dl,%dl
80104dfb:	74 3f                	je     80104e3c <strncmp+0x5c>
80104dfd:	38 d3                	cmp    %dl,%bl
80104dff:	75 3b                	jne    80104e3c <strncmp+0x5c>
80104e01:	8d 47 01             	lea    0x1(%edi),%eax
80104e04:	01 cf                	add    %ecx,%edi
80104e06:	eb 1b                	jmp    80104e23 <strncmp+0x43>
80104e08:	90                   	nop
80104e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e10:	0f b6 10             	movzbl (%eax),%edx
80104e13:	84 d2                	test   %dl,%dl
80104e15:	74 21                	je     80104e38 <strncmp+0x58>
80104e17:	0f b6 19             	movzbl (%ecx),%ebx
80104e1a:	83 c0 01             	add    $0x1,%eax
80104e1d:	89 ce                	mov    %ecx,%esi
80104e1f:	38 da                	cmp    %bl,%dl
80104e21:	75 19                	jne    80104e3c <strncmp+0x5c>
80104e23:	39 c7                	cmp    %eax,%edi
    n--, p++, q++;
80104e25:	8d 4e 01             	lea    0x1(%esi),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104e28:	75 e6                	jne    80104e10 <strncmp+0x30>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104e2a:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
80104e2b:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
80104e2d:	5e                   	pop    %esi
80104e2e:	5f                   	pop    %edi
80104e2f:	5d                   	pop    %ebp
80104e30:	c3                   	ret    
80104e31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e38:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104e3c:	0f b6 c2             	movzbl %dl,%eax
80104e3f:	29 d8                	sub    %ebx,%eax
}
80104e41:	5b                   	pop    %ebx
80104e42:	5e                   	pop    %esi
80104e43:	5f                   	pop    %edi
80104e44:	5d                   	pop    %ebp
80104e45:	c3                   	ret    
80104e46:	8d 76 00             	lea    0x0(%esi),%esi
80104e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e50 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104e50:	55                   	push   %ebp
80104e51:	89 e5                	mov    %esp,%ebp
80104e53:	56                   	push   %esi
80104e54:	53                   	push   %ebx
80104e55:	8b 45 08             	mov    0x8(%ebp),%eax
80104e58:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104e5b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104e5e:	89 c2                	mov    %eax,%edx
80104e60:	eb 19                	jmp    80104e7b <strncpy+0x2b>
80104e62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e68:	83 c3 01             	add    $0x1,%ebx
80104e6b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104e6f:	83 c2 01             	add    $0x1,%edx
80104e72:	84 c9                	test   %cl,%cl
80104e74:	88 4a ff             	mov    %cl,-0x1(%edx)
80104e77:	74 09                	je     80104e82 <strncpy+0x32>
80104e79:	89 f1                	mov    %esi,%ecx
80104e7b:	85 c9                	test   %ecx,%ecx
80104e7d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104e80:	7f e6                	jg     80104e68 <strncpy+0x18>
    ;
  while(n-- > 0)
80104e82:	31 c9                	xor    %ecx,%ecx
80104e84:	85 f6                	test   %esi,%esi
80104e86:	7e 17                	jle    80104e9f <strncpy+0x4f>
80104e88:	90                   	nop
80104e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104e90:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104e94:	89 f3                	mov    %esi,%ebx
80104e96:	83 c1 01             	add    $0x1,%ecx
80104e99:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80104e9b:	85 db                	test   %ebx,%ebx
80104e9d:	7f f1                	jg     80104e90 <strncpy+0x40>
    *s++ = 0;
  return os;
}
80104e9f:	5b                   	pop    %ebx
80104ea0:	5e                   	pop    %esi
80104ea1:	5d                   	pop    %ebp
80104ea2:	c3                   	ret    
80104ea3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104eb0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104eb0:	55                   	push   %ebp
80104eb1:	89 e5                	mov    %esp,%ebp
80104eb3:	56                   	push   %esi
80104eb4:	53                   	push   %ebx
80104eb5:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104eb8:	8b 45 08             	mov    0x8(%ebp),%eax
80104ebb:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104ebe:	85 c9                	test   %ecx,%ecx
80104ec0:	7e 26                	jle    80104ee8 <safestrcpy+0x38>
80104ec2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104ec6:	89 c1                	mov    %eax,%ecx
80104ec8:	eb 17                	jmp    80104ee1 <safestrcpy+0x31>
80104eca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104ed0:	83 c2 01             	add    $0x1,%edx
80104ed3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104ed7:	83 c1 01             	add    $0x1,%ecx
80104eda:	84 db                	test   %bl,%bl
80104edc:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104edf:	74 04                	je     80104ee5 <safestrcpy+0x35>
80104ee1:	39 f2                	cmp    %esi,%edx
80104ee3:	75 eb                	jne    80104ed0 <safestrcpy+0x20>
    ;
  *s = 0;
80104ee5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104ee8:	5b                   	pop    %ebx
80104ee9:	5e                   	pop    %esi
80104eea:	5d                   	pop    %ebp
80104eeb:	c3                   	ret    
80104eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ef0 <strlen>:

int
strlen(const char *s)
{
80104ef0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104ef1:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
80104ef3:	89 e5                	mov    %esp,%ebp
80104ef5:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80104ef8:	80 3a 00             	cmpb   $0x0,(%edx)
80104efb:	74 0c                	je     80104f09 <strlen+0x19>
80104efd:	8d 76 00             	lea    0x0(%esi),%esi
80104f00:	83 c0 01             	add    $0x1,%eax
80104f03:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104f07:	75 f7                	jne    80104f00 <strlen+0x10>
    ;
  return n;
}
80104f09:	5d                   	pop    %ebp
80104f0a:	c3                   	ret    

80104f0b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104f0b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104f0f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104f13:	55                   	push   %ebp
  pushl %ebx
80104f14:	53                   	push   %ebx
  pushl %esi
80104f15:	56                   	push   %esi
  pushl %edi
80104f16:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104f17:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104f19:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104f1b:	5f                   	pop    %edi
  popl %esi
80104f1c:	5e                   	pop    %esi
  popl %ebx
80104f1d:	5b                   	pop    %ebx
  popl %ebp
80104f1e:	5d                   	pop    %ebp
  ret
80104f1f:	c3                   	ret    

80104f20 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104f20:	55                   	push   %ebp
80104f21:	89 e5                	mov    %esp,%ebp
80104f23:	53                   	push   %ebx
80104f24:	83 ec 04             	sub    $0x4,%esp
80104f27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104f2a:	e8 21 ea ff ff       	call   80103950 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104f2f:	8b 00                	mov    (%eax),%eax
80104f31:	39 d8                	cmp    %ebx,%eax
80104f33:	76 1b                	jbe    80104f50 <fetchint+0x30>
80104f35:	8d 53 04             	lea    0x4(%ebx),%edx
80104f38:	39 d0                	cmp    %edx,%eax
80104f3a:	72 14                	jb     80104f50 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104f3c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f3f:	8b 13                	mov    (%ebx),%edx
80104f41:	89 10                	mov    %edx,(%eax)
  return 0;
80104f43:	31 c0                	xor    %eax,%eax
}
80104f45:	83 c4 04             	add    $0x4,%esp
80104f48:	5b                   	pop    %ebx
80104f49:	5d                   	pop    %ebp
80104f4a:	c3                   	ret    
80104f4b:	90                   	nop
80104f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
80104f50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f55:	eb ee                	jmp    80104f45 <fetchint+0x25>
80104f57:	89 f6                	mov    %esi,%esi
80104f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f60 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104f60:	55                   	push   %ebp
80104f61:	89 e5                	mov    %esp,%ebp
80104f63:	53                   	push   %ebx
80104f64:	83 ec 04             	sub    $0x4,%esp
80104f67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104f6a:	e8 e1 e9 ff ff       	call   80103950 <myproc>

  if(addr >= curproc->sz)
80104f6f:	39 18                	cmp    %ebx,(%eax)
80104f71:	76 29                	jbe    80104f9c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104f73:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104f76:	89 da                	mov    %ebx,%edx
80104f78:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104f7a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104f7c:	39 c3                	cmp    %eax,%ebx
80104f7e:	73 1c                	jae    80104f9c <fetchstr+0x3c>
    if(*s == 0)
80104f80:	80 3b 00             	cmpb   $0x0,(%ebx)
80104f83:	75 10                	jne    80104f95 <fetchstr+0x35>
80104f85:	eb 29                	jmp    80104fb0 <fetchstr+0x50>
80104f87:	89 f6                	mov    %esi,%esi
80104f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104f90:	80 3a 00             	cmpb   $0x0,(%edx)
80104f93:	74 1b                	je     80104fb0 <fetchstr+0x50>

  if(addr >= curproc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
80104f95:	83 c2 01             	add    $0x1,%edx
80104f98:	39 d0                	cmp    %edx,%eax
80104f9a:	77 f4                	ja     80104f90 <fetchstr+0x30>
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
80104f9c:	83 c4 04             	add    $0x4,%esp
{
  char *s, *ep;
  struct proc *curproc = myproc();

  if(addr >= curproc->sz)
    return -1;
80104f9f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
80104fa4:	5b                   	pop    %ebx
80104fa5:	5d                   	pop    %ebp
80104fa6:	c3                   	ret    
80104fa7:	89 f6                	mov    %esi,%esi
80104fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104fb0:	83 c4 04             	add    $0x4,%esp
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
80104fb3:	89 d0                	mov    %edx,%eax
80104fb5:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104fb7:	5b                   	pop    %ebx
80104fb8:	5d                   	pop    %ebp
80104fb9:	c3                   	ret    
80104fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104fc0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104fc0:	55                   	push   %ebp
80104fc1:	89 e5                	mov    %esp,%ebp
80104fc3:	56                   	push   %esi
80104fc4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104fc5:	e8 86 e9 ff ff       	call   80103950 <myproc>
80104fca:	8b 40 18             	mov    0x18(%eax),%eax
80104fcd:	8b 55 08             	mov    0x8(%ebp),%edx
80104fd0:	8b 40 44             	mov    0x44(%eax),%eax
80104fd3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();
80104fd6:	e8 75 e9 ff ff       	call   80103950 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104fdb:	8b 00                	mov    (%eax),%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104fdd:	8d 73 04             	lea    0x4(%ebx),%esi
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104fe0:	39 c6                	cmp    %eax,%esi
80104fe2:	73 1c                	jae    80105000 <argint+0x40>
80104fe4:	8d 53 08             	lea    0x8(%ebx),%edx
80104fe7:	39 d0                	cmp    %edx,%eax
80104fe9:	72 15                	jb     80105000 <argint+0x40>
    return -1;
  *ip = *(int*)(addr);
80104feb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104fee:	8b 53 04             	mov    0x4(%ebx),%edx
80104ff1:	89 10                	mov    %edx,(%eax)
  return 0;
80104ff3:	31 c0                	xor    %eax,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
}
80104ff5:	5b                   	pop    %ebx
80104ff6:	5e                   	pop    %esi
80104ff7:	5d                   	pop    %ebp
80104ff8:	c3                   	ret    
80104ff9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
80105000:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105005:	eb ee                	jmp    80104ff5 <argint+0x35>
80105007:	89 f6                	mov    %esi,%esi
80105009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105010 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105010:	55                   	push   %ebp
80105011:	89 e5                	mov    %esp,%ebp
80105013:	56                   	push   %esi
80105014:	53                   	push   %ebx
80105015:	83 ec 10             	sub    $0x10,%esp
80105018:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010501b:	e8 30 e9 ff ff       	call   80103950 <myproc>
80105020:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80105022:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105025:	83 ec 08             	sub    $0x8,%esp
80105028:	50                   	push   %eax
80105029:	ff 75 08             	pushl  0x8(%ebp)
8010502c:	e8 8f ff ff ff       	call   80104fc0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105031:	c1 e8 1f             	shr    $0x1f,%eax
80105034:	83 c4 10             	add    $0x10,%esp
80105037:	84 c0                	test   %al,%al
80105039:	75 2d                	jne    80105068 <argptr+0x58>
8010503b:	89 d8                	mov    %ebx,%eax
8010503d:	c1 e8 1f             	shr    $0x1f,%eax
80105040:	84 c0                	test   %al,%al
80105042:	75 24                	jne    80105068 <argptr+0x58>
80105044:	8b 16                	mov    (%esi),%edx
80105046:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105049:	39 c2                	cmp    %eax,%edx
8010504b:	76 1b                	jbe    80105068 <argptr+0x58>
8010504d:	01 c3                	add    %eax,%ebx
8010504f:	39 da                	cmp    %ebx,%edx
80105051:	72 15                	jb     80105068 <argptr+0x58>
    return -1;
  *pp = (char*)i;
80105053:	8b 55 0c             	mov    0xc(%ebp),%edx
80105056:	89 02                	mov    %eax,(%edx)
  return 0;
80105058:	31 c0                	xor    %eax,%eax
}
8010505a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010505d:	5b                   	pop    %ebx
8010505e:	5e                   	pop    %esi
8010505f:	5d                   	pop    %ebp
80105060:	c3                   	ret    
80105061:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct proc *curproc = myproc();
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
    return -1;
80105068:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010506d:	eb eb                	jmp    8010505a <argptr+0x4a>
8010506f:	90                   	nop

80105070 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105070:	55                   	push   %ebp
80105071:	89 e5                	mov    %esp,%ebp
80105073:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105076:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105079:	50                   	push   %eax
8010507a:	ff 75 08             	pushl  0x8(%ebp)
8010507d:	e8 3e ff ff ff       	call   80104fc0 <argint>
80105082:	83 c4 10             	add    $0x10,%esp
80105085:	85 c0                	test   %eax,%eax
80105087:	78 17                	js     801050a0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80105089:	83 ec 08             	sub    $0x8,%esp
8010508c:	ff 75 0c             	pushl  0xc(%ebp)
8010508f:	ff 75 f4             	pushl  -0xc(%ebp)
80105092:	e8 c9 fe ff ff       	call   80104f60 <fetchstr>
80105097:	83 c4 10             	add    $0x10,%esp
}
8010509a:	c9                   	leave  
8010509b:	c3                   	ret    
8010509c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
801050a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
801050a5:	c9                   	leave  
801050a6:	c3                   	ret    
801050a7:	89 f6                	mov    %esi,%esi
801050a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801050b0 <fill_arglist>:
[SYS_halt]  sys_halt,
[SYS_ticketlockinit]  sys_ticketlockinit,
[SYS_ticketlocktest]  sys_ticketlocktest
};

void fill_arglist(struct syscallarg* end, int type){
801050b0:	55                   	push   %ebp
801050b1:	89 e5                	mov    %esp,%ebp
801050b3:	53                   	push   %ebx
801050b4:	83 ec 14             	sub    $0x14,%esp
801050b7:	8b 45 0c             	mov    0xc(%ebp),%eax
801050ba:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int* fds;
        char *path;
        char *path1;
        uint uargv;
        struct stat *st;
	switch(type){
801050bd:	83 f8 1d             	cmp    $0x1d,%eax
801050c0:	77 4e                	ja     80105110 <fill_arglist+0x60>
801050c2:	ff 24 85 e0 8b 10 80 	jmp    *-0x7fef7420(,%eax,4)
801050c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                        end->int_argv[0] = n;
                        break;
               case 18:
               case 20:
               case 9:
                        safestrcpy(end->type[0], "char*", strlen("char*")+1);
801050d0:	83 ec 0c             	sub    $0xc,%esp
801050d3:	68 e8 89 10 80       	push   $0x801089e8
801050d8:	e8 13 fe ff ff       	call   80104ef0 <strlen>
801050dd:	83 c4 0c             	add    $0xc,%esp
801050e0:	83 c0 01             	add    $0x1,%eax
801050e3:	50                   	push   %eax
801050e4:	68 e8 89 10 80       	push   $0x801089e8
801050e9:	53                   	push   %ebx
801050ea:	e8 c1 fd ff ff       	call   80104eb0 <safestrcpy>
                        if(argstr(0, &path) < 0){
801050ef:	59                   	pop    %ecx
801050f0:	58                   	pop    %eax
801050f1:	8d 45 f0             	lea    -0x10(%ebp),%eax
801050f4:	50                   	push   %eax
801050f5:	6a 00                	push   $0x0
801050f7:	e8 74 ff ff ff       	call   80105070 <argstr>
801050fc:	83 c4 10             	add    $0x10,%esp
801050ff:	85 c0                	test   %eax,%eax
80105101:	0f 88 59 05 00 00    	js     80105660 <fill_arglist+0x5b0>
                               cprintf("bad mknode arg val?\n");
   			       break;
                        }
                        end->int_argv[0] = n;
                        end->int_argv[1] = fd;
                        end->str_argv[0] = path;
80105107:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010510a:	89 83 14 01 00 00    	mov    %eax,0x114(%ebx)
                        break;
	}
}
80105110:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105113:	c9                   	leave  
80105114:	c3                   	ret    
80105115:	8d 76 00             	lea    0x0(%esi),%esi
   				break;
			}
			end->int_argv[0] = int_arg;
			break;
                case 24:
                        safestrcpy(end->type[0], "int", strlen("int")+1);
80105118:	83 ec 0c             	sub    $0xc,%esp
8010511b:	68 ba 89 10 80       	push   $0x801089ba
80105120:	e8 cb fd ff ff       	call   80104ef0 <strlen>
80105125:	83 c4 0c             	add    $0xc,%esp
80105128:	83 c0 01             	add    $0x1,%eax
8010512b:	50                   	push   %eax
8010512c:	68 ba 89 10 80       	push   $0x801089ba
80105131:	53                   	push   %ebx
80105132:	e8 79 fd ff ff       	call   80104eb0 <safestrcpy>
                        safestrcpy(end->type[1], "int", strlen("int")+1);
80105137:	c7 04 24 ba 89 10 80 	movl   $0x801089ba,(%esp)
8010513e:	e8 ad fd ff ff       	call   80104ef0 <strlen>
80105143:	83 c4 0c             	add    $0xc,%esp
80105146:	83 c0 01             	add    $0x1,%eax
80105149:	50                   	push   %eax
8010514a:	8d 43 1e             	lea    0x1e(%ebx),%eax
8010514d:	68 ba 89 10 80       	push   $0x801089ba
80105152:	50                   	push   %eax
80105153:	e8 58 fd ff ff       	call   80104eb0 <safestrcpy>
			if (argint(0, &int_arg) < 0 || argint(1, &int_arg2) < 0){
80105158:	59                   	pop    %ecx
80105159:	58                   	pop    %eax
8010515a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010515d:	50                   	push   %eax
8010515e:	6a 00                	push   $0x0
80105160:	e8 5b fe ff ff       	call   80104fc0 <argint>
80105165:	83 c4 10             	add    $0x10,%esp
80105168:	85 c0                	test   %eax,%eax
8010516a:	0f 88 08 05 00 00    	js     80105678 <fill_arglist+0x5c8>
80105170:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105173:	83 ec 08             	sub    $0x8,%esp
80105176:	50                   	push   %eax
80105177:	6a 01                	push   $0x1
80105179:	e8 42 fe ff ff       	call   80104fc0 <argint>
8010517e:	83 c4 10             	add    $0x10,%esp
80105181:	85 c0                	test   %eax,%eax
80105183:	0f 88 ef 04 00 00    	js     80105678 <fill_arglist+0x5c8>
   				cprintf("bad int arg val?\n");
   				break;
			}
			end->int_argv[0] = int_arg;
80105189:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010518c:	89 83 f0 00 00 00    	mov    %eax,0xf0(%ebx)
                        end->int_argv[1] = int_arg2;
80105192:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105195:	89 83 f4 00 00 00    	mov    %eax,0xf4(%ebx)
			break;
8010519b:	e9 70 ff ff ff       	jmp    80105110 <fill_arglist+0x60>
		case 1:
                case 14:
                case 11:
                case 28:
                case 29:
			safestrcpy(end->type[0], "void", strlen("void")+1);break;
801051a0:	83 ec 0c             	sub    $0xc,%esp
801051a3:	68 b5 89 10 80       	push   $0x801089b5
801051a8:	e8 43 fd ff ff       	call   80104ef0 <strlen>
801051ad:	83 c4 0c             	add    $0xc,%esp
801051b0:	83 c0 01             	add    $0x1,%eax
801051b3:	50                   	push   %eax
801051b4:	68 b5 89 10 80       	push   $0x801089b5
801051b9:	53                   	push   %ebx
801051ba:	e8 f1 fc ff ff       	call   80104eb0 <safestrcpy>
801051bf:	83 c4 10             	add    $0x10,%esp
801051c2:	e9 49 ff ff ff       	jmp    80105110 <fill_arglist+0x60>
801051c7:	89 f6                	mov    %esi,%esi
801051c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
			}
			end->int_argv[0] = int_arg;
                        end->int_argv[1] = int_arg2;
			break;
                case 4:
                        safestrcpy(end->type[0], "int*", strlen("int*")+1);
801051d0:	83 ec 0c             	sub    $0xc,%esp
801051d3:	68 d0 89 10 80       	push   $0x801089d0
801051d8:	e8 13 fd ff ff       	call   80104ef0 <strlen>
801051dd:	83 c4 0c             	add    $0xc,%esp
801051e0:	83 c0 01             	add    $0x1,%eax
801051e3:	50                   	push   %eax
801051e4:	68 d0 89 10 80       	push   $0x801089d0
801051e9:	53                   	push   %ebx
801051ea:	e8 c1 fc ff ff       	call   80104eb0 <safestrcpy>
                        if (argptr(0, (void*)&fds, 2*sizeof(fds[0])) < 0){
801051ef:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051f2:	83 c4 0c             	add    $0xc,%esp
801051f5:	6a 08                	push   $0x8
801051f7:	50                   	push   %eax
801051f8:	6a 00                	push   $0x0
801051fa:	e8 11 fe ff ff       	call   80105010 <argptr>
801051ff:	83 c4 10             	add    $0x10,%esp
80105202:	85 c0                	test   %eax,%eax
80105204:	0f 88 ce 04 00 00    	js     801056d8 <fill_arglist+0x628>
                                cprintf("bad int* arg val?\n");
   				break;
                        }
                        end->intptr_argv = fds;
8010520a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010520d:	89 83 10 01 00 00    	mov    %eax,0x110(%ebx)
                        break;
80105213:	e9 f8 fe ff ff       	jmp    80105110 <fill_arglist+0x60>
80105218:	90                   	nop
80105219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                case 5:
                case 16:
                        safestrcpy(end->type[0], "int", strlen("int")+1);
80105220:	83 ec 0c             	sub    $0xc,%esp
80105223:	68 ba 89 10 80       	push   $0x801089ba
80105228:	e8 c3 fc ff ff       	call   80104ef0 <strlen>
8010522d:	83 c4 0c             	add    $0xc,%esp
80105230:	83 c0 01             	add    $0x1,%eax
80105233:	50                   	push   %eax
80105234:	68 ba 89 10 80       	push   $0x801089ba
80105239:	53                   	push   %ebx
8010523a:	e8 71 fc ff ff       	call   80104eb0 <safestrcpy>
                        safestrcpy(end->type[1], "char*", strlen("char*")+1);
8010523f:	c7 04 24 e8 89 10 80 	movl   $0x801089e8,(%esp)
80105246:	e8 a5 fc ff ff       	call   80104ef0 <strlen>
8010524b:	83 c4 0c             	add    $0xc,%esp
8010524e:	83 c0 01             	add    $0x1,%eax
80105251:	50                   	push   %eax
80105252:	8d 43 1e             	lea    0x1e(%ebx),%eax
80105255:	68 e8 89 10 80       	push   $0x801089e8
8010525a:	50                   	push   %eax
8010525b:	e8 50 fc ff ff       	call   80104eb0 <safestrcpy>
                        safestrcpy(end->type[2], "int", strlen("int")+1);
80105260:	c7 04 24 ba 89 10 80 	movl   $0x801089ba,(%esp)
80105267:	e8 84 fc ff ff       	call   80104ef0 <strlen>
8010526c:	83 c4 0c             	add    $0xc,%esp
8010526f:	83 c0 01             	add    $0x1,%eax
80105272:	50                   	push   %eax
80105273:	8d 43 3c             	lea    0x3c(%ebx),%eax
80105276:	68 ba 89 10 80       	push   $0x801089ba
8010527b:	50                   	push   %eax
8010527c:	e8 2f fc ff ff       	call   80104eb0 <safestrcpy>
                        if(argint(0, &fd) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0){
80105281:	58                   	pop    %eax
80105282:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105285:	5a                   	pop    %edx
80105286:	50                   	push   %eax
80105287:	6a 00                	push   $0x0
80105289:	e8 32 fd ff ff       	call   80104fc0 <argint>
8010528e:	83 c4 10             	add    $0x10,%esp
80105291:	85 c0                	test   %eax,%eax
80105293:	0f 88 97 03 00 00    	js     80105630 <fill_arglist+0x580>
80105299:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010529c:	83 ec 08             	sub    $0x8,%esp
8010529f:	50                   	push   %eax
801052a0:	6a 02                	push   $0x2
801052a2:	e8 19 fd ff ff       	call   80104fc0 <argint>
801052a7:	83 c4 10             	add    $0x10,%esp
801052aa:	85 c0                	test   %eax,%eax
801052ac:	0f 88 7e 03 00 00    	js     80105630 <fill_arglist+0x580>
801052b2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052b5:	83 ec 04             	sub    $0x4,%esp
801052b8:	ff 75 ec             	pushl  -0x14(%ebp)
801052bb:	50                   	push   %eax
801052bc:	6a 01                	push   $0x1
801052be:	e8 4d fd ff ff       	call   80105010 <argptr>
801052c3:	83 c4 10             	add    $0x10,%esp
801052c6:	85 c0                	test   %eax,%eax
801052c8:	0f 88 62 03 00 00    	js     80105630 <fill_arglist+0x580>
                                cprintf("bad 3 arg val?\n");
   				break;
                        }
                        end->int_argv[0] = fd;
801052ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
801052d1:	89 83 f0 00 00 00    	mov    %eax,0xf0(%ebx)
                        end->int_argv[1] = n;
801052d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801052da:	89 83 f4 00 00 00    	mov    %eax,0xf4(%ebx)
                        end->str_argv[0] = p;
801052e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052e3:	89 83 14 01 00 00    	mov    %eax,0x114(%ebx)
                        break;
801052e9:	e9 22 fe ff ff       	jmp    80105110 <fill_arglist+0x60>
801052ee:	66 90                	xchg   %ax,%ax
                case 25:
                case 12:
                case 13:
                case 10:
                case 21:
			safestrcpy(end->type[0], "int", strlen("int")+1);
801052f0:	83 ec 0c             	sub    $0xc,%esp
801052f3:	68 ba 89 10 80       	push   $0x801089ba
801052f8:	e8 f3 fb ff ff       	call   80104ef0 <strlen>
801052fd:	83 c4 0c             	add    $0xc,%esp
80105300:	83 c0 01             	add    $0x1,%eax
80105303:	50                   	push   %eax
80105304:	68 ba 89 10 80       	push   $0x801089ba
80105309:	53                   	push   %ebx
8010530a:	e8 a1 fb ff ff       	call   80104eb0 <safestrcpy>
			if (argint(0, &int_arg) < 0){
8010530f:	58                   	pop    %eax
80105310:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105313:	5a                   	pop    %edx
80105314:	50                   	push   %eax
80105315:	6a 00                	push   $0x0
80105317:	e8 a4 fc ff ff       	call   80104fc0 <argint>
8010531c:	83 c4 10             	add    $0x10,%esp
8010531f:	85 c0                	test   %eax,%eax
80105321:	0f 88 51 03 00 00    	js     80105678 <fill_arglist+0x5c8>
   				cprintf("bad int arg val?\n");
   				break;
			}
			end->int_argv[0] = int_arg;
80105327:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010532a:	89 83 f0 00 00 00    	mov    %eax,0xf0(%ebx)
			break;
80105330:	e9 db fd ff ff       	jmp    80105110 <fill_arglist+0x60>
80105335:	8d 76 00             	lea    0x0(%esi),%esi
                        end->int_argv[0] = fd;
                        end->int_argv[1] = n;
                        end->str_argv[0] = p;
                        break;
                case 7:
		        safestrcpy(end->type[0], "char*", strlen("char*")+1);
80105338:	83 ec 0c             	sub    $0xc,%esp
8010533b:	68 e8 89 10 80       	push   $0x801089e8
80105340:	e8 ab fb ff ff       	call   80104ef0 <strlen>
80105345:	83 c4 0c             	add    $0xc,%esp
80105348:	83 c0 01             	add    $0x1,%eax
8010534b:	50                   	push   %eax
8010534c:	68 e8 89 10 80       	push   $0x801089e8
80105351:	53                   	push   %ebx
80105352:	e8 59 fb ff ff       	call   80104eb0 <safestrcpy>
                        safestrcpy(end->type[1], "char**", strlen("char**")+1);
80105357:	c7 04 24 fe 89 10 80 	movl   $0x801089fe,(%esp)
8010535e:	e8 8d fb ff ff       	call   80104ef0 <strlen>
80105363:	83 c4 0c             	add    $0xc,%esp
80105366:	83 c0 01             	add    $0x1,%eax
80105369:	50                   	push   %eax
8010536a:	8d 43 1e             	lea    0x1e(%ebx),%eax
8010536d:	68 fe 89 10 80       	push   $0x801089fe
80105372:	50                   	push   %eax
80105373:	e8 38 fb ff ff       	call   80104eb0 <safestrcpy>
                        if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105378:	59                   	pop    %ecx
80105379:	58                   	pop    %eax
8010537a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010537d:	50                   	push   %eax
8010537e:	6a 00                	push   $0x0
80105380:	e8 eb fc ff ff       	call   80105070 <argstr>
80105385:	83 c4 10             	add    $0x10,%esp
80105388:	85 c0                	test   %eax,%eax
8010538a:	0f 88 30 03 00 00    	js     801056c0 <fill_arglist+0x610>
80105390:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105393:	83 ec 08             	sub    $0x8,%esp
80105396:	50                   	push   %eax
80105397:	6a 01                	push   $0x1
80105399:	e8 22 fc ff ff       	call   80104fc0 <argint>
8010539e:	83 c4 10             	add    $0x10,%esp
801053a1:	85 c0                	test   %eax,%eax
801053a3:	0f 88 17 03 00 00    	js     801056c0 <fill_arglist+0x610>
                               cprintf("bad exec arg val?\n");
   			       break;
                        }
                        end->str_argv[0] = path;
801053a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801053ac:	89 83 14 01 00 00    	mov    %eax,0x114(%ebx)
                        end->ptr_argv[0] = (char**)uargv;
801053b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053b5:	89 83 34 01 00 00    	mov    %eax,0x134(%ebx)
                        break;
801053bb:	e9 50 fd ff ff       	jmp    80105110 <fill_arglist+0x60>
                        }
                        end->str_argv[0] = path;
                        end->str_argv[1] = path1;
                        break;
               case 8:
                        safestrcpy(end->type[0], "int", strlen("int")+1);
801053c0:	83 ec 0c             	sub    $0xc,%esp
801053c3:	68 ba 89 10 80       	push   $0x801089ba
801053c8:	e8 23 fb ff ff       	call   80104ef0 <strlen>
801053cd:	83 c4 0c             	add    $0xc,%esp
801053d0:	83 c0 01             	add    $0x1,%eax
801053d3:	50                   	push   %eax
801053d4:	68 ba 89 10 80       	push   $0x801089ba
801053d9:	53                   	push   %ebx
801053da:	e8 d1 fa ff ff       	call   80104eb0 <safestrcpy>
                        safestrcpy(end->type[1], "struct stat*", strlen("struct stat*")+1);
801053df:	c7 04 24 3e 8a 10 80 	movl   $0x80108a3e,(%esp)
801053e6:	e8 05 fb ff ff       	call   80104ef0 <strlen>
801053eb:	83 c4 0c             	add    $0xc,%esp
801053ee:	83 c0 01             	add    $0x1,%eax
801053f1:	50                   	push   %eax
801053f2:	8d 43 1e             	lea    0x1e(%ebx),%eax
801053f5:	68 3e 8a 10 80       	push   $0x80108a3e
801053fa:	50                   	push   %eax
801053fb:	e8 b0 fa ff ff       	call   80104eb0 <safestrcpy>
                        if(argint(0, &n) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0){
80105400:	59                   	pop    %ecx
80105401:	58                   	pop    %eax
80105402:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105405:	50                   	push   %eax
80105406:	6a 00                	push   $0x0
80105408:	e8 b3 fb ff ff       	call   80104fc0 <argint>
8010540d:	83 c4 10             	add    $0x10,%esp
80105410:	85 c0                	test   %eax,%eax
80105412:	0f 88 90 02 00 00    	js     801056a8 <fill_arglist+0x5f8>
80105418:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010541b:	83 ec 04             	sub    $0x4,%esp
8010541e:	6a 14                	push   $0x14
80105420:	50                   	push   %eax
80105421:	6a 01                	push   $0x1
80105423:	e8 e8 fb ff ff       	call   80105010 <argptr>
80105428:	83 c4 10             	add    $0x10,%esp
8010542b:	85 c0                	test   %eax,%eax
8010542d:	0f 88 75 02 00 00    	js     801056a8 <fill_arglist+0x5f8>
                               cprintf("bad fstat arg val?\n");
   			       break;
                        }
                        end->int_argv[0] = n;
80105433:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105436:	89 83 f0 00 00 00    	mov    %eax,0xf0(%ebx)
                        end->st = st;
8010543c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010543f:	89 83 54 01 00 00    	mov    %eax,0x154(%ebx)
                        break;
80105445:	e9 c6 fc ff ff       	jmp    80105110 <fill_arglist+0x60>
8010544a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                        }
                        end->str_argv[0] = path;
                        end->ptr_argv[0] = (char**)uargv;
                        break;
                case 15:
                        safestrcpy(end->type[0], "char*", strlen("char*")+1);
80105450:	83 ec 0c             	sub    $0xc,%esp
80105453:	68 e8 89 10 80       	push   $0x801089e8
80105458:	e8 93 fa ff ff       	call   80104ef0 <strlen>
8010545d:	83 c4 0c             	add    $0xc,%esp
80105460:	83 c0 01             	add    $0x1,%eax
80105463:	50                   	push   %eax
80105464:	68 e8 89 10 80       	push   $0x801089e8
80105469:	53                   	push   %ebx
8010546a:	e8 41 fa ff ff       	call   80104eb0 <safestrcpy>
                        safestrcpy(end->type[1], "int", strlen("int")+1);
8010546f:	c7 04 24 ba 89 10 80 	movl   $0x801089ba,(%esp)
80105476:	e8 75 fa ff ff       	call   80104ef0 <strlen>
8010547b:	83 c4 0c             	add    $0xc,%esp
8010547e:	83 c0 01             	add    $0x1,%eax
80105481:	50                   	push   %eax
80105482:	8d 43 1e             	lea    0x1e(%ebx),%eax
80105485:	68 ba 89 10 80       	push   $0x801089ba
8010548a:	50                   	push   %eax
8010548b:	e8 20 fa ff ff       	call   80104eb0 <safestrcpy>
                        if(argstr(0, &path) < 0 || argint(1, &n) < 0){
80105490:	58                   	pop    %eax
80105491:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105494:	5a                   	pop    %edx
80105495:	50                   	push   %eax
80105496:	6a 00                	push   $0x0
80105498:	e8 d3 fb ff ff       	call   80105070 <argstr>
8010549d:	83 c4 10             	add    $0x10,%esp
801054a0:	85 c0                	test   %eax,%eax
801054a2:	0f 88 e8 01 00 00    	js     80105690 <fill_arglist+0x5e0>
801054a8:	8d 45 ec             	lea    -0x14(%ebp),%eax
801054ab:	83 ec 08             	sub    $0x8,%esp
801054ae:	50                   	push   %eax
801054af:	6a 01                	push   $0x1
801054b1:	e8 0a fb ff ff       	call   80104fc0 <argint>
801054b6:	83 c4 10             	add    $0x10,%esp
801054b9:	85 c0                	test   %eax,%eax
801054bb:	0f 88 cf 01 00 00    	js     80105690 <fill_arglist+0x5e0>
                               cprintf("bad open arg val?\n");
   			       break;
                        }
                        end->str_argv[0] = path;
801054c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801054c4:	89 83 14 01 00 00    	mov    %eax,0x114(%ebx)
                        end->int_argv[0] = n;
801054ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
801054cd:	89 83 f0 00 00 00    	mov    %eax,0xf0(%ebx)
                        break;
801054d3:	e9 38 fc ff ff       	jmp    80105110 <fill_arglist+0x60>
801054d8:	90                   	nop
801054d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                        }
                        end->int_argv[0] = n;
                        end->st = st;
                        break;
              case 17:
                        safestrcpy(end->type[0], "char*", strlen("char*")+1);
801054e0:	83 ec 0c             	sub    $0xc,%esp
801054e3:	68 e8 89 10 80       	push   $0x801089e8
801054e8:	e8 03 fa ff ff       	call   80104ef0 <strlen>
801054ed:	83 c4 0c             	add    $0xc,%esp
801054f0:	83 c0 01             	add    $0x1,%eax
801054f3:	50                   	push   %eax
801054f4:	68 e8 89 10 80       	push   $0x801089e8
801054f9:	53                   	push   %ebx
801054fa:	e8 b1 f9 ff ff       	call   80104eb0 <safestrcpy>
                        safestrcpy(end->type[1], "short", strlen("short")+1);
801054ff:	c7 04 24 5f 8a 10 80 	movl   $0x80108a5f,(%esp)
80105506:	e8 e5 f9 ff ff       	call   80104ef0 <strlen>
8010550b:	83 c4 0c             	add    $0xc,%esp
8010550e:	83 c0 01             	add    $0x1,%eax
80105511:	50                   	push   %eax
80105512:	8d 43 1e             	lea    0x1e(%ebx),%eax
80105515:	68 5f 8a 10 80       	push   $0x80108a5f
8010551a:	50                   	push   %eax
8010551b:	e8 90 f9 ff ff       	call   80104eb0 <safestrcpy>
                        safestrcpy(end->type[2], "short", strlen("short")+1);
80105520:	c7 04 24 5f 8a 10 80 	movl   $0x80108a5f,(%esp)
80105527:	e8 c4 f9 ff ff       	call   80104ef0 <strlen>
8010552c:	83 c4 0c             	add    $0xc,%esp
8010552f:	83 c0 01             	add    $0x1,%eax
80105532:	50                   	push   %eax
80105533:	8d 43 3c             	lea    0x3c(%ebx),%eax
80105536:	68 5f 8a 10 80       	push   $0x80108a5f
8010553b:	50                   	push   %eax
8010553c:	e8 6f f9 ff ff       	call   80104eb0 <safestrcpy>
                        if(argstr(0, &path) < 0 || argint(1, &n) < 0 || argint(2, &fd) < 0){
80105541:	58                   	pop    %eax
80105542:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105545:	5a                   	pop    %edx
80105546:	50                   	push   %eax
80105547:	6a 00                	push   $0x0
80105549:	e8 22 fb ff ff       	call   80105070 <argstr>
8010554e:	83 c4 10             	add    $0x10,%esp
80105551:	85 c0                	test   %eax,%eax
80105553:	0f 88 ef 00 00 00    	js     80105648 <fill_arglist+0x598>
80105559:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010555c:	83 ec 08             	sub    $0x8,%esp
8010555f:	50                   	push   %eax
80105560:	6a 01                	push   $0x1
80105562:	e8 59 fa ff ff       	call   80104fc0 <argint>
80105567:	83 c4 10             	add    $0x10,%esp
8010556a:	85 c0                	test   %eax,%eax
8010556c:	0f 88 d6 00 00 00    	js     80105648 <fill_arglist+0x598>
80105572:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105575:	83 ec 08             	sub    $0x8,%esp
80105578:	50                   	push   %eax
80105579:	6a 02                	push   $0x2
8010557b:	e8 40 fa ff ff       	call   80104fc0 <argint>
80105580:	83 c4 10             	add    $0x10,%esp
80105583:	85 c0                	test   %eax,%eax
80105585:	0f 88 bd 00 00 00    	js     80105648 <fill_arglist+0x598>
                               cprintf("bad mknode arg val?\n");
   			       break;
                        }
                        end->int_argv[0] = n;
8010558b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010558e:	89 83 f0 00 00 00    	mov    %eax,0xf0(%ebx)
                        end->int_argv[1] = fd;
80105594:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105597:	89 83 f4 00 00 00    	mov    %eax,0xf4(%ebx)
8010559d:	e9 65 fb ff ff       	jmp    80105107 <fill_arglist+0x57>
801055a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
   			       break;
                        }
                        end->str_argv[0] = path;
                        break;
               case 19:
                        safestrcpy(end->type[0], "char*", strlen("char*")+1);
801055a8:	83 ec 0c             	sub    $0xc,%esp
801055ab:	68 e8 89 10 80       	push   $0x801089e8
801055b0:	e8 3b f9 ff ff       	call   80104ef0 <strlen>
801055b5:	83 c4 0c             	add    $0xc,%esp
801055b8:	83 c0 01             	add    $0x1,%eax
801055bb:	50                   	push   %eax
801055bc:	68 e8 89 10 80       	push   $0x801089e8
801055c1:	53                   	push   %ebx
801055c2:	e8 e9 f8 ff ff       	call   80104eb0 <safestrcpy>
                        safestrcpy(end->type[1], "char*", strlen("char*")+1);
801055c7:	c7 04 24 e8 89 10 80 	movl   $0x801089e8,(%esp)
801055ce:	e8 1d f9 ff ff       	call   80104ef0 <strlen>
801055d3:	83 c4 0c             	add    $0xc,%esp
801055d6:	83 c0 01             	add    $0x1,%eax
801055d9:	50                   	push   %eax
801055da:	8d 43 1e             	lea    0x1e(%ebx),%eax
801055dd:	68 e8 89 10 80       	push   $0x801089e8
801055e2:	50                   	push   %eax
801055e3:	e8 c8 f8 ff ff       	call   80104eb0 <safestrcpy>
                        if(argstr(0, &path) < 0 || argstr(0, &path1) < 0){
801055e8:	58                   	pop    %eax
801055e9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801055ec:	5a                   	pop    %edx
801055ed:	50                   	push   %eax
801055ee:	6a 00                	push   $0x0
801055f0:	e8 7b fa ff ff       	call   80105070 <argstr>
801055f5:	83 c4 10             	add    $0x10,%esp
801055f8:	85 c0                	test   %eax,%eax
801055fa:	78 64                	js     80105660 <fill_arglist+0x5b0>
801055fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055ff:	83 ec 08             	sub    $0x8,%esp
80105602:	50                   	push   %eax
80105603:	6a 00                	push   $0x0
80105605:	e8 66 fa ff ff       	call   80105070 <argstr>
8010560a:	83 c4 10             	add    $0x10,%esp
8010560d:	85 c0                	test   %eax,%eax
8010560f:	78 4f                	js     80105660 <fill_arglist+0x5b0>
                               cprintf("bad path arg val?\n");
   			       break;
                        }
                        end->str_argv[0] = path;
80105611:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105614:	89 83 14 01 00 00    	mov    %eax,0x114(%ebx)
                        end->str_argv[1] = path1;
8010561a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010561d:	89 83 18 01 00 00    	mov    %eax,0x118(%ebx)
                        break;
80105623:	e9 e8 fa ff ff       	jmp    80105110 <fill_arglist+0x60>
80105628:	90                   	nop
80105629:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                case 16:
                        safestrcpy(end->type[0], "int", strlen("int")+1);
                        safestrcpy(end->type[1], "char*", strlen("char*")+1);
                        safestrcpy(end->type[2], "int", strlen("int")+1);
                        if(argint(0, &fd) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0){
                                cprintf("bad 3 arg val?\n");
80105630:	83 ec 0c             	sub    $0xc,%esp
80105633:	68 ee 89 10 80       	push   $0x801089ee
80105638:	e8 a3 b0 ff ff       	call   801006e0 <cprintf>
   				break;
8010563d:	83 c4 10             	add    $0x10,%esp
80105640:	e9 cb fa ff ff       	jmp    80105110 <fill_arglist+0x60>
80105645:	8d 76 00             	lea    0x0(%esi),%esi
              case 17:
                        safestrcpy(end->type[0], "char*", strlen("char*")+1);
                        safestrcpy(end->type[1], "short", strlen("short")+1);
                        safestrcpy(end->type[2], "short", strlen("short")+1);
                        if(argstr(0, &path) < 0 || argint(1, &n) < 0 || argint(2, &fd) < 0){
                               cprintf("bad mknode arg val?\n");
80105648:	83 ec 0c             	sub    $0xc,%esp
8010564b:	68 65 8a 10 80       	push   $0x80108a65
80105650:	e8 8b b0 ff ff       	call   801006e0 <cprintf>
   			       break;
80105655:	83 c4 10             	add    $0x10,%esp
80105658:	e9 b3 fa ff ff       	jmp    80105110 <fill_arglist+0x60>
8010565d:	8d 76 00             	lea    0x0(%esi),%esi
               case 18:
               case 20:
               case 9:
                        safestrcpy(end->type[0], "char*", strlen("char*")+1);
                        if(argstr(0, &path) < 0){
                               cprintf("bad path arg val?\n");
80105660:	83 ec 0c             	sub    $0xc,%esp
80105663:	68 2b 8a 10 80       	push   $0x80108a2b
80105668:	e8 73 b0 ff ff       	call   801006e0 <cprintf>
   			       break;
8010566d:	83 c4 10             	add    $0x10,%esp
80105670:	e9 9b fa ff ff       	jmp    80105110 <fill_arglist+0x60>
80105675:	8d 76 00             	lea    0x0(%esi),%esi
                case 13:
                case 10:
                case 21:
			safestrcpy(end->type[0], "int", strlen("int")+1);
			if (argint(0, &int_arg) < 0){
   				cprintf("bad int arg val?\n");
80105678:	83 ec 0c             	sub    $0xc,%esp
8010567b:	68 be 89 10 80       	push   $0x801089be
80105680:	e8 5b b0 ff ff       	call   801006e0 <cprintf>
   				break;
80105685:	83 c4 10             	add    $0x10,%esp
80105688:	e9 83 fa ff ff       	jmp    80105110 <fill_arglist+0x60>
8010568d:	8d 76 00             	lea    0x0(%esi),%esi
                        break;
                case 15:
                        safestrcpy(end->type[0], "char*", strlen("char*")+1);
                        safestrcpy(end->type[1], "int", strlen("int")+1);
                        if(argstr(0, &path) < 0 || argint(1, &n) < 0){
                               cprintf("bad open arg val?\n");
80105690:	83 ec 0c             	sub    $0xc,%esp
80105693:	68 18 8a 10 80       	push   $0x80108a18
80105698:	e8 43 b0 ff ff       	call   801006e0 <cprintf>
   			       break;
8010569d:	83 c4 10             	add    $0x10,%esp
801056a0:	e9 6b fa ff ff       	jmp    80105110 <fill_arglist+0x60>
801056a5:	8d 76 00             	lea    0x0(%esi),%esi
                        break;
               case 8:
                        safestrcpy(end->type[0], "int", strlen("int")+1);
                        safestrcpy(end->type[1], "struct stat*", strlen("struct stat*")+1);
                        if(argint(0, &n) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0){
                               cprintf("bad fstat arg val?\n");
801056a8:	83 ec 0c             	sub    $0xc,%esp
801056ab:	68 4b 8a 10 80       	push   $0x80108a4b
801056b0:	e8 2b b0 ff ff       	call   801006e0 <cprintf>
   			       break;
801056b5:	83 c4 10             	add    $0x10,%esp
801056b8:	e9 53 fa ff ff       	jmp    80105110 <fill_arglist+0x60>
801056bd:	8d 76 00             	lea    0x0(%esi),%esi
                        break;
                case 7:
		        safestrcpy(end->type[0], "char*", strlen("char*")+1);
                        safestrcpy(end->type[1], "char**", strlen("char**")+1);
                        if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
                               cprintf("bad exec arg val?\n");
801056c0:	83 ec 0c             	sub    $0xc,%esp
801056c3:	68 05 8a 10 80       	push   $0x80108a05
801056c8:	e8 13 b0 ff ff       	call   801006e0 <cprintf>
   			       break;
801056cd:	83 c4 10             	add    $0x10,%esp
801056d0:	e9 3b fa ff ff       	jmp    80105110 <fill_arglist+0x60>
801056d5:	8d 76 00             	lea    0x0(%esi),%esi
                        end->int_argv[1] = int_arg2;
			break;
                case 4:
                        safestrcpy(end->type[0], "int*", strlen("int*")+1);
                        if (argptr(0, (void*)&fds, 2*sizeof(fds[0])) < 0){
                                cprintf("bad int* arg val?\n");
801056d8:	83 ec 0c             	sub    $0xc,%esp
801056db:	68 d5 89 10 80       	push   $0x801089d5
801056e0:	e8 fb af ff ff       	call   801006e0 <cprintf>
   				break;
801056e5:	83 c4 10             	add    $0x10,%esp
801056e8:	e9 23 fa ff ff       	jmp    80105110 <fill_arglist+0x60>
801056ed:	8d 76 00             	lea    0x0(%esi),%esi

801056f0 <syscall>:
	}
}

void
syscall(void)
{
801056f0:	55                   	push   %ebp
801056f1:	89 e5                	mov    %esp,%ebp
801056f3:	57                   	push   %edi
801056f4:	56                   	push   %esi
801056f5:	53                   	push   %ebx
801056f6:	83 ec 1c             	sub    $0x1c,%esp
  int num;
  struct proc *curproc = myproc();
801056f9:	e8 52 e2 ff ff       	call   80103950 <myproc>

  num = curproc->tf->eax;
801056fe:	8b 50 18             	mov    0x18(%eax),%edx

void
syscall(void)
{
  int num;
  struct proc *curproc = myproc();
80105701:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80105703:	8b 7a 1c             	mov    0x1c(%edx),%edi
80105706:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105709:	8d 77 ff             	lea    -0x1(%edi),%esi
8010570c:	83 fe 1c             	cmp    $0x1c,%esi
8010570f:	0f 87 4b 01 00 00    	ja     80105860 <syscall+0x170>
80105715:	8b 04 bd 60 8c 10 80 	mov    -0x7fef73a0(,%edi,4),%eax
8010571c:	85 c0                	test   %eax,%eax
8010571e:	0f 84 3c 01 00 00    	je     80105860 <syscall+0x170>
    curproc->tf->eax = syscalls[num]();
80105724:	ff d0                	call   *%eax
80105726:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80105729:	89 42 1c             	mov    %eax,0x1c(%edx)
    if (first_proc == 0){
8010572c:	a1 74 e5 12 80       	mov    0x8012e574,%eax
80105731:	85 c0                	test   %eax,%eax
80105733:	0f 84 d7 01 00 00    	je     80105910 <syscall+0x220>
      cmostime(&(first_proc -> date));
      first_proc -> pid = curproc -> pid;
      first_proc -> next = 0;
      last_proc = first_proc;
    }else{
      last_proc -> next = (struct node*) kalloc();
80105739:	8b 15 78 e5 12 80    	mov    0x8012e578,%edx
8010573f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80105742:	e8 e9 ce ff ff       	call   80102630 <kalloc>
80105747:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      safestrcpy(last_proc -> next->name, syscalls_string[num-1], strlen(syscalls_string[num-1])+1);
8010574a:	83 ec 0c             	sub    $0xc,%esp
      cmostime(&(first_proc -> date));
      first_proc -> pid = curproc -> pid;
      first_proc -> next = 0;
      last_proc = first_proc;
    }else{
      last_proc -> next = (struct node*) kalloc();
8010574d:	89 42 3c             	mov    %eax,0x3c(%edx)
      safestrcpy(last_proc -> next->name, syscalls_string[num-1], strlen(syscalls_string[num-1])+1);
80105750:	8b 04 b5 e0 8c 10 80 	mov    -0x7fef7320(,%esi,4),%eax
80105757:	50                   	push   %eax
80105758:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010575b:	e8 90 f7 ff ff       	call   80104ef0 <strlen>
80105760:	83 c4 0c             	add    $0xc,%esp
80105763:	83 c0 01             	add    $0x1,%eax
80105766:	50                   	push   %eax
80105767:	a1 78 e5 12 80       	mov    0x8012e578,%eax
8010576c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010576f:	ff 70 3c             	pushl  0x3c(%eax)
80105772:	e8 39 f7 ff ff       	call   80104eb0 <safestrcpy>
      cmostime(&(last_proc -> next-> date));
80105777:	a1 78 e5 12 80       	mov    0x8012e578,%eax
8010577c:	8b 40 3c             	mov    0x3c(%eax),%eax
8010577f:	83 c0 20             	add    $0x20,%eax
80105782:	89 04 24             	mov    %eax,(%esp)
80105785:	e8 e6 d1 ff ff       	call   80102970 <cmostime>
      last_proc -> next -> pid = curproc -> pid;
8010578a:	a1 78 e5 12 80       	mov    0x8012e578,%eax
8010578f:	8b 4b 10             	mov    0x10(%ebx),%ecx
      last_proc -> next -> next = 0;
      last_proc = last_proc -> next;
80105792:	83 c4 10             	add    $0x10,%esp
      last_proc = first_proc;
    }else{
      last_proc -> next = (struct node*) kalloc();
      safestrcpy(last_proc -> next->name, syscalls_string[num-1], strlen(syscalls_string[num-1])+1);
      cmostime(&(last_proc -> next-> date));
      last_proc -> next -> pid = curproc -> pid;
80105795:	8b 50 3c             	mov    0x3c(%eax),%edx
80105798:	89 4a 38             	mov    %ecx,0x38(%edx)
      last_proc -> next -> next = 0;
8010579b:	8b 50 3c             	mov    0x3c(%eax),%edx
8010579e:	c7 42 3c 00 00 00 00 	movl   $0x0,0x3c(%edx)
      last_proc = last_proc -> next;
801057a5:	8b 40 3c             	mov    0x3c(%eax),%eax
801057a8:	a3 78 e5 12 80       	mov    %eax,0x8012e578
    }
    if (curproc->syscalls[num-1].count == 0){
801057ad:	6b d6 34             	imul   $0x34,%esi,%edx
801057b0:	01 da                	add    %ebx,%edx
801057b2:	8b 42 7c             	mov    0x7c(%edx),%eax
801057b5:	85 c0                	test   %eax,%eax
801057b7:	0f 85 d3 00 00 00    	jne    80105890 <syscall+0x1a0>
801057bd:	89 55 e0             	mov    %edx,-0x20(%ebp)
    	curproc->syscalls[num-1].datelist = (struct date*)kalloc();
801057c0:	e8 6b ce ff ff       	call   80102630 <kalloc>
801057c5:	8b 55 e0             	mov    -0x20(%ebp),%edx
801057c8:	89 82 80 00 00 00    	mov    %eax,0x80(%edx)
    	curproc->syscalls[num-1].datelist->next = 0;
801057ce:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    	curproc->syscalls[num-1].datelist_end = curproc->syscalls[num-1].datelist;
801057d5:	8b 82 80 00 00 00    	mov    0x80(%edx),%eax
801057db:	89 82 84 00 00 00    	mov    %eax,0x84(%edx)
    	curproc->syscalls[num-1].arglist = (struct syscallarg*)kalloc();
801057e1:	e8 4a ce ff ff       	call   80102630 <kalloc>
801057e6:	8b 55 e0             	mov    -0x20(%ebp),%edx
801057e9:	89 82 a8 00 00 00    	mov    %eax,0xa8(%edx)
    	curproc->syscalls[num-1].arglist->next = 0;
801057ef:	c7 80 58 01 00 00 00 	movl   $0x0,0x158(%eax)
801057f6:	00 00 00 
    	curproc->syscalls[num-1].arglist_end = curproc->syscalls[num-1].arglist;
801057f9:	8b 82 a8 00 00 00    	mov    0xa8(%edx),%eax
801057ff:	89 82 ac 00 00 00    	mov    %eax,0xac(%edx)
    	curproc->syscalls[num-1].datelist_end = curproc->syscalls[num-1].datelist_end->next;
    	curproc->syscalls[num-1].arglist_end->next = (struct syscallarg*)kalloc();
      curproc->syscalls[num-1].arglist_end->next->next = 0;
    	curproc->syscalls[num-1].arglist_end = curproc->syscalls[num-1].arglist_end->next;
    }
    curproc->syscalls[num-1].count = curproc->syscalls[num-1].count + 1;
80105805:	6b d6 34             	imul   $0x34,%esi,%edx
    safestrcpy(curproc->syscalls[num-1].name, syscalls_string[num-1], strlen(syscalls_string[num-1])+1);
80105808:	83 ec 0c             	sub    $0xc,%esp
    	curproc->syscalls[num-1].datelist_end = curproc->syscalls[num-1].datelist_end->next;
    	curproc->syscalls[num-1].arglist_end->next = (struct syscallarg*)kalloc();
      curproc->syscalls[num-1].arglist_end->next->next = 0;
    	curproc->syscalls[num-1].arglist_end = curproc->syscalls[num-1].arglist_end->next;
    }
    curproc->syscalls[num-1].count = curproc->syscalls[num-1].count + 1;
8010580b:	8d 34 13             	lea    (%ebx,%edx,1),%esi
8010580e:	89 55 e0             	mov    %edx,-0x20(%ebp)
80105811:	83 46 7c 01          	addl   $0x1,0x7c(%esi)
    safestrcpy(curproc->syscalls[num-1].name, syscalls_string[num-1], strlen(syscalls_string[num-1])+1);
80105815:	ff 75 e4             	pushl  -0x1c(%ebp)
80105818:	e8 d3 f6 ff ff       	call   80104ef0 <strlen>
8010581d:	8b 55 e0             	mov    -0x20(%ebp),%edx
80105820:	83 c4 0c             	add    $0xc,%esp
80105823:	83 c0 01             	add    $0x1,%eax
80105826:	50                   	push   %eax
80105827:	ff 75 e4             	pushl  -0x1c(%ebp)
8010582a:	8d 84 13 88 00 00 00 	lea    0x88(%ebx,%edx,1),%eax
80105831:	50                   	push   %eax
80105832:	e8 79 f6 ff ff       	call   80104eb0 <safestrcpy>
   	cmostime(&(curproc->syscalls[num-1].datelist_end->date));
80105837:	58                   	pop    %eax
80105838:	ff b6 84 00 00 00    	pushl  0x84(%esi)
8010583e:	e8 2d d1 ff ff       	call   80102970 <cmostime>
   	fill_arglist(curproc->syscalls[num-1].arglist_end, num);
80105843:	5a                   	pop    %edx
80105844:	59                   	pop    %ecx
80105845:	57                   	push   %edi
80105846:	ff b6 ac 00 00 00    	pushl  0xac(%esi)
8010584c:	e8 5f f8 ff ff       	call   801050b0 <fill_arglist>
80105851:	83 c4 10             	add    $0x10,%esp
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105854:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105857:	5b                   	pop    %ebx
80105858:	5e                   	pop    %esi
80105859:	5f                   	pop    %edi
8010585a:	5d                   	pop    %ebp
8010585b:	c3                   	ret    
8010585c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    safestrcpy(curproc->syscalls[num-1].name, syscalls_string[num-1], strlen(syscalls_string[num-1])+1);
   	cmostime(&(curproc->syscalls[num-1].datelist_end->date));
   	fill_arglist(curproc->syscalls[num-1].arglist_end, num);
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
80105860:	8d 43 6c             	lea    0x6c(%ebx),%eax
    curproc->syscalls[num-1].count = curproc->syscalls[num-1].count + 1;
    safestrcpy(curproc->syscalls[num-1].name, syscalls_string[num-1], strlen(syscalls_string[num-1])+1);
   	cmostime(&(curproc->syscalls[num-1].datelist_end->date));
   	fill_arglist(curproc->syscalls[num-1].arglist_end, num);
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80105863:	57                   	push   %edi
80105864:	50                   	push   %eax
80105865:	ff 73 10             	pushl  0x10(%ebx)
80105868:	68 7a 8a 10 80       	push   $0x80108a7a
8010586d:	e8 6e ae ff ff       	call   801006e0 <cprintf>
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
80105872:	8b 43 18             	mov    0x18(%ebx),%eax
80105875:	83 c4 10             	add    $0x10,%esp
80105878:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
8010587f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105882:	5b                   	pop    %ebx
80105883:	5e                   	pop    %esi
80105884:	5f                   	pop    %edi
80105885:	5d                   	pop    %ebp
80105886:	c3                   	ret    
80105887:	89 f6                	mov    %esi,%esi
80105889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    	curproc->syscalls[num-1].datelist_end = curproc->syscalls[num-1].datelist;
    	curproc->syscalls[num-1].arglist = (struct syscallarg*)kalloc();
    	curproc->syscalls[num-1].arglist->next = 0;
    	curproc->syscalls[num-1].arglist_end = curproc->syscalls[num-1].arglist;
    }else{
    	curproc->syscalls[num-1].datelist_end->next = (struct date*)kalloc();
80105890:	8b 8a 84 00 00 00    	mov    0x84(%edx),%ecx
80105896:	89 55 dc             	mov    %edx,-0x24(%ebp)
80105899:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010589c:	e8 8f cd ff ff       	call   80102630 <kalloc>
      curproc->syscalls[num-1].datelist_end->next->next = 0;
801058a1:	8b 55 dc             	mov    -0x24(%ebp),%edx
    	curproc->syscalls[num-1].datelist_end = curproc->syscalls[num-1].datelist;
    	curproc->syscalls[num-1].arglist = (struct syscallarg*)kalloc();
    	curproc->syscalls[num-1].arglist->next = 0;
    	curproc->syscalls[num-1].arglist_end = curproc->syscalls[num-1].arglist;
    }else{
    	curproc->syscalls[num-1].datelist_end->next = (struct date*)kalloc();
801058a4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801058a7:	89 41 1c             	mov    %eax,0x1c(%ecx)
      curproc->syscalls[num-1].datelist_end->next->next = 0;
801058aa:	8b 82 84 00 00 00    	mov    0x84(%edx),%eax
801058b0:	8b 40 1c             	mov    0x1c(%eax),%eax
801058b3:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    	curproc->syscalls[num-1].datelist_end = curproc->syscalls[num-1].datelist_end->next;
801058ba:	8b 82 84 00 00 00    	mov    0x84(%edx),%eax
    	curproc->syscalls[num-1].arglist_end->next = (struct syscallarg*)kalloc();
801058c0:	8b 8a ac 00 00 00    	mov    0xac(%edx),%ecx
    	curproc->syscalls[num-1].arglist->next = 0;
    	curproc->syscalls[num-1].arglist_end = curproc->syscalls[num-1].arglist;
    }else{
    	curproc->syscalls[num-1].datelist_end->next = (struct date*)kalloc();
      curproc->syscalls[num-1].datelist_end->next->next = 0;
    	curproc->syscalls[num-1].datelist_end = curproc->syscalls[num-1].datelist_end->next;
801058c6:	8b 40 1c             	mov    0x1c(%eax),%eax
    	curproc->syscalls[num-1].arglist_end->next = (struct syscallarg*)kalloc();
801058c9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    	curproc->syscalls[num-1].arglist->next = 0;
    	curproc->syscalls[num-1].arglist_end = curproc->syscalls[num-1].arglist;
    }else{
    	curproc->syscalls[num-1].datelist_end->next = (struct date*)kalloc();
      curproc->syscalls[num-1].datelist_end->next->next = 0;
    	curproc->syscalls[num-1].datelist_end = curproc->syscalls[num-1].datelist_end->next;
801058cc:	89 82 84 00 00 00    	mov    %eax,0x84(%edx)
    	curproc->syscalls[num-1].arglist_end->next = (struct syscallarg*)kalloc();
801058d2:	e8 59 cd ff ff       	call   80102630 <kalloc>
      curproc->syscalls[num-1].arglist_end->next->next = 0;
801058d7:	8b 55 dc             	mov    -0x24(%ebp),%edx
    	curproc->syscalls[num-1].arglist_end = curproc->syscalls[num-1].arglist;
    }else{
    	curproc->syscalls[num-1].datelist_end->next = (struct date*)kalloc();
      curproc->syscalls[num-1].datelist_end->next->next = 0;
    	curproc->syscalls[num-1].datelist_end = curproc->syscalls[num-1].datelist_end->next;
    	curproc->syscalls[num-1].arglist_end->next = (struct syscallarg*)kalloc();
801058da:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801058dd:	89 81 58 01 00 00    	mov    %eax,0x158(%ecx)
      curproc->syscalls[num-1].arglist_end->next->next = 0;
801058e3:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
801058e9:	8b 80 58 01 00 00    	mov    0x158(%eax),%eax
801058ef:	c7 80 58 01 00 00 00 	movl   $0x0,0x158(%eax)
801058f6:	00 00 00 
    	curproc->syscalls[num-1].arglist_end = curproc->syscalls[num-1].arglist_end->next;
801058f9:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
801058ff:	8b 80 58 01 00 00    	mov    0x158(%eax),%eax
80105905:	89 82 ac 00 00 00    	mov    %eax,0xac(%edx)
8010590b:	e9 f5 fe ff ff       	jmp    80105805 <syscall+0x115>

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
    if (first_proc == 0){
      first_proc = (struct node*) kalloc();
80105910:	e8 1b cd ff ff       	call   80102630 <kalloc>
80105915:	a3 74 e5 12 80       	mov    %eax,0x8012e574
      safestrcpy(first_proc->name, syscalls_string[num-1], strlen(syscalls_string[num-1])+1);
8010591a:	8b 04 b5 e0 8c 10 80 	mov    -0x7fef7320(,%esi,4),%eax
80105921:	83 ec 0c             	sub    $0xc,%esp
80105924:	50                   	push   %eax
80105925:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105928:	e8 c3 f5 ff ff       	call   80104ef0 <strlen>
8010592d:	83 c4 0c             	add    $0xc,%esp
80105930:	83 c0 01             	add    $0x1,%eax
80105933:	50                   	push   %eax
80105934:	ff 75 e4             	pushl  -0x1c(%ebp)
80105937:	ff 35 74 e5 12 80    	pushl  0x8012e574
8010593d:	e8 6e f5 ff ff       	call   80104eb0 <safestrcpy>
      cmostime(&(first_proc -> date));
80105942:	a1 74 e5 12 80       	mov    0x8012e574,%eax
80105947:	83 c0 20             	add    $0x20,%eax
8010594a:	89 04 24             	mov    %eax,(%esp)
8010594d:	e8 1e d0 ff ff       	call   80102970 <cmostime>
      first_proc -> pid = curproc -> pid;
80105952:	a1 74 e5 12 80       	mov    0x8012e574,%eax
80105957:	8b 53 10             	mov    0x10(%ebx),%edx
8010595a:	83 c4 10             	add    $0x10,%esp
8010595d:	89 50 38             	mov    %edx,0x38(%eax)
      first_proc -> next = 0;
80105960:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
      last_proc = first_proc;
80105967:	a3 78 e5 12 80       	mov    %eax,0x8012e578
8010596c:	e9 3c fe ff ff       	jmp    801057ad <syscall+0xbd>
80105971:	66 90                	xchg   %ax,%ax
80105973:	66 90                	xchg   %ax,%ax
80105975:	66 90                	xchg   %ax,%ax
80105977:	66 90                	xchg   %ax,%ax
80105979:	66 90                	xchg   %ax,%ax
8010597b:	66 90                	xchg   %ax,%ax
8010597d:	66 90                	xchg   %ax,%ax
8010597f:	90                   	nop

80105980 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105980:	55                   	push   %ebp
80105981:	89 e5                	mov    %esp,%ebp
80105983:	57                   	push   %edi
80105984:	56                   	push   %esi
80105985:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105986:	8d 75 da             	lea    -0x26(%ebp),%esi
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105989:	83 ec 44             	sub    $0x44,%esp
8010598c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
8010598f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105992:	56                   	push   %esi
80105993:	50                   	push   %eax
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105994:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80105997:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
8010599a:	e8 e1 c6 ff ff       	call   80102080 <nameiparent>
8010599f:	83 c4 10             	add    $0x10,%esp
801059a2:	85 c0                	test   %eax,%eax
801059a4:	0f 84 f6 00 00 00    	je     80105aa0 <create+0x120>
    return 0;
  ilock(dp);
801059aa:	83 ec 0c             	sub    $0xc,%esp
801059ad:	89 c7                	mov    %eax,%edi
801059af:	50                   	push   %eax
801059b0:	e8 5b be ff ff       	call   80101810 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
801059b5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
801059b8:	83 c4 0c             	add    $0xc,%esp
801059bb:	50                   	push   %eax
801059bc:	56                   	push   %esi
801059bd:	57                   	push   %edi
801059be:	e8 7d c3 ff ff       	call   80101d40 <dirlookup>
801059c3:	83 c4 10             	add    $0x10,%esp
801059c6:	85 c0                	test   %eax,%eax
801059c8:	89 c3                	mov    %eax,%ebx
801059ca:	74 54                	je     80105a20 <create+0xa0>
    iunlockput(dp);
801059cc:	83 ec 0c             	sub    $0xc,%esp
801059cf:	57                   	push   %edi
801059d0:	e8 cb c0 ff ff       	call   80101aa0 <iunlockput>
    ilock(ip);
801059d5:	89 1c 24             	mov    %ebx,(%esp)
801059d8:	e8 33 be ff ff       	call   80101810 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801059dd:	83 c4 10             	add    $0x10,%esp
801059e0:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
801059e5:	75 19                	jne    80105a00 <create+0x80>
801059e7:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
801059ec:	89 d8                	mov    %ebx,%eax
801059ee:	75 10                	jne    80105a00 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801059f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059f3:	5b                   	pop    %ebx
801059f4:	5e                   	pop    %esi
801059f5:	5f                   	pop    %edi
801059f6:	5d                   	pop    %ebp
801059f7:	c3                   	ret    
801059f8:	90                   	nop
801059f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if((ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
80105a00:	83 ec 0c             	sub    $0xc,%esp
80105a03:	53                   	push   %ebx
80105a04:	e8 97 c0 ff ff       	call   80101aa0 <iunlockput>
    return 0;
80105a09:	83 c4 10             	add    $0x10,%esp
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105a0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
80105a0f:	31 c0                	xor    %eax,%eax
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105a11:	5b                   	pop    %ebx
80105a12:	5e                   	pop    %esi
80105a13:	5f                   	pop    %edi
80105a14:	5d                   	pop    %ebp
80105a15:	c3                   	ret    
80105a16:	8d 76 00             	lea    0x0(%esi),%esi
80105a19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105a20:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80105a24:	83 ec 08             	sub    $0x8,%esp
80105a27:	50                   	push   %eax
80105a28:	ff 37                	pushl  (%edi)
80105a2a:	e8 71 bc ff ff       	call   801016a0 <ialloc>
80105a2f:	83 c4 10             	add    $0x10,%esp
80105a32:	85 c0                	test   %eax,%eax
80105a34:	89 c3                	mov    %eax,%ebx
80105a36:	0f 84 cc 00 00 00    	je     80105b08 <create+0x188>
    panic("create: ialloc");

  ilock(ip);
80105a3c:	83 ec 0c             	sub    $0xc,%esp
80105a3f:	50                   	push   %eax
80105a40:	e8 cb bd ff ff       	call   80101810 <ilock>
  ip->major = major;
80105a45:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80105a49:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
80105a4d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80105a51:	66 89 43 54          	mov    %ax,0x54(%ebx)
  ip->nlink = 1;
80105a55:	b8 01 00 00 00       	mov    $0x1,%eax
80105a5a:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
80105a5e:	89 1c 24             	mov    %ebx,(%esp)
80105a61:	e8 fa bc ff ff       	call   80101760 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80105a66:	83 c4 10             	add    $0x10,%esp
80105a69:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80105a6e:	74 40                	je     80105ab0 <create+0x130>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105a70:	83 ec 04             	sub    $0x4,%esp
80105a73:	ff 73 04             	pushl  0x4(%ebx)
80105a76:	56                   	push   %esi
80105a77:	57                   	push   %edi
80105a78:	e8 23 c5 ff ff       	call   80101fa0 <dirlink>
80105a7d:	83 c4 10             	add    $0x10,%esp
80105a80:	85 c0                	test   %eax,%eax
80105a82:	78 77                	js     80105afb <create+0x17b>
    panic("create: dirlink");

  iunlockput(dp);
80105a84:	83 ec 0c             	sub    $0xc,%esp
80105a87:	57                   	push   %edi
80105a88:	e8 13 c0 ff ff       	call   80101aa0 <iunlockput>

  return ip;
80105a8d:	83 c4 10             	add    $0x10,%esp
}
80105a90:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
80105a93:	89 d8                	mov    %ebx,%eax
}
80105a95:	5b                   	pop    %ebx
80105a96:	5e                   	pop    %esi
80105a97:	5f                   	pop    %edi
80105a98:	5d                   	pop    %ebp
80105a99:	c3                   	ret    
80105a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
80105aa0:	31 c0                	xor    %eax,%eax
80105aa2:	e9 49 ff ff ff       	jmp    801059f0 <create+0x70>
80105aa7:	89 f6                	mov    %esi,%esi
80105aa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
80105ab0:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
80105ab5:	83 ec 0c             	sub    $0xc,%esp
80105ab8:	57                   	push   %edi
80105ab9:	e8 a2 bc ff ff       	call   80101760 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105abe:	83 c4 0c             	add    $0xc,%esp
80105ac1:	ff 73 04             	pushl  0x4(%ebx)
80105ac4:	68 70 8d 10 80       	push   $0x80108d70
80105ac9:	53                   	push   %ebx
80105aca:	e8 d1 c4 ff ff       	call   80101fa0 <dirlink>
80105acf:	83 c4 10             	add    $0x10,%esp
80105ad2:	85 c0                	test   %eax,%eax
80105ad4:	78 18                	js     80105aee <create+0x16e>
80105ad6:	83 ec 04             	sub    $0x4,%esp
80105ad9:	ff 77 04             	pushl  0x4(%edi)
80105adc:	68 6f 8d 10 80       	push   $0x80108d6f
80105ae1:	53                   	push   %ebx
80105ae2:	e8 b9 c4 ff ff       	call   80101fa0 <dirlink>
80105ae7:	83 c4 10             	add    $0x10,%esp
80105aea:	85 c0                	test   %eax,%eax
80105aec:	79 82                	jns    80105a70 <create+0xf0>
      panic("create dots");
80105aee:	83 ec 0c             	sub    $0xc,%esp
80105af1:	68 63 8d 10 80       	push   $0x80108d63
80105af6:	e8 75 a8 ff ff       	call   80100370 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
80105afb:	83 ec 0c             	sub    $0xc,%esp
80105afe:	68 72 8d 10 80       	push   $0x80108d72
80105b03:	e8 68 a8 ff ff       	call   80100370 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
80105b08:	83 ec 0c             	sub    $0xc,%esp
80105b0b:	68 54 8d 10 80       	push   $0x80108d54
80105b10:	e8 5b a8 ff ff       	call   80100370 <panic>
80105b15:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105b20 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80105b20:	55                   	push   %ebp
80105b21:	89 e5                	mov    %esp,%ebp
80105b23:	56                   	push   %esi
80105b24:	53                   	push   %ebx
80105b25:	89 c6                	mov    %eax,%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105b27:	8d 45 f4             	lea    -0xc(%ebp),%eax
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80105b2a:	89 d3                	mov    %edx,%ebx
80105b2c:	83 ec 18             	sub    $0x18,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105b2f:	50                   	push   %eax
80105b30:	6a 00                	push   $0x0
80105b32:	e8 89 f4 ff ff       	call   80104fc0 <argint>
80105b37:	83 c4 10             	add    $0x10,%esp
80105b3a:	85 c0                	test   %eax,%eax
80105b3c:	78 32                	js     80105b70 <argfd.constprop.0+0x50>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80105b3e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105b42:	77 2c                	ja     80105b70 <argfd.constprop.0+0x50>
80105b44:	e8 07 de ff ff       	call   80103950 <myproc>
80105b49:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105b4c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105b50:	85 c0                	test   %eax,%eax
80105b52:	74 1c                	je     80105b70 <argfd.constprop.0+0x50>
    return -1;
  if(pfd)
80105b54:	85 f6                	test   %esi,%esi
80105b56:	74 02                	je     80105b5a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105b58:	89 16                	mov    %edx,(%esi)
  if(pf)
80105b5a:	85 db                	test   %ebx,%ebx
80105b5c:	74 22                	je     80105b80 <argfd.constprop.0+0x60>
    *pf = f;
80105b5e:	89 03                	mov    %eax,(%ebx)
  return 0;
80105b60:	31 c0                	xor    %eax,%eax
}
80105b62:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105b65:	5b                   	pop    %ebx
80105b66:	5e                   	pop    %esi
80105b67:	5d                   	pop    %ebp
80105b68:	c3                   	ret    
80105b69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b70:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
80105b73:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
}
80105b78:	5b                   	pop    %ebx
80105b79:	5e                   	pop    %esi
80105b7a:	5d                   	pop    %ebp
80105b7b:	c3                   	ret    
80105b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
80105b80:	31 c0                	xor    %eax,%eax
80105b82:	eb de                	jmp    80105b62 <argfd.constprop.0+0x42>
80105b84:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105b8a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105b90 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80105b90:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105b91:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
80105b93:	89 e5                	mov    %esp,%ebp
80105b95:	56                   	push   %esi
80105b96:	53                   	push   %ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105b97:	8d 55 f4             	lea    -0xc(%ebp),%edx
  return -1;
}

int
sys_dup(void)
{
80105b9a:	83 ec 10             	sub    $0x10,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105b9d:	e8 7e ff ff ff       	call   80105b20 <argfd.constprop.0>
80105ba2:	85 c0                	test   %eax,%eax
80105ba4:	78 1a                	js     80105bc0 <sys_dup+0x30>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105ba6:	31 db                	xor    %ebx,%ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
80105ba8:	8b 75 f4             	mov    -0xc(%ebp),%esi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105bab:	e8 a0 dd ff ff       	call   80103950 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80105bb0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105bb4:	85 d2                	test   %edx,%edx
80105bb6:	74 18                	je     80105bd0 <sys_dup+0x40>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105bb8:	83 c3 01             	add    $0x1,%ebx
80105bbb:	83 fb 10             	cmp    $0x10,%ebx
80105bbe:	75 f0                	jne    80105bb0 <sys_dup+0x20>
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80105bc0:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
80105bc3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80105bc8:	5b                   	pop    %ebx
80105bc9:	5e                   	pop    %esi
80105bca:	5d                   	pop    %ebp
80105bcb:	c3                   	ret    
80105bcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105bd0:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
80105bd4:	83 ec 0c             	sub    $0xc,%esp
80105bd7:	ff 75 f4             	pushl  -0xc(%ebp)
80105bda:	e8 a1 b3 ff ff       	call   80100f80 <filedup>
  return fd;
80105bdf:	83 c4 10             	add    $0x10,%esp
}
80105be2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
80105be5:	89 d8                	mov    %ebx,%eax
}
80105be7:	5b                   	pop    %ebx
80105be8:	5e                   	pop    %esi
80105be9:	5d                   	pop    %ebp
80105bea:	c3                   	ret    
80105beb:	90                   	nop
80105bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105bf0 <sys_read>:

int
sys_read(void)
{
80105bf0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105bf1:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
80105bf3:	89 e5                	mov    %esp,%ebp
80105bf5:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105bf8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80105bfb:	e8 20 ff ff ff       	call   80105b20 <argfd.constprop.0>
80105c00:	85 c0                	test   %eax,%eax
80105c02:	78 4c                	js     80105c50 <sys_read+0x60>
80105c04:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c07:	83 ec 08             	sub    $0x8,%esp
80105c0a:	50                   	push   %eax
80105c0b:	6a 02                	push   $0x2
80105c0d:	e8 ae f3 ff ff       	call   80104fc0 <argint>
80105c12:	83 c4 10             	add    $0x10,%esp
80105c15:	85 c0                	test   %eax,%eax
80105c17:	78 37                	js     80105c50 <sys_read+0x60>
80105c19:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c1c:	83 ec 04             	sub    $0x4,%esp
80105c1f:	ff 75 f0             	pushl  -0x10(%ebp)
80105c22:	50                   	push   %eax
80105c23:	6a 01                	push   $0x1
80105c25:	e8 e6 f3 ff ff       	call   80105010 <argptr>
80105c2a:	83 c4 10             	add    $0x10,%esp
80105c2d:	85 c0                	test   %eax,%eax
80105c2f:	78 1f                	js     80105c50 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80105c31:	83 ec 04             	sub    $0x4,%esp
80105c34:	ff 75 f0             	pushl  -0x10(%ebp)
80105c37:	ff 75 f4             	pushl  -0xc(%ebp)
80105c3a:	ff 75 ec             	pushl  -0x14(%ebp)
80105c3d:	e8 ae b4 ff ff       	call   801010f0 <fileread>
80105c42:	83 c4 10             	add    $0x10,%esp
}
80105c45:	c9                   	leave  
80105c46:	c3                   	ret    
80105c47:	89 f6                	mov    %esi,%esi
80105c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80105c50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fileread(f, p, n);
}
80105c55:	c9                   	leave  
80105c56:	c3                   	ret    
80105c57:	89 f6                	mov    %esi,%esi
80105c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105c60 <sys_write>:

int
sys_write(void)
{
80105c60:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105c61:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
80105c63:	89 e5                	mov    %esp,%ebp
80105c65:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105c68:	8d 55 ec             	lea    -0x14(%ebp),%edx
80105c6b:	e8 b0 fe ff ff       	call   80105b20 <argfd.constprop.0>
80105c70:	85 c0                	test   %eax,%eax
80105c72:	78 4c                	js     80105cc0 <sys_write+0x60>
80105c74:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c77:	83 ec 08             	sub    $0x8,%esp
80105c7a:	50                   	push   %eax
80105c7b:	6a 02                	push   $0x2
80105c7d:	e8 3e f3 ff ff       	call   80104fc0 <argint>
80105c82:	83 c4 10             	add    $0x10,%esp
80105c85:	85 c0                	test   %eax,%eax
80105c87:	78 37                	js     80105cc0 <sys_write+0x60>
80105c89:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c8c:	83 ec 04             	sub    $0x4,%esp
80105c8f:	ff 75 f0             	pushl  -0x10(%ebp)
80105c92:	50                   	push   %eax
80105c93:	6a 01                	push   $0x1
80105c95:	e8 76 f3 ff ff       	call   80105010 <argptr>
80105c9a:	83 c4 10             	add    $0x10,%esp
80105c9d:	85 c0                	test   %eax,%eax
80105c9f:	78 1f                	js     80105cc0 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
80105ca1:	83 ec 04             	sub    $0x4,%esp
80105ca4:	ff 75 f0             	pushl  -0x10(%ebp)
80105ca7:	ff 75 f4             	pushl  -0xc(%ebp)
80105caa:	ff 75 ec             	pushl  -0x14(%ebp)
80105cad:	e8 ce b4 ff ff       	call   80101180 <filewrite>
80105cb2:	83 c4 10             	add    $0x10,%esp
}
80105cb5:	c9                   	leave  
80105cb6:	c3                   	ret    
80105cb7:	89 f6                	mov    %esi,%esi
80105cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80105cc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filewrite(f, p, n);
}
80105cc5:	c9                   	leave  
80105cc6:	c3                   	ret    
80105cc7:	89 f6                	mov    %esi,%esi
80105cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105cd0 <sys_close>:

int
sys_close(void)
{
80105cd0:	55                   	push   %ebp
80105cd1:	89 e5                	mov    %esp,%ebp
80105cd3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80105cd6:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105cd9:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105cdc:	e8 3f fe ff ff       	call   80105b20 <argfd.constprop.0>
80105ce1:	85 c0                	test   %eax,%eax
80105ce3:	78 2b                	js     80105d10 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
80105ce5:	e8 66 dc ff ff       	call   80103950 <myproc>
80105cea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80105ced:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
  myproc()->ofile[fd] = 0;
80105cf0:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105cf7:	00 
  fileclose(f);
80105cf8:	ff 75 f4             	pushl  -0xc(%ebp)
80105cfb:	e8 d0 b2 ff ff       	call   80100fd0 <fileclose>
  return 0;
80105d00:	83 c4 10             	add    $0x10,%esp
80105d03:	31 c0                	xor    %eax,%eax
}
80105d05:	c9                   	leave  
80105d06:	c3                   	ret    
80105d07:	89 f6                	mov    %esi,%esi
80105d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
80105d10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  myproc()->ofile[fd] = 0;
  fileclose(f);
  return 0;
}
80105d15:	c9                   	leave  
80105d16:	c3                   	ret    
80105d17:	89 f6                	mov    %esi,%esi
80105d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105d20 <sys_fstat>:

int
sys_fstat(void)
{
80105d20:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105d21:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
80105d23:	89 e5                	mov    %esp,%ebp
80105d25:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105d28:	8d 55 f0             	lea    -0x10(%ebp),%edx
80105d2b:	e8 f0 fd ff ff       	call   80105b20 <argfd.constprop.0>
80105d30:	85 c0                	test   %eax,%eax
80105d32:	78 2c                	js     80105d60 <sys_fstat+0x40>
80105d34:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d37:	83 ec 04             	sub    $0x4,%esp
80105d3a:	6a 14                	push   $0x14
80105d3c:	50                   	push   %eax
80105d3d:	6a 01                	push   $0x1
80105d3f:	e8 cc f2 ff ff       	call   80105010 <argptr>
80105d44:	83 c4 10             	add    $0x10,%esp
80105d47:	85 c0                	test   %eax,%eax
80105d49:	78 15                	js     80105d60 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
80105d4b:	83 ec 08             	sub    $0x8,%esp
80105d4e:	ff 75 f4             	pushl  -0xc(%ebp)
80105d51:	ff 75 f0             	pushl  -0x10(%ebp)
80105d54:	e8 47 b3 ff ff       	call   801010a0 <filestat>
80105d59:	83 c4 10             	add    $0x10,%esp
}
80105d5c:	c9                   	leave  
80105d5d:	c3                   	ret    
80105d5e:	66 90                	xchg   %ax,%ax
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
80105d60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filestat(f, st);
}
80105d65:	c9                   	leave  
80105d66:	c3                   	ret    
80105d67:	89 f6                	mov    %esi,%esi
80105d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105d70 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105d70:	55                   	push   %ebp
80105d71:	89 e5                	mov    %esp,%ebp
80105d73:	57                   	push   %edi
80105d74:	56                   	push   %esi
80105d75:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105d76:	8d 45 d4             	lea    -0x2c(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105d79:	83 ec 34             	sub    $0x34,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105d7c:	50                   	push   %eax
80105d7d:	6a 00                	push   $0x0
80105d7f:	e8 ec f2 ff ff       	call   80105070 <argstr>
80105d84:	83 c4 10             	add    $0x10,%esp
80105d87:	85 c0                	test   %eax,%eax
80105d89:	0f 88 fb 00 00 00    	js     80105e8a <sys_link+0x11a>
80105d8f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105d92:	83 ec 08             	sub    $0x8,%esp
80105d95:	50                   	push   %eax
80105d96:	6a 01                	push   $0x1
80105d98:	e8 d3 f2 ff ff       	call   80105070 <argstr>
80105d9d:	83 c4 10             	add    $0x10,%esp
80105da0:	85 c0                	test   %eax,%eax
80105da2:	0f 88 e2 00 00 00    	js     80105e8a <sys_link+0x11a>
    return -1;

  begin_op();
80105da8:	e8 43 cf ff ff       	call   80102cf0 <begin_op>
  if((ip = namei(old)) == 0){
80105dad:	83 ec 0c             	sub    $0xc,%esp
80105db0:	ff 75 d4             	pushl  -0x2c(%ebp)
80105db3:	e8 a8 c2 ff ff       	call   80102060 <namei>
80105db8:	83 c4 10             	add    $0x10,%esp
80105dbb:	85 c0                	test   %eax,%eax
80105dbd:	89 c3                	mov    %eax,%ebx
80105dbf:	0f 84 f3 00 00 00    	je     80105eb8 <sys_link+0x148>
    end_op();
    return -1;
  }

  ilock(ip);
80105dc5:	83 ec 0c             	sub    $0xc,%esp
80105dc8:	50                   	push   %eax
80105dc9:	e8 42 ba ff ff       	call   80101810 <ilock>
  if(ip->type == T_DIR){
80105dce:	83 c4 10             	add    $0x10,%esp
80105dd1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105dd6:	0f 84 c4 00 00 00    	je     80105ea0 <sys_link+0x130>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
80105ddc:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105de1:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80105de4:	8d 7d da             	lea    -0x26(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80105de7:	53                   	push   %ebx
80105de8:	e8 73 b9 ff ff       	call   80101760 <iupdate>
  iunlock(ip);
80105ded:	89 1c 24             	mov    %ebx,(%esp)
80105df0:	e8 fb ba ff ff       	call   801018f0 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80105df5:	58                   	pop    %eax
80105df6:	5a                   	pop    %edx
80105df7:	57                   	push   %edi
80105df8:	ff 75 d0             	pushl  -0x30(%ebp)
80105dfb:	e8 80 c2 ff ff       	call   80102080 <nameiparent>
80105e00:	83 c4 10             	add    $0x10,%esp
80105e03:	85 c0                	test   %eax,%eax
80105e05:	89 c6                	mov    %eax,%esi
80105e07:	74 5b                	je     80105e64 <sys_link+0xf4>
    goto bad;
  ilock(dp);
80105e09:	83 ec 0c             	sub    $0xc,%esp
80105e0c:	50                   	push   %eax
80105e0d:	e8 fe b9 ff ff       	call   80101810 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105e12:	83 c4 10             	add    $0x10,%esp
80105e15:	8b 03                	mov    (%ebx),%eax
80105e17:	39 06                	cmp    %eax,(%esi)
80105e19:	75 3d                	jne    80105e58 <sys_link+0xe8>
80105e1b:	83 ec 04             	sub    $0x4,%esp
80105e1e:	ff 73 04             	pushl  0x4(%ebx)
80105e21:	57                   	push   %edi
80105e22:	56                   	push   %esi
80105e23:	e8 78 c1 ff ff       	call   80101fa0 <dirlink>
80105e28:	83 c4 10             	add    $0x10,%esp
80105e2b:	85 c0                	test   %eax,%eax
80105e2d:	78 29                	js     80105e58 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
80105e2f:	83 ec 0c             	sub    $0xc,%esp
80105e32:	56                   	push   %esi
80105e33:	e8 68 bc ff ff       	call   80101aa0 <iunlockput>
  iput(ip);
80105e38:	89 1c 24             	mov    %ebx,(%esp)
80105e3b:	e8 00 bb ff ff       	call   80101940 <iput>

  end_op();
80105e40:	e8 1b cf ff ff       	call   80102d60 <end_op>

  return 0;
80105e45:	83 c4 10             	add    $0x10,%esp
80105e48:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80105e4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e4d:	5b                   	pop    %ebx
80105e4e:	5e                   	pop    %esi
80105e4f:	5f                   	pop    %edi
80105e50:	5d                   	pop    %ebp
80105e51:	c3                   	ret    
80105e52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
80105e58:	83 ec 0c             	sub    $0xc,%esp
80105e5b:	56                   	push   %esi
80105e5c:	e8 3f bc ff ff       	call   80101aa0 <iunlockput>
    goto bad;
80105e61:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  ilock(ip);
80105e64:	83 ec 0c             	sub    $0xc,%esp
80105e67:	53                   	push   %ebx
80105e68:	e8 a3 b9 ff ff       	call   80101810 <ilock>
  ip->nlink--;
80105e6d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105e72:	89 1c 24             	mov    %ebx,(%esp)
80105e75:	e8 e6 b8 ff ff       	call   80101760 <iupdate>
  iunlockput(ip);
80105e7a:	89 1c 24             	mov    %ebx,(%esp)
80105e7d:	e8 1e bc ff ff       	call   80101aa0 <iunlockput>
  end_op();
80105e82:	e8 d9 ce ff ff       	call   80102d60 <end_op>
  return -1;
80105e87:	83 c4 10             	add    $0x10,%esp
}
80105e8a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
80105e8d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e92:	5b                   	pop    %ebx
80105e93:	5e                   	pop    %esi
80105e94:	5f                   	pop    %edi
80105e95:	5d                   	pop    %ebp
80105e96:	c3                   	ret    
80105e97:	89 f6                	mov    %esi,%esi
80105e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
  }

  ilock(ip);
  if(ip->type == T_DIR){
    iunlockput(ip);
80105ea0:	83 ec 0c             	sub    $0xc,%esp
80105ea3:	53                   	push   %ebx
80105ea4:	e8 f7 bb ff ff       	call   80101aa0 <iunlockput>
    end_op();
80105ea9:	e8 b2 ce ff ff       	call   80102d60 <end_op>
    return -1;
80105eae:	83 c4 10             	add    $0x10,%esp
80105eb1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105eb6:	eb 92                	jmp    80105e4a <sys_link+0xda>
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
    return -1;

  begin_op();
  if((ip = namei(old)) == 0){
    end_op();
80105eb8:	e8 a3 ce ff ff       	call   80102d60 <end_op>
    return -1;
80105ebd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ec2:	eb 86                	jmp    80105e4a <sys_link+0xda>
80105ec4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105eca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105ed0 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
80105ed0:	55                   	push   %ebp
80105ed1:	89 e5                	mov    %esp,%ebp
80105ed3:	57                   	push   %edi
80105ed4:	56                   	push   %esi
80105ed5:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105ed6:	8d 45 c0             	lea    -0x40(%ebp),%eax
}

//PAGEBREAK!
int
sys_unlink(void)
{
80105ed9:	83 ec 54             	sub    $0x54,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105edc:	50                   	push   %eax
80105edd:	6a 00                	push   $0x0
80105edf:	e8 8c f1 ff ff       	call   80105070 <argstr>
80105ee4:	83 c4 10             	add    $0x10,%esp
80105ee7:	85 c0                	test   %eax,%eax
80105ee9:	0f 88 82 01 00 00    	js     80106071 <sys_unlink+0x1a1>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
80105eef:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  uint off;

  if(argstr(0, &path) < 0)
    return -1;

  begin_op();
80105ef2:	e8 f9 cd ff ff       	call   80102cf0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105ef7:	83 ec 08             	sub    $0x8,%esp
80105efa:	53                   	push   %ebx
80105efb:	ff 75 c0             	pushl  -0x40(%ebp)
80105efe:	e8 7d c1 ff ff       	call   80102080 <nameiparent>
80105f03:	83 c4 10             	add    $0x10,%esp
80105f06:	85 c0                	test   %eax,%eax
80105f08:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105f0b:	0f 84 6a 01 00 00    	je     8010607b <sys_unlink+0x1ab>
    end_op();
    return -1;
  }

  ilock(dp);
80105f11:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80105f14:	83 ec 0c             	sub    $0xc,%esp
80105f17:	56                   	push   %esi
80105f18:	e8 f3 b8 ff ff       	call   80101810 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105f1d:	58                   	pop    %eax
80105f1e:	5a                   	pop    %edx
80105f1f:	68 70 8d 10 80       	push   $0x80108d70
80105f24:	53                   	push   %ebx
80105f25:	e8 f6 bd ff ff       	call   80101d20 <namecmp>
80105f2a:	83 c4 10             	add    $0x10,%esp
80105f2d:	85 c0                	test   %eax,%eax
80105f2f:	0f 84 fc 00 00 00    	je     80106031 <sys_unlink+0x161>
80105f35:	83 ec 08             	sub    $0x8,%esp
80105f38:	68 6f 8d 10 80       	push   $0x80108d6f
80105f3d:	53                   	push   %ebx
80105f3e:	e8 dd bd ff ff       	call   80101d20 <namecmp>
80105f43:	83 c4 10             	add    $0x10,%esp
80105f46:	85 c0                	test   %eax,%eax
80105f48:	0f 84 e3 00 00 00    	je     80106031 <sys_unlink+0x161>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105f4e:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105f51:	83 ec 04             	sub    $0x4,%esp
80105f54:	50                   	push   %eax
80105f55:	53                   	push   %ebx
80105f56:	56                   	push   %esi
80105f57:	e8 e4 bd ff ff       	call   80101d40 <dirlookup>
80105f5c:	83 c4 10             	add    $0x10,%esp
80105f5f:	85 c0                	test   %eax,%eax
80105f61:	89 c3                	mov    %eax,%ebx
80105f63:	0f 84 c8 00 00 00    	je     80106031 <sys_unlink+0x161>
    goto bad;
  ilock(ip);
80105f69:	83 ec 0c             	sub    $0xc,%esp
80105f6c:	50                   	push   %eax
80105f6d:	e8 9e b8 ff ff       	call   80101810 <ilock>

  if(ip->nlink < 1)
80105f72:	83 c4 10             	add    $0x10,%esp
80105f75:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105f7a:	0f 8e 24 01 00 00    	jle    801060a4 <sys_unlink+0x1d4>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80105f80:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105f85:	8d 75 d8             	lea    -0x28(%ebp),%esi
80105f88:	74 66                	je     80105ff0 <sys_unlink+0x120>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80105f8a:	83 ec 04             	sub    $0x4,%esp
80105f8d:	6a 10                	push   $0x10
80105f8f:	6a 00                	push   $0x0
80105f91:	56                   	push   %esi
80105f92:	e8 19 ed ff ff       	call   80104cb0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105f97:	6a 10                	push   $0x10
80105f99:	ff 75 c4             	pushl  -0x3c(%ebp)
80105f9c:	56                   	push   %esi
80105f9d:	ff 75 b4             	pushl  -0x4c(%ebp)
80105fa0:	e8 4b bc ff ff       	call   80101bf0 <writei>
80105fa5:	83 c4 20             	add    $0x20,%esp
80105fa8:	83 f8 10             	cmp    $0x10,%eax
80105fab:	0f 85 e6 00 00 00    	jne    80106097 <sys_unlink+0x1c7>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80105fb1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105fb6:	0f 84 9c 00 00 00    	je     80106058 <sys_unlink+0x188>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80105fbc:	83 ec 0c             	sub    $0xc,%esp
80105fbf:	ff 75 b4             	pushl  -0x4c(%ebp)
80105fc2:	e8 d9 ba ff ff       	call   80101aa0 <iunlockput>

  ip->nlink--;
80105fc7:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105fcc:	89 1c 24             	mov    %ebx,(%esp)
80105fcf:	e8 8c b7 ff ff       	call   80101760 <iupdate>
  iunlockput(ip);
80105fd4:	89 1c 24             	mov    %ebx,(%esp)
80105fd7:	e8 c4 ba ff ff       	call   80101aa0 <iunlockput>

  end_op();
80105fdc:	e8 7f cd ff ff       	call   80102d60 <end_op>

  return 0;
80105fe1:	83 c4 10             	add    $0x10,%esp
80105fe4:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80105fe6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105fe9:	5b                   	pop    %ebx
80105fea:	5e                   	pop    %esi
80105feb:	5f                   	pop    %edi
80105fec:	5d                   	pop    %ebp
80105fed:	c3                   	ret    
80105fee:	66 90                	xchg   %ax,%ax
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105ff0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105ff4:	76 94                	jbe    80105f8a <sys_unlink+0xba>
80105ff6:	bf 20 00 00 00       	mov    $0x20,%edi
80105ffb:	eb 0f                	jmp    8010600c <sys_unlink+0x13c>
80105ffd:	8d 76 00             	lea    0x0(%esi),%esi
80106000:	83 c7 10             	add    $0x10,%edi
80106003:	3b 7b 58             	cmp    0x58(%ebx),%edi
80106006:	0f 83 7e ff ff ff    	jae    80105f8a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010600c:	6a 10                	push   $0x10
8010600e:	57                   	push   %edi
8010600f:	56                   	push   %esi
80106010:	53                   	push   %ebx
80106011:	e8 da ba ff ff       	call   80101af0 <readi>
80106016:	83 c4 10             	add    $0x10,%esp
80106019:	83 f8 10             	cmp    $0x10,%eax
8010601c:	75 6c                	jne    8010608a <sys_unlink+0x1ba>
      panic("isdirempty: readi");
    if(de.inum != 0)
8010601e:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80106023:	74 db                	je     80106000 <sys_unlink+0x130>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
80106025:	83 ec 0c             	sub    $0xc,%esp
80106028:	53                   	push   %ebx
80106029:	e8 72 ba ff ff       	call   80101aa0 <iunlockput>
    goto bad;
8010602e:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  iunlockput(dp);
80106031:	83 ec 0c             	sub    $0xc,%esp
80106034:	ff 75 b4             	pushl  -0x4c(%ebp)
80106037:	e8 64 ba ff ff       	call   80101aa0 <iunlockput>
  end_op();
8010603c:	e8 1f cd ff ff       	call   80102d60 <end_op>
  return -1;
80106041:	83 c4 10             	add    $0x10,%esp
}
80106044:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
80106047:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010604c:	5b                   	pop    %ebx
8010604d:	5e                   	pop    %esi
8010604e:	5f                   	pop    %edi
8010604f:	5d                   	pop    %ebp
80106050:	c3                   	ret    
80106051:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80106058:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
8010605b:	83 ec 0c             	sub    $0xc,%esp

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
8010605e:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80106063:	50                   	push   %eax
80106064:	e8 f7 b6 ff ff       	call   80101760 <iupdate>
80106069:	83 c4 10             	add    $0x10,%esp
8010606c:	e9 4b ff ff ff       	jmp    80105fbc <sys_unlink+0xec>
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
80106071:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106076:	e9 6b ff ff ff       	jmp    80105fe6 <sys_unlink+0x116>

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
    end_op();
8010607b:	e8 e0 cc ff ff       	call   80102d60 <end_op>
    return -1;
80106080:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106085:	e9 5c ff ff ff       	jmp    80105fe6 <sys_unlink+0x116>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
8010608a:	83 ec 0c             	sub    $0xc,%esp
8010608d:	68 94 8d 10 80       	push   $0x80108d94
80106092:	e8 d9 a2 ff ff       	call   80100370 <panic>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
80106097:	83 ec 0c             	sub    $0xc,%esp
8010609a:	68 a6 8d 10 80       	push   $0x80108da6
8010609f:	e8 cc a2 ff ff       	call   80100370 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
801060a4:	83 ec 0c             	sub    $0xc,%esp
801060a7:	68 82 8d 10 80       	push   $0x80108d82
801060ac:	e8 bf a2 ff ff       	call   80100370 <panic>
801060b1:	eb 0d                	jmp    801060c0 <sys_open>
801060b3:	90                   	nop
801060b4:	90                   	nop
801060b5:	90                   	nop
801060b6:	90                   	nop
801060b7:	90                   	nop
801060b8:	90                   	nop
801060b9:	90                   	nop
801060ba:	90                   	nop
801060bb:	90                   	nop
801060bc:	90                   	nop
801060bd:	90                   	nop
801060be:	90                   	nop
801060bf:	90                   	nop

801060c0 <sys_open>:
  return ip;
}

int
sys_open(void)
{
801060c0:	55                   	push   %ebp
801060c1:	89 e5                	mov    %esp,%ebp
801060c3:	57                   	push   %edi
801060c4:	56                   	push   %esi
801060c5:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801060c6:	8d 45 e0             	lea    -0x20(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
801060c9:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801060cc:	50                   	push   %eax
801060cd:	6a 00                	push   $0x0
801060cf:	e8 9c ef ff ff       	call   80105070 <argstr>
801060d4:	83 c4 10             	add    $0x10,%esp
801060d7:	85 c0                	test   %eax,%eax
801060d9:	0f 88 9e 00 00 00    	js     8010617d <sys_open+0xbd>
801060df:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801060e2:	83 ec 08             	sub    $0x8,%esp
801060e5:	50                   	push   %eax
801060e6:	6a 01                	push   $0x1
801060e8:	e8 d3 ee ff ff       	call   80104fc0 <argint>
801060ed:	83 c4 10             	add    $0x10,%esp
801060f0:	85 c0                	test   %eax,%eax
801060f2:	0f 88 85 00 00 00    	js     8010617d <sys_open+0xbd>
    return -1;

  begin_op();
801060f8:	e8 f3 cb ff ff       	call   80102cf0 <begin_op>

  if(omode & O_CREATE){
801060fd:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80106101:	0f 85 89 00 00 00    	jne    80106190 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80106107:	83 ec 0c             	sub    $0xc,%esp
8010610a:	ff 75 e0             	pushl  -0x20(%ebp)
8010610d:	e8 4e bf ff ff       	call   80102060 <namei>
80106112:	83 c4 10             	add    $0x10,%esp
80106115:	85 c0                	test   %eax,%eax
80106117:	89 c6                	mov    %eax,%esi
80106119:	0f 84 8e 00 00 00    	je     801061ad <sys_open+0xed>
      end_op();
      return -1;
    }
    ilock(ip);
8010611f:	83 ec 0c             	sub    $0xc,%esp
80106122:	50                   	push   %eax
80106123:	e8 e8 b6 ff ff       	call   80101810 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80106128:	83 c4 10             	add    $0x10,%esp
8010612b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80106130:	0f 84 d2 00 00 00    	je     80106208 <sys_open+0x148>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80106136:	e8 d5 ad ff ff       	call   80100f10 <filealloc>
8010613b:	85 c0                	test   %eax,%eax
8010613d:	89 c7                	mov    %eax,%edi
8010613f:	74 2b                	je     8010616c <sys_open+0xac>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80106141:	31 db                	xor    %ebx,%ebx
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80106143:	e8 08 d8 ff ff       	call   80103950 <myproc>
80106148:	90                   	nop
80106149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80106150:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80106154:	85 d2                	test   %edx,%edx
80106156:	74 68                	je     801061c0 <sys_open+0x100>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80106158:	83 c3 01             	add    $0x1,%ebx
8010615b:	83 fb 10             	cmp    $0x10,%ebx
8010615e:	75 f0                	jne    80106150 <sys_open+0x90>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
80106160:	83 ec 0c             	sub    $0xc,%esp
80106163:	57                   	push   %edi
80106164:	e8 67 ae ff ff       	call   80100fd0 <fileclose>
80106169:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010616c:	83 ec 0c             	sub    $0xc,%esp
8010616f:	56                   	push   %esi
80106170:	e8 2b b9 ff ff       	call   80101aa0 <iunlockput>
    end_op();
80106175:	e8 e6 cb ff ff       	call   80102d60 <end_op>
    return -1;
8010617a:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
8010617d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
80106180:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
80106185:	5b                   	pop    %ebx
80106186:	5e                   	pop    %esi
80106187:	5f                   	pop    %edi
80106188:	5d                   	pop    %ebp
80106189:	c3                   	ret    
8010618a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80106190:	83 ec 0c             	sub    $0xc,%esp
80106193:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106196:	31 c9                	xor    %ecx,%ecx
80106198:	6a 00                	push   $0x0
8010619a:	ba 02 00 00 00       	mov    $0x2,%edx
8010619f:	e8 dc f7 ff ff       	call   80105980 <create>
    if(ip == 0){
801061a4:	83 c4 10             	add    $0x10,%esp
801061a7:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
801061a9:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801061ab:	75 89                	jne    80106136 <sys_open+0x76>
      end_op();
801061ad:	e8 ae cb ff ff       	call   80102d60 <end_op>
      return -1;
801061b2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061b7:	eb 43                	jmp    801061fc <sys_open+0x13c>
801061b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801061c0:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
801061c3:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801061c7:	56                   	push   %esi
801061c8:	e8 23 b7 ff ff       	call   801018f0 <iunlock>
  end_op();
801061cd:	e8 8e cb ff ff       	call   80102d60 <end_op>

  f->type = FD_INODE;
801061d2:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801061d8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801061db:	83 c4 10             	add    $0x10,%esp
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
801061de:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
801061e1:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801061e8:	89 d0                	mov    %edx,%eax
801061ea:	83 e0 01             	and    $0x1,%eax
801061ed:	83 f0 01             	xor    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801061f0:	83 e2 03             	and    $0x3,%edx
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801061f3:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801061f6:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
801061fa:	89 d8                	mov    %ebx,%eax
}
801061fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801061ff:	5b                   	pop    %ebx
80106200:	5e                   	pop    %esi
80106201:	5f                   	pop    %edi
80106202:	5d                   	pop    %ebp
80106203:	c3                   	ret    
80106204:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
80106208:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010620b:	85 c9                	test   %ecx,%ecx
8010620d:	0f 84 23 ff ff ff    	je     80106136 <sys_open+0x76>
80106213:	e9 54 ff ff ff       	jmp    8010616c <sys_open+0xac>
80106218:	90                   	nop
80106219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106220 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
80106220:	55                   	push   %ebp
80106221:	89 e5                	mov    %esp,%ebp
80106223:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106226:	e8 c5 ca ff ff       	call   80102cf0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010622b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010622e:	83 ec 08             	sub    $0x8,%esp
80106231:	50                   	push   %eax
80106232:	6a 00                	push   $0x0
80106234:	e8 37 ee ff ff       	call   80105070 <argstr>
80106239:	83 c4 10             	add    $0x10,%esp
8010623c:	85 c0                	test   %eax,%eax
8010623e:	78 30                	js     80106270 <sys_mkdir+0x50>
80106240:	83 ec 0c             	sub    $0xc,%esp
80106243:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106246:	31 c9                	xor    %ecx,%ecx
80106248:	6a 00                	push   $0x0
8010624a:	ba 01 00 00 00       	mov    $0x1,%edx
8010624f:	e8 2c f7 ff ff       	call   80105980 <create>
80106254:	83 c4 10             	add    $0x10,%esp
80106257:	85 c0                	test   %eax,%eax
80106259:	74 15                	je     80106270 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010625b:	83 ec 0c             	sub    $0xc,%esp
8010625e:	50                   	push   %eax
8010625f:	e8 3c b8 ff ff       	call   80101aa0 <iunlockput>
  end_op();
80106264:	e8 f7 ca ff ff       	call   80102d60 <end_op>
  return 0;
80106269:	83 c4 10             	add    $0x10,%esp
8010626c:	31 c0                	xor    %eax,%eax
}
8010626e:	c9                   	leave  
8010626f:	c3                   	ret    
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
80106270:	e8 eb ca ff ff       	call   80102d60 <end_op>
    return -1;
80106275:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010627a:	c9                   	leave  
8010627b:	c3                   	ret    
8010627c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106280 <sys_mknod>:

int
sys_mknod(void)
{
80106280:	55                   	push   %ebp
80106281:	89 e5                	mov    %esp,%ebp
80106283:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80106286:	e8 65 ca ff ff       	call   80102cf0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010628b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010628e:	83 ec 08             	sub    $0x8,%esp
80106291:	50                   	push   %eax
80106292:	6a 00                	push   $0x0
80106294:	e8 d7 ed ff ff       	call   80105070 <argstr>
80106299:	83 c4 10             	add    $0x10,%esp
8010629c:	85 c0                	test   %eax,%eax
8010629e:	78 60                	js     80106300 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801062a0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801062a3:	83 ec 08             	sub    $0x8,%esp
801062a6:	50                   	push   %eax
801062a7:	6a 01                	push   $0x1
801062a9:	e8 12 ed ff ff       	call   80104fc0 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
801062ae:	83 c4 10             	add    $0x10,%esp
801062b1:	85 c0                	test   %eax,%eax
801062b3:	78 4b                	js     80106300 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801062b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801062b8:	83 ec 08             	sub    $0x8,%esp
801062bb:	50                   	push   %eax
801062bc:	6a 02                	push   $0x2
801062be:	e8 fd ec ff ff       	call   80104fc0 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
801062c3:	83 c4 10             	add    $0x10,%esp
801062c6:	85 c0                	test   %eax,%eax
801062c8:	78 36                	js     80106300 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801062ca:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
801062ce:	83 ec 0c             	sub    $0xc,%esp
801062d1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801062d5:	ba 03 00 00 00       	mov    $0x3,%edx
801062da:	50                   	push   %eax
801062db:	8b 45 ec             	mov    -0x14(%ebp),%eax
801062de:	e8 9d f6 ff ff       	call   80105980 <create>
801062e3:	83 c4 10             	add    $0x10,%esp
801062e6:	85 c0                	test   %eax,%eax
801062e8:	74 16                	je     80106300 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
801062ea:	83 ec 0c             	sub    $0xc,%esp
801062ed:	50                   	push   %eax
801062ee:	e8 ad b7 ff ff       	call   80101aa0 <iunlockput>
  end_op();
801062f3:	e8 68 ca ff ff       	call   80102d60 <end_op>
  return 0;
801062f8:	83 c4 10             	add    $0x10,%esp
801062fb:	31 c0                	xor    %eax,%eax
}
801062fd:	c9                   	leave  
801062fe:	c3                   	ret    
801062ff:	90                   	nop
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80106300:	e8 5b ca ff ff       	call   80102d60 <end_op>
    return -1;
80106305:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010630a:	c9                   	leave  
8010630b:	c3                   	ret    
8010630c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106310 <sys_chdir>:

int
sys_chdir(void)
{
80106310:	55                   	push   %ebp
80106311:	89 e5                	mov    %esp,%ebp
80106313:	56                   	push   %esi
80106314:	53                   	push   %ebx
80106315:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80106318:	e8 33 d6 ff ff       	call   80103950 <myproc>
8010631d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010631f:	e8 cc c9 ff ff       	call   80102cf0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80106324:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106327:	83 ec 08             	sub    $0x8,%esp
8010632a:	50                   	push   %eax
8010632b:	6a 00                	push   $0x0
8010632d:	e8 3e ed ff ff       	call   80105070 <argstr>
80106332:	83 c4 10             	add    $0x10,%esp
80106335:	85 c0                	test   %eax,%eax
80106337:	78 77                	js     801063b0 <sys_chdir+0xa0>
80106339:	83 ec 0c             	sub    $0xc,%esp
8010633c:	ff 75 f4             	pushl  -0xc(%ebp)
8010633f:	e8 1c bd ff ff       	call   80102060 <namei>
80106344:	83 c4 10             	add    $0x10,%esp
80106347:	85 c0                	test   %eax,%eax
80106349:	89 c3                	mov    %eax,%ebx
8010634b:	74 63                	je     801063b0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010634d:	83 ec 0c             	sub    $0xc,%esp
80106350:	50                   	push   %eax
80106351:	e8 ba b4 ff ff       	call   80101810 <ilock>
  if(ip->type != T_DIR){
80106356:	83 c4 10             	add    $0x10,%esp
80106359:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010635e:	75 30                	jne    80106390 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80106360:	83 ec 0c             	sub    $0xc,%esp
80106363:	53                   	push   %ebx
80106364:	e8 87 b5 ff ff       	call   801018f0 <iunlock>
  iput(curproc->cwd);
80106369:	58                   	pop    %eax
8010636a:	ff 76 68             	pushl  0x68(%esi)
8010636d:	e8 ce b5 ff ff       	call   80101940 <iput>
  end_op();
80106372:	e8 e9 c9 ff ff       	call   80102d60 <end_op>
  curproc->cwd = ip;
80106377:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010637a:	83 c4 10             	add    $0x10,%esp
8010637d:	31 c0                	xor    %eax,%eax
}
8010637f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106382:	5b                   	pop    %ebx
80106383:	5e                   	pop    %esi
80106384:	5d                   	pop    %ebp
80106385:	c3                   	ret    
80106386:	8d 76 00             	lea    0x0(%esi),%esi
80106389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
80106390:	83 ec 0c             	sub    $0xc,%esp
80106393:	53                   	push   %ebx
80106394:	e8 07 b7 ff ff       	call   80101aa0 <iunlockput>
    end_op();
80106399:	e8 c2 c9 ff ff       	call   80102d60 <end_op>
    return -1;
8010639e:	83 c4 10             	add    $0x10,%esp
801063a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063a6:	eb d7                	jmp    8010637f <sys_chdir+0x6f>
801063a8:	90                   	nop
801063a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct inode *ip;
  struct proc *curproc = myproc();
  
  begin_op();
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
801063b0:	e8 ab c9 ff ff       	call   80102d60 <end_op>
    return -1;
801063b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063ba:	eb c3                	jmp    8010637f <sys_chdir+0x6f>
801063bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801063c0 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
801063c0:	55                   	push   %ebp
801063c1:	89 e5                	mov    %esp,%ebp
801063c3:	57                   	push   %edi
801063c4:	56                   	push   %esi
801063c5:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801063c6:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
801063cc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801063d2:	50                   	push   %eax
801063d3:	6a 00                	push   $0x0
801063d5:	e8 96 ec ff ff       	call   80105070 <argstr>
801063da:	83 c4 10             	add    $0x10,%esp
801063dd:	85 c0                	test   %eax,%eax
801063df:	78 7f                	js     80106460 <sys_exec+0xa0>
801063e1:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801063e7:	83 ec 08             	sub    $0x8,%esp
801063ea:	50                   	push   %eax
801063eb:	6a 01                	push   $0x1
801063ed:	e8 ce eb ff ff       	call   80104fc0 <argint>
801063f2:	83 c4 10             	add    $0x10,%esp
801063f5:	85 c0                	test   %eax,%eax
801063f7:	78 67                	js     80106460 <sys_exec+0xa0>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801063f9:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801063ff:	83 ec 04             	sub    $0x4,%esp
80106402:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
80106408:	68 80 00 00 00       	push   $0x80
8010640d:	6a 00                	push   $0x0
8010640f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80106415:	50                   	push   %eax
80106416:	31 db                	xor    %ebx,%ebx
80106418:	e8 93 e8 ff ff       	call   80104cb0 <memset>
8010641d:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106420:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80106426:	83 ec 08             	sub    $0x8,%esp
80106429:	57                   	push   %edi
8010642a:	8d 04 98             	lea    (%eax,%ebx,4),%eax
8010642d:	50                   	push   %eax
8010642e:	e8 ed ea ff ff       	call   80104f20 <fetchint>
80106433:	83 c4 10             	add    $0x10,%esp
80106436:	85 c0                	test   %eax,%eax
80106438:	78 26                	js     80106460 <sys_exec+0xa0>
      return -1;
    if(uarg == 0){
8010643a:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80106440:	85 c0                	test   %eax,%eax
80106442:	74 2c                	je     80106470 <sys_exec+0xb0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80106444:	83 ec 08             	sub    $0x8,%esp
80106447:	56                   	push   %esi
80106448:	50                   	push   %eax
80106449:	e8 12 eb ff ff       	call   80104f60 <fetchstr>
8010644e:	83 c4 10             	add    $0x10,%esp
80106451:	85 c0                	test   %eax,%eax
80106453:	78 0b                	js     80106460 <sys_exec+0xa0>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80106455:	83 c3 01             	add    $0x1,%ebx
80106458:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
8010645b:	83 fb 20             	cmp    $0x20,%ebx
8010645e:	75 c0                	jne    80106420 <sys_exec+0x60>
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80106460:	8d 65 f4             	lea    -0xc(%ebp),%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
80106463:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80106468:	5b                   	pop    %ebx
80106469:	5e                   	pop    %esi
8010646a:	5f                   	pop    %edi
8010646b:	5d                   	pop    %ebp
8010646c:	c3                   	ret    
8010646d:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80106470:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106476:	83 ec 08             	sub    $0x8,%esp
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
80106479:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80106480:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80106484:	50                   	push   %eax
80106485:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010648b:	e8 00 a7 ff ff       	call   80100b90 <exec>
80106490:	83 c4 10             	add    $0x10,%esp
}
80106493:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106496:	5b                   	pop    %ebx
80106497:	5e                   	pop    %esi
80106498:	5f                   	pop    %edi
80106499:	5d                   	pop    %ebp
8010649a:	c3                   	ret    
8010649b:	90                   	nop
8010649c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801064a0 <sys_pipe>:

int
sys_pipe(void)
{
801064a0:	55                   	push   %ebp
801064a1:	89 e5                	mov    %esp,%ebp
801064a3:	57                   	push   %edi
801064a4:	56                   	push   %esi
801064a5:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801064a6:	8d 45 dc             	lea    -0x24(%ebp),%eax
  return exec(path, argv);
}

int
sys_pipe(void)
{
801064a9:	83 ec 20             	sub    $0x20,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801064ac:	6a 08                	push   $0x8
801064ae:	50                   	push   %eax
801064af:	6a 00                	push   $0x0
801064b1:	e8 5a eb ff ff       	call   80105010 <argptr>
801064b6:	83 c4 10             	add    $0x10,%esp
801064b9:	85 c0                	test   %eax,%eax
801064bb:	78 4a                	js     80106507 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801064bd:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801064c0:	83 ec 08             	sub    $0x8,%esp
801064c3:	50                   	push   %eax
801064c4:	8d 45 e0             	lea    -0x20(%ebp),%eax
801064c7:	50                   	push   %eax
801064c8:	e8 c3 ce ff ff       	call   80103390 <pipealloc>
801064cd:	83 c4 10             	add    $0x10,%esp
801064d0:	85 c0                	test   %eax,%eax
801064d2:	78 33                	js     80106507 <sys_pipe+0x67>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801064d4:	31 db                	xor    %ebx,%ebx
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801064d6:	8b 7d e0             	mov    -0x20(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
801064d9:	e8 72 d4 ff ff       	call   80103950 <myproc>
801064de:	66 90                	xchg   %ax,%ax

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
801064e0:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801064e4:	85 f6                	test   %esi,%esi
801064e6:	74 30                	je     80106518 <sys_pipe+0x78>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801064e8:	83 c3 01             	add    $0x1,%ebx
801064eb:	83 fb 10             	cmp    $0x10,%ebx
801064ee:	75 f0                	jne    801064e0 <sys_pipe+0x40>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
801064f0:	83 ec 0c             	sub    $0xc,%esp
801064f3:	ff 75 e0             	pushl  -0x20(%ebp)
801064f6:	e8 d5 aa ff ff       	call   80100fd0 <fileclose>
    fileclose(wf);
801064fb:	58                   	pop    %eax
801064fc:	ff 75 e4             	pushl  -0x1c(%ebp)
801064ff:	e8 cc aa ff ff       	call   80100fd0 <fileclose>
    return -1;
80106504:	83 c4 10             	add    $0x10,%esp
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
80106507:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
8010650a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
8010650f:	5b                   	pop    %ebx
80106510:	5e                   	pop    %esi
80106511:	5f                   	pop    %edi
80106512:	5d                   	pop    %ebp
80106513:	c3                   	ret    
80106514:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80106518:	8d 73 08             	lea    0x8(%ebx),%esi
8010651b:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010651f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80106522:	e8 29 d4 ff ff       	call   80103950 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
80106527:	31 d2                	xor    %edx,%edx
80106529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80106530:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80106534:	85 c9                	test   %ecx,%ecx
80106536:	74 18                	je     80106550 <sys_pipe+0xb0>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80106538:	83 c2 01             	add    $0x1,%edx
8010653b:	83 fa 10             	cmp    $0x10,%edx
8010653e:	75 f0                	jne    80106530 <sys_pipe+0x90>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80106540:	e8 0b d4 ff ff       	call   80103950 <myproc>
80106545:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
8010654c:	00 
8010654d:	eb a1                	jmp    801064f0 <sys_pipe+0x50>
8010654f:	90                   	nop
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80106550:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80106554:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106557:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80106559:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010655c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
}
8010655f:	8d 65 f4             	lea    -0xc(%ebp),%esp
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
80106562:	31 c0                	xor    %eax,%eax
}
80106564:	5b                   	pop    %ebx
80106565:	5e                   	pop    %esi
80106566:	5f                   	pop    %edi
80106567:	5d                   	pop    %ebp
80106568:	c3                   	ret    
80106569:	66 90                	xchg   %ax,%ax
8010656b:	66 90                	xchg   %ax,%ax
8010656d:	66 90                	xchg   %ax,%ax
8010656f:	90                   	nop

80106570 <sys_fork>:
struct ticket_lock ticketlock;
int safe_count = 0;

int
sys_fork(void)
{
80106570:	55                   	push   %ebp
80106571:	89 e5                	mov    %esp,%ebp
  return fork();
}
80106573:	5d                   	pop    %ebp
int safe_count = 0;

int
sys_fork(void)
{
  return fork();
80106574:	e9 77 d5 ff ff       	jmp    80103af0 <fork>
80106579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106580 <sys_exit>:
}

int
sys_exit(void)
{
80106580:	55                   	push   %ebp
80106581:	89 e5                	mov    %esp,%ebp
80106583:	83 ec 08             	sub    $0x8,%esp
  exit();
80106586:	e8 05 d8 ff ff       	call   80103d90 <exit>
  return 0;  // not reached
}
8010658b:	31 c0                	xor    %eax,%eax
8010658d:	c9                   	leave  
8010658e:	c3                   	ret    
8010658f:	90                   	nop

80106590 <sys_wait>:

int
sys_wait(void)
{
80106590:	55                   	push   %ebp
80106591:	89 e5                	mov    %esp,%ebp
  return wait();
}
80106593:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
80106594:	e9 37 da ff ff       	jmp    80103fd0 <wait>
80106599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801065a0 <sys_kill>:
}

int
sys_kill(void)
{
801065a0:	55                   	push   %ebp
801065a1:	89 e5                	mov    %esp,%ebp
801065a3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801065a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801065a9:	50                   	push   %eax
801065aa:	6a 00                	push   $0x0
801065ac:	e8 0f ea ff ff       	call   80104fc0 <argint>
801065b1:	83 c4 10             	add    $0x10,%esp
801065b4:	85 c0                	test   %eax,%eax
801065b6:	78 18                	js     801065d0 <sys_kill+0x30>
    return -1;
  return kill(pid);
801065b8:	83 ec 0c             	sub    $0xc,%esp
801065bb:	ff 75 f4             	pushl  -0xc(%ebp)
801065be:	e8 4d e0 ff ff       	call   80104610 <kill>
801065c3:	83 c4 10             	add    $0x10,%esp
}
801065c6:	c9                   	leave  
801065c7:	c3                   	ret    
801065c8:	90                   	nop
801065c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
801065d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
801065d5:	c9                   	leave  
801065d6:	c3                   	ret    
801065d7:	89 f6                	mov    %esi,%esi
801065d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801065e0 <sys_inc_num>:

int
sys_inc_num(void)
{
801065e0:	55                   	push   %ebp
801065e1:	89 e5                	mov    %esp,%ebp
801065e3:	83 ec 20             	sub    $0x20,%esp
  int num;
 // register int *num asm ("ebx");
   if(argint(0, &num) < 0)
801065e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801065e9:	50                   	push   %eax
801065ea:	6a 00                	push   $0x0
801065ec:	e8 cf e9 ff ff       	call   80104fc0 <argint>
801065f1:	83 c4 10             	add    $0x10,%esp
801065f4:	85 c0                	test   %eax,%eax
801065f6:	78 20                	js     80106618 <sys_inc_num+0x38>
     return -1;
  cprintf("num : %d\n", num+1);
801065f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065fb:	83 ec 08             	sub    $0x8,%esp
801065fe:	83 c0 01             	add    $0x1,%eax
80106601:	50                   	push   %eax
80106602:	68 b5 8d 10 80       	push   $0x80108db5
80106607:	e8 d4 a0 ff ff       	call   801006e0 <cprintf>
  return 0;
8010660c:	83 c4 10             	add    $0x10,%esp
8010660f:	31 c0                	xor    %eax,%eax
}
80106611:	c9                   	leave  
80106612:	c3                   	ret    
80106613:	90                   	nop
80106614:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
sys_inc_num(void)
{
  int num;
 // register int *num asm ("ebx");
   if(argint(0, &num) < 0)
     return -1;
80106618:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  cprintf("num : %d\n", num+1);
  return 0;
}
8010661d:	c9                   	leave  
8010661e:	c3                   	ret    
8010661f:	90                   	nop

80106620 <sys_sort_syscalls>:
  return -1;
}

int
sys_sort_syscalls(void)
{
80106620:	55                   	push   %ebp
80106621:	89 e5                	mov    %esp,%ebp
80106623:	83 ec 20             	sub    $0x20,%esp
  int pid, i;

  if(argint(0, &pid) < 0)
80106626:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106629:	50                   	push   %eax
8010662a:	6a 00                	push   $0x0
8010662c:	e8 8f e9 ff ff       	call   80104fc0 <argint>
80106631:	83 c4 10             	add    $0x10,%esp
80106634:	85 c0                	test   %eax,%eax
80106636:	78 28                	js     80106660 <sys_sort_syscalls+0x40>
    return -1;
  cprintf("num : %d\n", pid);
80106638:	83 ec 08             	sub    $0x8,%esp
8010663b:	ff 75 f4             	pushl  -0xc(%ebp)
8010663e:	68 b5 8d 10 80       	push   $0x80108db5
80106643:	e8 98 a0 ff ff       	call   801006e0 <cprintf>
  i = invocation_log(pid);
80106648:	58                   	pop    %eax
80106649:	ff 75 f4             	pushl  -0xc(%ebp)
8010664c:	e8 df da ff ff       	call   80104130 <invocation_log>
80106651:	83 c4 10             	add    $0x10,%esp
  if(i >= 0){
80106654:	c1 f8 1f             	sar    $0x1f,%eax
    return 0;
  }
  return -1;
}
80106657:	c9                   	leave  
80106658:	c3                   	ret    
80106659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
sys_sort_syscalls(void)
{
  int pid, i;

  if(argint(0, &pid) < 0)
    return -1;
80106660:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  i = invocation_log(pid);
  if(i >= 0){
    return 0;
  }
  return -1;
}
80106665:	c9                   	leave  
80106666:	c3                   	ret    
80106667:	89 f6                	mov    %esi,%esi
80106669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106670 <sys_invoked_syscalls>:
80106670:	55                   	push   %ebp
80106671:	89 e5                	mov    %esp,%ebp
80106673:	5d                   	pop    %ebp
80106674:	eb aa                	jmp    80106620 <sys_sort_syscalls>
80106676:	8d 76 00             	lea    0x0(%esi),%esi
80106679:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106680 <sys_get_count>:

int
sys_get_count(void)
{
80106680:	55                   	push   %ebp
80106681:	89 e5                	mov    %esp,%ebp
80106683:	53                   	push   %ebx
  int pid, sysnum, result;

  if (argint(0, &pid) < 0 || argint(1, &sysnum) < 0)
80106684:	8d 45 f0             	lea    -0x10(%ebp),%eax
  return -1;
}

int
sys_get_count(void)
{
80106687:	83 ec 1c             	sub    $0x1c,%esp
  int pid, sysnum, result;

  if (argint(0, &pid) < 0 || argint(1, &sysnum) < 0)
8010668a:	50                   	push   %eax
8010668b:	6a 00                	push   $0x0
8010668d:	e8 2e e9 ff ff       	call   80104fc0 <argint>
80106692:	83 c4 10             	add    $0x10,%esp
80106695:	85 c0                	test   %eax,%eax
80106697:	78 47                	js     801066e0 <sys_get_count+0x60>
80106699:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010669c:	83 ec 08             	sub    $0x8,%esp
8010669f:	50                   	push   %eax
801066a0:	6a 01                	push   $0x1
801066a2:	e8 19 e9 ff ff       	call   80104fc0 <argint>
801066a7:	83 c4 10             	add    $0x10,%esp
801066aa:	85 c0                	test   %eax,%eax
801066ac:	78 32                	js     801066e0 <sys_get_count+0x60>
    return -1;
  result = get_syscall_count(pid, sysnum);
801066ae:	83 ec 08             	sub    $0x8,%esp
801066b1:	ff 75 f4             	pushl  -0xc(%ebp)
801066b4:	ff 75 f0             	pushl  -0x10(%ebp)
801066b7:	e8 64 de ff ff       	call   80104520 <get_syscall_count>
  cprintf("count_syscall: pid: %d sysnum: %d res:%d\n", pid, sysnum, result);
801066bc:	50                   	push   %eax
801066bd:	ff 75 f4             	pushl  -0xc(%ebp)
{
  int pid, sysnum, result;

  if (argint(0, &pid) < 0 || argint(1, &sysnum) < 0)
    return -1;
  result = get_syscall_count(pid, sysnum);
801066c0:	89 c3                	mov    %eax,%ebx
  cprintf("count_syscall: pid: %d sysnum: %d res:%d\n", pid, sysnum, result);
801066c2:	ff 75 f0             	pushl  -0x10(%ebp)
801066c5:	68 cc 8d 10 80       	push   $0x80108dcc
801066ca:	e8 11 a0 ff ff       	call   801006e0 <cprintf>
  return result;
801066cf:	83 c4 20             	add    $0x20,%esp
801066d2:	89 d8                	mov    %ebx,%eax
}
801066d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801066d7:	c9                   	leave  
801066d8:	c3                   	ret    
801066d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
sys_get_count(void)
{
  int pid, sysnum, result;

  if (argint(0, &pid) < 0 || argint(1, &sysnum) < 0)
    return -1;
801066e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066e5:	eb ed                	jmp    801066d4 <sys_get_count+0x54>
801066e7:	89 f6                	mov    %esi,%esi
801066e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801066f0 <sys_log_syscalls>:
  return result;
}

void
sys_log_syscalls(void)
{
801066f0:	55                   	push   %ebp
801066f1:	89 e5                	mov    %esp,%ebp
801066f3:	83 ec 14             	sub    $0x14,%esp
  log_syscalls(first_proc);
801066f6:	ff 35 74 e5 12 80    	pushl  0x8012e574
801066fc:	e8 bf de ff ff       	call   801045c0 <log_syscalls>
}
80106701:	83 c4 10             	add    $0x10,%esp
80106704:	c9                   	leave  
80106705:	c3                   	ret    
80106706:	8d 76 00             	lea    0x0(%esi),%esi
80106709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106710 <sys_ticketlockinit>:

void
sys_ticketlockinit(void)
{
80106710:	55                   	push   %ebp
80106711:	89 e5                	mov    %esp,%ebp
80106713:	83 ec 10             	sub    $0x10,%esp
  init_ticket_lock(&ticketlock, "ticket_lock");
80106716:	68 bf 8d 10 80       	push   $0x80108dbf
8010671b:	68 80 e5 12 80       	push   $0x8012e580
80106720:	e8 0b e4 ff ff       	call   80104b30 <init_ticket_lock>
}
80106725:	83 c4 10             	add    $0x10,%esp
80106728:	c9                   	leave  
80106729:	c3                   	ret    
8010672a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106730 <sys_ticketlocktest>:

void
sys_ticketlocktest(void)
{
80106730:	55                   	push   %ebp
80106731:	89 e5                	mov    %esp,%ebp
80106733:	83 ec 14             	sub    $0x14,%esp
  ticket_acquire(&ticketlock);
80106736:	68 80 e5 12 80       	push   $0x8012e580
8010673b:	e8 30 e4 ff ff       	call   80104b70 <ticket_acquire>
  safe_count++;
80106740:	a1 bc c5 10 80       	mov    0x8010c5bc,%eax
  cprintf("num : %d\n", safe_count);
80106745:	5a                   	pop    %edx
80106746:	59                   	pop    %ecx

void
sys_ticketlocktest(void)
{
  ticket_acquire(&ticketlock);
  safe_count++;
80106747:	83 c0 01             	add    $0x1,%eax
  cprintf("num : %d\n", safe_count);
8010674a:	50                   	push   %eax
8010674b:	68 b5 8d 10 80       	push   $0x80108db5

void
sys_ticketlocktest(void)
{
  ticket_acquire(&ticketlock);
  safe_count++;
80106750:	a3 bc c5 10 80       	mov    %eax,0x8010c5bc
  cprintf("num : %d\n", safe_count);
80106755:	e8 86 9f ff ff       	call   801006e0 <cprintf>
  ticket_release(&ticketlock);
8010675a:	c7 04 24 80 e5 12 80 	movl   $0x8012e580,(%esp)
80106761:	e8 8a e4 ff ff       	call   80104bf0 <ticket_release>
}
80106766:	83 c4 10             	add    $0x10,%esp
80106769:	c9                   	leave  
8010676a:	c3                   	ret    
8010676b:	90                   	nop
8010676c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106770 <sys_getpid>:

int
sys_getpid(void)
{
80106770:	55                   	push   %ebp
80106771:	89 e5                	mov    %esp,%ebp
80106773:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80106776:	e8 d5 d1 ff ff       	call   80103950 <myproc>
8010677b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010677e:	c9                   	leave  
8010677f:	c3                   	ret    

80106780 <sys_sbrk>:

int
sys_sbrk(void)
{
80106780:	55                   	push   %ebp
80106781:	89 e5                	mov    %esp,%ebp
80106783:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106784:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return myproc()->pid;
}

int
sys_sbrk(void)
{
80106787:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
8010678a:	50                   	push   %eax
8010678b:	6a 00                	push   $0x0
8010678d:	e8 2e e8 ff ff       	call   80104fc0 <argint>
80106792:	83 c4 10             	add    $0x10,%esp
80106795:	85 c0                	test   %eax,%eax
80106797:	78 27                	js     801067c0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80106799:	e8 b2 d1 ff ff       	call   80103950 <myproc>
  if(growproc(n) < 0)
8010679e:	83 ec 0c             	sub    $0xc,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
801067a1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801067a3:	ff 75 f4             	pushl  -0xc(%ebp)
801067a6:	e8 c5 d2 ff ff       	call   80103a70 <growproc>
801067ab:	83 c4 10             	add    $0x10,%esp
801067ae:	85 c0                	test   %eax,%eax
801067b0:	78 0e                	js     801067c0 <sys_sbrk+0x40>
    return -1;
  return addr;
801067b2:	89 d8                	mov    %ebx,%eax
}
801067b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801067b7:	c9                   	leave  
801067b8:	c3                   	ret    
801067b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
801067c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067c5:	eb ed                	jmp    801067b4 <sys_sbrk+0x34>
801067c7:	89 f6                	mov    %esi,%esi
801067c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801067d0 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
801067d0:	55                   	push   %ebp
801067d1:	89 e5                	mov    %esp,%ebp
801067d3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801067d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return addr;
}

int
sys_sleep(void)
{
801067d7:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801067da:	50                   	push   %eax
801067db:	6a 00                	push   $0x0
801067dd:	e8 de e7 ff ff       	call   80104fc0 <argint>
801067e2:	83 c4 10             	add    $0x10,%esp
801067e5:	85 c0                	test   %eax,%eax
801067e7:	0f 88 8a 00 00 00    	js     80106877 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801067ed:	83 ec 0c             	sub    $0xc,%esp
801067f0:	68 e0 e5 12 80       	push   $0x8012e5e0
801067f5:	e8 36 e2 ff ff       	call   80104a30 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801067fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
801067fd:	83 c4 10             	add    $0x10,%esp
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
80106800:	8b 1d 20 ee 12 80    	mov    0x8012ee20,%ebx
  while(ticks - ticks0 < n){
80106806:	85 d2                	test   %edx,%edx
80106808:	75 27                	jne    80106831 <sys_sleep+0x61>
8010680a:	eb 54                	jmp    80106860 <sys_sleep+0x90>
8010680c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106810:	83 ec 08             	sub    $0x8,%esp
80106813:	68 e0 e5 12 80       	push   $0x8012e5e0
80106818:	68 20 ee 12 80       	push   $0x8012ee20
8010681d:	e8 ee d6 ff ff       	call   80103f10 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80106822:	a1 20 ee 12 80       	mov    0x8012ee20,%eax
80106827:	83 c4 10             	add    $0x10,%esp
8010682a:	29 d8                	sub    %ebx,%eax
8010682c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010682f:	73 2f                	jae    80106860 <sys_sleep+0x90>
    if(myproc()->killed){
80106831:	e8 1a d1 ff ff       	call   80103950 <myproc>
80106836:	8b 40 24             	mov    0x24(%eax),%eax
80106839:	85 c0                	test   %eax,%eax
8010683b:	74 d3                	je     80106810 <sys_sleep+0x40>
      release(&tickslock);
8010683d:	83 ec 0c             	sub    $0xc,%esp
80106840:	68 e0 e5 12 80       	push   $0x8012e5e0
80106845:	e8 96 e2 ff ff       	call   80104ae0 <release>
      return -1;
8010684a:	83 c4 10             	add    $0x10,%esp
8010684d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
80106852:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106855:	c9                   	leave  
80106856:	c3                   	ret    
80106857:	89 f6                	mov    %esi,%esi
80106859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80106860:	83 ec 0c             	sub    $0xc,%esp
80106863:	68 e0 e5 12 80       	push   $0x8012e5e0
80106868:	e8 73 e2 ff ff       	call   80104ae0 <release>
  return 0;
8010686d:	83 c4 10             	add    $0x10,%esp
80106870:	31 c0                	xor    %eax,%eax
}
80106872:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106875:	c9                   	leave  
80106876:	c3                   	ret    
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
80106877:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010687c:	eb d4                	jmp    80106852 <sys_sleep+0x82>
8010687e:	66 90                	xchg   %ax,%ax

80106880 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106880:	55                   	push   %ebp
80106881:	89 e5                	mov    %esp,%ebp
80106883:	53                   	push   %ebx
80106884:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80106887:	68 e0 e5 12 80       	push   $0x8012e5e0
8010688c:	e8 9f e1 ff ff       	call   80104a30 <acquire>
  xticks = ticks;
80106891:	8b 1d 20 ee 12 80    	mov    0x8012ee20,%ebx
  release(&tickslock);
80106897:	c7 04 24 e0 e5 12 80 	movl   $0x8012e5e0,(%esp)
8010689e:	e8 3d e2 ff ff       	call   80104ae0 <release>
  return xticks;
}
801068a3:	89 d8                	mov    %ebx,%eax
801068a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801068a8:	c9                   	leave  
801068a9:	c3                   	ret    
801068aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801068b0 <sys_halt>:

int
sys_halt(void)
{
801068b0:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801068b1:	ba f4 00 00 00       	mov    $0xf4,%edx
801068b6:	31 c0                	xor    %eax,%eax
801068b8:	89 e5                	mov    %esp,%ebp
801068ba:	ee                   	out    %al,(%dx)
  outb(0xf4, 0x00);
  return 0;
}
801068bb:	31 c0                	xor    %eax,%eax
801068bd:	5d                   	pop    %ebp
801068be:	c3                   	ret    

801068bf <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801068bf:	1e                   	push   %ds
  pushl %es
801068c0:	06                   	push   %es
  pushl %fs
801068c1:	0f a0                	push   %fs
  pushl %gs
801068c3:	0f a8                	push   %gs
  pushal
801068c5:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801068c6:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801068ca:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801068cc:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801068ce:	54                   	push   %esp
  call trap
801068cf:	e8 ec 00 00 00       	call   801069c0 <trap>
  addl $4, %esp
801068d4:	83 c4 04             	add    $0x4,%esp

801068d7 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801068d7:	61                   	popa   
  popl %gs
801068d8:	0f a9                	pop    %gs
  popl %fs
801068da:	0f a1                	pop    %fs
  popl %es
801068dc:	07                   	pop    %es
  popl %ds
801068dd:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801068de:	83 c4 08             	add    $0x8,%esp
  iret
801068e1:	cf                   	iret   
801068e2:	66 90                	xchg   %ax,%ax
801068e4:	66 90                	xchg   %ax,%ax
801068e6:	66 90                	xchg   %ax,%ax
801068e8:	66 90                	xchg   %ax,%ax
801068ea:	66 90                	xchg   %ax,%ax
801068ec:	66 90                	xchg   %ax,%ax
801068ee:	66 90                	xchg   %ax,%ax

801068f0 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
801068f0:	31 c0                	xor    %eax,%eax
801068f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801068f8:	8b 14 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%edx
801068ff:	b9 08 00 00 00       	mov    $0x8,%ecx
80106904:	c6 04 c5 24 e6 12 80 	movb   $0x0,-0x7fed19dc(,%eax,8)
8010690b:	00 
8010690c:	66 89 0c c5 22 e6 12 	mov    %cx,-0x7fed19de(,%eax,8)
80106913:	80 
80106914:	c6 04 c5 25 e6 12 80 	movb   $0x8e,-0x7fed19db(,%eax,8)
8010691b:	8e 
8010691c:	66 89 14 c5 20 e6 12 	mov    %dx,-0x7fed19e0(,%eax,8)
80106923:	80 
80106924:	c1 ea 10             	shr    $0x10,%edx
80106927:	66 89 14 c5 26 e6 12 	mov    %dx,-0x7fed19da(,%eax,8)
8010692e:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
8010692f:	83 c0 01             	add    $0x1,%eax
80106932:	3d 00 01 00 00       	cmp    $0x100,%eax
80106937:	75 bf                	jne    801068f8 <tvinit+0x8>
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106939:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010693a:	ba 08 00 00 00       	mov    $0x8,%edx
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
8010693f:	89 e5                	mov    %esp,%ebp
80106941:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106944:	a1 08 c1 10 80       	mov    0x8010c108,%eax

  initlock(&tickslock, "time");
80106949:	68 15 8b 10 80       	push   $0x80108b15
8010694e:	68 e0 e5 12 80       	push   $0x8012e5e0
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106953:	66 89 15 22 e8 12 80 	mov    %dx,0x8012e822
8010695a:	c6 05 24 e8 12 80 00 	movb   $0x0,0x8012e824
80106961:	66 a3 20 e8 12 80    	mov    %ax,0x8012e820
80106967:	c1 e8 10             	shr    $0x10,%eax
8010696a:	c6 05 25 e8 12 80 ef 	movb   $0xef,0x8012e825
80106971:	66 a3 26 e8 12 80    	mov    %ax,0x8012e826

  initlock(&tickslock, "time");
80106977:	e8 54 df ff ff       	call   801048d0 <initlock>
}
8010697c:	83 c4 10             	add    $0x10,%esp
8010697f:	c9                   	leave  
80106980:	c3                   	ret    
80106981:	eb 0d                	jmp    80106990 <idtinit>
80106983:	90                   	nop
80106984:	90                   	nop
80106985:	90                   	nop
80106986:	90                   	nop
80106987:	90                   	nop
80106988:	90                   	nop
80106989:	90                   	nop
8010698a:	90                   	nop
8010698b:	90                   	nop
8010698c:	90                   	nop
8010698d:	90                   	nop
8010698e:	90                   	nop
8010698f:	90                   	nop

80106990 <idtinit>:

void
idtinit(void)
{
80106990:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80106991:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106996:	89 e5                	mov    %esp,%ebp
80106998:	83 ec 10             	sub    $0x10,%esp
8010699b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010699f:	b8 20 e6 12 80       	mov    $0x8012e620,%eax
801069a4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801069a8:	c1 e8 10             	shr    $0x10,%eax
801069ab:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
801069af:	8d 45 fa             	lea    -0x6(%ebp),%eax
801069b2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801069b5:	c9                   	leave  
801069b6:	c3                   	ret    
801069b7:	89 f6                	mov    %esi,%esi
801069b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801069c0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801069c0:	55                   	push   %ebp
801069c1:	89 e5                	mov    %esp,%ebp
801069c3:	57                   	push   %edi
801069c4:	56                   	push   %esi
801069c5:	53                   	push   %ebx
801069c6:	83 ec 1c             	sub    $0x1c,%esp
801069c9:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
801069cc:	8b 47 30             	mov    0x30(%edi),%eax
801069cf:	83 f8 40             	cmp    $0x40,%eax
801069d2:	0f 84 88 01 00 00    	je     80106b60 <trap+0x1a0>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801069d8:	83 e8 20             	sub    $0x20,%eax
801069db:	83 f8 1f             	cmp    $0x1f,%eax
801069de:	77 10                	ja     801069f0 <trap+0x30>
801069e0:	ff 24 85 98 8e 10 80 	jmp    *-0x7fef7168(,%eax,4)
801069e7:	89 f6                	mov    %esi,%esi
801069e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
801069f0:	e8 5b cf ff ff       	call   80103950 <myproc>
801069f5:	85 c0                	test   %eax,%eax
801069f7:	0f 84 d7 01 00 00    	je     80106bd4 <trap+0x214>
801069fd:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80106a01:	0f 84 cd 01 00 00    	je     80106bd4 <trap+0x214>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106a07:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106a0a:	8b 57 38             	mov    0x38(%edi),%edx
80106a0d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80106a10:	89 55 dc             	mov    %edx,-0x24(%ebp)
80106a13:	e8 18 cf ff ff       	call   80103930 <cpuid>
80106a18:	8b 77 34             	mov    0x34(%edi),%esi
80106a1b:	8b 5f 30             	mov    0x30(%edi),%ebx
80106a1e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106a21:	e8 2a cf ff ff       	call   80103950 <myproc>
80106a26:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106a29:	e8 22 cf ff ff       	call   80103950 <myproc>
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106a2e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106a31:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106a34:	51                   	push   %ecx
80106a35:	52                   	push   %edx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106a36:	8b 55 e0             	mov    -0x20(%ebp),%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106a39:	ff 75 e4             	pushl  -0x1c(%ebp)
80106a3c:	56                   	push   %esi
80106a3d:	53                   	push   %ebx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106a3e:	83 c2 6c             	add    $0x6c,%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106a41:	52                   	push   %edx
80106a42:	ff 70 10             	pushl  0x10(%eax)
80106a45:	68 54 8e 10 80       	push   $0x80108e54
80106a4a:	e8 91 9c ff ff       	call   801006e0 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80106a4f:	83 c4 20             	add    $0x20,%esp
80106a52:	e8 f9 ce ff ff       	call   80103950 <myproc>
80106a57:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80106a5e:	66 90                	xchg   %ax,%ax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106a60:	e8 eb ce ff ff       	call   80103950 <myproc>
80106a65:	85 c0                	test   %eax,%eax
80106a67:	74 0c                	je     80106a75 <trap+0xb5>
80106a69:	e8 e2 ce ff ff       	call   80103950 <myproc>
80106a6e:	8b 50 24             	mov    0x24(%eax),%edx
80106a71:	85 d2                	test   %edx,%edx
80106a73:	75 4b                	jne    80106ac0 <trap+0x100>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106a75:	e8 d6 ce ff ff       	call   80103950 <myproc>
80106a7a:	85 c0                	test   %eax,%eax
80106a7c:	74 0b                	je     80106a89 <trap+0xc9>
80106a7e:	e8 cd ce ff ff       	call   80103950 <myproc>
80106a83:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106a87:	74 4f                	je     80106ad8 <trap+0x118>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106a89:	e8 c2 ce ff ff       	call   80103950 <myproc>
80106a8e:	85 c0                	test   %eax,%eax
80106a90:	74 1d                	je     80106aaf <trap+0xef>
80106a92:	e8 b9 ce ff ff       	call   80103950 <myproc>
80106a97:	8b 40 24             	mov    0x24(%eax),%eax
80106a9a:	85 c0                	test   %eax,%eax
80106a9c:	74 11                	je     80106aaf <trap+0xef>
80106a9e:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106aa2:	83 e0 03             	and    $0x3,%eax
80106aa5:	66 83 f8 03          	cmp    $0x3,%ax
80106aa9:	0f 84 da 00 00 00    	je     80106b89 <trap+0x1c9>
    exit();
}
80106aaf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ab2:	5b                   	pop    %ebx
80106ab3:	5e                   	pop    %esi
80106ab4:	5f                   	pop    %edi
80106ab5:	5d                   	pop    %ebp
80106ab6:	c3                   	ret    
80106ab7:	89 f6                	mov    %esi,%esi
80106ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106ac0:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106ac4:	83 e0 03             	and    $0x3,%eax
80106ac7:	66 83 f8 03          	cmp    $0x3,%ax
80106acb:	75 a8                	jne    80106a75 <trap+0xb5>
    exit();
80106acd:	e8 be d2 ff ff       	call   80103d90 <exit>
80106ad2:	eb a1                	jmp    80106a75 <trap+0xb5>
80106ad4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106ad8:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80106adc:	75 ab                	jne    80106a89 <trap+0xc9>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();
80106ade:	e8 dd d3 ff ff       	call   80103ec0 <yield>
80106ae3:	eb a4                	jmp    80106a89 <trap+0xc9>
80106ae5:	8d 76 00             	lea    0x0(%esi),%esi
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80106ae8:	e8 43 ce ff ff       	call   80103930 <cpuid>
80106aed:	85 c0                	test   %eax,%eax
80106aef:	0f 84 ab 00 00 00    	je     80106ba0 <trap+0x1e0>
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
80106af5:	e8 b6 bd ff ff       	call   801028b0 <lapiceoi>
    break;
80106afa:	e9 61 ff ff ff       	jmp    80106a60 <trap+0xa0>
80106aff:	90                   	nop
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106b00:	e8 6b bc ff ff       	call   80102770 <kbdintr>
    lapiceoi();
80106b05:	e8 a6 bd ff ff       	call   801028b0 <lapiceoi>
    break;
80106b0a:	e9 51 ff ff ff       	jmp    80106a60 <trap+0xa0>
80106b0f:	90                   	nop
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106b10:	e8 5b 02 00 00       	call   80106d70 <uartintr>
    lapiceoi();
80106b15:	e8 96 bd ff ff       	call   801028b0 <lapiceoi>
    break;
80106b1a:	e9 41 ff ff ff       	jmp    80106a60 <trap+0xa0>
80106b1f:	90                   	nop
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106b20:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80106b24:	8b 77 38             	mov    0x38(%edi),%esi
80106b27:	e8 04 ce ff ff       	call   80103930 <cpuid>
80106b2c:	56                   	push   %esi
80106b2d:	53                   	push   %ebx
80106b2e:	50                   	push   %eax
80106b2f:	68 fc 8d 10 80       	push   $0x80108dfc
80106b34:	e8 a7 9b ff ff       	call   801006e0 <cprintf>
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
80106b39:	e8 72 bd ff ff       	call   801028b0 <lapiceoi>
    break;
80106b3e:	83 c4 10             	add    $0x10,%esp
80106b41:	e9 1a ff ff ff       	jmp    80106a60 <trap+0xa0>
80106b46:	8d 76 00             	lea    0x0(%esi),%esi
80106b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106b50:	e8 9b b6 ff ff       	call   801021f0 <ideintr>
80106b55:	eb 9e                	jmp    80106af5 <trap+0x135>
80106b57:	89 f6                	mov    %esi,%esi
80106b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
80106b60:	e8 eb cd ff ff       	call   80103950 <myproc>
80106b65:	8b 58 24             	mov    0x24(%eax),%ebx
80106b68:	85 db                	test   %ebx,%ebx
80106b6a:	75 2c                	jne    80106b98 <trap+0x1d8>
      exit();
    myproc()->tf = tf;
80106b6c:	e8 df cd ff ff       	call   80103950 <myproc>
80106b71:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80106b74:	e8 77 eb ff ff       	call   801056f0 <syscall>
    if(myproc()->killed)
80106b79:	e8 d2 cd ff ff       	call   80103950 <myproc>
80106b7e:	8b 48 24             	mov    0x24(%eax),%ecx
80106b81:	85 c9                	test   %ecx,%ecx
80106b83:	0f 84 26 ff ff ff    	je     80106aaf <trap+0xef>
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80106b89:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b8c:	5b                   	pop    %ebx
80106b8d:	5e                   	pop    %esi
80106b8e:	5f                   	pop    %edi
80106b8f:	5d                   	pop    %ebp
    if(myproc()->killed)
      exit();
    myproc()->tf = tf;
    syscall();
    if(myproc()->killed)
      exit();
80106b90:	e9 fb d1 ff ff       	jmp    80103d90 <exit>
80106b95:	8d 76 00             	lea    0x0(%esi),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit();
80106b98:	e8 f3 d1 ff ff       	call   80103d90 <exit>
80106b9d:	eb cd                	jmp    80106b6c <trap+0x1ac>
80106b9f:	90                   	nop
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
80106ba0:	83 ec 0c             	sub    $0xc,%esp
80106ba3:	68 e0 e5 12 80       	push   $0x8012e5e0
80106ba8:	e8 83 de ff ff       	call   80104a30 <acquire>
      ticks++;
      wakeup(&ticks);
80106bad:	c7 04 24 20 ee 12 80 	movl   $0x8012ee20,(%esp)

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
      ticks++;
80106bb4:	83 05 20 ee 12 80 01 	addl   $0x1,0x8012ee20
      wakeup(&ticks);
80106bbb:	e8 10 d5 ff ff       	call   801040d0 <wakeup>
      release(&tickslock);
80106bc0:	c7 04 24 e0 e5 12 80 	movl   $0x8012e5e0,(%esp)
80106bc7:	e8 14 df ff ff       	call   80104ae0 <release>
80106bcc:	83 c4 10             	add    $0x10,%esp
80106bcf:	e9 21 ff ff ff       	jmp    80106af5 <trap+0x135>
80106bd4:	0f 20 d6             	mov    %cr2,%esi

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106bd7:	8b 5f 38             	mov    0x38(%edi),%ebx
80106bda:	e8 51 cd ff ff       	call   80103930 <cpuid>
80106bdf:	83 ec 0c             	sub    $0xc,%esp
80106be2:	56                   	push   %esi
80106be3:	53                   	push   %ebx
80106be4:	50                   	push   %eax
80106be5:	ff 77 30             	pushl  0x30(%edi)
80106be8:	68 20 8e 10 80       	push   $0x80108e20
80106bed:	e8 ee 9a ff ff       	call   801006e0 <cprintf>
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
80106bf2:	83 c4 14             	add    $0x14,%esp
80106bf5:	68 f6 8d 10 80       	push   $0x80108df6
80106bfa:	e8 71 97 ff ff       	call   80100370 <panic>
80106bff:	90                   	nop

80106c00 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106c00:	a1 c0 c5 10 80       	mov    0x8010c5c0,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80106c05:	55                   	push   %ebp
80106c06:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106c08:	85 c0                	test   %eax,%eax
80106c0a:	74 1c                	je     80106c28 <uartgetc+0x28>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106c0c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106c11:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106c12:	a8 01                	test   $0x1,%al
80106c14:	74 12                	je     80106c28 <uartgetc+0x28>
80106c16:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106c1b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106c1c:	0f b6 c0             	movzbl %al,%eax
}
80106c1f:	5d                   	pop    %ebp
80106c20:	c3                   	ret    
80106c21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

static int
uartgetc(void)
{
  if(!uart)
    return -1;
80106c28:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
80106c2d:	5d                   	pop    %ebp
80106c2e:	c3                   	ret    
80106c2f:	90                   	nop

80106c30 <uartputc.part.0>:
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}

void
uartputc(int c)
80106c30:	55                   	push   %ebp
80106c31:	89 e5                	mov    %esp,%ebp
80106c33:	57                   	push   %edi
80106c34:	56                   	push   %esi
80106c35:	53                   	push   %ebx
80106c36:	89 c7                	mov    %eax,%edi
80106c38:	bb 80 00 00 00       	mov    $0x80,%ebx
80106c3d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106c42:	83 ec 0c             	sub    $0xc,%esp
80106c45:	eb 1b                	jmp    80106c62 <uartputc.part.0+0x32>
80106c47:	89 f6                	mov    %esi,%esi
80106c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
80106c50:	83 ec 0c             	sub    $0xc,%esp
80106c53:	6a 0a                	push   $0xa
80106c55:	e8 76 bc ff ff       	call   801028d0 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106c5a:	83 c4 10             	add    $0x10,%esp
80106c5d:	83 eb 01             	sub    $0x1,%ebx
80106c60:	74 07                	je     80106c69 <uartputc.part.0+0x39>
80106c62:	89 f2                	mov    %esi,%edx
80106c64:	ec                   	in     (%dx),%al
80106c65:	a8 20                	test   $0x20,%al
80106c67:	74 e7                	je     80106c50 <uartputc.part.0+0x20>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106c69:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106c6e:	89 f8                	mov    %edi,%eax
80106c70:	ee                   	out    %al,(%dx)
    microdelay(10);
  outb(COM1+0, c);
}
80106c71:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c74:	5b                   	pop    %ebx
80106c75:	5e                   	pop    %esi
80106c76:	5f                   	pop    %edi
80106c77:	5d                   	pop    %ebp
80106c78:	c3                   	ret    
80106c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106c80 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106c80:	55                   	push   %ebp
80106c81:	31 c9                	xor    %ecx,%ecx
80106c83:	89 c8                	mov    %ecx,%eax
80106c85:	89 e5                	mov    %esp,%ebp
80106c87:	57                   	push   %edi
80106c88:	56                   	push   %esi
80106c89:	53                   	push   %ebx
80106c8a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80106c8f:	89 da                	mov    %ebx,%edx
80106c91:	83 ec 0c             	sub    $0xc,%esp
80106c94:	ee                   	out    %al,(%dx)
80106c95:	bf fb 03 00 00       	mov    $0x3fb,%edi
80106c9a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106c9f:	89 fa                	mov    %edi,%edx
80106ca1:	ee                   	out    %al,(%dx)
80106ca2:	b8 0c 00 00 00       	mov    $0xc,%eax
80106ca7:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106cac:	ee                   	out    %al,(%dx)
80106cad:	be f9 03 00 00       	mov    $0x3f9,%esi
80106cb2:	89 c8                	mov    %ecx,%eax
80106cb4:	89 f2                	mov    %esi,%edx
80106cb6:	ee                   	out    %al,(%dx)
80106cb7:	b8 03 00 00 00       	mov    $0x3,%eax
80106cbc:	89 fa                	mov    %edi,%edx
80106cbe:	ee                   	out    %al,(%dx)
80106cbf:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106cc4:	89 c8                	mov    %ecx,%eax
80106cc6:	ee                   	out    %al,(%dx)
80106cc7:	b8 01 00 00 00       	mov    $0x1,%eax
80106ccc:	89 f2                	mov    %esi,%edx
80106cce:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106ccf:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106cd4:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80106cd5:	3c ff                	cmp    $0xff,%al
80106cd7:	74 5a                	je     80106d33 <uartinit+0xb3>
    return;
  uart = 1;
80106cd9:	c7 05 c0 c5 10 80 01 	movl   $0x1,0x8010c5c0
80106ce0:	00 00 00 
80106ce3:	89 da                	mov    %ebx,%edx
80106ce5:	ec                   	in     (%dx),%al
80106ce6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106ceb:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);
80106cec:	83 ec 08             	sub    $0x8,%esp
80106cef:	bb 18 8f 10 80       	mov    $0x80108f18,%ebx
80106cf4:	6a 00                	push   $0x0
80106cf6:	6a 04                	push   $0x4
80106cf8:	e8 43 b7 ff ff       	call   80102440 <ioapicenable>
80106cfd:	83 c4 10             	add    $0x10,%esp
80106d00:	b8 78 00 00 00       	mov    $0x78,%eax
80106d05:	eb 13                	jmp    80106d1a <uartinit+0x9a>
80106d07:	89 f6                	mov    %esi,%esi
80106d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106d10:	83 c3 01             	add    $0x1,%ebx
80106d13:	0f be 03             	movsbl (%ebx),%eax
80106d16:	84 c0                	test   %al,%al
80106d18:	74 19                	je     80106d33 <uartinit+0xb3>
void
uartputc(int c)
{
  int i;

  if(!uart)
80106d1a:	8b 15 c0 c5 10 80    	mov    0x8010c5c0,%edx
80106d20:	85 d2                	test   %edx,%edx
80106d22:	74 ec                	je     80106d10 <uartinit+0x90>
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106d24:	83 c3 01             	add    $0x1,%ebx
80106d27:	e8 04 ff ff ff       	call   80106c30 <uartputc.part.0>
80106d2c:	0f be 03             	movsbl (%ebx),%eax
80106d2f:	84 c0                	test   %al,%al
80106d31:	75 e7                	jne    80106d1a <uartinit+0x9a>
    uartputc(*p);
}
80106d33:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d36:	5b                   	pop    %ebx
80106d37:	5e                   	pop    %esi
80106d38:	5f                   	pop    %edi
80106d39:	5d                   	pop    %ebp
80106d3a:	c3                   	ret    
80106d3b:	90                   	nop
80106d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106d40 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
80106d40:	8b 15 c0 c5 10 80    	mov    0x8010c5c0,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
80106d46:	55                   	push   %ebp
80106d47:	89 e5                	mov    %esp,%ebp
  int i;

  if(!uart)
80106d49:	85 d2                	test   %edx,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
80106d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  int i;

  if(!uart)
80106d4e:	74 10                	je     80106d60 <uartputc+0x20>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80106d50:	5d                   	pop    %ebp
80106d51:	e9 da fe ff ff       	jmp    80106c30 <uartputc.part.0>
80106d56:	8d 76 00             	lea    0x0(%esi),%esi
80106d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106d60:	5d                   	pop    %ebp
80106d61:	c3                   	ret    
80106d62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106d70 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
80106d70:	55                   	push   %ebp
80106d71:	89 e5                	mov    %esp,%ebp
80106d73:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106d76:	68 00 6c 10 80       	push   $0x80106c00
80106d7b:	e8 f0 9a ff ff       	call   80100870 <consoleintr>
}
80106d80:	83 c4 10             	add    $0x10,%esp
80106d83:	c9                   	leave  
80106d84:	c3                   	ret    

80106d85 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106d85:	6a 00                	push   $0x0
  pushl $0
80106d87:	6a 00                	push   $0x0
  jmp alltraps
80106d89:	e9 31 fb ff ff       	jmp    801068bf <alltraps>

80106d8e <vector1>:
.globl vector1
vector1:
  pushl $0
80106d8e:	6a 00                	push   $0x0
  pushl $1
80106d90:	6a 01                	push   $0x1
  jmp alltraps
80106d92:	e9 28 fb ff ff       	jmp    801068bf <alltraps>

80106d97 <vector2>:
.globl vector2
vector2:
  pushl $0
80106d97:	6a 00                	push   $0x0
  pushl $2
80106d99:	6a 02                	push   $0x2
  jmp alltraps
80106d9b:	e9 1f fb ff ff       	jmp    801068bf <alltraps>

80106da0 <vector3>:
.globl vector3
vector3:
  pushl $0
80106da0:	6a 00                	push   $0x0
  pushl $3
80106da2:	6a 03                	push   $0x3
  jmp alltraps
80106da4:	e9 16 fb ff ff       	jmp    801068bf <alltraps>

80106da9 <vector4>:
.globl vector4
vector4:
  pushl $0
80106da9:	6a 00                	push   $0x0
  pushl $4
80106dab:	6a 04                	push   $0x4
  jmp alltraps
80106dad:	e9 0d fb ff ff       	jmp    801068bf <alltraps>

80106db2 <vector5>:
.globl vector5
vector5:
  pushl $0
80106db2:	6a 00                	push   $0x0
  pushl $5
80106db4:	6a 05                	push   $0x5
  jmp alltraps
80106db6:	e9 04 fb ff ff       	jmp    801068bf <alltraps>

80106dbb <vector6>:
.globl vector6
vector6:
  pushl $0
80106dbb:	6a 00                	push   $0x0
  pushl $6
80106dbd:	6a 06                	push   $0x6
  jmp alltraps
80106dbf:	e9 fb fa ff ff       	jmp    801068bf <alltraps>

80106dc4 <vector7>:
.globl vector7
vector7:
  pushl $0
80106dc4:	6a 00                	push   $0x0
  pushl $7
80106dc6:	6a 07                	push   $0x7
  jmp alltraps
80106dc8:	e9 f2 fa ff ff       	jmp    801068bf <alltraps>

80106dcd <vector8>:
.globl vector8
vector8:
  pushl $8
80106dcd:	6a 08                	push   $0x8
  jmp alltraps
80106dcf:	e9 eb fa ff ff       	jmp    801068bf <alltraps>

80106dd4 <vector9>:
.globl vector9
vector9:
  pushl $0
80106dd4:	6a 00                	push   $0x0
  pushl $9
80106dd6:	6a 09                	push   $0x9
  jmp alltraps
80106dd8:	e9 e2 fa ff ff       	jmp    801068bf <alltraps>

80106ddd <vector10>:
.globl vector10
vector10:
  pushl $10
80106ddd:	6a 0a                	push   $0xa
  jmp alltraps
80106ddf:	e9 db fa ff ff       	jmp    801068bf <alltraps>

80106de4 <vector11>:
.globl vector11
vector11:
  pushl $11
80106de4:	6a 0b                	push   $0xb
  jmp alltraps
80106de6:	e9 d4 fa ff ff       	jmp    801068bf <alltraps>

80106deb <vector12>:
.globl vector12
vector12:
  pushl $12
80106deb:	6a 0c                	push   $0xc
  jmp alltraps
80106ded:	e9 cd fa ff ff       	jmp    801068bf <alltraps>

80106df2 <vector13>:
.globl vector13
vector13:
  pushl $13
80106df2:	6a 0d                	push   $0xd
  jmp alltraps
80106df4:	e9 c6 fa ff ff       	jmp    801068bf <alltraps>

80106df9 <vector14>:
.globl vector14
vector14:
  pushl $14
80106df9:	6a 0e                	push   $0xe
  jmp alltraps
80106dfb:	e9 bf fa ff ff       	jmp    801068bf <alltraps>

80106e00 <vector15>:
.globl vector15
vector15:
  pushl $0
80106e00:	6a 00                	push   $0x0
  pushl $15
80106e02:	6a 0f                	push   $0xf
  jmp alltraps
80106e04:	e9 b6 fa ff ff       	jmp    801068bf <alltraps>

80106e09 <vector16>:
.globl vector16
vector16:
  pushl $0
80106e09:	6a 00                	push   $0x0
  pushl $16
80106e0b:	6a 10                	push   $0x10
  jmp alltraps
80106e0d:	e9 ad fa ff ff       	jmp    801068bf <alltraps>

80106e12 <vector17>:
.globl vector17
vector17:
  pushl $17
80106e12:	6a 11                	push   $0x11
  jmp alltraps
80106e14:	e9 a6 fa ff ff       	jmp    801068bf <alltraps>

80106e19 <vector18>:
.globl vector18
vector18:
  pushl $0
80106e19:	6a 00                	push   $0x0
  pushl $18
80106e1b:	6a 12                	push   $0x12
  jmp alltraps
80106e1d:	e9 9d fa ff ff       	jmp    801068bf <alltraps>

80106e22 <vector19>:
.globl vector19
vector19:
  pushl $0
80106e22:	6a 00                	push   $0x0
  pushl $19
80106e24:	6a 13                	push   $0x13
  jmp alltraps
80106e26:	e9 94 fa ff ff       	jmp    801068bf <alltraps>

80106e2b <vector20>:
.globl vector20
vector20:
  pushl $0
80106e2b:	6a 00                	push   $0x0
  pushl $20
80106e2d:	6a 14                	push   $0x14
  jmp alltraps
80106e2f:	e9 8b fa ff ff       	jmp    801068bf <alltraps>

80106e34 <vector21>:
.globl vector21
vector21:
  pushl $0
80106e34:	6a 00                	push   $0x0
  pushl $21
80106e36:	6a 15                	push   $0x15
  jmp alltraps
80106e38:	e9 82 fa ff ff       	jmp    801068bf <alltraps>

80106e3d <vector22>:
.globl vector22
vector22:
  pushl $0
80106e3d:	6a 00                	push   $0x0
  pushl $22
80106e3f:	6a 16                	push   $0x16
  jmp alltraps
80106e41:	e9 79 fa ff ff       	jmp    801068bf <alltraps>

80106e46 <vector23>:
.globl vector23
vector23:
  pushl $0
80106e46:	6a 00                	push   $0x0
  pushl $23
80106e48:	6a 17                	push   $0x17
  jmp alltraps
80106e4a:	e9 70 fa ff ff       	jmp    801068bf <alltraps>

80106e4f <vector24>:
.globl vector24
vector24:
  pushl $0
80106e4f:	6a 00                	push   $0x0
  pushl $24
80106e51:	6a 18                	push   $0x18
  jmp alltraps
80106e53:	e9 67 fa ff ff       	jmp    801068bf <alltraps>

80106e58 <vector25>:
.globl vector25
vector25:
  pushl $0
80106e58:	6a 00                	push   $0x0
  pushl $25
80106e5a:	6a 19                	push   $0x19
  jmp alltraps
80106e5c:	e9 5e fa ff ff       	jmp    801068bf <alltraps>

80106e61 <vector26>:
.globl vector26
vector26:
  pushl $0
80106e61:	6a 00                	push   $0x0
  pushl $26
80106e63:	6a 1a                	push   $0x1a
  jmp alltraps
80106e65:	e9 55 fa ff ff       	jmp    801068bf <alltraps>

80106e6a <vector27>:
.globl vector27
vector27:
  pushl $0
80106e6a:	6a 00                	push   $0x0
  pushl $27
80106e6c:	6a 1b                	push   $0x1b
  jmp alltraps
80106e6e:	e9 4c fa ff ff       	jmp    801068bf <alltraps>

80106e73 <vector28>:
.globl vector28
vector28:
  pushl $0
80106e73:	6a 00                	push   $0x0
  pushl $28
80106e75:	6a 1c                	push   $0x1c
  jmp alltraps
80106e77:	e9 43 fa ff ff       	jmp    801068bf <alltraps>

80106e7c <vector29>:
.globl vector29
vector29:
  pushl $0
80106e7c:	6a 00                	push   $0x0
  pushl $29
80106e7e:	6a 1d                	push   $0x1d
  jmp alltraps
80106e80:	e9 3a fa ff ff       	jmp    801068bf <alltraps>

80106e85 <vector30>:
.globl vector30
vector30:
  pushl $0
80106e85:	6a 00                	push   $0x0
  pushl $30
80106e87:	6a 1e                	push   $0x1e
  jmp alltraps
80106e89:	e9 31 fa ff ff       	jmp    801068bf <alltraps>

80106e8e <vector31>:
.globl vector31
vector31:
  pushl $0
80106e8e:	6a 00                	push   $0x0
  pushl $31
80106e90:	6a 1f                	push   $0x1f
  jmp alltraps
80106e92:	e9 28 fa ff ff       	jmp    801068bf <alltraps>

80106e97 <vector32>:
.globl vector32
vector32:
  pushl $0
80106e97:	6a 00                	push   $0x0
  pushl $32
80106e99:	6a 20                	push   $0x20
  jmp alltraps
80106e9b:	e9 1f fa ff ff       	jmp    801068bf <alltraps>

80106ea0 <vector33>:
.globl vector33
vector33:
  pushl $0
80106ea0:	6a 00                	push   $0x0
  pushl $33
80106ea2:	6a 21                	push   $0x21
  jmp alltraps
80106ea4:	e9 16 fa ff ff       	jmp    801068bf <alltraps>

80106ea9 <vector34>:
.globl vector34
vector34:
  pushl $0
80106ea9:	6a 00                	push   $0x0
  pushl $34
80106eab:	6a 22                	push   $0x22
  jmp alltraps
80106ead:	e9 0d fa ff ff       	jmp    801068bf <alltraps>

80106eb2 <vector35>:
.globl vector35
vector35:
  pushl $0
80106eb2:	6a 00                	push   $0x0
  pushl $35
80106eb4:	6a 23                	push   $0x23
  jmp alltraps
80106eb6:	e9 04 fa ff ff       	jmp    801068bf <alltraps>

80106ebb <vector36>:
.globl vector36
vector36:
  pushl $0
80106ebb:	6a 00                	push   $0x0
  pushl $36
80106ebd:	6a 24                	push   $0x24
  jmp alltraps
80106ebf:	e9 fb f9 ff ff       	jmp    801068bf <alltraps>

80106ec4 <vector37>:
.globl vector37
vector37:
  pushl $0
80106ec4:	6a 00                	push   $0x0
  pushl $37
80106ec6:	6a 25                	push   $0x25
  jmp alltraps
80106ec8:	e9 f2 f9 ff ff       	jmp    801068bf <alltraps>

80106ecd <vector38>:
.globl vector38
vector38:
  pushl $0
80106ecd:	6a 00                	push   $0x0
  pushl $38
80106ecf:	6a 26                	push   $0x26
  jmp alltraps
80106ed1:	e9 e9 f9 ff ff       	jmp    801068bf <alltraps>

80106ed6 <vector39>:
.globl vector39
vector39:
  pushl $0
80106ed6:	6a 00                	push   $0x0
  pushl $39
80106ed8:	6a 27                	push   $0x27
  jmp alltraps
80106eda:	e9 e0 f9 ff ff       	jmp    801068bf <alltraps>

80106edf <vector40>:
.globl vector40
vector40:
  pushl $0
80106edf:	6a 00                	push   $0x0
  pushl $40
80106ee1:	6a 28                	push   $0x28
  jmp alltraps
80106ee3:	e9 d7 f9 ff ff       	jmp    801068bf <alltraps>

80106ee8 <vector41>:
.globl vector41
vector41:
  pushl $0
80106ee8:	6a 00                	push   $0x0
  pushl $41
80106eea:	6a 29                	push   $0x29
  jmp alltraps
80106eec:	e9 ce f9 ff ff       	jmp    801068bf <alltraps>

80106ef1 <vector42>:
.globl vector42
vector42:
  pushl $0
80106ef1:	6a 00                	push   $0x0
  pushl $42
80106ef3:	6a 2a                	push   $0x2a
  jmp alltraps
80106ef5:	e9 c5 f9 ff ff       	jmp    801068bf <alltraps>

80106efa <vector43>:
.globl vector43
vector43:
  pushl $0
80106efa:	6a 00                	push   $0x0
  pushl $43
80106efc:	6a 2b                	push   $0x2b
  jmp alltraps
80106efe:	e9 bc f9 ff ff       	jmp    801068bf <alltraps>

80106f03 <vector44>:
.globl vector44
vector44:
  pushl $0
80106f03:	6a 00                	push   $0x0
  pushl $44
80106f05:	6a 2c                	push   $0x2c
  jmp alltraps
80106f07:	e9 b3 f9 ff ff       	jmp    801068bf <alltraps>

80106f0c <vector45>:
.globl vector45
vector45:
  pushl $0
80106f0c:	6a 00                	push   $0x0
  pushl $45
80106f0e:	6a 2d                	push   $0x2d
  jmp alltraps
80106f10:	e9 aa f9 ff ff       	jmp    801068bf <alltraps>

80106f15 <vector46>:
.globl vector46
vector46:
  pushl $0
80106f15:	6a 00                	push   $0x0
  pushl $46
80106f17:	6a 2e                	push   $0x2e
  jmp alltraps
80106f19:	e9 a1 f9 ff ff       	jmp    801068bf <alltraps>

80106f1e <vector47>:
.globl vector47
vector47:
  pushl $0
80106f1e:	6a 00                	push   $0x0
  pushl $47
80106f20:	6a 2f                	push   $0x2f
  jmp alltraps
80106f22:	e9 98 f9 ff ff       	jmp    801068bf <alltraps>

80106f27 <vector48>:
.globl vector48
vector48:
  pushl $0
80106f27:	6a 00                	push   $0x0
  pushl $48
80106f29:	6a 30                	push   $0x30
  jmp alltraps
80106f2b:	e9 8f f9 ff ff       	jmp    801068bf <alltraps>

80106f30 <vector49>:
.globl vector49
vector49:
  pushl $0
80106f30:	6a 00                	push   $0x0
  pushl $49
80106f32:	6a 31                	push   $0x31
  jmp alltraps
80106f34:	e9 86 f9 ff ff       	jmp    801068bf <alltraps>

80106f39 <vector50>:
.globl vector50
vector50:
  pushl $0
80106f39:	6a 00                	push   $0x0
  pushl $50
80106f3b:	6a 32                	push   $0x32
  jmp alltraps
80106f3d:	e9 7d f9 ff ff       	jmp    801068bf <alltraps>

80106f42 <vector51>:
.globl vector51
vector51:
  pushl $0
80106f42:	6a 00                	push   $0x0
  pushl $51
80106f44:	6a 33                	push   $0x33
  jmp alltraps
80106f46:	e9 74 f9 ff ff       	jmp    801068bf <alltraps>

80106f4b <vector52>:
.globl vector52
vector52:
  pushl $0
80106f4b:	6a 00                	push   $0x0
  pushl $52
80106f4d:	6a 34                	push   $0x34
  jmp alltraps
80106f4f:	e9 6b f9 ff ff       	jmp    801068bf <alltraps>

80106f54 <vector53>:
.globl vector53
vector53:
  pushl $0
80106f54:	6a 00                	push   $0x0
  pushl $53
80106f56:	6a 35                	push   $0x35
  jmp alltraps
80106f58:	e9 62 f9 ff ff       	jmp    801068bf <alltraps>

80106f5d <vector54>:
.globl vector54
vector54:
  pushl $0
80106f5d:	6a 00                	push   $0x0
  pushl $54
80106f5f:	6a 36                	push   $0x36
  jmp alltraps
80106f61:	e9 59 f9 ff ff       	jmp    801068bf <alltraps>

80106f66 <vector55>:
.globl vector55
vector55:
  pushl $0
80106f66:	6a 00                	push   $0x0
  pushl $55
80106f68:	6a 37                	push   $0x37
  jmp alltraps
80106f6a:	e9 50 f9 ff ff       	jmp    801068bf <alltraps>

80106f6f <vector56>:
.globl vector56
vector56:
  pushl $0
80106f6f:	6a 00                	push   $0x0
  pushl $56
80106f71:	6a 38                	push   $0x38
  jmp alltraps
80106f73:	e9 47 f9 ff ff       	jmp    801068bf <alltraps>

80106f78 <vector57>:
.globl vector57
vector57:
  pushl $0
80106f78:	6a 00                	push   $0x0
  pushl $57
80106f7a:	6a 39                	push   $0x39
  jmp alltraps
80106f7c:	e9 3e f9 ff ff       	jmp    801068bf <alltraps>

80106f81 <vector58>:
.globl vector58
vector58:
  pushl $0
80106f81:	6a 00                	push   $0x0
  pushl $58
80106f83:	6a 3a                	push   $0x3a
  jmp alltraps
80106f85:	e9 35 f9 ff ff       	jmp    801068bf <alltraps>

80106f8a <vector59>:
.globl vector59
vector59:
  pushl $0
80106f8a:	6a 00                	push   $0x0
  pushl $59
80106f8c:	6a 3b                	push   $0x3b
  jmp alltraps
80106f8e:	e9 2c f9 ff ff       	jmp    801068bf <alltraps>

80106f93 <vector60>:
.globl vector60
vector60:
  pushl $0
80106f93:	6a 00                	push   $0x0
  pushl $60
80106f95:	6a 3c                	push   $0x3c
  jmp alltraps
80106f97:	e9 23 f9 ff ff       	jmp    801068bf <alltraps>

80106f9c <vector61>:
.globl vector61
vector61:
  pushl $0
80106f9c:	6a 00                	push   $0x0
  pushl $61
80106f9e:	6a 3d                	push   $0x3d
  jmp alltraps
80106fa0:	e9 1a f9 ff ff       	jmp    801068bf <alltraps>

80106fa5 <vector62>:
.globl vector62
vector62:
  pushl $0
80106fa5:	6a 00                	push   $0x0
  pushl $62
80106fa7:	6a 3e                	push   $0x3e
  jmp alltraps
80106fa9:	e9 11 f9 ff ff       	jmp    801068bf <alltraps>

80106fae <vector63>:
.globl vector63
vector63:
  pushl $0
80106fae:	6a 00                	push   $0x0
  pushl $63
80106fb0:	6a 3f                	push   $0x3f
  jmp alltraps
80106fb2:	e9 08 f9 ff ff       	jmp    801068bf <alltraps>

80106fb7 <vector64>:
.globl vector64
vector64:
  pushl $0
80106fb7:	6a 00                	push   $0x0
  pushl $64
80106fb9:	6a 40                	push   $0x40
  jmp alltraps
80106fbb:	e9 ff f8 ff ff       	jmp    801068bf <alltraps>

80106fc0 <vector65>:
.globl vector65
vector65:
  pushl $0
80106fc0:	6a 00                	push   $0x0
  pushl $65
80106fc2:	6a 41                	push   $0x41
  jmp alltraps
80106fc4:	e9 f6 f8 ff ff       	jmp    801068bf <alltraps>

80106fc9 <vector66>:
.globl vector66
vector66:
  pushl $0
80106fc9:	6a 00                	push   $0x0
  pushl $66
80106fcb:	6a 42                	push   $0x42
  jmp alltraps
80106fcd:	e9 ed f8 ff ff       	jmp    801068bf <alltraps>

80106fd2 <vector67>:
.globl vector67
vector67:
  pushl $0
80106fd2:	6a 00                	push   $0x0
  pushl $67
80106fd4:	6a 43                	push   $0x43
  jmp alltraps
80106fd6:	e9 e4 f8 ff ff       	jmp    801068bf <alltraps>

80106fdb <vector68>:
.globl vector68
vector68:
  pushl $0
80106fdb:	6a 00                	push   $0x0
  pushl $68
80106fdd:	6a 44                	push   $0x44
  jmp alltraps
80106fdf:	e9 db f8 ff ff       	jmp    801068bf <alltraps>

80106fe4 <vector69>:
.globl vector69
vector69:
  pushl $0
80106fe4:	6a 00                	push   $0x0
  pushl $69
80106fe6:	6a 45                	push   $0x45
  jmp alltraps
80106fe8:	e9 d2 f8 ff ff       	jmp    801068bf <alltraps>

80106fed <vector70>:
.globl vector70
vector70:
  pushl $0
80106fed:	6a 00                	push   $0x0
  pushl $70
80106fef:	6a 46                	push   $0x46
  jmp alltraps
80106ff1:	e9 c9 f8 ff ff       	jmp    801068bf <alltraps>

80106ff6 <vector71>:
.globl vector71
vector71:
  pushl $0
80106ff6:	6a 00                	push   $0x0
  pushl $71
80106ff8:	6a 47                	push   $0x47
  jmp alltraps
80106ffa:	e9 c0 f8 ff ff       	jmp    801068bf <alltraps>

80106fff <vector72>:
.globl vector72
vector72:
  pushl $0
80106fff:	6a 00                	push   $0x0
  pushl $72
80107001:	6a 48                	push   $0x48
  jmp alltraps
80107003:	e9 b7 f8 ff ff       	jmp    801068bf <alltraps>

80107008 <vector73>:
.globl vector73
vector73:
  pushl $0
80107008:	6a 00                	push   $0x0
  pushl $73
8010700a:	6a 49                	push   $0x49
  jmp alltraps
8010700c:	e9 ae f8 ff ff       	jmp    801068bf <alltraps>

80107011 <vector74>:
.globl vector74
vector74:
  pushl $0
80107011:	6a 00                	push   $0x0
  pushl $74
80107013:	6a 4a                	push   $0x4a
  jmp alltraps
80107015:	e9 a5 f8 ff ff       	jmp    801068bf <alltraps>

8010701a <vector75>:
.globl vector75
vector75:
  pushl $0
8010701a:	6a 00                	push   $0x0
  pushl $75
8010701c:	6a 4b                	push   $0x4b
  jmp alltraps
8010701e:	e9 9c f8 ff ff       	jmp    801068bf <alltraps>

80107023 <vector76>:
.globl vector76
vector76:
  pushl $0
80107023:	6a 00                	push   $0x0
  pushl $76
80107025:	6a 4c                	push   $0x4c
  jmp alltraps
80107027:	e9 93 f8 ff ff       	jmp    801068bf <alltraps>

8010702c <vector77>:
.globl vector77
vector77:
  pushl $0
8010702c:	6a 00                	push   $0x0
  pushl $77
8010702e:	6a 4d                	push   $0x4d
  jmp alltraps
80107030:	e9 8a f8 ff ff       	jmp    801068bf <alltraps>

80107035 <vector78>:
.globl vector78
vector78:
  pushl $0
80107035:	6a 00                	push   $0x0
  pushl $78
80107037:	6a 4e                	push   $0x4e
  jmp alltraps
80107039:	e9 81 f8 ff ff       	jmp    801068bf <alltraps>

8010703e <vector79>:
.globl vector79
vector79:
  pushl $0
8010703e:	6a 00                	push   $0x0
  pushl $79
80107040:	6a 4f                	push   $0x4f
  jmp alltraps
80107042:	e9 78 f8 ff ff       	jmp    801068bf <alltraps>

80107047 <vector80>:
.globl vector80
vector80:
  pushl $0
80107047:	6a 00                	push   $0x0
  pushl $80
80107049:	6a 50                	push   $0x50
  jmp alltraps
8010704b:	e9 6f f8 ff ff       	jmp    801068bf <alltraps>

80107050 <vector81>:
.globl vector81
vector81:
  pushl $0
80107050:	6a 00                	push   $0x0
  pushl $81
80107052:	6a 51                	push   $0x51
  jmp alltraps
80107054:	e9 66 f8 ff ff       	jmp    801068bf <alltraps>

80107059 <vector82>:
.globl vector82
vector82:
  pushl $0
80107059:	6a 00                	push   $0x0
  pushl $82
8010705b:	6a 52                	push   $0x52
  jmp alltraps
8010705d:	e9 5d f8 ff ff       	jmp    801068bf <alltraps>

80107062 <vector83>:
.globl vector83
vector83:
  pushl $0
80107062:	6a 00                	push   $0x0
  pushl $83
80107064:	6a 53                	push   $0x53
  jmp alltraps
80107066:	e9 54 f8 ff ff       	jmp    801068bf <alltraps>

8010706b <vector84>:
.globl vector84
vector84:
  pushl $0
8010706b:	6a 00                	push   $0x0
  pushl $84
8010706d:	6a 54                	push   $0x54
  jmp alltraps
8010706f:	e9 4b f8 ff ff       	jmp    801068bf <alltraps>

80107074 <vector85>:
.globl vector85
vector85:
  pushl $0
80107074:	6a 00                	push   $0x0
  pushl $85
80107076:	6a 55                	push   $0x55
  jmp alltraps
80107078:	e9 42 f8 ff ff       	jmp    801068bf <alltraps>

8010707d <vector86>:
.globl vector86
vector86:
  pushl $0
8010707d:	6a 00                	push   $0x0
  pushl $86
8010707f:	6a 56                	push   $0x56
  jmp alltraps
80107081:	e9 39 f8 ff ff       	jmp    801068bf <alltraps>

80107086 <vector87>:
.globl vector87
vector87:
  pushl $0
80107086:	6a 00                	push   $0x0
  pushl $87
80107088:	6a 57                	push   $0x57
  jmp alltraps
8010708a:	e9 30 f8 ff ff       	jmp    801068bf <alltraps>

8010708f <vector88>:
.globl vector88
vector88:
  pushl $0
8010708f:	6a 00                	push   $0x0
  pushl $88
80107091:	6a 58                	push   $0x58
  jmp alltraps
80107093:	e9 27 f8 ff ff       	jmp    801068bf <alltraps>

80107098 <vector89>:
.globl vector89
vector89:
  pushl $0
80107098:	6a 00                	push   $0x0
  pushl $89
8010709a:	6a 59                	push   $0x59
  jmp alltraps
8010709c:	e9 1e f8 ff ff       	jmp    801068bf <alltraps>

801070a1 <vector90>:
.globl vector90
vector90:
  pushl $0
801070a1:	6a 00                	push   $0x0
  pushl $90
801070a3:	6a 5a                	push   $0x5a
  jmp alltraps
801070a5:	e9 15 f8 ff ff       	jmp    801068bf <alltraps>

801070aa <vector91>:
.globl vector91
vector91:
  pushl $0
801070aa:	6a 00                	push   $0x0
  pushl $91
801070ac:	6a 5b                	push   $0x5b
  jmp alltraps
801070ae:	e9 0c f8 ff ff       	jmp    801068bf <alltraps>

801070b3 <vector92>:
.globl vector92
vector92:
  pushl $0
801070b3:	6a 00                	push   $0x0
  pushl $92
801070b5:	6a 5c                	push   $0x5c
  jmp alltraps
801070b7:	e9 03 f8 ff ff       	jmp    801068bf <alltraps>

801070bc <vector93>:
.globl vector93
vector93:
  pushl $0
801070bc:	6a 00                	push   $0x0
  pushl $93
801070be:	6a 5d                	push   $0x5d
  jmp alltraps
801070c0:	e9 fa f7 ff ff       	jmp    801068bf <alltraps>

801070c5 <vector94>:
.globl vector94
vector94:
  pushl $0
801070c5:	6a 00                	push   $0x0
  pushl $94
801070c7:	6a 5e                	push   $0x5e
  jmp alltraps
801070c9:	e9 f1 f7 ff ff       	jmp    801068bf <alltraps>

801070ce <vector95>:
.globl vector95
vector95:
  pushl $0
801070ce:	6a 00                	push   $0x0
  pushl $95
801070d0:	6a 5f                	push   $0x5f
  jmp alltraps
801070d2:	e9 e8 f7 ff ff       	jmp    801068bf <alltraps>

801070d7 <vector96>:
.globl vector96
vector96:
  pushl $0
801070d7:	6a 00                	push   $0x0
  pushl $96
801070d9:	6a 60                	push   $0x60
  jmp alltraps
801070db:	e9 df f7 ff ff       	jmp    801068bf <alltraps>

801070e0 <vector97>:
.globl vector97
vector97:
  pushl $0
801070e0:	6a 00                	push   $0x0
  pushl $97
801070e2:	6a 61                	push   $0x61
  jmp alltraps
801070e4:	e9 d6 f7 ff ff       	jmp    801068bf <alltraps>

801070e9 <vector98>:
.globl vector98
vector98:
  pushl $0
801070e9:	6a 00                	push   $0x0
  pushl $98
801070eb:	6a 62                	push   $0x62
  jmp alltraps
801070ed:	e9 cd f7 ff ff       	jmp    801068bf <alltraps>

801070f2 <vector99>:
.globl vector99
vector99:
  pushl $0
801070f2:	6a 00                	push   $0x0
  pushl $99
801070f4:	6a 63                	push   $0x63
  jmp alltraps
801070f6:	e9 c4 f7 ff ff       	jmp    801068bf <alltraps>

801070fb <vector100>:
.globl vector100
vector100:
  pushl $0
801070fb:	6a 00                	push   $0x0
  pushl $100
801070fd:	6a 64                	push   $0x64
  jmp alltraps
801070ff:	e9 bb f7 ff ff       	jmp    801068bf <alltraps>

80107104 <vector101>:
.globl vector101
vector101:
  pushl $0
80107104:	6a 00                	push   $0x0
  pushl $101
80107106:	6a 65                	push   $0x65
  jmp alltraps
80107108:	e9 b2 f7 ff ff       	jmp    801068bf <alltraps>

8010710d <vector102>:
.globl vector102
vector102:
  pushl $0
8010710d:	6a 00                	push   $0x0
  pushl $102
8010710f:	6a 66                	push   $0x66
  jmp alltraps
80107111:	e9 a9 f7 ff ff       	jmp    801068bf <alltraps>

80107116 <vector103>:
.globl vector103
vector103:
  pushl $0
80107116:	6a 00                	push   $0x0
  pushl $103
80107118:	6a 67                	push   $0x67
  jmp alltraps
8010711a:	e9 a0 f7 ff ff       	jmp    801068bf <alltraps>

8010711f <vector104>:
.globl vector104
vector104:
  pushl $0
8010711f:	6a 00                	push   $0x0
  pushl $104
80107121:	6a 68                	push   $0x68
  jmp alltraps
80107123:	e9 97 f7 ff ff       	jmp    801068bf <alltraps>

80107128 <vector105>:
.globl vector105
vector105:
  pushl $0
80107128:	6a 00                	push   $0x0
  pushl $105
8010712a:	6a 69                	push   $0x69
  jmp alltraps
8010712c:	e9 8e f7 ff ff       	jmp    801068bf <alltraps>

80107131 <vector106>:
.globl vector106
vector106:
  pushl $0
80107131:	6a 00                	push   $0x0
  pushl $106
80107133:	6a 6a                	push   $0x6a
  jmp alltraps
80107135:	e9 85 f7 ff ff       	jmp    801068bf <alltraps>

8010713a <vector107>:
.globl vector107
vector107:
  pushl $0
8010713a:	6a 00                	push   $0x0
  pushl $107
8010713c:	6a 6b                	push   $0x6b
  jmp alltraps
8010713e:	e9 7c f7 ff ff       	jmp    801068bf <alltraps>

80107143 <vector108>:
.globl vector108
vector108:
  pushl $0
80107143:	6a 00                	push   $0x0
  pushl $108
80107145:	6a 6c                	push   $0x6c
  jmp alltraps
80107147:	e9 73 f7 ff ff       	jmp    801068bf <alltraps>

8010714c <vector109>:
.globl vector109
vector109:
  pushl $0
8010714c:	6a 00                	push   $0x0
  pushl $109
8010714e:	6a 6d                	push   $0x6d
  jmp alltraps
80107150:	e9 6a f7 ff ff       	jmp    801068bf <alltraps>

80107155 <vector110>:
.globl vector110
vector110:
  pushl $0
80107155:	6a 00                	push   $0x0
  pushl $110
80107157:	6a 6e                	push   $0x6e
  jmp alltraps
80107159:	e9 61 f7 ff ff       	jmp    801068bf <alltraps>

8010715e <vector111>:
.globl vector111
vector111:
  pushl $0
8010715e:	6a 00                	push   $0x0
  pushl $111
80107160:	6a 6f                	push   $0x6f
  jmp alltraps
80107162:	e9 58 f7 ff ff       	jmp    801068bf <alltraps>

80107167 <vector112>:
.globl vector112
vector112:
  pushl $0
80107167:	6a 00                	push   $0x0
  pushl $112
80107169:	6a 70                	push   $0x70
  jmp alltraps
8010716b:	e9 4f f7 ff ff       	jmp    801068bf <alltraps>

80107170 <vector113>:
.globl vector113
vector113:
  pushl $0
80107170:	6a 00                	push   $0x0
  pushl $113
80107172:	6a 71                	push   $0x71
  jmp alltraps
80107174:	e9 46 f7 ff ff       	jmp    801068bf <alltraps>

80107179 <vector114>:
.globl vector114
vector114:
  pushl $0
80107179:	6a 00                	push   $0x0
  pushl $114
8010717b:	6a 72                	push   $0x72
  jmp alltraps
8010717d:	e9 3d f7 ff ff       	jmp    801068bf <alltraps>

80107182 <vector115>:
.globl vector115
vector115:
  pushl $0
80107182:	6a 00                	push   $0x0
  pushl $115
80107184:	6a 73                	push   $0x73
  jmp alltraps
80107186:	e9 34 f7 ff ff       	jmp    801068bf <alltraps>

8010718b <vector116>:
.globl vector116
vector116:
  pushl $0
8010718b:	6a 00                	push   $0x0
  pushl $116
8010718d:	6a 74                	push   $0x74
  jmp alltraps
8010718f:	e9 2b f7 ff ff       	jmp    801068bf <alltraps>

80107194 <vector117>:
.globl vector117
vector117:
  pushl $0
80107194:	6a 00                	push   $0x0
  pushl $117
80107196:	6a 75                	push   $0x75
  jmp alltraps
80107198:	e9 22 f7 ff ff       	jmp    801068bf <alltraps>

8010719d <vector118>:
.globl vector118
vector118:
  pushl $0
8010719d:	6a 00                	push   $0x0
  pushl $118
8010719f:	6a 76                	push   $0x76
  jmp alltraps
801071a1:	e9 19 f7 ff ff       	jmp    801068bf <alltraps>

801071a6 <vector119>:
.globl vector119
vector119:
  pushl $0
801071a6:	6a 00                	push   $0x0
  pushl $119
801071a8:	6a 77                	push   $0x77
  jmp alltraps
801071aa:	e9 10 f7 ff ff       	jmp    801068bf <alltraps>

801071af <vector120>:
.globl vector120
vector120:
  pushl $0
801071af:	6a 00                	push   $0x0
  pushl $120
801071b1:	6a 78                	push   $0x78
  jmp alltraps
801071b3:	e9 07 f7 ff ff       	jmp    801068bf <alltraps>

801071b8 <vector121>:
.globl vector121
vector121:
  pushl $0
801071b8:	6a 00                	push   $0x0
  pushl $121
801071ba:	6a 79                	push   $0x79
  jmp alltraps
801071bc:	e9 fe f6 ff ff       	jmp    801068bf <alltraps>

801071c1 <vector122>:
.globl vector122
vector122:
  pushl $0
801071c1:	6a 00                	push   $0x0
  pushl $122
801071c3:	6a 7a                	push   $0x7a
  jmp alltraps
801071c5:	e9 f5 f6 ff ff       	jmp    801068bf <alltraps>

801071ca <vector123>:
.globl vector123
vector123:
  pushl $0
801071ca:	6a 00                	push   $0x0
  pushl $123
801071cc:	6a 7b                	push   $0x7b
  jmp alltraps
801071ce:	e9 ec f6 ff ff       	jmp    801068bf <alltraps>

801071d3 <vector124>:
.globl vector124
vector124:
  pushl $0
801071d3:	6a 00                	push   $0x0
  pushl $124
801071d5:	6a 7c                	push   $0x7c
  jmp alltraps
801071d7:	e9 e3 f6 ff ff       	jmp    801068bf <alltraps>

801071dc <vector125>:
.globl vector125
vector125:
  pushl $0
801071dc:	6a 00                	push   $0x0
  pushl $125
801071de:	6a 7d                	push   $0x7d
  jmp alltraps
801071e0:	e9 da f6 ff ff       	jmp    801068bf <alltraps>

801071e5 <vector126>:
.globl vector126
vector126:
  pushl $0
801071e5:	6a 00                	push   $0x0
  pushl $126
801071e7:	6a 7e                	push   $0x7e
  jmp alltraps
801071e9:	e9 d1 f6 ff ff       	jmp    801068bf <alltraps>

801071ee <vector127>:
.globl vector127
vector127:
  pushl $0
801071ee:	6a 00                	push   $0x0
  pushl $127
801071f0:	6a 7f                	push   $0x7f
  jmp alltraps
801071f2:	e9 c8 f6 ff ff       	jmp    801068bf <alltraps>

801071f7 <vector128>:
.globl vector128
vector128:
  pushl $0
801071f7:	6a 00                	push   $0x0
  pushl $128
801071f9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801071fe:	e9 bc f6 ff ff       	jmp    801068bf <alltraps>

80107203 <vector129>:
.globl vector129
vector129:
  pushl $0
80107203:	6a 00                	push   $0x0
  pushl $129
80107205:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010720a:	e9 b0 f6 ff ff       	jmp    801068bf <alltraps>

8010720f <vector130>:
.globl vector130
vector130:
  pushl $0
8010720f:	6a 00                	push   $0x0
  pushl $130
80107211:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80107216:	e9 a4 f6 ff ff       	jmp    801068bf <alltraps>

8010721b <vector131>:
.globl vector131
vector131:
  pushl $0
8010721b:	6a 00                	push   $0x0
  pushl $131
8010721d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107222:	e9 98 f6 ff ff       	jmp    801068bf <alltraps>

80107227 <vector132>:
.globl vector132
vector132:
  pushl $0
80107227:	6a 00                	push   $0x0
  pushl $132
80107229:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010722e:	e9 8c f6 ff ff       	jmp    801068bf <alltraps>

80107233 <vector133>:
.globl vector133
vector133:
  pushl $0
80107233:	6a 00                	push   $0x0
  pushl $133
80107235:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010723a:	e9 80 f6 ff ff       	jmp    801068bf <alltraps>

8010723f <vector134>:
.globl vector134
vector134:
  pushl $0
8010723f:	6a 00                	push   $0x0
  pushl $134
80107241:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80107246:	e9 74 f6 ff ff       	jmp    801068bf <alltraps>

8010724b <vector135>:
.globl vector135
vector135:
  pushl $0
8010724b:	6a 00                	push   $0x0
  pushl $135
8010724d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107252:	e9 68 f6 ff ff       	jmp    801068bf <alltraps>

80107257 <vector136>:
.globl vector136
vector136:
  pushl $0
80107257:	6a 00                	push   $0x0
  pushl $136
80107259:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010725e:	e9 5c f6 ff ff       	jmp    801068bf <alltraps>

80107263 <vector137>:
.globl vector137
vector137:
  pushl $0
80107263:	6a 00                	push   $0x0
  pushl $137
80107265:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010726a:	e9 50 f6 ff ff       	jmp    801068bf <alltraps>

8010726f <vector138>:
.globl vector138
vector138:
  pushl $0
8010726f:	6a 00                	push   $0x0
  pushl $138
80107271:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80107276:	e9 44 f6 ff ff       	jmp    801068bf <alltraps>

8010727b <vector139>:
.globl vector139
vector139:
  pushl $0
8010727b:	6a 00                	push   $0x0
  pushl $139
8010727d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107282:	e9 38 f6 ff ff       	jmp    801068bf <alltraps>

80107287 <vector140>:
.globl vector140
vector140:
  pushl $0
80107287:	6a 00                	push   $0x0
  pushl $140
80107289:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010728e:	e9 2c f6 ff ff       	jmp    801068bf <alltraps>

80107293 <vector141>:
.globl vector141
vector141:
  pushl $0
80107293:	6a 00                	push   $0x0
  pushl $141
80107295:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010729a:	e9 20 f6 ff ff       	jmp    801068bf <alltraps>

8010729f <vector142>:
.globl vector142
vector142:
  pushl $0
8010729f:	6a 00                	push   $0x0
  pushl $142
801072a1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801072a6:	e9 14 f6 ff ff       	jmp    801068bf <alltraps>

801072ab <vector143>:
.globl vector143
vector143:
  pushl $0
801072ab:	6a 00                	push   $0x0
  pushl $143
801072ad:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801072b2:	e9 08 f6 ff ff       	jmp    801068bf <alltraps>

801072b7 <vector144>:
.globl vector144
vector144:
  pushl $0
801072b7:	6a 00                	push   $0x0
  pushl $144
801072b9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801072be:	e9 fc f5 ff ff       	jmp    801068bf <alltraps>

801072c3 <vector145>:
.globl vector145
vector145:
  pushl $0
801072c3:	6a 00                	push   $0x0
  pushl $145
801072c5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801072ca:	e9 f0 f5 ff ff       	jmp    801068bf <alltraps>

801072cf <vector146>:
.globl vector146
vector146:
  pushl $0
801072cf:	6a 00                	push   $0x0
  pushl $146
801072d1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801072d6:	e9 e4 f5 ff ff       	jmp    801068bf <alltraps>

801072db <vector147>:
.globl vector147
vector147:
  pushl $0
801072db:	6a 00                	push   $0x0
  pushl $147
801072dd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801072e2:	e9 d8 f5 ff ff       	jmp    801068bf <alltraps>

801072e7 <vector148>:
.globl vector148
vector148:
  pushl $0
801072e7:	6a 00                	push   $0x0
  pushl $148
801072e9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801072ee:	e9 cc f5 ff ff       	jmp    801068bf <alltraps>

801072f3 <vector149>:
.globl vector149
vector149:
  pushl $0
801072f3:	6a 00                	push   $0x0
  pushl $149
801072f5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801072fa:	e9 c0 f5 ff ff       	jmp    801068bf <alltraps>

801072ff <vector150>:
.globl vector150
vector150:
  pushl $0
801072ff:	6a 00                	push   $0x0
  pushl $150
80107301:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107306:	e9 b4 f5 ff ff       	jmp    801068bf <alltraps>

8010730b <vector151>:
.globl vector151
vector151:
  pushl $0
8010730b:	6a 00                	push   $0x0
  pushl $151
8010730d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107312:	e9 a8 f5 ff ff       	jmp    801068bf <alltraps>

80107317 <vector152>:
.globl vector152
vector152:
  pushl $0
80107317:	6a 00                	push   $0x0
  pushl $152
80107319:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010731e:	e9 9c f5 ff ff       	jmp    801068bf <alltraps>

80107323 <vector153>:
.globl vector153
vector153:
  pushl $0
80107323:	6a 00                	push   $0x0
  pushl $153
80107325:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010732a:	e9 90 f5 ff ff       	jmp    801068bf <alltraps>

8010732f <vector154>:
.globl vector154
vector154:
  pushl $0
8010732f:	6a 00                	push   $0x0
  pushl $154
80107331:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107336:	e9 84 f5 ff ff       	jmp    801068bf <alltraps>

8010733b <vector155>:
.globl vector155
vector155:
  pushl $0
8010733b:	6a 00                	push   $0x0
  pushl $155
8010733d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107342:	e9 78 f5 ff ff       	jmp    801068bf <alltraps>

80107347 <vector156>:
.globl vector156
vector156:
  pushl $0
80107347:	6a 00                	push   $0x0
  pushl $156
80107349:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010734e:	e9 6c f5 ff ff       	jmp    801068bf <alltraps>

80107353 <vector157>:
.globl vector157
vector157:
  pushl $0
80107353:	6a 00                	push   $0x0
  pushl $157
80107355:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010735a:	e9 60 f5 ff ff       	jmp    801068bf <alltraps>

8010735f <vector158>:
.globl vector158
vector158:
  pushl $0
8010735f:	6a 00                	push   $0x0
  pushl $158
80107361:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107366:	e9 54 f5 ff ff       	jmp    801068bf <alltraps>

8010736b <vector159>:
.globl vector159
vector159:
  pushl $0
8010736b:	6a 00                	push   $0x0
  pushl $159
8010736d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107372:	e9 48 f5 ff ff       	jmp    801068bf <alltraps>

80107377 <vector160>:
.globl vector160
vector160:
  pushl $0
80107377:	6a 00                	push   $0x0
  pushl $160
80107379:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010737e:	e9 3c f5 ff ff       	jmp    801068bf <alltraps>

80107383 <vector161>:
.globl vector161
vector161:
  pushl $0
80107383:	6a 00                	push   $0x0
  pushl $161
80107385:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010738a:	e9 30 f5 ff ff       	jmp    801068bf <alltraps>

8010738f <vector162>:
.globl vector162
vector162:
  pushl $0
8010738f:	6a 00                	push   $0x0
  pushl $162
80107391:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107396:	e9 24 f5 ff ff       	jmp    801068bf <alltraps>

8010739b <vector163>:
.globl vector163
vector163:
  pushl $0
8010739b:	6a 00                	push   $0x0
  pushl $163
8010739d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801073a2:	e9 18 f5 ff ff       	jmp    801068bf <alltraps>

801073a7 <vector164>:
.globl vector164
vector164:
  pushl $0
801073a7:	6a 00                	push   $0x0
  pushl $164
801073a9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801073ae:	e9 0c f5 ff ff       	jmp    801068bf <alltraps>

801073b3 <vector165>:
.globl vector165
vector165:
  pushl $0
801073b3:	6a 00                	push   $0x0
  pushl $165
801073b5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801073ba:	e9 00 f5 ff ff       	jmp    801068bf <alltraps>

801073bf <vector166>:
.globl vector166
vector166:
  pushl $0
801073bf:	6a 00                	push   $0x0
  pushl $166
801073c1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801073c6:	e9 f4 f4 ff ff       	jmp    801068bf <alltraps>

801073cb <vector167>:
.globl vector167
vector167:
  pushl $0
801073cb:	6a 00                	push   $0x0
  pushl $167
801073cd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801073d2:	e9 e8 f4 ff ff       	jmp    801068bf <alltraps>

801073d7 <vector168>:
.globl vector168
vector168:
  pushl $0
801073d7:	6a 00                	push   $0x0
  pushl $168
801073d9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801073de:	e9 dc f4 ff ff       	jmp    801068bf <alltraps>

801073e3 <vector169>:
.globl vector169
vector169:
  pushl $0
801073e3:	6a 00                	push   $0x0
  pushl $169
801073e5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801073ea:	e9 d0 f4 ff ff       	jmp    801068bf <alltraps>

801073ef <vector170>:
.globl vector170
vector170:
  pushl $0
801073ef:	6a 00                	push   $0x0
  pushl $170
801073f1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801073f6:	e9 c4 f4 ff ff       	jmp    801068bf <alltraps>

801073fb <vector171>:
.globl vector171
vector171:
  pushl $0
801073fb:	6a 00                	push   $0x0
  pushl $171
801073fd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107402:	e9 b8 f4 ff ff       	jmp    801068bf <alltraps>

80107407 <vector172>:
.globl vector172
vector172:
  pushl $0
80107407:	6a 00                	push   $0x0
  pushl $172
80107409:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010740e:	e9 ac f4 ff ff       	jmp    801068bf <alltraps>

80107413 <vector173>:
.globl vector173
vector173:
  pushl $0
80107413:	6a 00                	push   $0x0
  pushl $173
80107415:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010741a:	e9 a0 f4 ff ff       	jmp    801068bf <alltraps>

8010741f <vector174>:
.globl vector174
vector174:
  pushl $0
8010741f:	6a 00                	push   $0x0
  pushl $174
80107421:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107426:	e9 94 f4 ff ff       	jmp    801068bf <alltraps>

8010742b <vector175>:
.globl vector175
vector175:
  pushl $0
8010742b:	6a 00                	push   $0x0
  pushl $175
8010742d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107432:	e9 88 f4 ff ff       	jmp    801068bf <alltraps>

80107437 <vector176>:
.globl vector176
vector176:
  pushl $0
80107437:	6a 00                	push   $0x0
  pushl $176
80107439:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010743e:	e9 7c f4 ff ff       	jmp    801068bf <alltraps>

80107443 <vector177>:
.globl vector177
vector177:
  pushl $0
80107443:	6a 00                	push   $0x0
  pushl $177
80107445:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010744a:	e9 70 f4 ff ff       	jmp    801068bf <alltraps>

8010744f <vector178>:
.globl vector178
vector178:
  pushl $0
8010744f:	6a 00                	push   $0x0
  pushl $178
80107451:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107456:	e9 64 f4 ff ff       	jmp    801068bf <alltraps>

8010745b <vector179>:
.globl vector179
vector179:
  pushl $0
8010745b:	6a 00                	push   $0x0
  pushl $179
8010745d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107462:	e9 58 f4 ff ff       	jmp    801068bf <alltraps>

80107467 <vector180>:
.globl vector180
vector180:
  pushl $0
80107467:	6a 00                	push   $0x0
  pushl $180
80107469:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010746e:	e9 4c f4 ff ff       	jmp    801068bf <alltraps>

80107473 <vector181>:
.globl vector181
vector181:
  pushl $0
80107473:	6a 00                	push   $0x0
  pushl $181
80107475:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010747a:	e9 40 f4 ff ff       	jmp    801068bf <alltraps>

8010747f <vector182>:
.globl vector182
vector182:
  pushl $0
8010747f:	6a 00                	push   $0x0
  pushl $182
80107481:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107486:	e9 34 f4 ff ff       	jmp    801068bf <alltraps>

8010748b <vector183>:
.globl vector183
vector183:
  pushl $0
8010748b:	6a 00                	push   $0x0
  pushl $183
8010748d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107492:	e9 28 f4 ff ff       	jmp    801068bf <alltraps>

80107497 <vector184>:
.globl vector184
vector184:
  pushl $0
80107497:	6a 00                	push   $0x0
  pushl $184
80107499:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010749e:	e9 1c f4 ff ff       	jmp    801068bf <alltraps>

801074a3 <vector185>:
.globl vector185
vector185:
  pushl $0
801074a3:	6a 00                	push   $0x0
  pushl $185
801074a5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801074aa:	e9 10 f4 ff ff       	jmp    801068bf <alltraps>

801074af <vector186>:
.globl vector186
vector186:
  pushl $0
801074af:	6a 00                	push   $0x0
  pushl $186
801074b1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801074b6:	e9 04 f4 ff ff       	jmp    801068bf <alltraps>

801074bb <vector187>:
.globl vector187
vector187:
  pushl $0
801074bb:	6a 00                	push   $0x0
  pushl $187
801074bd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801074c2:	e9 f8 f3 ff ff       	jmp    801068bf <alltraps>

801074c7 <vector188>:
.globl vector188
vector188:
  pushl $0
801074c7:	6a 00                	push   $0x0
  pushl $188
801074c9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801074ce:	e9 ec f3 ff ff       	jmp    801068bf <alltraps>

801074d3 <vector189>:
.globl vector189
vector189:
  pushl $0
801074d3:	6a 00                	push   $0x0
  pushl $189
801074d5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801074da:	e9 e0 f3 ff ff       	jmp    801068bf <alltraps>

801074df <vector190>:
.globl vector190
vector190:
  pushl $0
801074df:	6a 00                	push   $0x0
  pushl $190
801074e1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801074e6:	e9 d4 f3 ff ff       	jmp    801068bf <alltraps>

801074eb <vector191>:
.globl vector191
vector191:
  pushl $0
801074eb:	6a 00                	push   $0x0
  pushl $191
801074ed:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801074f2:	e9 c8 f3 ff ff       	jmp    801068bf <alltraps>

801074f7 <vector192>:
.globl vector192
vector192:
  pushl $0
801074f7:	6a 00                	push   $0x0
  pushl $192
801074f9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801074fe:	e9 bc f3 ff ff       	jmp    801068bf <alltraps>

80107503 <vector193>:
.globl vector193
vector193:
  pushl $0
80107503:	6a 00                	push   $0x0
  pushl $193
80107505:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010750a:	e9 b0 f3 ff ff       	jmp    801068bf <alltraps>

8010750f <vector194>:
.globl vector194
vector194:
  pushl $0
8010750f:	6a 00                	push   $0x0
  pushl $194
80107511:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107516:	e9 a4 f3 ff ff       	jmp    801068bf <alltraps>

8010751b <vector195>:
.globl vector195
vector195:
  pushl $0
8010751b:	6a 00                	push   $0x0
  pushl $195
8010751d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107522:	e9 98 f3 ff ff       	jmp    801068bf <alltraps>

80107527 <vector196>:
.globl vector196
vector196:
  pushl $0
80107527:	6a 00                	push   $0x0
  pushl $196
80107529:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010752e:	e9 8c f3 ff ff       	jmp    801068bf <alltraps>

80107533 <vector197>:
.globl vector197
vector197:
  pushl $0
80107533:	6a 00                	push   $0x0
  pushl $197
80107535:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010753a:	e9 80 f3 ff ff       	jmp    801068bf <alltraps>

8010753f <vector198>:
.globl vector198
vector198:
  pushl $0
8010753f:	6a 00                	push   $0x0
  pushl $198
80107541:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107546:	e9 74 f3 ff ff       	jmp    801068bf <alltraps>

8010754b <vector199>:
.globl vector199
vector199:
  pushl $0
8010754b:	6a 00                	push   $0x0
  pushl $199
8010754d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107552:	e9 68 f3 ff ff       	jmp    801068bf <alltraps>

80107557 <vector200>:
.globl vector200
vector200:
  pushl $0
80107557:	6a 00                	push   $0x0
  pushl $200
80107559:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010755e:	e9 5c f3 ff ff       	jmp    801068bf <alltraps>

80107563 <vector201>:
.globl vector201
vector201:
  pushl $0
80107563:	6a 00                	push   $0x0
  pushl $201
80107565:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010756a:	e9 50 f3 ff ff       	jmp    801068bf <alltraps>

8010756f <vector202>:
.globl vector202
vector202:
  pushl $0
8010756f:	6a 00                	push   $0x0
  pushl $202
80107571:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107576:	e9 44 f3 ff ff       	jmp    801068bf <alltraps>

8010757b <vector203>:
.globl vector203
vector203:
  pushl $0
8010757b:	6a 00                	push   $0x0
  pushl $203
8010757d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107582:	e9 38 f3 ff ff       	jmp    801068bf <alltraps>

80107587 <vector204>:
.globl vector204
vector204:
  pushl $0
80107587:	6a 00                	push   $0x0
  pushl $204
80107589:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010758e:	e9 2c f3 ff ff       	jmp    801068bf <alltraps>

80107593 <vector205>:
.globl vector205
vector205:
  pushl $0
80107593:	6a 00                	push   $0x0
  pushl $205
80107595:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010759a:	e9 20 f3 ff ff       	jmp    801068bf <alltraps>

8010759f <vector206>:
.globl vector206
vector206:
  pushl $0
8010759f:	6a 00                	push   $0x0
  pushl $206
801075a1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801075a6:	e9 14 f3 ff ff       	jmp    801068bf <alltraps>

801075ab <vector207>:
.globl vector207
vector207:
  pushl $0
801075ab:	6a 00                	push   $0x0
  pushl $207
801075ad:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801075b2:	e9 08 f3 ff ff       	jmp    801068bf <alltraps>

801075b7 <vector208>:
.globl vector208
vector208:
  pushl $0
801075b7:	6a 00                	push   $0x0
  pushl $208
801075b9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801075be:	e9 fc f2 ff ff       	jmp    801068bf <alltraps>

801075c3 <vector209>:
.globl vector209
vector209:
  pushl $0
801075c3:	6a 00                	push   $0x0
  pushl $209
801075c5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801075ca:	e9 f0 f2 ff ff       	jmp    801068bf <alltraps>

801075cf <vector210>:
.globl vector210
vector210:
  pushl $0
801075cf:	6a 00                	push   $0x0
  pushl $210
801075d1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801075d6:	e9 e4 f2 ff ff       	jmp    801068bf <alltraps>

801075db <vector211>:
.globl vector211
vector211:
  pushl $0
801075db:	6a 00                	push   $0x0
  pushl $211
801075dd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801075e2:	e9 d8 f2 ff ff       	jmp    801068bf <alltraps>

801075e7 <vector212>:
.globl vector212
vector212:
  pushl $0
801075e7:	6a 00                	push   $0x0
  pushl $212
801075e9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801075ee:	e9 cc f2 ff ff       	jmp    801068bf <alltraps>

801075f3 <vector213>:
.globl vector213
vector213:
  pushl $0
801075f3:	6a 00                	push   $0x0
  pushl $213
801075f5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801075fa:	e9 c0 f2 ff ff       	jmp    801068bf <alltraps>

801075ff <vector214>:
.globl vector214
vector214:
  pushl $0
801075ff:	6a 00                	push   $0x0
  pushl $214
80107601:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107606:	e9 b4 f2 ff ff       	jmp    801068bf <alltraps>

8010760b <vector215>:
.globl vector215
vector215:
  pushl $0
8010760b:	6a 00                	push   $0x0
  pushl $215
8010760d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107612:	e9 a8 f2 ff ff       	jmp    801068bf <alltraps>

80107617 <vector216>:
.globl vector216
vector216:
  pushl $0
80107617:	6a 00                	push   $0x0
  pushl $216
80107619:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010761e:	e9 9c f2 ff ff       	jmp    801068bf <alltraps>

80107623 <vector217>:
.globl vector217
vector217:
  pushl $0
80107623:	6a 00                	push   $0x0
  pushl $217
80107625:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010762a:	e9 90 f2 ff ff       	jmp    801068bf <alltraps>

8010762f <vector218>:
.globl vector218
vector218:
  pushl $0
8010762f:	6a 00                	push   $0x0
  pushl $218
80107631:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107636:	e9 84 f2 ff ff       	jmp    801068bf <alltraps>

8010763b <vector219>:
.globl vector219
vector219:
  pushl $0
8010763b:	6a 00                	push   $0x0
  pushl $219
8010763d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107642:	e9 78 f2 ff ff       	jmp    801068bf <alltraps>

80107647 <vector220>:
.globl vector220
vector220:
  pushl $0
80107647:	6a 00                	push   $0x0
  pushl $220
80107649:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010764e:	e9 6c f2 ff ff       	jmp    801068bf <alltraps>

80107653 <vector221>:
.globl vector221
vector221:
  pushl $0
80107653:	6a 00                	push   $0x0
  pushl $221
80107655:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010765a:	e9 60 f2 ff ff       	jmp    801068bf <alltraps>

8010765f <vector222>:
.globl vector222
vector222:
  pushl $0
8010765f:	6a 00                	push   $0x0
  pushl $222
80107661:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107666:	e9 54 f2 ff ff       	jmp    801068bf <alltraps>

8010766b <vector223>:
.globl vector223
vector223:
  pushl $0
8010766b:	6a 00                	push   $0x0
  pushl $223
8010766d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107672:	e9 48 f2 ff ff       	jmp    801068bf <alltraps>

80107677 <vector224>:
.globl vector224
vector224:
  pushl $0
80107677:	6a 00                	push   $0x0
  pushl $224
80107679:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010767e:	e9 3c f2 ff ff       	jmp    801068bf <alltraps>

80107683 <vector225>:
.globl vector225
vector225:
  pushl $0
80107683:	6a 00                	push   $0x0
  pushl $225
80107685:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010768a:	e9 30 f2 ff ff       	jmp    801068bf <alltraps>

8010768f <vector226>:
.globl vector226
vector226:
  pushl $0
8010768f:	6a 00                	push   $0x0
  pushl $226
80107691:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107696:	e9 24 f2 ff ff       	jmp    801068bf <alltraps>

8010769b <vector227>:
.globl vector227
vector227:
  pushl $0
8010769b:	6a 00                	push   $0x0
  pushl $227
8010769d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801076a2:	e9 18 f2 ff ff       	jmp    801068bf <alltraps>

801076a7 <vector228>:
.globl vector228
vector228:
  pushl $0
801076a7:	6a 00                	push   $0x0
  pushl $228
801076a9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801076ae:	e9 0c f2 ff ff       	jmp    801068bf <alltraps>

801076b3 <vector229>:
.globl vector229
vector229:
  pushl $0
801076b3:	6a 00                	push   $0x0
  pushl $229
801076b5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801076ba:	e9 00 f2 ff ff       	jmp    801068bf <alltraps>

801076bf <vector230>:
.globl vector230
vector230:
  pushl $0
801076bf:	6a 00                	push   $0x0
  pushl $230
801076c1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801076c6:	e9 f4 f1 ff ff       	jmp    801068bf <alltraps>

801076cb <vector231>:
.globl vector231
vector231:
  pushl $0
801076cb:	6a 00                	push   $0x0
  pushl $231
801076cd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801076d2:	e9 e8 f1 ff ff       	jmp    801068bf <alltraps>

801076d7 <vector232>:
.globl vector232
vector232:
  pushl $0
801076d7:	6a 00                	push   $0x0
  pushl $232
801076d9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801076de:	e9 dc f1 ff ff       	jmp    801068bf <alltraps>

801076e3 <vector233>:
.globl vector233
vector233:
  pushl $0
801076e3:	6a 00                	push   $0x0
  pushl $233
801076e5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801076ea:	e9 d0 f1 ff ff       	jmp    801068bf <alltraps>

801076ef <vector234>:
.globl vector234
vector234:
  pushl $0
801076ef:	6a 00                	push   $0x0
  pushl $234
801076f1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801076f6:	e9 c4 f1 ff ff       	jmp    801068bf <alltraps>

801076fb <vector235>:
.globl vector235
vector235:
  pushl $0
801076fb:	6a 00                	push   $0x0
  pushl $235
801076fd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107702:	e9 b8 f1 ff ff       	jmp    801068bf <alltraps>

80107707 <vector236>:
.globl vector236
vector236:
  pushl $0
80107707:	6a 00                	push   $0x0
  pushl $236
80107709:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010770e:	e9 ac f1 ff ff       	jmp    801068bf <alltraps>

80107713 <vector237>:
.globl vector237
vector237:
  pushl $0
80107713:	6a 00                	push   $0x0
  pushl $237
80107715:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010771a:	e9 a0 f1 ff ff       	jmp    801068bf <alltraps>

8010771f <vector238>:
.globl vector238
vector238:
  pushl $0
8010771f:	6a 00                	push   $0x0
  pushl $238
80107721:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107726:	e9 94 f1 ff ff       	jmp    801068bf <alltraps>

8010772b <vector239>:
.globl vector239
vector239:
  pushl $0
8010772b:	6a 00                	push   $0x0
  pushl $239
8010772d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107732:	e9 88 f1 ff ff       	jmp    801068bf <alltraps>

80107737 <vector240>:
.globl vector240
vector240:
  pushl $0
80107737:	6a 00                	push   $0x0
  pushl $240
80107739:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010773e:	e9 7c f1 ff ff       	jmp    801068bf <alltraps>

80107743 <vector241>:
.globl vector241
vector241:
  pushl $0
80107743:	6a 00                	push   $0x0
  pushl $241
80107745:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010774a:	e9 70 f1 ff ff       	jmp    801068bf <alltraps>

8010774f <vector242>:
.globl vector242
vector242:
  pushl $0
8010774f:	6a 00                	push   $0x0
  pushl $242
80107751:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107756:	e9 64 f1 ff ff       	jmp    801068bf <alltraps>

8010775b <vector243>:
.globl vector243
vector243:
  pushl $0
8010775b:	6a 00                	push   $0x0
  pushl $243
8010775d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107762:	e9 58 f1 ff ff       	jmp    801068bf <alltraps>

80107767 <vector244>:
.globl vector244
vector244:
  pushl $0
80107767:	6a 00                	push   $0x0
  pushl $244
80107769:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010776e:	e9 4c f1 ff ff       	jmp    801068bf <alltraps>

80107773 <vector245>:
.globl vector245
vector245:
  pushl $0
80107773:	6a 00                	push   $0x0
  pushl $245
80107775:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010777a:	e9 40 f1 ff ff       	jmp    801068bf <alltraps>

8010777f <vector246>:
.globl vector246
vector246:
  pushl $0
8010777f:	6a 00                	push   $0x0
  pushl $246
80107781:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107786:	e9 34 f1 ff ff       	jmp    801068bf <alltraps>

8010778b <vector247>:
.globl vector247
vector247:
  pushl $0
8010778b:	6a 00                	push   $0x0
  pushl $247
8010778d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107792:	e9 28 f1 ff ff       	jmp    801068bf <alltraps>

80107797 <vector248>:
.globl vector248
vector248:
  pushl $0
80107797:	6a 00                	push   $0x0
  pushl $248
80107799:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010779e:	e9 1c f1 ff ff       	jmp    801068bf <alltraps>

801077a3 <vector249>:
.globl vector249
vector249:
  pushl $0
801077a3:	6a 00                	push   $0x0
  pushl $249
801077a5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801077aa:	e9 10 f1 ff ff       	jmp    801068bf <alltraps>

801077af <vector250>:
.globl vector250
vector250:
  pushl $0
801077af:	6a 00                	push   $0x0
  pushl $250
801077b1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801077b6:	e9 04 f1 ff ff       	jmp    801068bf <alltraps>

801077bb <vector251>:
.globl vector251
vector251:
  pushl $0
801077bb:	6a 00                	push   $0x0
  pushl $251
801077bd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801077c2:	e9 f8 f0 ff ff       	jmp    801068bf <alltraps>

801077c7 <vector252>:
.globl vector252
vector252:
  pushl $0
801077c7:	6a 00                	push   $0x0
  pushl $252
801077c9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801077ce:	e9 ec f0 ff ff       	jmp    801068bf <alltraps>

801077d3 <vector253>:
.globl vector253
vector253:
  pushl $0
801077d3:	6a 00                	push   $0x0
  pushl $253
801077d5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801077da:	e9 e0 f0 ff ff       	jmp    801068bf <alltraps>

801077df <vector254>:
.globl vector254
vector254:
  pushl $0
801077df:	6a 00                	push   $0x0
  pushl $254
801077e1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801077e6:	e9 d4 f0 ff ff       	jmp    801068bf <alltraps>

801077eb <vector255>:
.globl vector255
vector255:
  pushl $0
801077eb:	6a 00                	push   $0x0
  pushl $255
801077ed:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801077f2:	e9 c8 f0 ff ff       	jmp    801068bf <alltraps>
801077f7:	66 90                	xchg   %ax,%ax
801077f9:	66 90                	xchg   %ax,%ax
801077fb:	66 90                	xchg   %ax,%ax
801077fd:	66 90                	xchg   %ax,%ax
801077ff:	90                   	nop

80107800 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107800:	55                   	push   %ebp
80107801:	89 e5                	mov    %esp,%ebp
80107803:	57                   	push   %edi
80107804:	56                   	push   %esi
80107805:	53                   	push   %ebx
80107806:	89 d3                	mov    %edx,%ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107808:	c1 ea 16             	shr    $0x16,%edx
8010780b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
8010780e:	83 ec 0c             	sub    $0xc,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
80107811:	8b 07                	mov    (%edi),%eax
80107813:	a8 01                	test   $0x1,%al
80107815:	74 29                	je     80107840 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107817:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010781c:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80107822:	8d 65 f4             	lea    -0xc(%ebp),%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80107825:	c1 eb 0a             	shr    $0xa,%ebx
80107828:	81 e3 fc 0f 00 00    	and    $0xffc,%ebx
8010782e:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
}
80107831:	5b                   	pop    %ebx
80107832:	5e                   	pop    %esi
80107833:	5f                   	pop    %edi
80107834:	5d                   	pop    %ebp
80107835:	c3                   	ret    
80107836:	8d 76 00             	lea    0x0(%esi),%esi
80107839:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107840:	85 c9                	test   %ecx,%ecx
80107842:	74 2c                	je     80107870 <walkpgdir+0x70>
80107844:	e8 e7 ad ff ff       	call   80102630 <kalloc>
80107849:	85 c0                	test   %eax,%eax
8010784b:	89 c6                	mov    %eax,%esi
8010784d:	74 21                	je     80107870 <walkpgdir+0x70>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
8010784f:	83 ec 04             	sub    $0x4,%esp
80107852:	68 00 10 00 00       	push   $0x1000
80107857:	6a 00                	push   $0x0
80107859:	50                   	push   %eax
8010785a:	e8 51 d4 ff ff       	call   80104cb0 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010785f:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107865:	83 c4 10             	add    $0x10,%esp
80107868:	83 c8 07             	or     $0x7,%eax
8010786b:	89 07                	mov    %eax,(%edi)
8010786d:	eb b3                	jmp    80107822 <walkpgdir+0x22>
8010786f:	90                   	nop
  }
  return &pgtab[PTX(va)];
}
80107870:	8d 65 f4             	lea    -0xc(%ebp),%esp
  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
80107873:	31 c0                	xor    %eax,%eax
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80107875:	5b                   	pop    %ebx
80107876:	5e                   	pop    %esi
80107877:	5f                   	pop    %edi
80107878:	5d                   	pop    %ebp
80107879:	c3                   	ret    
8010787a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107880 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107880:	55                   	push   %ebp
80107881:	89 e5                	mov    %esp,%ebp
80107883:	57                   	push   %edi
80107884:	56                   	push   %esi
80107885:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80107886:	89 d3                	mov    %edx,%ebx
80107888:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
8010788e:	83 ec 1c             	sub    $0x1c,%esp
80107891:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107894:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107898:	8b 7d 08             	mov    0x8(%ebp),%edi
8010789b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801078a0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
801078a3:	8b 45 0c             	mov    0xc(%ebp),%eax
801078a6:	29 df                	sub    %ebx,%edi
801078a8:	83 c8 01             	or     $0x1,%eax
801078ab:	89 45 dc             	mov    %eax,-0x24(%ebp)
801078ae:	eb 15                	jmp    801078c5 <mappages+0x45>
  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
801078b0:	f6 00 01             	testb  $0x1,(%eax)
801078b3:	75 45                	jne    801078fa <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
801078b5:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
801078b8:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
801078bb:	89 30                	mov    %esi,(%eax)
    if(a == last)
801078bd:	74 31                	je     801078f0 <mappages+0x70>
      break;
    a += PGSIZE;
801078bf:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801078c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801078c8:	b9 01 00 00 00       	mov    $0x1,%ecx
801078cd:	89 da                	mov    %ebx,%edx
801078cf:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
801078d2:	e8 29 ff ff ff       	call   80107800 <walkpgdir>
801078d7:	85 c0                	test   %eax,%eax
801078d9:	75 d5                	jne    801078b0 <mappages+0x30>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
801078db:	8d 65 f4             	lea    -0xc(%ebp),%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
801078de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
801078e3:	5b                   	pop    %ebx
801078e4:	5e                   	pop    %esi
801078e5:	5f                   	pop    %edi
801078e6:	5d                   	pop    %ebp
801078e7:	c3                   	ret    
801078e8:	90                   	nop
801078e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801078f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
801078f3:	31 c0                	xor    %eax,%eax
}
801078f5:	5b                   	pop    %ebx
801078f6:	5e                   	pop    %esi
801078f7:	5f                   	pop    %edi
801078f8:	5d                   	pop    %ebp
801078f9:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
801078fa:	83 ec 0c             	sub    $0xc,%esp
801078fd:	68 20 8f 10 80       	push   $0x80108f20
80107902:	e8 69 8a ff ff       	call   80100370 <panic>
80107907:	89 f6                	mov    %esi,%esi
80107909:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107910 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107910:	55                   	push   %ebp
80107911:	89 e5                	mov    %esp,%ebp
80107913:	57                   	push   %edi
80107914:	56                   	push   %esi
80107915:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80107916:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
8010791c:	89 c7                	mov    %eax,%edi
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
8010791e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107924:	83 ec 1c             	sub    $0x1c,%esp
80107927:	89 4d e0             	mov    %ecx,-0x20(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
8010792a:	39 d3                	cmp    %edx,%ebx
8010792c:	73 66                	jae    80107994 <deallocuvm.part.0+0x84>
8010792e:	89 d6                	mov    %edx,%esi
80107930:	eb 3d                	jmp    8010796f <deallocuvm.part.0+0x5f>
80107932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80107938:	8b 10                	mov    (%eax),%edx
8010793a:	f6 c2 01             	test   $0x1,%dl
8010793d:	74 26                	je     80107965 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010793f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80107945:	74 58                	je     8010799f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80107947:	83 ec 0c             	sub    $0xc,%esp
8010794a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107950:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107953:	52                   	push   %edx
80107954:	e8 27 ab ff ff       	call   80102480 <kfree>
      *pte = 0;
80107959:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010795c:	83 c4 10             	add    $0x10,%esp
8010795f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80107965:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010796b:	39 f3                	cmp    %esi,%ebx
8010796d:	73 25                	jae    80107994 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010796f:	31 c9                	xor    %ecx,%ecx
80107971:	89 da                	mov    %ebx,%edx
80107973:	89 f8                	mov    %edi,%eax
80107975:	e8 86 fe ff ff       	call   80107800 <walkpgdir>
    if(!pte)
8010797a:	85 c0                	test   %eax,%eax
8010797c:	75 ba                	jne    80107938 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010797e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80107984:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
8010798a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107990:	39 f3                	cmp    %esi,%ebx
80107992:	72 db                	jb     8010796f <deallocuvm.part.0+0x5f>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80107994:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107997:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010799a:	5b                   	pop    %ebx
8010799b:	5e                   	pop    %esi
8010799c:	5f                   	pop    %edi
8010799d:	5d                   	pop    %ebp
8010799e:	c3                   	ret    
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
8010799f:	83 ec 0c             	sub    $0xc,%esp
801079a2:	68 e6 83 10 80       	push   $0x801083e6
801079a7:	e8 c4 89 ff ff       	call   80100370 <panic>
801079ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801079b0 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
801079b0:	55                   	push   %ebp
801079b1:	89 e5                	mov    %esp,%ebp
801079b3:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
801079b6:	e8 75 bf ff ff       	call   80103930 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801079bb:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801079c1:	31 c9                	xor    %ecx,%ecx
801079c3:	ba ff ff ff ff       	mov    $0xffffffff,%edx
801079c8:	66 89 90 18 48 11 80 	mov    %dx,-0x7feeb7e8(%eax)
801079cf:	66 89 88 1a 48 11 80 	mov    %cx,-0x7feeb7e6(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801079d6:	ba ff ff ff ff       	mov    $0xffffffff,%edx
801079db:	31 c9                	xor    %ecx,%ecx
801079dd:	66 89 90 20 48 11 80 	mov    %dx,-0x7feeb7e0(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801079e4:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801079e9:	66 89 88 22 48 11 80 	mov    %cx,-0x7feeb7de(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801079f0:	31 c9                	xor    %ecx,%ecx
801079f2:	66 89 90 28 48 11 80 	mov    %dx,-0x7feeb7d8(%eax)
801079f9:	66 89 88 2a 48 11 80 	mov    %cx,-0x7feeb7d6(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107a00:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80107a05:	31 c9                	xor    %ecx,%ecx
80107a07:	66 89 90 30 48 11 80 	mov    %dx,-0x7feeb7d0(%eax)
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107a0e:	c6 80 1c 48 11 80 00 	movb   $0x0,-0x7feeb7e4(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80107a15:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107a1a:	c6 80 1d 48 11 80 9a 	movb   $0x9a,-0x7feeb7e3(%eax)
80107a21:	c6 80 1e 48 11 80 cf 	movb   $0xcf,-0x7feeb7e2(%eax)
80107a28:	c6 80 1f 48 11 80 00 	movb   $0x0,-0x7feeb7e1(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107a2f:	c6 80 24 48 11 80 00 	movb   $0x0,-0x7feeb7dc(%eax)
80107a36:	c6 80 25 48 11 80 92 	movb   $0x92,-0x7feeb7db(%eax)
80107a3d:	c6 80 26 48 11 80 cf 	movb   $0xcf,-0x7feeb7da(%eax)
80107a44:	c6 80 27 48 11 80 00 	movb   $0x0,-0x7feeb7d9(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107a4b:	c6 80 2c 48 11 80 00 	movb   $0x0,-0x7feeb7d4(%eax)
80107a52:	c6 80 2d 48 11 80 fa 	movb   $0xfa,-0x7feeb7d3(%eax)
80107a59:	c6 80 2e 48 11 80 cf 	movb   $0xcf,-0x7feeb7d2(%eax)
80107a60:	c6 80 2f 48 11 80 00 	movb   $0x0,-0x7feeb7d1(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107a67:	66 89 88 32 48 11 80 	mov    %cx,-0x7feeb7ce(%eax)
80107a6e:	c6 80 34 48 11 80 00 	movb   $0x0,-0x7feeb7cc(%eax)
80107a75:	c6 80 35 48 11 80 f2 	movb   $0xf2,-0x7feeb7cb(%eax)
80107a7c:	c6 80 36 48 11 80 cf 	movb   $0xcf,-0x7feeb7ca(%eax)
80107a83:	c6 80 37 48 11 80 00 	movb   $0x0,-0x7feeb7c9(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
80107a8a:	05 10 48 11 80       	add    $0x80114810,%eax
80107a8f:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
80107a93:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107a97:	c1 e8 10             	shr    $0x10,%eax
80107a9a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80107a9e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80107aa1:	0f 01 10             	lgdtl  (%eax)
}
80107aa4:	c9                   	leave  
80107aa5:	c3                   	ret    
80107aa6:	8d 76 00             	lea    0x0(%esi),%esi
80107aa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107ab0 <switchkvm>:
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107ab0:	a1 24 ee 12 80       	mov    0x8012ee24,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80107ab5:	55                   	push   %ebp
80107ab6:	89 e5                	mov    %esp,%ebp
80107ab8:	05 00 00 00 80       	add    $0x80000000,%eax
80107abd:	0f 22 d8             	mov    %eax,%cr3
  lcr3(V2P(kpgdir));   // switch to the kernel page table
}
80107ac0:	5d                   	pop    %ebp
80107ac1:	c3                   	ret    
80107ac2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107ad0 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107ad0:	55                   	push   %ebp
80107ad1:	89 e5                	mov    %esp,%ebp
80107ad3:	57                   	push   %edi
80107ad4:	56                   	push   %esi
80107ad5:	53                   	push   %ebx
80107ad6:	83 ec 1c             	sub    $0x1c,%esp
80107ad9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80107adc:	85 f6                	test   %esi,%esi
80107ade:	0f 84 cd 00 00 00    	je     80107bb1 <switchuvm+0xe1>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80107ae4:	8b 46 08             	mov    0x8(%esi),%eax
80107ae7:	85 c0                	test   %eax,%eax
80107ae9:	0f 84 dc 00 00 00    	je     80107bcb <switchuvm+0xfb>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
80107aef:	8b 7e 04             	mov    0x4(%esi),%edi
80107af2:	85 ff                	test   %edi,%edi
80107af4:	0f 84 c4 00 00 00    	je     80107bbe <switchuvm+0xee>
    panic("switchuvm: no pgdir");

  pushcli();
80107afa:	e8 51 ce ff ff       	call   80104950 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107aff:	e8 ac bd ff ff       	call   801038b0 <mycpu>
80107b04:	89 c3                	mov    %eax,%ebx
80107b06:	e8 a5 bd ff ff       	call   801038b0 <mycpu>
80107b0b:	89 c7                	mov    %eax,%edi
80107b0d:	e8 9e bd ff ff       	call   801038b0 <mycpu>
80107b12:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107b15:	83 c7 08             	add    $0x8,%edi
80107b18:	e8 93 bd ff ff       	call   801038b0 <mycpu>
80107b1d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107b20:	83 c0 08             	add    $0x8,%eax
80107b23:	ba 67 00 00 00       	mov    $0x67,%edx
80107b28:	c1 e8 18             	shr    $0x18,%eax
80107b2b:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
80107b32:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107b39:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
80107b40:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80107b47:	83 c1 08             	add    $0x8,%ecx
80107b4a:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80107b50:	c1 e9 10             	shr    $0x10,%ecx
80107b53:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107b59:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    panic("switchuvm: no pgdir");

  pushcli();
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
80107b5e:	e8 4d bd ff ff       	call   801038b0 <mycpu>
80107b63:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107b6a:	e8 41 bd ff ff       	call   801038b0 <mycpu>
80107b6f:	b9 10 00 00 00       	mov    $0x10,%ecx
80107b74:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107b78:	e8 33 bd ff ff       	call   801038b0 <mycpu>
80107b7d:	8b 56 08             	mov    0x8(%esi),%edx
80107b80:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
80107b86:	89 48 0c             	mov    %ecx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107b89:	e8 22 bd ff ff       	call   801038b0 <mycpu>
80107b8e:	66 89 58 6e          	mov    %bx,0x6e(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
80107b92:	b8 28 00 00 00       	mov    $0x28,%eax
80107b97:	0f 00 d8             	ltr    %ax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107b9a:	8b 46 04             	mov    0x4(%esi),%eax
80107b9d:	05 00 00 00 80       	add    $0x80000000,%eax
80107ba2:	0f 22 d8             	mov    %eax,%cr3
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
}
80107ba5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107ba8:	5b                   	pop    %ebx
80107ba9:	5e                   	pop    %esi
80107baa:	5f                   	pop    %edi
80107bab:	5d                   	pop    %ebp
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
80107bac:	e9 df cd ff ff       	jmp    80104990 <popcli>
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
80107bb1:	83 ec 0c             	sub    $0xc,%esp
80107bb4:	68 26 8f 10 80       	push   $0x80108f26
80107bb9:	e8 b2 87 ff ff       	call   80100370 <panic>
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
80107bbe:	83 ec 0c             	sub    $0xc,%esp
80107bc1:	68 51 8f 10 80       	push   $0x80108f51
80107bc6:	e8 a5 87 ff ff       	call   80100370 <panic>
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
80107bcb:	83 ec 0c             	sub    $0xc,%esp
80107bce:	68 3c 8f 10 80       	push   $0x80108f3c
80107bd3:	e8 98 87 ff ff       	call   80100370 <panic>
80107bd8:	90                   	nop
80107bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107be0 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107be0:	55                   	push   %ebp
80107be1:	89 e5                	mov    %esp,%ebp
80107be3:	57                   	push   %edi
80107be4:	56                   	push   %esi
80107be5:	53                   	push   %ebx
80107be6:	83 ec 1c             	sub    $0x1c,%esp
80107be9:	8b 75 10             	mov    0x10(%ebp),%esi
80107bec:	8b 45 08             	mov    0x8(%ebp),%eax
80107bef:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
80107bf2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107bf8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
80107bfb:	77 49                	ja     80107c46 <inituvm+0x66>
    panic("inituvm: more than a page");
  mem = kalloc();
80107bfd:	e8 2e aa ff ff       	call   80102630 <kalloc>
  memset(mem, 0, PGSIZE);
80107c02:	83 ec 04             	sub    $0x4,%esp
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
80107c05:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107c07:	68 00 10 00 00       	push   $0x1000
80107c0c:	6a 00                	push   $0x0
80107c0e:	50                   	push   %eax
80107c0f:	e8 9c d0 ff ff       	call   80104cb0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107c14:	58                   	pop    %eax
80107c15:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107c1b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107c20:	5a                   	pop    %edx
80107c21:	6a 06                	push   $0x6
80107c23:	50                   	push   %eax
80107c24:	31 d2                	xor    %edx,%edx
80107c26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107c29:	e8 52 fc ff ff       	call   80107880 <mappages>
  memmove(mem, init, sz);
80107c2e:	89 75 10             	mov    %esi,0x10(%ebp)
80107c31:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107c34:	83 c4 10             	add    $0x10,%esp
80107c37:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80107c3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107c3d:	5b                   	pop    %ebx
80107c3e:	5e                   	pop    %esi
80107c3f:	5f                   	pop    %edi
80107c40:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
80107c41:	e9 1a d1 ff ff       	jmp    80104d60 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
80107c46:	83 ec 0c             	sub    $0xc,%esp
80107c49:	68 65 8f 10 80       	push   $0x80108f65
80107c4e:	e8 1d 87 ff ff       	call   80100370 <panic>
80107c53:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107c60 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107c60:	55                   	push   %ebp
80107c61:	89 e5                	mov    %esp,%ebp
80107c63:	57                   	push   %edi
80107c64:	56                   	push   %esi
80107c65:	53                   	push   %ebx
80107c66:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107c69:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80107c70:	0f 85 91 00 00 00    	jne    80107d07 <loaduvm+0xa7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80107c76:	8b 75 18             	mov    0x18(%ebp),%esi
80107c79:	31 db                	xor    %ebx,%ebx
80107c7b:	85 f6                	test   %esi,%esi
80107c7d:	75 1a                	jne    80107c99 <loaduvm+0x39>
80107c7f:	eb 6f                	jmp    80107cf0 <loaduvm+0x90>
80107c81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107c88:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107c8e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80107c94:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80107c97:	76 57                	jbe    80107cf0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107c99:	8b 55 0c             	mov    0xc(%ebp),%edx
80107c9c:	8b 45 08             	mov    0x8(%ebp),%eax
80107c9f:	31 c9                	xor    %ecx,%ecx
80107ca1:	01 da                	add    %ebx,%edx
80107ca3:	e8 58 fb ff ff       	call   80107800 <walkpgdir>
80107ca8:	85 c0                	test   %eax,%eax
80107caa:	74 4e                	je     80107cfa <loaduvm+0x9a>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80107cac:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107cae:	8b 4d 14             	mov    0x14(%ebp),%ecx
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
80107cb1:	bf 00 10 00 00       	mov    $0x1000,%edi
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80107cb6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107cbb:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107cc1:	0f 46 fe             	cmovbe %esi,%edi
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107cc4:	01 d9                	add    %ebx,%ecx
80107cc6:	05 00 00 00 80       	add    $0x80000000,%eax
80107ccb:	57                   	push   %edi
80107ccc:	51                   	push   %ecx
80107ccd:	50                   	push   %eax
80107cce:	ff 75 10             	pushl  0x10(%ebp)
80107cd1:	e8 1a 9e ff ff       	call   80101af0 <readi>
80107cd6:	83 c4 10             	add    $0x10,%esp
80107cd9:	39 c7                	cmp    %eax,%edi
80107cdb:	74 ab                	je     80107c88 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
80107cdd:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
80107ce0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80107ce5:	5b                   	pop    %ebx
80107ce6:	5e                   	pop    %esi
80107ce7:	5f                   	pop    %edi
80107ce8:	5d                   	pop    %ebp
80107ce9:	c3                   	ret    
80107cea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107cf0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80107cf3:	31 c0                	xor    %eax,%eax
}
80107cf5:	5b                   	pop    %ebx
80107cf6:	5e                   	pop    %esi
80107cf7:	5f                   	pop    %edi
80107cf8:	5d                   	pop    %ebp
80107cf9:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
80107cfa:	83 ec 0c             	sub    $0xc,%esp
80107cfd:	68 7f 8f 10 80       	push   $0x80108f7f
80107d02:	e8 69 86 ff ff       	call   80100370 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
80107d07:	83 ec 0c             	sub    $0xc,%esp
80107d0a:	68 20 90 10 80       	push   $0x80109020
80107d0f:	e8 5c 86 ff ff       	call   80100370 <panic>
80107d14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107d1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107d20 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107d20:	55                   	push   %ebp
80107d21:	89 e5                	mov    %esp,%ebp
80107d23:	57                   	push   %edi
80107d24:	56                   	push   %esi
80107d25:	53                   	push   %ebx
80107d26:	83 ec 0c             	sub    $0xc,%esp
80107d29:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80107d2c:	85 ff                	test   %edi,%edi
80107d2e:	0f 88 ca 00 00 00    	js     80107dfe <allocuvm+0xde>
    return 0;
  if(newsz < oldsz)
80107d34:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80107d37:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
80107d3a:	0f 82 82 00 00 00    	jb     80107dc2 <allocuvm+0xa2>
    return oldsz;

  a = PGROUNDUP(oldsz);
80107d40:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107d46:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80107d4c:	39 df                	cmp    %ebx,%edi
80107d4e:	77 43                	ja     80107d93 <allocuvm+0x73>
80107d50:	e9 bb 00 00 00       	jmp    80107e10 <allocuvm+0xf0>
80107d55:	8d 76 00             	lea    0x0(%esi),%esi
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
80107d58:	83 ec 04             	sub    $0x4,%esp
80107d5b:	68 00 10 00 00       	push   $0x1000
80107d60:	6a 00                	push   $0x0
80107d62:	50                   	push   %eax
80107d63:	e8 48 cf ff ff       	call   80104cb0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107d68:	58                   	pop    %eax
80107d69:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107d6f:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107d74:	5a                   	pop    %edx
80107d75:	6a 06                	push   $0x6
80107d77:	50                   	push   %eax
80107d78:	89 da                	mov    %ebx,%edx
80107d7a:	8b 45 08             	mov    0x8(%ebp),%eax
80107d7d:	e8 fe fa ff ff       	call   80107880 <mappages>
80107d82:	83 c4 10             	add    $0x10,%esp
80107d85:	85 c0                	test   %eax,%eax
80107d87:	78 47                	js     80107dd0 <allocuvm+0xb0>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80107d89:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107d8f:	39 df                	cmp    %ebx,%edi
80107d91:	76 7d                	jbe    80107e10 <allocuvm+0xf0>
    mem = kalloc();
80107d93:	e8 98 a8 ff ff       	call   80102630 <kalloc>
    if(mem == 0){
80107d98:	85 c0                	test   %eax,%eax
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
80107d9a:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80107d9c:	75 ba                	jne    80107d58 <allocuvm+0x38>
      cprintf("allocuvm out of memory\n");
80107d9e:	83 ec 0c             	sub    $0xc,%esp
80107da1:	68 9d 8f 10 80       	push   $0x80108f9d
80107da6:	e8 35 89 ff ff       	call   801006e0 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80107dab:	83 c4 10             	add    $0x10,%esp
80107dae:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107db1:	76 4b                	jbe    80107dfe <allocuvm+0xde>
80107db3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107db6:	8b 45 08             	mov    0x8(%ebp),%eax
80107db9:	89 fa                	mov    %edi,%edx
80107dbb:	e8 50 fb ff ff       	call   80107910 <deallocuvm.part.0>
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
80107dc0:	31 c0                	xor    %eax,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80107dc2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107dc5:	5b                   	pop    %ebx
80107dc6:	5e                   	pop    %esi
80107dc7:	5f                   	pop    %edi
80107dc8:	5d                   	pop    %ebp
80107dc9:	c3                   	ret    
80107dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
80107dd0:	83 ec 0c             	sub    $0xc,%esp
80107dd3:	68 b5 8f 10 80       	push   $0x80108fb5
80107dd8:	e8 03 89 ff ff       	call   801006e0 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80107ddd:	83 c4 10             	add    $0x10,%esp
80107de0:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107de3:	76 0d                	jbe    80107df2 <allocuvm+0xd2>
80107de5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107de8:	8b 45 08             	mov    0x8(%ebp),%eax
80107deb:	89 fa                	mov    %edi,%edx
80107ded:	e8 1e fb ff ff       	call   80107910 <deallocuvm.part.0>
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
80107df2:	83 ec 0c             	sub    $0xc,%esp
80107df5:	56                   	push   %esi
80107df6:	e8 85 a6 ff ff       	call   80102480 <kfree>
      return 0;
80107dfb:	83 c4 10             	add    $0x10,%esp
    }
  }
  return newsz;
}
80107dfe:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
80107e01:	31 c0                	xor    %eax,%eax
    }
  }
  return newsz;
}
80107e03:	5b                   	pop    %ebx
80107e04:	5e                   	pop    %esi
80107e05:	5f                   	pop    %edi
80107e06:	5d                   	pop    %ebp
80107e07:	c3                   	ret    
80107e08:	90                   	nop
80107e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107e10:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80107e13:	89 f8                	mov    %edi,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80107e15:	5b                   	pop    %ebx
80107e16:	5e                   	pop    %esi
80107e17:	5f                   	pop    %edi
80107e18:	5d                   	pop    %ebp
80107e19:	c3                   	ret    
80107e1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107e20 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107e20:	55                   	push   %ebp
80107e21:	89 e5                	mov    %esp,%ebp
80107e23:	8b 55 0c             	mov    0xc(%ebp),%edx
80107e26:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107e29:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80107e2c:	39 d1                	cmp    %edx,%ecx
80107e2e:	73 10                	jae    80107e40 <deallocuvm+0x20>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80107e30:	5d                   	pop    %ebp
80107e31:	e9 da fa ff ff       	jmp    80107910 <deallocuvm.part.0>
80107e36:	8d 76 00             	lea    0x0(%esi),%esi
80107e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107e40:	89 d0                	mov    %edx,%eax
80107e42:	5d                   	pop    %ebp
80107e43:	c3                   	ret    
80107e44:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107e4a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107e50 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107e50:	55                   	push   %ebp
80107e51:	89 e5                	mov    %esp,%ebp
80107e53:	57                   	push   %edi
80107e54:	56                   	push   %esi
80107e55:	53                   	push   %ebx
80107e56:	83 ec 0c             	sub    $0xc,%esp
80107e59:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80107e5c:	85 f6                	test   %esi,%esi
80107e5e:	74 59                	je     80107eb9 <freevm+0x69>
80107e60:	31 c9                	xor    %ecx,%ecx
80107e62:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107e67:	89 f0                	mov    %esi,%eax
80107e69:	e8 a2 fa ff ff       	call   80107910 <deallocuvm.part.0>
80107e6e:	89 f3                	mov    %esi,%ebx
80107e70:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107e76:	eb 0f                	jmp    80107e87 <freevm+0x37>
80107e78:	90                   	nop
80107e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107e80:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107e83:	39 fb                	cmp    %edi,%ebx
80107e85:	74 23                	je     80107eaa <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107e87:	8b 03                	mov    (%ebx),%eax
80107e89:	a8 01                	test   $0x1,%al
80107e8b:	74 f3                	je     80107e80 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
80107e8d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107e92:	83 ec 0c             	sub    $0xc,%esp
80107e95:	83 c3 04             	add    $0x4,%ebx
80107e98:	05 00 00 00 80       	add    $0x80000000,%eax
80107e9d:	50                   	push   %eax
80107e9e:	e8 dd a5 ff ff       	call   80102480 <kfree>
80107ea3:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107ea6:	39 fb                	cmp    %edi,%ebx
80107ea8:	75 dd                	jne    80107e87 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80107eaa:	89 75 08             	mov    %esi,0x8(%ebp)
}
80107ead:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107eb0:	5b                   	pop    %ebx
80107eb1:	5e                   	pop    %esi
80107eb2:	5f                   	pop    %edi
80107eb3:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80107eb4:	e9 c7 a5 ff ff       	jmp    80102480 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
80107eb9:	83 ec 0c             	sub    $0xc,%esp
80107ebc:	68 d1 8f 10 80       	push   $0x80108fd1
80107ec1:	e8 aa 84 ff ff       	call   80100370 <panic>
80107ec6:	8d 76 00             	lea    0x0(%esi),%esi
80107ec9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107ed0 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80107ed0:	55                   	push   %ebp
80107ed1:	89 e5                	mov    %esp,%ebp
80107ed3:	56                   	push   %esi
80107ed4:	53                   	push   %ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80107ed5:	e8 56 a7 ff ff       	call   80102630 <kalloc>
80107eda:	85 c0                	test   %eax,%eax
80107edc:	74 6a                	je     80107f48 <setupkvm+0x78>
    return 0;
  memset(pgdir, 0, PGSIZE);
80107ede:	83 ec 04             	sub    $0x4,%esp
80107ee1:	89 c6                	mov    %eax,%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107ee3:	bb 20 c4 10 80       	mov    $0x8010c420,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
80107ee8:	68 00 10 00 00       	push   $0x1000
80107eed:	6a 00                	push   $0x0
80107eef:	50                   	push   %eax
80107ef0:	e8 bb cd ff ff       	call   80104cb0 <memset>
80107ef5:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107ef8:	8b 43 04             	mov    0x4(%ebx),%eax
80107efb:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107efe:	83 ec 08             	sub    $0x8,%esp
80107f01:	8b 13                	mov    (%ebx),%edx
80107f03:	ff 73 0c             	pushl  0xc(%ebx)
80107f06:	50                   	push   %eax
80107f07:	29 c1                	sub    %eax,%ecx
80107f09:	89 f0                	mov    %esi,%eax
80107f0b:	e8 70 f9 ff ff       	call   80107880 <mappages>
80107f10:	83 c4 10             	add    $0x10,%esp
80107f13:	85 c0                	test   %eax,%eax
80107f15:	78 19                	js     80107f30 <setupkvm+0x60>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107f17:	83 c3 10             	add    $0x10,%ebx
80107f1a:	81 fb 60 c4 10 80    	cmp    $0x8010c460,%ebx
80107f20:	75 d6                	jne    80107ef8 <setupkvm+0x28>
80107f22:	89 f0                	mov    %esi,%eax
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
}
80107f24:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107f27:	5b                   	pop    %ebx
80107f28:	5e                   	pop    %esi
80107f29:	5d                   	pop    %ebp
80107f2a:	c3                   	ret    
80107f2b:	90                   	nop
80107f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
80107f30:	83 ec 0c             	sub    $0xc,%esp
80107f33:	56                   	push   %esi
80107f34:	e8 17 ff ff ff       	call   80107e50 <freevm>
      return 0;
80107f39:	83 c4 10             	add    $0x10,%esp
    }
  return pgdir;
}
80107f3c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
80107f3f:	31 c0                	xor    %eax,%eax
    }
  return pgdir;
}
80107f41:	5b                   	pop    %ebx
80107f42:	5e                   	pop    %esi
80107f43:	5d                   	pop    %ebp
80107f44:	c3                   	ret    
80107f45:	8d 76 00             	lea    0x0(%esi),%esi
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
80107f48:	31 c0                	xor    %eax,%eax
80107f4a:	eb d8                	jmp    80107f24 <setupkvm+0x54>
80107f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107f50 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80107f50:	55                   	push   %ebp
80107f51:	89 e5                	mov    %esp,%ebp
80107f53:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107f56:	e8 75 ff ff ff       	call   80107ed0 <setupkvm>
80107f5b:	a3 24 ee 12 80       	mov    %eax,0x8012ee24
80107f60:	05 00 00 00 80       	add    $0x80000000,%eax
80107f65:	0f 22 d8             	mov    %eax,%cr3
  switchkvm();
}
80107f68:	c9                   	leave  
80107f69:	c3                   	ret    
80107f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107f70 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107f70:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107f71:	31 c9                	xor    %ecx,%ecx

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107f73:	89 e5                	mov    %esp,%ebp
80107f75:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107f78:	8b 55 0c             	mov    0xc(%ebp),%edx
80107f7b:	8b 45 08             	mov    0x8(%ebp),%eax
80107f7e:	e8 7d f8 ff ff       	call   80107800 <walkpgdir>
  if(pte == 0)
80107f83:	85 c0                	test   %eax,%eax
80107f85:	74 05                	je     80107f8c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107f87:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80107f8a:	c9                   	leave  
80107f8b:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107f8c:	83 ec 0c             	sub    $0xc,%esp
80107f8f:	68 e2 8f 10 80       	push   $0x80108fe2
80107f94:	e8 d7 83 ff ff       	call   80100370 <panic>
80107f99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107fa0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107fa0:	55                   	push   %ebp
80107fa1:	89 e5                	mov    %esp,%ebp
80107fa3:	57                   	push   %edi
80107fa4:	56                   	push   %esi
80107fa5:	53                   	push   %ebx
80107fa6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107fa9:	e8 22 ff ff ff       	call   80107ed0 <setupkvm>
80107fae:	85 c0                	test   %eax,%eax
80107fb0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107fb3:	0f 84 c5 00 00 00    	je     8010807e <copyuvm+0xde>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107fb9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107fbc:	85 c9                	test   %ecx,%ecx
80107fbe:	0f 84 9c 00 00 00    	je     80108060 <copyuvm+0xc0>
80107fc4:	31 ff                	xor    %edi,%edi
80107fc6:	eb 4a                	jmp    80108012 <copyuvm+0x72>
80107fc8:	90                   	nop
80107fc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107fd0:	83 ec 04             	sub    $0x4,%esp
80107fd3:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107fd9:	68 00 10 00 00       	push   $0x1000
80107fde:	53                   	push   %ebx
80107fdf:	50                   	push   %eax
80107fe0:	e8 7b cd ff ff       	call   80104d60 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107fe5:	58                   	pop    %eax
80107fe6:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107fec:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107ff1:	5a                   	pop    %edx
80107ff2:	ff 75 e4             	pushl  -0x1c(%ebp)
80107ff5:	50                   	push   %eax
80107ff6:	89 fa                	mov    %edi,%edx
80107ff8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107ffb:	e8 80 f8 ff ff       	call   80107880 <mappages>
80108000:	83 c4 10             	add    $0x10,%esp
80108003:	85 c0                	test   %eax,%eax
80108005:	78 69                	js     80108070 <copyuvm+0xd0>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80108007:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010800d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80108010:	76 4e                	jbe    80108060 <copyuvm+0xc0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108012:	8b 45 08             	mov    0x8(%ebp),%eax
80108015:	31 c9                	xor    %ecx,%ecx
80108017:	89 fa                	mov    %edi,%edx
80108019:	e8 e2 f7 ff ff       	call   80107800 <walkpgdir>
8010801e:	85 c0                	test   %eax,%eax
80108020:	74 6d                	je     8010808f <copyuvm+0xef>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80108022:	8b 00                	mov    (%eax),%eax
80108024:	a8 01                	test   $0x1,%al
80108026:	74 5a                	je     80108082 <copyuvm+0xe2>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80108028:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
8010802a:	25 ff 0f 00 00       	and    $0xfff,%eax
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
8010802f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
80108035:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80108038:	e8 f3 a5 ff ff       	call   80102630 <kalloc>
8010803d:	85 c0                	test   %eax,%eax
8010803f:	89 c6                	mov    %eax,%esi
80108041:	75 8d                	jne    80107fd0 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80108043:	83 ec 0c             	sub    $0xc,%esp
80108046:	ff 75 e0             	pushl  -0x20(%ebp)
80108049:	e8 02 fe ff ff       	call   80107e50 <freevm>
  return 0;
8010804e:	83 c4 10             	add    $0x10,%esp
80108051:	31 c0                	xor    %eax,%eax
}
80108053:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108056:	5b                   	pop    %ebx
80108057:	5e                   	pop    %esi
80108058:	5f                   	pop    %edi
80108059:	5d                   	pop    %ebp
8010805a:	c3                   	ret    
8010805b:	90                   	nop
8010805c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80108060:	8b 45 e0             	mov    -0x20(%ebp),%eax
  return d;

bad:
  freevm(d);
  return 0;
}
80108063:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108066:	5b                   	pop    %ebx
80108067:	5e                   	pop    %esi
80108068:	5f                   	pop    %edi
80108069:	5d                   	pop    %ebp
8010806a:	c3                   	ret    
8010806b:	90                   	nop
8010806c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
      kfree(mem);
80108070:	83 ec 0c             	sub    $0xc,%esp
80108073:	56                   	push   %esi
80108074:	e8 07 a4 ff ff       	call   80102480 <kfree>
      goto bad;
80108079:	83 c4 10             	add    $0x10,%esp
8010807c:	eb c5                	jmp    80108043 <copyuvm+0xa3>
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
8010807e:	31 c0                	xor    %eax,%eax
80108080:	eb d1                	jmp    80108053 <copyuvm+0xb3>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
80108082:	83 ec 0c             	sub    $0xc,%esp
80108085:	68 06 90 10 80       	push   $0x80109006
8010808a:	e8 e1 82 ff ff       	call   80100370 <panic>

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010808f:	83 ec 0c             	sub    $0xc,%esp
80108092:	68 ec 8f 10 80       	push   $0x80108fec
80108097:	e8 d4 82 ff ff       	call   80100370 <panic>
8010809c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801080a0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801080a0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801080a1:	31 c9                	xor    %ecx,%ecx

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801080a3:	89 e5                	mov    %esp,%ebp
801080a5:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801080a8:	8b 55 0c             	mov    0xc(%ebp),%edx
801080ab:	8b 45 08             	mov    0x8(%ebp),%eax
801080ae:	e8 4d f7 ff ff       	call   80107800 <walkpgdir>
  if((*pte & PTE_P) == 0)
801080b3:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
801080b5:	89 c2                	mov    %eax,%edx
801080b7:	83 e2 05             	and    $0x5,%edx
801080ba:	83 fa 05             	cmp    $0x5,%edx
801080bd:	75 11                	jne    801080d0 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
801080bf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
}
801080c4:	c9                   	leave  
  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
801080c5:	05 00 00 00 80       	add    $0x80000000,%eax
}
801080ca:	c3                   	ret    
801080cb:	90                   	nop
801080cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
801080d0:	31 c0                	xor    %eax,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
801080d2:	c9                   	leave  
801080d3:	c3                   	ret    
801080d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801080da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801080e0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801080e0:	55                   	push   %ebp
801080e1:	89 e5                	mov    %esp,%ebp
801080e3:	57                   	push   %edi
801080e4:	56                   	push   %esi
801080e5:	53                   	push   %ebx
801080e6:	83 ec 1c             	sub    $0x1c,%esp
801080e9:	8b 5d 14             	mov    0x14(%ebp),%ebx
801080ec:	8b 55 0c             	mov    0xc(%ebp),%edx
801080ef:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801080f2:	85 db                	test   %ebx,%ebx
801080f4:	75 40                	jne    80108136 <copyout+0x56>
801080f6:	eb 70                	jmp    80108168 <copyout+0x88>
801080f8:	90                   	nop
801080f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80108100:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80108103:	89 f1                	mov    %esi,%ecx
80108105:	29 d1                	sub    %edx,%ecx
80108107:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010810d:	39 d9                	cmp    %ebx,%ecx
8010810f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80108112:	29 f2                	sub    %esi,%edx
80108114:	83 ec 04             	sub    $0x4,%esp
80108117:	01 d0                	add    %edx,%eax
80108119:	51                   	push   %ecx
8010811a:	57                   	push   %edi
8010811b:	50                   	push   %eax
8010811c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010811f:	e8 3c cc ff ff       	call   80104d60 <memmove>
    len -= n;
    buf += n;
80108124:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108127:	83 c4 10             	add    $0x10,%esp
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
8010812a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
80108130:	01 cf                	add    %ecx,%edi
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108132:	29 cb                	sub    %ecx,%ebx
80108134:	74 32                	je     80108168 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80108136:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80108138:	83 ec 08             	sub    $0x8,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
8010813b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010813e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80108144:	56                   	push   %esi
80108145:	ff 75 08             	pushl  0x8(%ebp)
80108148:	e8 53 ff ff ff       	call   801080a0 <uva2ka>
    if(pa0 == 0)
8010814d:	83 c4 10             	add    $0x10,%esp
80108150:	85 c0                	test   %eax,%eax
80108152:	75 ac                	jne    80108100 <copyout+0x20>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80108154:	8d 65 f4             	lea    -0xc(%ebp),%esp
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
80108157:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
8010815c:	5b                   	pop    %ebx
8010815d:	5e                   	pop    %esi
8010815e:	5f                   	pop    %edi
8010815f:	5d                   	pop    %ebp
80108160:	c3                   	ret    
80108161:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108168:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
8010816b:	31 c0                	xor    %eax,%eax
}
8010816d:	5b                   	pop    %ebx
8010816e:	5e                   	pop    %esi
8010816f:	5f                   	pop    %edi
80108170:	5d                   	pop    %ebp
80108171:	c3                   	ret    
