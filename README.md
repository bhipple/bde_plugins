bde_plugins
===========
Tools for creating and formatting code according to BDE Standards

Known issues and TODOs:  
* Currently does not work when { for a namespace is on its own line

Functions
---------
h3. Reformatting  
Bde_Format()  
StripTabsAndTrailingWhitespaces()  

h3. Code Generation
MkClassFile(namespace, filename)  
BatchMkClassFile(namespace, ...)  
Class(classname)  
CmtSection(title)  

Suggested Mappings
------------------
* nnoremap <Leader>fmt :call Bde_Format()<CR>  
* nnoremap <Leader>cmt :call CmtSection("")<Left><Left>  
* nnoremap <Leader>w :call StripTabsAndTrailingWhitespaces()<CR>  
  
* nnoremap <Leader>ii O// Application Includes<CR>// BDE Includes<CR>// System Includes<ESC>  
* nnoremap <Leader>ia O// Application Includes<ESC>  
* nnoremap <Leader>ib O// BDE Includes<ESC>  
* nnoremap <Leader>is O// System Includes<ESC>  
